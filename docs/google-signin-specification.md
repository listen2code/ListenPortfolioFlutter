# Google 登录与联合身份验证设计方案书 (Google Sign-In Specification)

为了给招聘官及访客提供低门槛的一键授权登录体验，同时完整展示全栈联合身份验证（Federated Authentication）的设计与开发能力，我们在此设计一套符合整洁架构原则的 **Google 登录与全栈集成方案**。

---

## 1. 业务流程与设计目标

* **面试官一键解锁**：允许招聘官使用已有 Google 账号直接一键登录，无需繁琐注册即可查阅“详细简历（Detailed CV）”。
* **全栈身份校验（ID Token Verification）**：采用工业界标准的 OAuth 2.0 / OIDC (OpenID Connect) 流程，在客户端获取 Google 证书，并在 Spring Boot 后端进行安全验签。
* **渐进式账户合并**：若 Google 账号对应的邮箱在系统中已注册普通账号，支持自动关联并绑定，避免账户割裂。

---

## 2. 身份验证时序图 (Authentication Sequence Flow)

下图展示了从客户端触发 Google 登录，到后端校验并颁发自定义 JWT 令牌的完整闭环流程：

```mermaid
sequenceDiagram
    actor User as 用户 (招聘官)
    participant Client as Flutter 客户端
    participant GSDK as Google SDK / 授权服务
    participant Backend as Spring Boot 后端
    participant GAPI as Google Auth API (验证服务)
    database DB as 数据库 (MySQL)

    User->>Client: 点击 "Sign in with Google"
    Client->>GSDK: 请求 Google 登录授权
    GSDK->>User: 弹出 OAuth 授权/账户选择界面
    User->>GSDK: 确认授权并选择账户
    GSDK->>Client: 返回 用户 Profile 与 idToken (JWT)
    
    Note over Client: 客户端拿到 idToken，准备发送给自建后端
    
    Client->>Backend: HTTPS POST /v1/auth/google (携带 idToken)
    Backend->>GAPI: 验证 idToken 的签名与受众 (Audience)
    GAPI->>Backend: 返回验签结果与用户信息 (Email, Name, Avatar)
    
    Note over Backend: 后端确认 Token 合法，进入本地用户匹配流程
    
    Backend->>DB: 根据 Email 查询本地用户
    alt 用户不存在
        Backend->>DB: 创建新用户 (设定随机密码, 记录 Google 关联标识)
    else 用户已存在
        Backend->>DB: 更新用户 Google 关联标识与最新昵称/头像
    end
    
    Backend->>Backend: 生成自建系统的 Access Token & Refresh Token
    Backend->>Client: 返回自建系统的 Token 载荷 (HTTP 200 OK)
    
    Note over Client: 客户端更新 AuthManager 内存状态，并落盘存储
    
    Client->>User: 提示“登录成功”，解锁详细简历与个人中心
```

---

## 3. 客户端实现细节 (`ListenPortfolioFlutter`)

### 3.1 依赖引入
在 `pubspec.yaml` 中添加以下依赖：
```yaml
dependencies:
  google_sign_in: ^6.2.1
```

### 3.2 抽象与适配设计
为保持 `features/auth` 模块的整洁度，我们在数据源层扩展 Google 登录支持。

在 `lib/features/auth/data/datasources/auth_remote_data_source.dart` 中新增 API 契约：
```dart
  @POST('/v1/auth/google')
  @Extra({ApiClient.kNoAuthKey: true})
  Future<BaseResponseModel<TokenDto>> loginWithGoogle(@Field('idToken') String idToken);
```

### 3.3 Google 登录处理逻辑
在 `lib/features/auth/presentation/pages/login/login_view_model.dart` 中新增处理方法：

```text
import 'package:google_sign_in/google_sign_in.dart';

class LoginViewModel extends ... {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<void> handleGoogleSignIn() async {
    try {
      emitEffect(LoadingEffect(true));
      
      // 1. 调用 Google SDK 弹出账户选择器
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // 用户取消了登录
        emitEffect(LoadingEffect(false));
        return;
      }

      // 2. 获取包含 idToken 的 Auth 凭证
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        emitEffect(LoadingEffect(false));
        emitEffect(MessageEffect.error("Failed to retrieve ID Token from Google."));
        return;
      }

      // 3. 将 idToken 发送给自建后端换取 JWT
      await call<void>(
        ref.execute<UserModel, GoogleLoginParam>(
          googleLoginUseCaseProvider,
          param: GoogleLoginParam(idToken: idToken),
        ),
        showLoading: true,
        onSuccess: (user) {
          // 4. 更新全局登录态并重定向
          authManager.onLoginSuccess(user);
          emitEffect(MessageEffect.success(I18nKeys.loginSuccess.tr));
          AppNav.offAll(Routes.home, isReplace: false);
        },
      );
    } catch (error) {
      appLogger.e("Google Sign-In Error: $error");
      emitEffect(MessageEffect.error("Google Sign-In failed. Please try again."));
    } finally {
      emitEffect(LoadingEffect(false));
    }
  }
}
```

