# 错误码速查表

**Status**: `Partially Implemented`

> 本文档同时包含当前代码中已经存在的错误处理机制，以及仍在规划中的统一错误码 / `messageId` / i18n 映射方案。阅读时请以代码实现为准，不要默认本文所有条目都已落地。

本文档整理了 Listen Portfolio Flutter 项目中的错误码体系，包括 `AppException` 子类、业务错误码和对应的处理方式，方便快速排查线上问题。

## 🏗️ 错误处理架构

### 📋 核心组件

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │    │    Domain       │    │     Data        │
│                 │    │                 │    │                 │
│  UI Layer       │───▶│  Use Cases      │───▶│  Repositories   │
│                 │    │                 │    │                 │
│ Error Handling  │    │ Either<Failure,  │    │ safeCall()      │
│                 │    │      T>         │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 🔄 错误流转

1. **Data Layer** → API 调用失败 → 创建 `Failure` 对象
2. **Domain Layer** → UseCase 处理 → 返回 `Either<Failure, T>`
3. **Presentation Layer** → ViewModel 处理 → 显示用户友好消息

---

## 📊 错误码分类体系

### 🎯 标准响应格式

#### **成功响应**
```json
{
  "result": "0",
  "messageId": "SUCCESS",
  "message": "Operation successful",
  "body": { ... }
}
```

#### **错误响应**
```json
{
  "result": "1",
  "messageId": "ERROR_CODE",
  "message": "Error description",
  "body": {
    "error": "Detailed error information"
  }
}
```

### 📋 错误码层级

| 层级 | 前缀 | 说明 | 示例 |
|------|------|------|------|
| **系统级** | `SYS_` | 框架、网络、存储错误 | `SYS_NETWORK_ERROR` |
| **业务级** | `BIZ_` | 业务逻辑错误 | `BIZ_LOGIN_FAILED` |
| **验证级** | `VAL_` | 数据验证错误 | `VAL_EMAIL_INVALID` |
| **权限级** | `AUTH_` | 认证授权错误 | `AUTH_TOKEN_EXPIRED` |
| **外部级** | `EXT_` | 第三方服务错误 | `EXT_PAYMENT_FAILED` |

---

## 🔧 Failure 类型详解

### 🌐 **NetworkFailure** - 网络错误

#### **错误码范围**: `NET_0001` - `NET_0099`

| 错误码 | 说明 | 触发场景 | 用户消息 |
|--------|------|----------|----------|
| `NET_0001` | 网络连接失败 | 无网络连接 | "No internet connection" |
| `NET_0002` | 请求超时 | 网络超时 | "Request timeout" |
| `NET_0003` | DNS 解析失败 | 域名无法解析 | "Unable to connect to server" |
| `NET_0004` | SSL/TLS 错误 | 证书问题 | "Secure connection failed" |
| `NET_0005` | 服务器无响应 | 服务器宕机 | "Server unavailable" |

#### **处理方式**
```dart
// 在 ViewModel 中处理
return result.fold(
  (failure) {
    if (failure is NetworkFailure) {
      emitEffect(MessageEffect.error('Please check your internet connection'));
    }
  },
  (success) => handleSuccess(success),
);
```

### 🖥️ **ServerFailure** - 服务器错误

#### **错误码范围**: `SRV_0100` - `SRV_0199`

| 错误码 | HTTP状态码 | 说明 | 用户消息 |
|--------|------------|------|----------|
| `SRV_0100` | 500 | 内部服务器错误 | "Server error occurred" |
| `SRV_0101` | 502 | 网关错误 | "Service temporarily unavailable" |
| `SRV_0102` | 503 | 服务不可用 | "Service under maintenance" |
| `SRV_0103` | 504 | 网关超时 | "Request timeout" |
| `SRV_0104` | 429 | 请求过于频繁 | "Too many requests, please try again later" |

#### **处理方式**
```dart
if (failure is ServerFailure) {
  switch (failure.messageId) {
    case 'SRV_0104':
      emitEffect(MessageEffect.warning('Please wait before trying again'));
      break;
    default:
      emitEffect(MessageEffect.error('Server error, please try again later'));
  }
}
```

### 💾 **CacheFailure** - 缓存错误

#### **错误码范围**: `CAC_0200` - `CAC_0299`

