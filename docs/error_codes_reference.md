# 全链路统一错误码与异常处理架构规范 (Error Handling Architecture & Error Codes Reference)

**Status**: `Active & Implemented (Standard Architecture Reference)`  
**Latest Update**: 2026-09-12  
**Maintainer**: Architecture & Core Infrastructure Team

---

## 1. 架构愿景与设计哲学 (Architectural Philosophy)

在现代高可用移动端工程与分布式后端交互中，错误处理不仅是简单的 `try-catch` 或弹窗提示，而是贯穿**网络传输层 (Transport)、网关防腐层 (Gateway Antifragile)、领域模型层 (Domain/Failure)、展示状态机 (Presentation/MVI) 以及用户感知层 (User Experience)** 的端到端闭环系统。

本项目（Listen Portfolio Flutter / ListenCore / ListenPortfolioBackend）确立了以下四大核心设计哲学：

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│                             端到端错误流转与防腐管道                              │
└──────────────────────────────────────────────────────────────────────────────────┘

 [Edge Gateway / Nginx] ──(413/502/504 HTML or JSON)──┐
                                                      ▼
 [Transport / Dio]        ── ErrorInterceptor / AuthInterceptor ──▶ AppException (Data)
                                                                           │
 [Repository Boundary]    ── BaseRepository.safeCall()          ──▶ Either<Failure, T>
                                                                           │
 [Presentation / MVI]     ── BaseViewModel.handleResult()       ──▶ ErrorMapper.map()
                                                                           │
 [UI & User Perception]   ── MessageEffect (Dialog / Toast)    ──▶ Localized i18n