---

## 4. 后端校验细节 (`ListenPortfolioBackend`)

在 Spring Boot 服务端，不应直接信任客户端传来的用户信息，必须使用 Google 的公钥库对其 `idToken` 进行独立验签。

### 4.1 引入 Google 官方校验库
在 `pom.xml` 中添加依赖：
```xml
<dependency>
    <groupId>com.google.api-client</groupId>
    <artifactId>google-api-client</artifactId>
    <version>2.2.0</version>
</dependency>
```

### 4.2 后端验证服务代码

```java
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
public class GoogleAuthService {

    @Value("${google.client-id}")
    private String googleClientId;

    public GoogleUserInfoDto verifyToken(String idTokenString) throws Exception {
        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                new NetHttpTransport(), 
                new GsonFactory()
        )
        // 校验受众，确保该 Token 是为我们的客户端 App 申请的
        .setAudience(Collections.singletonList(googleClientId))
        .build();

        GoogleIdToken idToken = verifier.verify(idTokenString);
        if (idToken != null) {
          GoogleIdToken.Payload payload = idToken.getPayload();

          // 解析 Google 账户的核心个人资料
          String email = payload.getEmail();
          boolean emailVerified = payload.getEmailVerified();
          String name = (String) payload.get("name");
          String pictureUrl = (String) payload.get("picture");
          String googleUserId = payload.getSubject(); // Google 唯一用户 ID

          if (!emailVerified) {
              throw new IllegalArgumentException("Google email address is not verified.");
          }

          return new GoogleUserInfoDto(googleUserId, email, name, pictureUrl);
        } else {
            throw new IllegalArgumentException("Invalid Google ID Token.");
        }
    }
}
```

---

## 5. 平台级证书与配置清单 (Checklist)

### 5.1 Google Cloud API 控制台配置
1. 登录 [Google Cloud Console](https://console.cloud.google.com/) 并创建一个项目。
2. 配置 **OAuth 同意屏幕 (OAuth Consent Screen)**，填写应用名称，在 Scopes 中勾选 `.../auth/userinfo.email` 和 `.../auth/userinfo.profile`。
3. 创建凭据 (Credentials)：
   - **Android 客户端 ID**：需绑定 App 的包名 (`com.listen2code.portfolio`) 和证书 SHA-1 指纹。
   - **iOS 客户端 ID**：需绑定 iOS Bundle ID。
   - **Web 应用客户端 ID**（核心）：**后端校验所需的就是这个 Web 客户端 ID。**

### 5.2 Android 端签名关联 (Keystore Fingerprint)
* **Debug 测试**：获取本地开发机器的 `debug.keystore` 的 SHA-1 并填入控制台。
* **Release 发布**：获取在 GitHub Actions / 签名服务中使用的正式 Release 证书的 SHA-1 指纹并填入。
  > [!WARNING]
  > 如果使用了 Google Play App Signing（应用签名保护），需要把 Google Play 管理中心控制台生成的“应用签名证书”的 SHA-1 同样填入 Google Cloud API 控制台，否则线上版本会报 `Sign-In Error 10`。

### 5.3 iOS 端反向 DNS 机制
* 在 Xcode 项目的 `Info.plist` 中，必须将 Google 控制台生成的 iOS 客户端 ID 的 `REVERSED_CLIENT_ID` 配置到 URL Types 中：
  ```xml
  <key>CFBundleURLTypes</key>
  <array>
      <dict>
          <key>CFBundleTypeRole</key>
          <string>Editor</string>
          <key>CFBundleURLSchemes</key>
          <array>
              <string>com.googleusercontent.apps.xxxxxx-xxxxxxxx</string>
          </array>
      </dict>
  </array>
  ```

---

## 6. App Store 政策与 Apple 登录对齐 (App Store Review Guideline 4.8)

> [!IMPORTANT]
> **苹果应用商店审查指南 4.8 规定：**
> 如果您的 iOS App 提供任何第三方的社交登录服务（如 Google、Facebook、GitHub 等），您**必须**同时向用户提供 **“使用 Apple 登录 (Sign in with Apple)”** 作为等效的选项。
> 
> **应对策略**：
> 在 Phase 3（第 11-16 周）接入 Google 登录时，应在 UI 上并排提供 `Google 登录` 和 `Apple 登录` 两个按钮。在 iOS 系统下渲染两者，而在 Android 系统下隐藏 Apple 登录按钮。
