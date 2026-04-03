# Mock 数据维护规范

本文档定义了 Listen Portfolio Flutter 项目中 Mock 数据的目录结构、命名规则和维护规范，确保团队协作时 Mock 数据的一致性和可维护性。

## 📁 目录结构

### 🎯 整体结构

```
assets/mock/
├── v1/                    # API 版本号目录
│   ├── get/              # GET 请求响应数据
│   ├── post/             # POST 请求响应数据
│   ├── put/              # PUT 请求响应数据
│   ├── delete/           # DELETE 请求响应数据
│   └── images/           # Mock 图片资源
└── images/               # 通用 Mock 图片资源
```

### 📋 版本管理

#### **版本号规则**
- 使用语义化版本号：`v{major}.{minor}.{patch}`
- 当前版本：`v1.0.0` → 目录名：`v1`
- 版本升级时创建新目录：`v2`, `v3` 等

#### **版本兼容性**
```
v1/     ← 当前稳定版本
v2/     ← 开发中版本（可选）
```

---

## 🗂️ HTTP 方法目录结构

### 📥 GET 请求 (`get/`)

```
assets/mock/v1/get/
├── user.json              # 获取用户信息
├── aboutMe.json           # 获取关于我信息
├── projects.json          # 获取项目列表
└── {endpoint}.json        # 其他 GET 接口
```

### 📤 POST 请求 (`post/`)

```
assets/mock/v1/post/
├── auth/                  # 认证相关接口
│   ├── login.json         # 登录接口
│   ├── signUp.json        # 注册接口
│   ├── refresh.json       # 刷新令牌接口
│   └── forgot-password.json # 忘记密码接口
├── user/                  # 用户相关接口
│   ├── update.json        # 更新用户信息
│   └── delete.json        # 删除用户账户
└── {feature}/             # 其他功能模块
    └── {endpoint}.json
```

### 📝 PUT 请求 (`put/`)

```
assets/mock/v1/put/
├── user.json              # 更新用户信息
├── settings.json          # 更新设置
└── {endpoint}.json        # 其他 PUT 接口
```

### 🗑️ DELETE 请求 (`delete/`)

```
assets/mock/v1/delete/
├── user.json              # 删除用户账户
├── cache.json             # 清除缓存
└── {endpoint}.json        # 其他 DELETE 接口
```

---

## 📝 文件命名规则

### 🎯 基本规则

#### **命名格式**
```
{feature}-{action}.json
{endpoint}.json
{resource}.json
```

#### **命名约定**
- ✅ **小写字母**：全小写命名
- ✅ **连字符分隔**：使用 `-` 连接多个单词
- ✅ **语义化**：文件名要能清楚表达接口用途
- ❌ **避免缩写**：使用完整单词，避免歧义

### 📋 具体示例

#### **认证模块 (`auth/`)**
```
✅ login.json              ← 登录接口
✅ sign-up.json            ← 注册接口（使用连字符）
✅ refresh-token.json      ← 刷新令牌接口
✅ forgot-password.json    ← 忘记密码接口

❌ login.json              ← 正确
❌ Login.json              ← 错误：大写字母
❌ login_api.json          ← 错误：使用下划线
❌ loginAPI.json           ← 错误：驼峰命名
```

#### **用户模块 (`user/`)**
```
✅ profile.json            ← 用户资料
✅ update-profile.json     ← 更新资料
✅ change-password.json    ← 修改密码
✅ delete-account.json     ← 删除账户

 userInfo.json            ← 错误：驼峰命名
❌ user_info.json          ← 错误：下划线
❌ UserInfo.json           ← 错误：大写字母
```

#### **项目模块 (`projects/`)**
```
✅ projects.json           ← 项目列表
✅ project-detail.json     ← 项目详情
✅ create-project.json     ← 创建项目
✅ update-project.json     ← 更新项目
✅ delete-project.json     ← 删除项目

❌ projects.json            ← 正确
❌ Projects.json           ← 错误：大写字母
❌ projectDetail.json      ← 错误：驼峰命名
```

---

## 🏗️ 数据结构规范

### 📋 标准响应格式

#### **成功响应**
```json
{
  "result": "0",
  "message": "success",
  "messageId": "unique_message_id",
  "body": {
    // 具体数据内容
  }
}
```

#### **错误响应**
```json
{
  "result": "1",
  "message": "error_description",
  "messageId": "error_code",
  "body": {
    "error": "detailed_error_info"
  }
}
```

### 🎯 字段规范