| 错误码 | 说明 | 触发场景 | 用户消息 |
|--------|------|----------|----------|
| `CAC_0200` | 缓存未命中 | 首次访问 | "Loading from server..." |
| `CAC_0201` | 缓存过期 | 数据过期 | "Updating data..." |
| `CAC_0202` | 缓存损坏 | 数据损坏 | "Data corrupted, refreshing..." |
| `CAC_0203` | 存储空间不足 | 本地存储满 | "Storage full, clearing cache..." |

### 🔐 **AuthFailure** - 认证错误

#### **错误码范围**: `AUTH_0300` - `AUTH_0399`

| 错误码 | 说明 | 触发场景 | 用户消息 |
|--------|------|----------|----------|
| `AUTH_0300` | 登录失败 | 用户名密码错误 | "Invalid username or password" |
| `AUTH_0301` | 账户不存在 | 用户未注册 | "Account not found" |
| `AUTH_0302` | 账户已锁定 | 多次失败尝试 | "Account locked, please contact support" |
| `AUTH_0303` | Token 过期 | JWT 过期 | "Session expired, please login again" |
| `AUTH_0304` | Token 无效 | Token 被篡改 | "Invalid session, please login again" |
| `AUTH_0305` | 权限不足 | 无权限访问 | "Access denied" |
| `AUTH_0306` | 刷新令牌失败 | RefreshToken 无效 | "Session expired, please login again" |

#### **处理示例**
```dart
// LoginUseCase 中的处理
if (userId.isEmpty) {
  return const Left(ServerFailure('User ID is missing in response'));
}
```

### ✅ **ValidationFailure** - 验证错误

#### **错误码范围**: `VAL_0400` - `VAL_0499`

| 错误码 | 说明 | 触发场景 | 用户消息 |
|--------|------|----------|----------|
| `VAL_0400` | 邮箱格式错误 | 邮箱验证失败 | "Please enter a valid email address" |
| `VAL_0401` | 密码长度不足 | 密码太短 | "Password must be at least 8 characters" |
| `VAL_0402` | 密码不匹配 | 确认密码不一致 | "Passwords do not match" |
| `VAL_0403` | 必填字段为空 | 表单验证 | "Please fill in all required fields" |
| `VAL_0404` | 手机号格式错误 | 手机号验证 | "Please enter a valid phone number" |

### 🏢 **BusinessFailure** - 业务逻辑错误

#### **错误码范围**: `BIZ_0500` - `BIZ_0599`

| 错误码 | 说明 | 触发场景 | 用户消息 |
|--------|------|----------|----------|
| `BIZ_0500` | 用户已存在 | 注册时用户名重复 | "Username already exists" |
| `BIZ_0501` | 邮箱已注册 | 注册时邮箱重复 | "Email already registered" |
| `BIZ_0502` | 原密码错误 | 修改密码验证失败 | "Current password is incorrect" |
| `BIZ_0503` | 账户删除失败 | 删除账户时失败 | "Failed to delete account" |
| `BIZ_0504` | 密码重试次数过多 | 忘记密码限制 | "Too many attempts, please try again later" |

---

## 🎨 UI 消息映射

### 📱 **用户友好消息**

#### **网络错误**
```dart
const Map<String, String> networkErrorMessages = {
  'NET_0001': 'Please check your internet connection',
  'NET_0002': 'Request timeout, please try again',
  'NET_0003': 'Unable to connect to server',
  'NET_0004': 'Secure connection failed',
  'NET_0005': 'Server is temporarily unavailable',
};
```

#### **认证错误**
```dart
const Map<String, String> authErrorMessages = {
  'AUTH_0300': 'Invalid username or password',
  'AUTH_0301': 'Account not found',
  'AUTH_0302': 'Account locked due to too many failed attempts',
  'AUTH_0303': 'Session expired, please login again',
  'AUTH_0304': 'Invalid session, please login again',
  'AUTH_0305': 'You don\'t have permission to access this resource',
  'AUTH_0306': 'Session expired, please login again',
};
```

### 🌍 **国际化支持**

#### **错误消息键名**

> [!WARNING]
> 以下代码为设计草稿，当前代码库中尚未实现，仅供开发参考。