```

1. **类型安全与领域纯洁性 (Domain Decoupling)**：
   - 外部基础设施异常（如 Dio 的 `DioException`、数据库 `SqliteException`、JSON 序列化 `TypeError`）严禁穿透进入 Domain 层和 Presentation 层。
   - 数据层将底层原始异常捕获并统一抽象为领域层无副作用的不可变对象 `Failure`，通过函数式编程 `Either<Failure, T>` 显式传递错误轨道（Railway Oriented Programming）。
2. **边缘网关韧性防腐 (Edge Gateway Antifragile Defense)**：
   - 在生产环境下，反向代理网关（Nginx、Cloudflare、AWS ALB）在遭遇文件过大（413 Payload Too Large）、节点崩溃（502 Bad Gateway）或超时（504 Gateway Timeout）时，会抛出原生的非 JSON HTML 错误网页。
   - 客户端解析器实施防御性解析，通过正则提取 HTML `<title>` 摘要，杜绝 Dart `TypeError` 造成的二次崩溃，并将网关错误平滑转化为标准的 `ServerException`。
3. **静默自愈优先 (Self-Healing Concurrency Queue)**：
   - 针对 HTTP 401 Unauthorized 凭据失效，利用 Dio 逆序拦截器管道在最底层由 `AuthInterceptor` 挂起并发请求并执行单例刷新（`onRefreshToken()`）。只有在刷新彻底失败后，才将终态错误向外抛出。
4. **三级级联多语言本地化 (3-Tier Cascade Fallback)**：
   - `ErrorMapper` 提供 `messageId` 错误契约码 $\rightarrow$ 原始文本翻译 $\rightarrow$ 兜底技术文案的三级级联解析，确保全球化语言无缝回退，杜绝空文案或未经处理的技术乱码。

---

## 2. 标准契约协议 (Envelope Specification)

前后端通信严格遵循规范化的统一 JSON 数据包络（Envelope）。

### 2.1 成功响应格式 (Success Envelope)

当 HTTP 状态码为 200 OK 且业务逻辑执行成功时：

```json
{
  "result": "0",
  "messageId": "SUCCESS",
  "message": "Operation successful",
  "body": {
    "userId": "usr_9981",
    "email": "user@example.com",
    "avatarUrl": "https://cdn.listen.dev/avatars/u9981.webp"
  }
}
```

- **`result`**: `"0"`（表示业务成功，定义于 `ApiResult.success` / Java `ApiResponse.success`）。
- **`messageId`**: 可选契约码，默认空字符串或 `"SUCCESS"`。
- **`message`**: 可选成功附带文案。
- **`body`**: 强类型有效载荷实体。

### 2.2 业务失败响应格式 (Business Failure Envelope)

当服务器端业务逻辑拦截或鉴权不通过时（例如密码错误、账户已被锁定）：

```json
{
  "result": "1",
  "messageId": "AUTH_0300",
  "message": "Invalid username or password",
  "body": null
}
```

- **`result`**: `"1"`（表示业务错误，定义于 `ApiResult.serverError`）。若为会话超时，`result` 为 `"3"`（`ApiResult.sessionTimeout`）。
- **`messageId`**: 唯一契约错误码（如 `AUTH_0300`），作为客户端 `ErrorMapper` 映射多语言的最高优先级 Key。
- **`message`**: 服务端生成的默认诊断描述（作为多语言缺失时的第二级回退）。
- **`body`**: 错误时通常为 `null`，或携带字段级校验明细字典。

### 2.3 错误码层级划分 (Classification Tiers)

| 层级 | 前缀 | 责任边界 | 示例 | 治理责任 |
|:---|:---|:---|:---|:---|
| **网络与系统级** | `NET_` / `SYS_` | 传输物理连接、DNS 解析、TLS 握手、超时、本地存储 | `NET_0001`, `SYS_CANCEL` | 移动基础设施组 |
| **认证与权限级** | `AUTH_` | Token 失效、签名错误、越权拦截、密码防刷锁定、AppCheck | `AUTH_0300`, `AUTH_0303` | 统一身份认证组 (IAM) |
| **数据校验级** | `VAL_` | 前端表单约束校验、后端 DTO 强类型绑定与 JSR-303 验证 | `VAL_0400`, `VAL_0403` | 全栈业务协同 |
| **业务逻辑级** | `BIZ_` | 领域业务约束（用户名重复、个人信息缺失、支付异常） | `BIZ_0500`, `BIZ_0507` | 各垂直业务领域组 |
| **服务端与网关级** | `SRV_` | Nginx 反代限流、Spring 内部未捕获异常、数据库宕机 | `SRV_0100`, `SRV_0105` | 服务端与 DevOps 组 |

---

## 3. 核心组件与时序流转 (Core Components & Lifecycle)

### 3.1 异常体系与领域失败模型映射

系统将错误严格划分为**数据层异常 (`AppException`)** 与 **领域层失败 (`Failure`)**：

```
 数据层异常 (lib/errors/exceptions.dart)          领域层失败 (lib/errors/failures.dart)
 ┌────────────────────────────────────┐         ┌───────────────────────────────────┐
 │ AppException (Base)                │         │ Failure (Abstract Base, Equatable)│
 ├────────────────────────────────────┤         ├───────────────────────────────────┤
 │ ├─ ServerException                 │──safeCall──▶ ├─ ServerFailure / ServerApiFailure │
 │ ├─ NetworkException                │──safeCall──▶ ├─ NetworkFailure                   │
 │ ├─ AuthException                   │──safeCall──▶ ├─ AuthFailure                      │
 │ ├─ CacheException                  │──safeCall──▶ ├─ CacheFailure                     │
 │ ├─ ParseException (or TypeError)   │──safeCall──▶ ├─ ParseFailure                     │
 │ └─ Unknown / Third-Party Exception │──safeCall──▶ └─ UnknownFailure                   │
 └────────────────────────────────────┘         └───────────────────────────────────┘