#### **通用字段**
| 字段 | 类型 | 说明 | 示例 |
|------|------|------|------|
| `result` | string | 响应结果码 | "0"=成功, "1"=失败 |
| `message` | string | 响应消息 | "success", "error" |
| `messageId` | string | 消息标识符 | "LOGIN_SUCCESS", "USER_NOT_FOUND" |
| `body` | object | 响应数据体 | 具体业务数据 |

#### **业务数据字段**
- ✅ **驼峰命名**：使用 camelCase
- ✅ **语义化**：字段名要有明确含义
- ✅ **类型一致**：相同字段在不同接口中类型保持一致

---

## 🔄 新增接口 Mock 数据流程

### 1️⃣ **确定接口信息**

#### **接口分析**
```
接口路径: /api/v1/auth/login
请求方法: POST
功能描述: 用户登录
```

#### **确定目录位置**
```
HTTP 方法: POST → assets/mock/v1/post/
功能模块: auth → assets/mock/v1/post/auth/
```

### 2️⃣ **创建 Mock 文件**

#### **文件命名**
```
接口功能: 登录 → login
文件名: login.json
完整路径: assets/mock/v1/post/auth/login.json
```

#### **文件创建**
```bash
# 创建目录（如果不存在）
mkdir -p assets/mock/v1/post/auth

# 创建文件
touch assets/mock/v1/post/auth/login.json
```

### 3️⃣ **编写 Mock 数据**

#### **登录接口示例**
```json
{
  "result": "0",
  "message": "Login successful",
  "messageId": "LOGIN_SUCCESS",
  "body": {
    "userId": "1001",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 3600,
    "user": {
      "id": "1001",
      "email": "user@example.com",
      "name": "Test User"
    }
  }
}
```

### 4️⃣ **更新 pubspec.yaml**

#### **添加资源路径**
```yaml
flutter:
  assets:
    - assets/mock/v1/
    - assets/mock/v1/get/
    - assets/mock/v1/post/
    - assets/mock/v1/post/auth/
    - assets/mock/v1/post/user/
    - assets/mock/v1/put/
    - assets/mock/v1/delete/
```

### 5️⃣ **测试验证**

#### **验证步骤**
1. 启动应用（Mock 环境）
2. 调用对应接口
3. 验证返回数据格式
4. 检查业务逻辑是否正常

---

## 📝 Mock 数据编写指南

### 🎯 数据真实性

#### **用户数据**
```json
{
  "body": {
    "id": "1001",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "avatarUrl": "https://api.dicebear.com/7.x/avataaars/png?seed=JohnDoe",
    "location": "Tokyo, Japan",
    "bio": "Flutter Developer with 5 years of experience"
  }
}
```

#### **项目数据**
```json
{
  "body": {
    "projects": [
      {
        "id": "proj_001",
        "title": "E-commerce App",
        "description": "A full-featured e-commerce mobile application",
        "technologies": ["Flutter", "Firebase", "Stripe"],
        "imageUrl": "https://via.placeholder.com/300x200",
        "projectUrl": "https://github.com/user/ecommerce-app",
        "startDate": "2023-01-15",
        "endDate": "2023-06-30",
        "status": "completed"
      }
    ]
  }
}
```

### 🔄 数据变化场景

#### **分页数据**
```json
{
  "result": "0",
  "message": "success",
  "messageId": "PROJECTS_FETCHED",
  "body": {
    "projects": [...],
    "pagination": {
      "currentPage": 1,
      "totalPages": 10,
      "totalItems": 100,
      "hasNext": true,
      "hasPrevious": false
    }
  }
}
```

#### **错误场景**
```json
{
  "result": "1",
  "message": "Invalid credentials",
  "messageId": "LOGIN_FAILED",
  "body": {
    "error": "USER_NOT_FOUND",
    "details": "No user found with the provided email"
  }
}
```

---

## 🛠️ 维护最佳实践

### 📅 定期维护

#### **每周检查**
- [ ] 验证 Mock 数据与最新 API 文档一致性
- [ ] 清理不再使用的 Mock 文件
- [ ] 更新过期的测试数据

#### **版本发布前**
- [ ] 确保所有新接口都有对应的 Mock 数据
- [ ] 验证 Mock 数据格式正确性
- [ ] 更新相关文档

### 🔄 数据同步

#### **API 变更同步**
1. **API 接口变更** → 立即更新对应 Mock 数据
2. **数据结构变更** → 同步更新所有相关 Mock 文件
3. **新增字段** → 在 Mock 数据中添加对应字段

