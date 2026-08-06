# Shorebird OTA Code Push 热更新集成与使用指南

本文档介绍 `ListenPortfolioFlutter` 项目中集成 **Shorebird Code Push**（热更新服务）的作用、工程接入架构、CLI 操作流程及代码使用最佳实践。

---

## 💡 一、 Shorebird 的作用与原理

### 1. 什么是 Shorebird？
[Shorebird](https://shorebird.dev/) 是由 Flutter 联合创始人 Eric Seidel 团队打造的官方级 **OTA (Over-The-Air) 代码热更新解决方案**。

### 2. 核心作用
- **免审核热修 Bug**：生产环境（Android & iOS）发现紧急逻辑漏洞或 UI 异常时，无需重新提交 App Store / Google Play 审核并等待数天更新。
- **秒级拉取补丁**：客户端在后台自动拉取增量编译的 Dart 代码补丁（Patch），实现无感知更新。
- **苹果与谷歌合规**：符合 App Store 审核指南（Section 3.3.2）及 Google Play 开发者政策，允许在安全的沙盒环境内更新解释/AOT 执行的代码，禁止动态加载原生 C/C++/Java/Swift 二进制库。

---

## 🏗 二、 工程接入架构

在本项目中，Shorebird 已按照标准的依赖注入与防阻塞架构完成解耦集成：

### 1. 依赖声明 (`pubspec.yaml`)
```yaml
dependencies:
  shorebird_code_push: ^2.0.0
```

### 2. 服务接口与实现 ([`shorebird_service.dart`](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/shared/services/shorebird/shorebird_service.dart))
项目在 `lib/shared/services/shorebird/shorebird_service.dart` 中封装了 `IShorebirdService` 抽象接口与实现：

- **状态判定**：提供 `ShorebirdCodePushStatus` 枚举 (`idle`, `checking`, `updateAvailable`, `downloading`, `patchDownloaded`, `upToDate`, `unavailable`, `error`)。
- **状态查询**：
  - `isAvailable`：判定当前设备构建是否支持 Shorebird 引擎。
  - `getCurrentPatchNumber()`：获取当前生效的 Patch 补丁序号（基准包返回 null）。
- **热更新控制**：
  - `checkForUpdate()`：向 Shorebird 服务器检查是否有最新 Patch。
  - `downloadUpdate()`：在后台非阻塞下载 Patch 补丁。

### 3. 应用初始化 ([`app_initializer.dart`](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/shared/utils/app_initializer.dart))
在组合根 `AppInitializer` 中安全完成全局单例装配：
```dart
// 5. Initialize Shorebird OTA Code Push Service
try {
  shorebirdService = ShorebirdServiceImpl();
} catch (e, stackTrace) {
  appLogger.e('AppInitializer: Shorebird Code Push initialization failed.', error: e, stackTrace: stackTrace);
}
```

---

## 🚀 三、 命令行 (Shorebird CLI) 发布流程

要真正发布基准包和热更新补丁，需使用 Shorebird CLI 工具：

### 1. 安装 CLI（Windows PowerShell）
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -UseBasicParsing 'https://raw.githubusercontent.com/shorebirdtech/install/main/install.ps1' | iex
```

### 2. 本地项目前置配置（仅首次，必须在本地终端执行）

为了让 Shorebird 识别您的应用并允许 CI/CD 自动构建，请依次在本地完成以下 3 个关键前置步骤：

#### 步骤 A：本地终端登录授权 (`shorebird login`)
在本地电脑终端运行：
```bash
shorebird login
```
终端会自动打开浏览器，使用您的 Google 或 GitHub 账号完成授权登录。

#### 步骤 B：初始化项目并提交配置文件 (`shorebird init`)
在 Flutter 项目根目录运行：
```bash
shorebird init
```
- CLI 会在项目根目录自动生成 `shorebird.yaml` 文件，并分配唯一的 Shorebird App ID。
- ⚠️ **必须将 `shorebird.yaml` 提交至 Git 仓库**（否则云端/CI 编译时无法识别 App ID 导致失败）：
  ```bash
  git add shorebird.yaml
  git commit -m "chore: initialize shorebird configuration"
  git push
  ```

#### 步骤 C：获取 CI/CD 所需的 `SHOREBIRD_TOKEN` API 密钥
为使 GitHub Actions CI 流水线获得发布/热修权限：
1. 登录 Shorebird 官方控制台 ➔ [https://console.shorebird.dev](https://console.shorebird.dev)
2. 进入 **Account** ➔ **API Keys** ➔ 点击 **Create API Key**。
3. 给 Key 命名（如 `GitHub-Actions`），复制生成的密钥。
4. 打开 GitHub 项目仓库 ➔ **Settings** ➔ **Secrets and variables** ➔ **Actions** ➔ 点击 **New repository secret**：
   - **Name**: `SHOREBIRD_TOKEN`
   - **Secret**: 粘贴刚才复制的 API 密钥。

*(注：旧版的 `shorebird login:ci` 命令已被 Shorebird 官方废弃，请使用控制台生成的 API Keys)*

---

### 3. 构建发布“基准包” (Release)
提交到 App Store / Google Play 的版本必须使用 `shorebird release` 或运行 `./buildAndroid.sh bundle prod true`：

- **Android 发布包**：
  ```bash
  shorebird release android --artifact=aab
  ```
- **iOS 发布包**：
  ```bash
  shorebird release ios
  ```

### 4. 推送“热更新补丁” (Patch)
当修改了 Dart 代码后，无需重新发布完整的 APK/IPA：

- **方式 1：通过 Git Commit 消息自动触发 CI 推送（推荐）**
  在提交代码时，提交信息包含 `[patch]`、`[hotfix]` 或 `[shorebird-patch]` 关键字：
  ```bash
  git commit -m "fix(auth): 修复登录崩溃 [patch]"
  git push origin develop
  ```
  GitHub Actions CI 检测到关键字后会自动为您构建并推送热更新 Patch 至 Shorebird 云端。

- **方式 2：在 GitHub Actions 手动面板触发**
  进入 GitHub 仓库 **Actions** ➔ **CI and APK Build** ➔ **Run workflow**：
  - **Build Action**: 选择 `patch`
  - **Environment**: 选择目标环境 (`prod` / `dev`)

- **方式 3：开发者本地命令行推送**
  在本地终端运行：
  ```bash
  shorebird patch android
  ```

---

## 💻 四、 代码中使用 ShorebirdService

在业务逻辑中，您可以通过全局单例 `shorebirdService` 轻松控制更新：

### 1. 检查并提示用户更新补丁
```dart
import 'package:listen_portfolio_flutter/shared/shared.dart';

Future<void> checkAppPatchUpdate() async {
  // 1. 检查当前设备环境是否支持 Shorebird
  if (!shorebirdService.isAvailable) {
    appLogger.i('Shorebird is not available in current environment.');
    return;
  }

  // 2. 检查是否有新补丁
  final hasUpdate = await shorebirdService.checkForUpdate();
  if (hasUpdate) {
    appLogger.i('New patch available, downloading in background...');
    
    // 3. 后台下载补丁
    final success = await shorebirdService.downloadUpdate();
    if (success) {
      // 提示用户下次重启应用生效
      CommonToast.show('新版补丁已准备就绪，下次重启应用后生效');
    }
  }
}
```

### 2. 读取当前 Patch 版本号
```dart
final patchNumber = await shorebirdService.getCurrentPatchNumber();
if (patchNumber != null) {
  print('Current patch version: v$patchNumber');
} else {
  print('Running base release version');
}
```

---

## ⚠️ 五、 注意事项与最佳实践

1. **避免阻塞应用启动**：
   - **切勿**在 `main()` 函数或 `SplashPage` 中同步 `await checkForUpdate()`，否则在弱网环境下会导致应用被卡在启动页。建议在应用进入 HomePage 后异步无感知触发。
2. **补丁生效时机**：
   - 补丁在客户端下载成功后，必须要等**应用被完全关闭并重新打开（App Restart）** 后，新的 Dart 逻辑才会正式生效。
3. **不能修改原生代码**：
   - Shorebird 热更新仅支持 **Dart 语言级别**的修改（逻辑、UI、ViewModel、网络请求等）。
   - 如果修补修改了 `android/` 或 `ios/` 原生 C++/Java/Swift 代码、或者增删了含有原生代码的 Pub 插件，则必须发布全新的 Release 包，不能使用 Patch 热更新。