```

#### 关键源码定位
- **数据层异常**: [exceptions.dart](../../ListenCore/lib/errors/exceptions.dart)
- **领域层失败**: [failures.dart](../../ListenCore/lib/errors/failures.dart)
- **网络错误拦截器**: [error_interceptor.dart](../../ListenCore/lib/network/interceptors/error_interceptor.dart)
- **错误映射器**: [error_mapper.dart](../../ListenCore/lib/errors/error_mapper.dart)
- **基础仓储封装**: [base_repository.dart](../../ListenCore/lib/network/base_repository.dart)
- **展示层 ViewModel**: [base_view_model.dart](../../ListenCore/lib/base/base_view_model.dart)
- **后端统一响应**: [ApiResponse.java](../../ListenPortfolioBackend/src/main/java/com/listen/portfolio/common/ApiResponse.java)
- **后端全局异常捕获**: [GlobalExceptionHandler.java](../../ListenPortfolioBackend/src/main/java/com/listen/portfolio/common/config/GlobalExceptionHandler.java)

---

## 4. 重点难点实现解析 (Deep Dive into Key Implementations)

### 4.1 难点一：网关非 JSON / HTML 异常防腐解析 (Gateway HTML Error Defense)

#### 问题背景
在移动端上传大图片（如未压缩的高清头像）或服务端微服务短时间假死时，请求常在到达 Spring Boot 应用程序前就被 Nginx 或 AWS ALB 拦截。Nginx 会直接返回标准 HTML 网页：

```html
<html>
<head><title>413 Request Entity Too Large</title></head>
<body bgcolor="white">
<center><h1>413 Request Entity Too Large</h1></center>
<hr><center>nginx/1.24.0</center>
</body>
</html>
```

若客户端直接使用 `jsonDecode(response.data)` 或 `data['message']`，在 Dart 强类型运行时会立即抛出不可控的 `type 'String' is not a subtype of type 'Map<String, dynamic>'`，掩盖了真实的 413 原因并引发崩溃。

#### 代码实现方案
在 [error_interceptor.dart](../../ListenCore/lib/network/interceptors/error_interceptor.dart) 中采用复合形态探针：

```dart
// 提取错误文本：同时支持结构化 Map 与非结构化 HTML / 纯文本
if (data is Map) {
  message = data[BaseResponseModel.messageKey]?.toString();
  messageId = data[BaseResponseModel.messageIdKey]?.toString();
} else if (data is String) {
  final trimmed = data.trim();
  if (trimmed.startsWith('<')) {
    // 关键突破：通过轻量正则提取 <title> 中的纯文本，避免将庞大 HTML 注入错误提示
    final titleMatch = RegExp(r'<title>(.*?)</title>', caseSensitive: false).firstMatch(trimmed);
    if (titleMatch != null && titleMatch.group(1) != null) {
      message = titleMatch.group(1)!.trim(); // 提取出: "413 Request Entity Too Large"
    }
  } else if (trimmed.isNotEmpty) {
    message = trimmed;
  }
}
```

通过这一层防御，用户界面将清晰展现 `HTTP 413: 413 Request Entity Too Large`，而非晦涩难懂的 `TypeError: String is not a subtype of Map`。

---

### 4.2 难点二：Dio 拦截器执行逆序机制与 401 并发静默重试队列

#### 问题背景
当用户 Access Token 过期时，若页面同时触发了多个并行请求（例如首页同时请求个人信息、项目列表、关于我），若每个请求都弹出“登录过期”，将造成 UI 灾难性的多重弹窗。同时，如果多个请求同时发起刷新 Token，会导致并发刷新竞争与凭据失效。

#### 关键实现机理
1. **Dio 拦截器执行顺序法则**：
   - `onRequest` 按照添加顺序执行：`ZoneContext` $\rightarrow$ `ErrorInterceptor` $\rightarrow$ `AuthInterceptor` $\rightarrow$ `Logging`。
   - `onError` 按照**逆序**执行：`NetworkInspector` $\rightarrow$ `Logging` $\rightarrow$ `AuthInterceptor` $\rightarrow$ `ErrorInterceptor` $\rightarrow$ `ZoneContext`。
2. **`AuthInterceptor` 的拦截与排队**：
   由于逆序执行，`AuthInterceptor` **先于** `ErrorInterceptor` 捕获 401。
   - 第一个到达的 401 请求将 `_isRefreshing` 设为 `true`，调用后端 `onRefreshToken()`。
   - 后续到达的 401 请求被压入 `List<Completer<void>> _refreshQueue` 挂起等待。
   - 刷新成功后，调用 `completer.complete()` 唤醒队列中所有请求，并通过 `options.extra['is_refreshed'] = true` 重新发起 `ApiClient.dio.fetch(options)`。
   - 只有当刷新彻底失败或已被标记为重试过时，才继续调用 `handler.next(err)`，流转给 `ErrorInterceptor` 包装为 `AuthException`。

---

### 4.3 难点三：`ErrorMapper` 三级级联多语言本地化算法

在 [error_mapper.dart](../../ListenCore/lib/errors/error_mapper.dart) 中实现了无损类型保留的三级级联映射：

```
       Failure (带 messageId 与 raw message)
                        │
       ┌────────────────▼────────────────┐
  1级  │ messageId 是否在语言包中存在?   │ ──(是)──▶ 返回 messageId.tr
       └────────────────┬────────────────┘
                       (否)
       ┌────────────────▼────────────────┐
  2级  │ raw message 是否在语言包中存在? │ ──(是)──▶ 返回 raw message.tr
       └────────────────┬────────────────┘
                       (否)
       ┌────────────────▼────────────────┐
  3级  │ 保留原有的 failure.message      │ ──(兜底)─▶ 返回原始文本
       └─────────────────────────────────┘