```dart
// DESIGN ONLY - NOT YET IMPLEMENTED
class I18nErrorKeys {
  // Network Errors
  static const String networkError = 'error.network';
  static const String timeoutError = 'error.timeout';
  static const String serverUnavailable = 'error.server_unavailable';
  
  // Auth Errors
  static const String invalidCredentials = 'error.invalid_credentials';
  static const String accountNotFound = 'error.account_not_found';
  static const String sessionExpired = 'error.session_expired';
  
  // Validation Errors
  static const String emailInvalid = 'error.email_invalid';
  static const String passwordTooShort = 'error.password_too_short';
  static const String passwordsNotMatch = 'error.passwords_not_match';
}
```

#### **多语言配置示例**

> [!WARNING]
> 以下多语言 JSON 配置项为设计草稿，当前实际语言包文件（如 `.tr` 或 `.json` 文件）中尚未完整添加这些 key，仅供开发参考。

```json
// DESIGN ONLY - NOT YET IMPLEMENTED
// en.json
{
  "error": {
    "network": "Please check your internet connection",
    "timeout": "Request timeout, please try again",
    "invalid_credentials": "Invalid username or password",
    "session_expired": "Session expired, please login again"
  }
}

// zh.json
{
  "error": {
    "network": "请检查网络连接",
    "timeout": "请求超时，请重试",
    "invalid_credentials": "用户名或密码错误",
    "session_expired": "会话已过期，请重新登录"
  }
}
```

---

## 🔍 错误排查指南

### 🚨 **线上问题排查流程**

#### **1. 收集错误信息**
```dart
// 在 CrashManager 中记录详细错误
class CrashManager {
  static void logError({
    required String errorCode,
    required String errorMessage,
    required String stackTrace,
    required Map<String, dynamic> context,
  }) {
    final errorReport = {
      'timestamp': DateTime.now().toIso8601String(),
      'errorCode': errorCode,
      'errorMessage': errorMessage,
      'stackTrace': stackTrace,
      'context': context,
      'appVersion': PackageInfo.fromPlatform().version,
      'buildNumber': PackageInfo.fromPlatform().buildNumber,
    };
    
    // 保存到本地或上传到服务器
    _saveErrorReport(errorReport);
  }
}
```

#### **2. 错误分类处理**

| 错误类型 | 紧急程度 | 处理方式 | 通知方式 |
|---------|----------|----------|----------|
| **系统崩溃** | 🔴 高 | 立即修复 | 紧急通知 |
| **认证失败** | 🟡 中 | 检查认证逻辑 | 用户反馈 |
| **网络错误** | 🟡 中 | 检查网络配置 | 监控告警 |
| **验证错误** | 🟢 低 | 优化用户体验 | 用户反馈 |

#### **3. 常见问题排查**

##### **登录失败率高**
```
排查步骤:
1. 检查 AUTH_0300 错误码频率
2. 验证密码加密逻辑
3. 检查服务器端认证接口
4. 分析用户行为日志
```

##### **网络请求超时**
```
排查步骤:
1. 检查 NET_0002 错误码分布
2. 分析网络环境统计
3. 检查超时配置是否合理
4. 优化重试机制
```

##### **缓存数据异常**
```
排查步骤:
1. 检查 CAC_0202 错误码
2. 验证缓存序列化逻辑
3. 检查存储空间使用情况
4. 优化缓存清理策略
```

### 📊 **错误监控指标**

#### **关键指标**

> [!WARNING]
> 以下代码为设计草稿，当前代码库中尚未实现，仅供开发参考。

```dart
// DESIGN ONLY - NOT YET IMPLEMENTED
class ErrorMetrics {
  // 错误率统计
  static double getErrorRate(String errorCode) {
    final totalRequests = _getTotalRequests();
    final errorCount = _getErrorCount(errorCode);
    return errorCount / totalRequests;
  }
  
  // 错误趋势分析
  static List<ErrorTrend> getErrorTrend(String errorCode, Duration period) {
    return _calculateTrend(errorCode, period);
  }
  
  // 错误影响范围
  static Map<String, double> getErrorImpact(String errorCode) {
    return _calculateImpact(errorCode);
  }
}
```