#### **团队协作**
- 📋 **变更通知**：API 变更时通知团队成员更新 Mock
- 🔄 **定期同步**：每周同步 Mock 数据变更
- 📝 **文档更新**：及时更新相关文档

### 🧪 测试覆盖

#### **场景覆盖**
- ✅ **正常流程**：标准的成功响应
- ✅ **错误场景**：各种错误情况
- ✅ **边界情况**：空数据、极值等
- ✅ **权限场景**：不同权限级别的响应

#### **数据验证**
```bash
# 验证 JSON 格式正确性
flutter packages pub run build_runner build

# 运行测试确保 Mock 数据正常
flutter test test/mock/
```

---

## 🔧 工具和脚本

### 📝 Mock 数据生成器

#### **用户数据生成**
```dart
// 工具类：生成测试用户数据
class MockUserGenerator {
  static Map<String, dynamic> generateUser({
    String? id,
    String? name,
    String? email,
  }) {
    return {
      "result": "0",
      "message": "success",
      "messageId": "USER_FETCHED",
      "body": {
        "id": id ?? "1001",
        "name": name ?? "Test User",
        "email": email ?? "test@example.com",
        "avatarUrl": "https://api.dicebear.com/7.x/avataaars/png?seed=${name ?? 'Test'}",
        "location": "Tokyo, Japan",
        "createdAt": "2023-01-01T00:00:00Z",
        "updatedAt": "2023-12-01T00:00:00Z",
      }
    };
  }
}
```

### 🔄 批量更新脚本

#### **更新所有时间戳**
```bash
#!/bin/bash
# update_timestamps.sh

# 更新所有 Mock 文件中的时间戳
find assets/mock/v1 -name "*.json" -exec sed -i 's/"updatedAt": "[^"]*"/"updatedAt": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"/g' {} \;
```

---

## 📋 检查清单

### ✅ 新增 Mock 数据检查清单

- [ ] **文件命名**：符合命名规范（小写、连字符分隔）
- [ ] **目录结构**：放在正确的 HTTP 方法目录中
- [ ] **数据格式**：符合标准响应格式
- [ ] **字段命名**：使用 camelCase，语义化命名
- [ ] **数据真实性**：数据要真实可信
- [ ] **错误场景**：包含对应的错误响应
- [ ] **pubspec.yaml**：已添加新的资源路径
- [ ] **测试验证**：在 Mock 环境中测试通过
- [ ] **文档更新**：更新相关接口文档

### ✅ Mock 数据维护检查清单

- [ ] **格式验证**：JSON 格式正确
- [ ] **数据一致性**：与最新 API 文档一致
- [ ] **文件清理**：删除不再使用的文件
- [ ] **版本管理**：重大变更时创建新版本目录
- [ ] **团队同步**：通知团队成员相关变更

---

## 🚨 常见问题和解决方案

### ❓ **常见问题**

#### **1. Mock 数据不生效**
```
问题：应用启动后仍使用真实 API
解决：
1. 确认 APP_ENV=mock 环境变量设置
2. 检查 pubspec.yaml 中是否包含 assets/mock/v1/
3. 重新运行 flutter pub get
```

#### **2. JSON 格式错误**
```
问题：应用启动时报 JSON 解析错误
解决：
1. 使用 JSON 验证工具检查格式
2. 确认所有字符串使用双引号
3. 检查是否有尾随逗号
```

#### **3. 文件路径错误**
```
问题：找不到 Mock 文件
解决：
1. 确认文件路径大小写正确
2. 检查 pubspec.yaml 中资源路径配置
3. 重新构建应用
```

#### **4. 数据结构不匹配**
```
问题：应用解析数据时出错
解决：
1. 对比真实 API 响应格式
2. 更新 Mock 数据结构
3. 检查字段类型是否正确
```

### 💡 **最佳实践建议**

1. **🎯 保持简单**：Mock 数据不要过于复杂
2. **🔄 定期更新**：与 API 变更保持同步
3. **📝 文档同步**：及时更新相关文档
4. **🧪 充分测试**：覆盖各种使用场景
5. **👥 团队协作**：建立变更通知机制

---

## 📚 相关文档

- [标准化开发工作流](development-workflow.md)
- [API 设计规范](api-design.md)
- [错误处理指南](error-handling.md)
- [测试策略](testing-strategy.md)

---

**更新日期**: 2026-04-03  
**维护者**: 开发团队  
**版本**: 1.0.0