```

#### 类型保留模式
映射后不将对象退化为通用的 `UnknownFailure`，而是通过模式匹配精准重建对应的子类：
```dart
if (failure is ServerApiFailure) {
  return ServerApiFailure(translatedMessage, messageId: messageId);
} else if (failure is AuthFailure) {
  return AuthFailure(translatedMessage, messageId: messageId);
} // 保留具体类型，便于 ViewModel 进行针对性业务处理 (如 AuthFailure 触发登出)
```

---

## 5. 全量错误码速查表 (Comprehensive Error Code Catalog)

### 5.1 网络与传输错误 (`NET_` / `SYS_`)

| 错误码 | HTTP状态 | 触发场景 | 默认技术消息 | 多语言键 (`zh` / `en` / `ja`) | 推荐处理策略 |
|:---|:---|:---|:---|:---|:---|
| `NET_0001` | - | 设备断网 / 飞行模式 | `No internet connection` | 网络连接失败，请检查网络设置<br>No internet connection<br>ネットワーク接続に失敗しました | 提示网络检查，若有本地离线缓存则自动加载缓存 |
| `NET_0002` | - | 连接 / 发送 / 接收超时 | `Network connection timeout` | 请求超时，请稍后重试<br>Request timeout, please try again<br>リクエストがタイムアウトしました | 允许用户点击重试，检查边缘节点时延 |
| `NET_0003` | - | DNS 域名无法解析 | `Unable to resolve host` | 无法连接到服务器<br>Unable to connect to server<br>サーバーに接続できません | 引导检查本地 DNS 设置或代理软件 |
| `NET_0004` | - | SSL/TLS 证书无效 / 抓包 | `Bad certificate` | 安全连接失败，证书验证异常<br>Secure connection failed<br>安全な接続の確立に失敗しました | 阻断危险传输，提示系统时间或代理证书风险 |
| `NET_0005` | - | TCP Socket 连接拒绝 | `Connection error` | 服务器无法连接<br>Connection error<br>接続エラーが発生しました | 检查服务端集群是否停机或被防火墙拦截 |
| `SYS_CANCEL` | - | 用户主动取消 / 页面销毁 | `Request cancelled` | 请求已取消<br>Request cancelled<br>リクエストがキャンセルされました | 静默丢弃，不触发 UI 弹窗 |

---

### 5.2 认证与鉴权错误 (`AUTH_`)

| 错误码 | HTTP状态 | 触发场景 | 默认技术消息 | 多语言键 (`zh` / `en` / `ja`) | 推荐处理策略 |
|:---|:---|:---|:---|:---|:---|
| `AUTH_0300` | 400/401 | 用户名或密码输入错误 | `Invalid username or password` | 用户名或密码错误<br>Invalid username or password<br>ユーザー名またはパスワードが正しくありません | 清空密码输入框，高亮错误提示 |
| `AUTH_0301` | 404 | 账号不存在 | `Account not found` | 账户不存在<br>Account not found<br>アカウントが見つかりません | 引导前往注册页面 |
| `AUTH_0302` | 423 | 密码连续错误达到 5 次 | `Account locked due to security policy` | 账户已锁定，请稍后再试<br>Account locked, please try again later<br>アカウントがロックされました | 锁定登录按钮，启动倒计时冷却限制 |
| `AUTH_0303` | 401 | Access Token 过期且刷新失败 | `Session expired, please login again` | 登录已过期，请重新登录<br>Session expired, please login again<br>セッションが切れました。再ログインしてください | 触发 `LogoutEffect` 清除凭据并跳转登录页 |
| `AUTH_0304` | 401 | Token 签名非法或被篡改 | `Invalid authorization token` | 无效凭证，请重新登录<br>Invalid session, please login again<br>無効なセッションです | 清理本地存储，引导重新认证 |
| `AUTH_0305` | 403 | 试图越权访问非本人数据 | `Forbidden: insufficient permissions` | 权限不足，拒绝访问<br>Access denied<br>アクセスが拒否されました | 提示无权限，记录安全风控审计日志 |
| `AUTH_0306` | 401 | Refresh Token 过期或已拉黑 | `Refresh token expired or revoked` | 认证状态失效，请重新登录<br>Authentication revoked<br>認証が取り消されました | 清除本地 Refresh Token，跳转至登录页 |
| `AUTH_0307` | 403 | Firebase App Check 校验不通过 | `App Check verification failed` | 环境安全校验未通过<br>Security verification failed<br>セキュリティ検証に失敗しました | 提示请从官方 Google Play 安装正版客户端 |

---

### 5.3 格式校验与表单错误 (`VAL_`)

| 错误码 | HTTP状态 | 触发场景 | 默认技术消息 | 多语言键 (`zh` / `en` / `ja`) | 推荐处理策略 |
|:---|:---|:---|:---|:---|:---|
| `VAL_0400` | 400 | 邮箱不符合 RFC 5322 规则 | `Please enter a valid email address` | 请输入有效的邮箱地址<br>Invalid email address<br>有効なメールアドレスを入力してください | 表单 Field 红色辅助文本高亮 |
| `VAL_0401` | 400 | 密码长度低于 8 位或缺少复杂度 | `Password must be at least 8 characters` | 密码至少需要 8 位字符<br>Password too short<br>パスワードは8文字以上である必要があります | 输入框实时校验指示条反馈 |
| `VAL_0402` | 400 | 两次密码输入不一致 | `Passwords do not match` | 两次输入的密码不一致<br>Passwords do not match<br>パスワードが一致しません | 实时校验二次密码匹配状态 |
| `VAL_0403` | 400 | 必填字段缺失或为空字符串 | `Required fields missing` | 请填写所有必填字段<br>Please fill in all required fields<br>必須項目を入力してください | 定位至首个未填写的输入焦点 |
| `VAL_0404` | 400 | 手机号格式校验失败 | `Invalid phone number format` | 手机号格式不正确<br>Invalid phone number<br>電話番号の形式が正しくありません | 检查国际区号与号码位数 |
| `VAL_0405` | 400 | 请求体 JSON 畸变无法解析 | `Malformed request body` | 请求数据格式畸变<br>Malformed request<br>リクエスト形式が不正です | 拦截并上报 APM 诊断 |

---

### 5.4 业务领域错误 (`BIZ_`)

| 错误码 | HTTP状态 | 触发场景 | 默认技术消息 | 多语言键 (`zh` / `en` / `ja`) | 推荐处理策略 |
|:---|:---|:---|:---|:---|:---|
| `BIZ_0500` | 409 | 用户名已被占用 | `Username already exists` | 用户名已存在<br>Username already exists<br>ユーザー名は既に使用されています | 提示更换用户名，提供候选昵称建议 |
| `BIZ_0501` | 409 | 邮箱已被注册绑定 | `Email already registered` | 邮箱已被注册<br>Email already registered<br>メールアドレスは既に登録されています | 提示直接登录或找回密码 |
| `BIZ_0502` | 400 | 修改密码时原密码验证失败 | `Current password is incorrect` | 原密码输入不正确<br>Current password incorrect<br>現在のパスワードが正しくありません | 重新聚焦原密码输入框 |
| `BIZ_0503` | 500 | 账户注销业务处理失败 | `Failed to delete account` | 注销账户失败，请重试<br>Failed to delete account<br>アカウント削除に失敗しました | 弹窗展示技术支持邮箱指引 |
| `BIZ_0504` | 429 | 密码重试超过频次上限 | `Too many attempts, please try again` | 操作过于频繁，请稍后再试<br>Too many attempts<br>試行回数が多すぎます | 强制冷却 15 分钟 |
| `BIZ_0505` | 404 | 个人履历详情不存在 | `About me profile not found` | 未找到个人履历资料<br>Profile not found<br>プロフィールが見つかりません | 展示空状态缺省插画与重试按钮 |
| `BIZ_0506` | 404 | 作品集项目列表不存在 | `Projects not found` | 未找到相关项目列表<br>Projects not found<br>プロジェクトが見つかりません | 展示空列表视图并提供刷新手势 |
| `BIZ_0507` | 400 | 头像非合法图片魔数或体积超限 | `Invalid avatar format or size` | 头像格式或大小不符合要求<br>Invalid avatar image<br>アバター画像の形式が無効です | 引导裁剪或选择 JPG/PNG/WebP 格式 |
| `BIZ_0508` | 402 | Google Play / IAP 购买处理失败 | `In-app purchase verification failed` | 内购凭证验证失败<br>Purchase verification failed<br>購入の検証に失敗しました | 保留本地 Pending 交易并提示恢复购买 |

---

### 5.5 服务端与基础设施错误 (`SRV_`)

| 错误码 | HTTP状态 | 触发场景 | 默认技术消息 | 多语言键 (`zh` / `en` / `ja`) | 推荐处理策略 |
|:---|:---|:---|:---|:---|:---|
| `SRV_0100` | 500 | Spring Boot 未捕获未知异常 | `Internal Server Error` | 服务器发生内部错误，请稍后重试<br>Internal server error<br>サーバーエラーが発生しました | 弹出友好错误提示，上报全局 Trace ID |
| `SRV_0101` | 502 | Nginx 反向代理无法连通后端 | `Bad Gateway` | 服务暂时不可用，正在恢复中<br>Service temporarily unavailable<br>サービスが一時的に利用不能です | 展示服务器恢复提示，延迟 3 秒重试 |
| `SRV_0102` | 503 | 系统正在停机发布维护 | `Service Unavailable` | 系统维护中，请稍后访问<br>Service under maintenance<br>システムメンテナンス中です | 展示全屏停机维护广播公告与预计完成时间 |
| `SRV_0103` | 504 | 网关反代后端执行超时 | `Gateway Timeout` | 网关响应超时，请重试<br>Gateway timeout<br>ゲートウェイがタイムアウトしました | 优化后端 SQL 查询，客户端展示重试操作 |
| `SRV_0104` | 429 | 触发 API 限流阈值 (RateLimit) | `Too Many Requests` | 访问过于频繁，请稍后再试<br>Too many requests<br>リクエストが多すぎます | 展示 Warning Toast，按照 Retry-After 降频 |
| `SRV_0105` | 413 | 上传体积超过 Nginx `client_max_body_size` | `413 Request Entity Too Large` | 上传文件体积过大<br>File size too large<br>ファイルサイズが大きすぎます | 本地前置图像压缩，限制单次上传 $<2$MB |

---

## 6. 业务层实战范式 (Implementation Patterns in Practice)

### 6.1 仓储层标准调用与缓存降级 (`safeCall`)

在数据仓储层（Repository Layer），利用 `ListenCore` 提供的 `BaseRepository.safeCall()` 统一收敛网络前置探针、远端调用、本地持久化与错误降级：

```dart
class AboutMeRepositoryImpl with BaseRepository implements AboutMeRepository {
  final AboutMeRemoteDataSource remoteDataSource;
  final AboutMeLocalDataSource localDataSource;

  AboutMeRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, AboutMeEntity>> getAboutMe() async {
    return safeCall<AboutMeEntity>(
      call: () => remoteDataSource.getAboutMe(),
      cacheDataSource: localDataSource, // 发生网络错误时自动回退至本地缓存
      useCacheCondition: (failure) => failure is NetworkFailure || failure is ServerFailure,
    );
  }
}
```

#### `safeCall` 核心防腐流转机制
1. **网络连通性前置嗅探**：如果 `_networkInfo.isConnected` 为 `false` 且提供了 `cacheDataSource`，直接尝试返回本地缓存；若无缓存则直接短路返回 `Left(NetworkFailure('No internet connection'))`，杜绝无意义的底层超时等待。
2. **状态码自动解包与类型分流**：
   - 若 `response.result == ApiResult.success`（`"0"`），执行 `saveCache` 并返回 `Right(data)`。
   - 若 `response.result == ApiResult.sessionTimeout`（`"3"`），包装为 `AuthFailure`。
   - 若 `response.result == ApiResult.serverError`（`"1"`），提取 `response.messageId` 包装为 `ServerApiFailure`。
3. **低级异常刚性捕获与安全边界**：
   - `on DioException`: 提取 inner `AppException` 还原为对应 `Failure`。
   - `on TypeError`: 捕获字段类型解析不一致（如后端返回字符串而模型声明为 int），转为 `ParseFailure('Unexpected data format from server')`，杜绝未捕获异常导致页面白屏。
   - `catch (e, t)`: 兜底转化为 `UnknownFailure(e.toString())` 并记录 `appLogger.e`。

---

### 6.2 领域层与 UseCase 函数式单轨处理 (`Either<Failure, T>`)

在 Domain 层中，所有的 UseCase 均遵循纯函数式单轨设计，严格返回 `Future<Either<Failure, T>>`：

```dart
class GetAboutMeUseCase {
  final AboutMeRepository repository;