#### **告警阈值**
| 指标 | 阈值 | 告警级别 |
|------|------|----------|
| **总错误率** | > 5% | 🟡 中等 |
| **系统错误率** | > 2% | 🔴 高 |
| **认证错误率** | > 10% | 🟡 中等 |
| **网络错误率** | > 15% | 🟡 中等 |
| **单错误码频率** | > 100次/小时 | 🟡 中等 |

---

## 🛠️ 开发调试

### 🐛 **本地调试**

#### **错误注入测试**

> [!WARNING]
> 以下代码为设计草稿，当前代码库中尚未实现，仅供开发参考.

```dart
// DESIGN ONLY - NOT YET IMPLEMENTED
class ErrorInjector {
  static void injectError(String errorCode) {
    switch (errorCode) {
      case 'NET_0001':
        // 模拟网络连接失败
        throw NetworkFailure('Network connection failed');
      case 'AUTH_0300':
        // 模拟登录失败
        throw AuthFailure('Invalid credentials');
      case 'SRV_0100':
        // 模拟服务器错误
        throw ServerFailure('Internal server error');
    }
  }
}
```

#### **错误日志查看**
```dart
// 在开发环境中显示详细错误
if (kDebugMode) {
  result.fold(
    (failure) {
      print('=== ERROR DEBUG ===');
      print('Type: ${failure.runtimeType}');
      print('Code: ${failure.messageId}');
      print('Message: ${failure.message}');
      print('Timestamp: ${DateTime.now()}');
      print('==================');
    },
    (success) => print('Operation successful'),
  );
}
```

### 🧪 **单元测试**

#### **错误场景测试**
```dart
test('should handle network failure', () async {
  // Arrange
  when(mockRepository.login(any()))
      .thenAnswer((_) async => Left(NetworkFailure('NET_0001')));
  
  // Act
  final result = await loginUseCase.call(param: loginRequest);
  
  // Assert
  expect(result.isLeft(), true);
  expect(result.fold((l) => l, (r) => null), isA<NetworkFailure>());
});
```

---

## 📋 快速参考

### 🎯 **常用错误码速查**

| 错误码 | 类型 | 用户消息 | 处理建议 |
|--------|------|----------|----------|
| `NET_0001` | Network | "No internet connection" | 检查网络设置 |
| `AUTH_0300` | Auth | "Invalid credentials" | 重新输入账号密码 |
| `AUTH_0303` | Auth | "Session expired" | 重新登录 |
| `VAL_0400` | Validation | "Invalid email" | 检查邮箱格式 |
| `SRV_0100` | Server | "Server error" | 稍后重试 |
| `BIZ_0500` | Business | "Username exists" | 使用其他用户名 |

### 🔄 **错误处理模式**

```dart
// 标准错误处理模式
Future<void> handleOperation() async {
  final result = await someOperation();
  
  await result.fold(
    (failure) async {
      // 1. 记录错误
      CrashManager.logError(
        errorCode: failure.messageId,
        errorMessage: failure.message,
        stackTrace: StackTrace.current,
        context: {'operation': 'someOperation'},
      );
      
      // 2. 显示用户友好消息
      final userMessage = _getUserFriendlyMessage(failure);
      emitEffect(MessageEffect.error(userMessage));
      
      // 3. 特殊处理
      if (failure is AuthFailure) {
        await _handleAuthError(failure);
      }
    },
    (success) async {
      // 处理成功情况
      await _handleSuccess(success);
    },
  );
}
```

### 📱 **用户体验优化**

```dart
String _getUserFriendlyMessage(Failure failure) {
  // 网络错误 - 提供解决方案
  if (failure is NetworkFailure) {
    return 'Please check your internet connection and try again.';
  }
  
  // 认证错误 - 提供具体指导
  if (failure is AuthFailure) {
    switch (failure.messageId) {
      case 'AUTH_0300':
        return 'Invalid username or password. Please check your credentials.';
      case 'AUTH_0303':
        return 'Your session has expired. Please login again.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
  
  // 默认消息
  return failure.message;
}
```

---

## 📚 相关文档

- [标准化开发工作流](development-workflow.md)
- [Mock 数据维护规范](mock-data-specification.md)
- [项目开发指南](project-development-guide.md)
- [文档生成指南](documentation-generation.md)

---

**更新日期**: 2026-04-03  
**维护者**: 开发团队  
**版本**: 1.0.0