  GetAboutMeUseCase(this.repository);

  Future<Either<Failure, AboutMeEntity>> execute() {
    return repository.getAboutMe();
  }
}
```

---

### 6.3 展示层 MVI 统一处理范式 (`handleResult` & `handleFailure`)

在 Presentation 层的 `BaseViewModel` 中，通过 `handleResult()` 驱动状态转移与 UI 效果分发：

```dart
class AboutMeViewModel extends BaseViewModel<AboutMeIntent> {
  final GetAboutMeUseCase _getAboutMeUseCase;

  AboutMeViewModel(this._getAboutMeUseCase);

  @override
  Future<void> onIntent(AboutMeIntent intent) async {
    if (intent is LoadAboutMeIntent) {
      await _loadAboutMe();
    }
  }

  Future<void> _loadAboutMe() async {
    emitEffect(LoadingEffect(true));

    final result = await _getAboutMeUseCase.execute();

    await handleResult(
      result,
      onSuccess: (aboutMe) {
        updateState(state.copyWith(aboutMe: aboutMe, isLoading: false));
      },
      // onFailure 可缺省：缺省时自动调用 handleFailure() 触发 ErrorMapper 多语言映射
      onFailure: (failure) {
        updateState(state.copyWith(isLoading: false));
        handleFailure(failure);
      },
    );
  }
}
```

#### `handleFailure` 默认行为与差异化展现
- **`AuthFailure`**：自动发射 `LogoutEffect(message: mappedFailure.message)`，触发系统注销、清除本地 Token 并路由跳转至登录页。
- **`ServerApiFailure`**：若属于契约业务错误（如修改密码失败），通过 `MessageEffect.dialog(mappedFailure.message, title: Core.uiConfig.apiErrorTitle.tr)` 弹出对话框提醒用户。
- **其他 `Failure`（`NetworkFailure` / `ServerFailure`）**：通过 `MessageEffect.error(mappedFailure.message)` 触发轻量级顶部浮动横幅或 SnackBar / Toast。

---

### 6.4 单元测试最佳实践 (Unit Testing with Failures & ErrorMapper)

在针对 ViewModel 和 Repository 编写单元测试时，无需 Mock 真实的 HTTP 异常，只需构造强类型的 `Left(Failure)`：

```dart
test('should emit dialog effect when ServerApiFailure is encountered', () async {
  // Arrange
  when(mockUseCase.execute()).thenAnswer(
    (_) async => const Left(ServerApiFailure('Original Error', messageId: 'BIZ_0500')),
  );

  // Act & Assert
  expectLater(
    viewModel.effectStream,
    emitsInOrder([
      isA<LoadingEffect>(),
      predicate<MessageEffect>((e) => e.type == MessageType.dialog && e.message.contains('用户名已存在')),
    ]),
  );

  viewModel.sendIntent(LoadAboutMeIntent());
});
```

---

## 7. 生产环境常见故障排查指南 (Production Troubleshooting Matrix)

### 7.1 故障场景一：接口频繁报 `413 Request Entity Too Large`
- **故障排查链路**：
  1. 确认客户端是否上传了原尺寸图像（例如手机相册中 8MB~15MB 的高清原始照片）。
  2. 检查 Nginx 虚拟主机配置中 `client_max_body_size` 参数。若该值小于上传文件大小，请求将被 Nginx 反代直接切断，根本不会进入 Spring Boot。
- **治理措施**：
  - 在移动端实施前置下采样（详见 [todo.md](todo.md#opt-9-s3--cloudflare-r2-对象存储直传与端侧高质量图像下采样-s3r2-direct-upload--client-side-image-compression)），限制图像边长 $\le 512$ 像素，编码为 WebP（体积压制在 50KB 以内）。
  - Nginx 侧调整 `client_max_body_size 10M;` 保留合理的网关缓冲区。

### 7.2 故障场景二：大量请求同时报 401 且出现界面多次重定向
- **故障排查链路**：
  1. 查看移动端控制台日志是否包含 `[REFRESH] -> Starting flow` 与 `[QUEUE] -> Refresh in progress`。
  2. 检查后端 Refresh Token 是否已被注销或已跨越有效期限（通常为 7 天或 30 天）。
  3. 检查是否有业务接口遗漏配置了 `extra: { ApiClient.kNoAuthKey: true }`，导致访客公共接口因未带凭证被误判为 401。
- **治理措施**：
  - 验证 `AuthInterceptor` 的并发锁与重发逻辑是否正常运作，确保刷新期间仅发出单笔 `/auth/refresh` 请求。

### 7.3 故障场景三：接口返回 200 OK 但页面提示 `Unexpected data format from server`
- **故障排查链路**：
  1. 查看本地 APM 日志中的 `Data Type Mismatch: TypeError`。
  2. 核对服务端实体字段类型。例如后端数据库自增 ID 字段由 `Integer` 改为 `Long`，前端实体模型仍声明为 `int`，在部分平台上可能发生溢出；或服务端本应返回 `List` 的字段返回了空字符串 `""`。
- **治理措施**：
  - 在 DTO 的 `fromJson` 构造函数中使用 `as String?`、`num.tryParse()` 或 defensive casting 进行防御性兼容。

---

## 8. 存在不足与演进方向 (Limitations & Future Roadmap)

针对当前错误处理体系在实际运行与长效维护中暴露的瓶颈，已在项目待办清单 [todo.md](todo.md) 中建立专项演进课题：

### 8.1 Opt-23: 全链路异常指纹哈希与 APM 错误聚合去重
- **现状瓶颈**：当前在弱网频繁重试或并发请求批量失败时，相同错误（相同接口、HTTP 码与堆栈）会频繁弹跳重复 Toast，且日志缓冲区被无谓刷屏。
- **演进规划**：引入 `errorFingerprint` 64-bit 哈希算法与 3~5 秒滑动窗口冷却抑制器，重复错误静默聚合计数，消除 UI 界面抖动与遥测雪崩。（详见 [todo.md](todo.md#opt-23-全链路异常指纹哈希与-apm-错误聚合去重-error-fingerprint-hashing--apm-de-duplication)）。

### 8.2 Opt-24: 前后端契约错误码自动化代码生成与双端类型安全强校验
- **现状瓶颈**：Java 后端 `ErrorCode.java`、Flutter 前端常量及 `zh/en/ja` 多语言字典依赖人工手工维护，缺乏编译期刚性约束，存在漏配和文案脱节风险。
- **演进规划**：建立单一真实来源 `contracts/error_codes.yaml` 契约定义，基于 Dart CLI 自动化代码生成双端枚举和翻译模板，并在 CI 中建立 100% 键值对齐静态门禁。（详见 [todo.md](todo.md#opt-24-前后端契约错误码自动化代码生成与双端类型安全强校验-automated-error-code-contract-code-gen--end-to-end-type-safety)）。

---

## 9. 相关文档与源码参考 (References)

- **待办任务清单**: [todo.md](todo.md)
- **仓储缓存策略**: [repository_caching_strategy.md](repository_caching_strategy.md)
- **开发与调试工作流**: [development_workflow.md](development_workflow.md)
- **Mock 数据维护规范**: [mock_data_specification.md](mock_data_specification.md)
- **核心源码参考**:
  - [error_interceptor.dart](../../ListenCore/lib/network/interceptors/error_interceptor.dart) - 传输层 Dio 错误拦截与网关 HTML 防腐
  - [exceptions.dart](../../ListenCore/lib/errors/exceptions.dart) - 数据层强类型异常层次结构
  - [failures.dart](../../ListenCore/lib/errors/failures.dart) - 领域层不可变失败模型
  - [error_mapper.dart](../../ListenCore/lib/errors/error_mapper.dart) - 三级级联多语言映射器
  - [base_repository.dart](../../ListenCore/lib/network/base_repository.dart) - safeCall 统一防腐与缓存降级
  - [base_view_model.dart](../../ListenCore/lib/base/base_view_model.dart) - MVI handleResult 与 handleFailure
  - [ApiResponse.java](../../ListenPortfolioBackend/src/main/java/com/listen/portfolio/common/ApiResponse.java) - 后端标准统一响应包络
  - [GlobalExceptionHandler.java](../../ListenPortfolioBackend/src/main/java/com/listen/portfolio/common/config/GlobalExceptionHandler.java) - 后端全局异常处理与契约转换

