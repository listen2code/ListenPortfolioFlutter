# Flutter Testing Guide

## 📋 概述

本文档介绍 Listen Portfolio Flutter 项目的测试系统，包括 CI 集成、本地测试运行和覆盖率分析。

## 🧪 测试结构

### 测试文件分布
```
test/
├── core/                                    # 核心功能测试
│   ├── network/auth_interceptor_test.dart   # 认证拦截器测试
│   └── validators_test.dart                 # 验证器测试
├── features/                                # 功能模块测试
│   ├── auth/ (13 files)                     # 认证模块
│   │   ├── auth_repository_impl_test.dart   # Repository 层测试
│   │   ├── login/                          # Login 流程测试
│   │   ├── sign_up/                        # 注册测试
│   │   ├── password/                       # 密码管理测试
│   │   └── delete_account/                 # 账户删除测试
│   ├── home/ (10 files)                    # 主页功能
│   │   ├── about_me/                       # 关于我功能
│   │   ├── projects/                       # 项目展示和管理
│   │   ├── overview/                       # 概览页面
│   │   └── architecture/                   # 架构展示
│   └── settings/ (5 files)                 # 设置模块
│       ├── appearance/                     # 主题和外观
│       ├── crash_log_list/                 # 崩溃日志管理
│       ├── privacy_policy/                 # 隐私政策显示
│       ├── terms_of_service/               # 服务条款
│       └── settings/                       # 主设置页面
├── test_helpers/
│   └── test_setup.dart                     # 测试环境配置
└── test_config.toml                        # 测试配置文件
```

### 测试类型详解

#### 1. **ViewModel Tests** (MVI 架构)
- **目的**: 测试 Intent → State/Effect 转换逻辑
- **覆盖范围**: 用户交互、业务逻辑、状态管理
- **示例**: LoginViewModel, SettingsViewModel, ProjectViewModel

#### 2. **Repository Tests** (数据层)
- **目的**: 测试 safeCall 模式、错误处理、缓存
- **覆盖范围**: API 调用、本地存储、数据转换
- **示例**: AuthRepositoryImpl, ProjectsRepositoryImpl

#### 3. **UseCase Tests** (业务逻辑)
- **目的**: 测试参数验证、业务规则
- **覆盖范围**: 输入验证、业务逻辑、错误场景
- **示例**: LoginUseCase, GetProjectsUseCase

#### 4. **Widget Tests** (UI 层)
- **目的**: 测试 UI 组件渲染和用户交互
- **覆盖范围**: UI 组件、用户交互、可访问性
- **示例**: ProjectsWidget, SettingsPage

#### 5. **Infrastructure Tests** (基础设施)
- **目的**: 测试核心基础设施组件
- **覆盖范围**: 网络层、验证器、拦截器
- **示例**: AuthInterceptor, InputValidators

## 🚀 本地测试运行

### 使用 PowerShell 脚本 (推荐)

```powershell
# 运行所有测试
.\scripts\run_tests.ps1

# 运行单元测试并生成覆盖率
.\scripts\run_tests.ps1 -Unit -Coverage

# 运行特定测试文件
.\scripts\run_tests.ps1 -File "test\features\auth\login\login_view_model_test.dart"

# 详细输出
.\scripts\run_tests.ps1 -Verbose
```

### 使用 Bash 脚本 (Linux/macOS/WSL)

```bash
# 运行所有测试
./scripts/run_tests.sh

# 运行单元测试并生成覆盖率
./scripts/run_tests.sh -u -c

# 运行特定测试类型
./scripts/run_tests.sh --unit --widget

# 详细输出
./scripts/run_tests.sh --verbose
```

### 使用 Flutter 命令

```bash
# 运行所有测试
flutter test

# 运行特定测试
flutter test test/features/auth/

# 生成覆盖率报告
flutter test --coverage

# 详细输出
flutter test --reporter=expanded
```

## 📊 覆盖率分析

### 覆盖率目标
- **最低要求**: 60% (TODO.md 中指定)
- **目标分布**:
  - ViewModel 层: 90%
  - Repository 层: 85%
  - UseCase 层: 80%
  - Widget 层: 70%
  - 基础设施: 75%

### 生成覆盖率报告

```bash
# 生成覆盖率数据
flutter test --coverage

# 生成 HTML 报告 (需要 lcov)
genhtml coverage/lcov.info -o coverage/html

# 查看覆盖率摘要
lcov --summary coverage/lcov.info
```

### 覆盖率报告位置
- **HTML 报告**: `coverage/html/index.html`
- **原始数据**: `coverage/lcov.info`
- **CI 上传**: 自动上传到 Codecov

## 🔄 CI 集成

### 主 CI 工作流 (`.github/workflows/ci.yml`)

项目使用单一的主 CI 工作流，集成了测试作为质量门控：

#### **工作流结构**
```yaml
jobs:
  check-conditions          # 检查是否需要构建 APK
  flutter-test             # 运行测试和覆盖率分析
  dependency-analysis      # 依赖边界检查和代码分析
  build-apk               # 构建 APK (依赖测试通过)
  skip-build              # 跳过构建的通知
```

#### **测试执行流程**
1. **flutter-test 作业**:
   - 运行所有单元测试 (31 个文件)
   - 生成覆盖率报告
   - 上传覆盖率到 Codecov
   - 检查覆盖率是否达到 60% 最低要求

2. **依赖关系**:
   - APK 构建依赖测试通过
   - 如果测试失败，APK 构建被跳过

#### **测试失败定义**

##### **1. 硬性失败 (会导致 APK 构建跳过)**
- ✅ **任何单元测试失败**: `flutter test` 命令返回非零退出码
- ✅ **任何 Widget 测试失败**: 测试用例断言失败或异常
- ✅ **任何集成测试失败**: 端到端测试失败
- ✅ **依赖分析失败**: `dependency-analysis` 作业失败

##### **2. 软性失败 (仅警告，不阻止构建)**
- ⚠️ **覆盖率不足**: 低于 60% 但测试全部通过
- ⚠️ **覆盖率生成失败**: lcov 工具问题但不影响测试执行

##### **3. 具体失败场景**
```bash
# 场景1: 单个测试用例失败
flutter test --coverage --reporter=expanded
# 输出: 00:01 +2: Some test failed
# 结果: 整个 flutter-test 作业失败 → APK 构建跳过

# 场景2: 编译错误
flutter test test/features/auth/login/login_view_model_test.dart
# 输出: Compilation error
# 结果: flutter-test 作业失败 → APK 构建跳过

# 场景3: 覆盖率不足
# 测试全部通过，但覆盖率只有 45%
# 输出: Coverage check failed: 45% < 60%
# 结果: flutter-test 作业成功 → APK 构建继续
```

##### **4. GitHub Actions 状态判断**
```yaml
# build-apk 作业的条件
if: needs.check-conditions.outputs.should_build_apk == 'true' 
    && needs.flutter-test.result == 'success' 
    && needs.dependency-analysis.result == 'success'
```

**说明**: `needs.flutter-test.result == 'success'` 要求整个 flutter-test 作业成功完成

#### **触发条件**
```yaml
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  workflow_dispatch:  # 手动触发
    inputs:
      environment: mock/dev/test/prod
      force_build_apk: true/false
```

#### **手动触发测试**
在 GitHub Actions 页面：
1. 选择 "CI and APK Build" 工作流
2. 点击 "Run workflow"
3. 选择环境和是否强制构建 APK

### 测试结果查看

#### **1. GitHub Actions 页面**
- 查看 "flutter-test" 作业的详细日志
- 下载覆盖率报告产物
- 查看 Codecov 集成结果

#### **2. Pull Request 评论**
自动生成的测试结果评论包含：
- ✅ 测试执行状态
- 📊 覆盖率百分比
- 📈 Codecov 链接

#### **3. 覆盖率报告**
- **HTML 报告**: 从 Actions 产物下载 `coverage-reports`
- **Codecov**: https://app.codecov.io/gh/listen2code/ListenPortfolioFlutter
- **本地查看**: `coverage/html/index.html`

### 🚨 测试失败处理

#### **失败类型分析**

##### **1. 测试用例失败 (最常见)**
```bash
# 示例输出
00:01 +2: LoginViewModel should handle login with valid credentials
00:01 +2: LoginViewModel should show error for invalid credentials
00:01 +0: LoginViewModel should handle network error
00:01 +0: Some test(s) failed.
00:01 +0: Failed to load "test/features/auth/login/login_view_model_test.dart": 
Test failed. See exception logs for details.
```

**影响**: 🔴 **APK 构建跳过**  
**原因**: 任何测试用例的 `expect()` 断言失败或异常

##### **2. 编译错误**
```bash
# 示例输出
Error: Could not resolve the package 'listen_core' in 'test/features/auth/login/login_view_model_test.dart'.
```

**影响**: 🔴 **APK 构建跳过**  
**原因**: 依赖问题、导入错误、语法错误

##### **3. 超时错误**
```bash
# 示例输出
00:30 +1: Test timeout. The test took longer than 30 seconds to complete.
```

**影响**: 🔴 **APK 构建跳过**  
**原因**: 测试执行时间超过默认 30 秒超时

##### **4. 覆盖率不足**
```bash
# 示例输出
Coverage check failed: 45.2% < 60%
Consider adding more tests to meet the minimum coverage requirement
```

**影响**: 🟡 **仅警告，APK 构建继续**  
**原因**: 当前配置为软性检查，不阻止构建

#### **失败调试步骤**

##### **1. 查看 GitHub Actions 日志**
1. 进入失败的 workflow run
2. 点击 "flutter-test" 作业
3. 查看详细的错误输出
4. 定位具体的失败测试文件

##### **2. 本地重现失败**
```bash
# 复制失败的测试命令
flutter test --reporter=expanded test/features/auth/login/login_view_model_test.dart

# 或运行所有测试查看详细输出
flutter test --reporter=expanded
```

##### **3. 修复和验证**
```bash
# 修复代码后，本地验证
flutter test test/features/auth/login/login_view_model_test.dart

# 确保所有测试通过
flutter test

# 检查覆盖率
flutter test --coverage
lcov --summary coverage/lcov.info
```

#### **失败恢复策略**

##### **1. 紧急修复 (Production 需求)**
如果必须立即发布，可以：
1. 临时跳过失败的测试 (不推荐)
2. 修复关键测试，标记其他测试为待修复
3. 使用 `[skip-build]` 跳过 APK 构建

##### **2. 根本修复 (推荐)**
1. 分析失败原因
2. 修复测试代码或业务逻辑
3. 增加测试覆盖率
4. 确保所有测试通过

##### **3. 预防措施**
1. 本地运行完整测试再提交
2. 使用 pre-commit hooks
3. 定期检查覆盖率趋势
4. 监控测试执行时间

## 🎯 关键测试场景

### 1. AuthInterceptor 401 并发测试
```dart
test('should handle 3 concurrent 401 responses with single refresh', () async {
  // 模拟 3 个并发请求同时收到 401
  // 验证只触发一次 refresh
  // 验证所有请求都成功重试
});
```

### 2. CrashManager 安全模式测试
```dart
test('should trigger safe mode after 3 crashes in 30 seconds', () async {
  // 模拟 30 秒内 3 次崩溃
  // 验证 onReset() 正确触发
  // 验证安全模式状态
});
```

### 3. I18n 键完整性测试
```dart
test('should have translations for all keys in zh and ja', () async {
  // 遍历 I18nKeys 的所有 key
  // 断言 zh/ja 语言文件都有对应翻译
});
```

## 🛠️ 测试环境

### 测试环境设置 (`test/test_helpers/test_setup.dart`)
```dart
class TestEnvConfig implements BaseEnvConfig {
  @override
  String get baseUrl => 'http://api.test.com';
  @override
  AppEnvironment get env => AppEnvironment.mock;
  // ... 其他配置
}
```

### 测试配置说明

项目使用硬编码的测试配置，无需外部配置文件：

#### **默认设置**
- **超时时间**: 30 秒
- **覆盖率最低要求**: 60%
- **测试环境**: mock
- **失败策略**: 覆盖率不足时警告（不阻止构建）

#### **路径配置**
- **单元测试路径**: `test/core/`, `test/features/`
- **Widget 测试路径**: `test/features/home/projects/projects_widget_test.dart`
- **集成测试路径**: `integration_test/` (如果存在)

#### **覆盖率排除**
- `**/*.g.dart` - 生成的代码
- `**/*.freezed.dart` - Freezed 生成的代码
- `**/generated/**` - 生成的文件
- `**/test/**` - 测试文件本身
- `**/build/**` - 构建产物

## 📈 测试最佳实践

### 1. 测试结构
```dart
group('FeatureName Tests', () {
  setUp(() async {
    await setupTestEnvironment();
    // 设置 mock 对象
  });

  test('should handle specific scenario', () async {
    // Arrange - 准备测试数据
    // Act - 执行被测试的操作
    // Assert - 验证结果
  });
});
```

### 2. Mock 使用
```dart
// 使用 mocktail 进行 mock
class MockAuthService extends Mock implements AuthService {}

setUp(() {
  mockAuthService = MockAuthService();
  when(() => mockAuthService.login(any())).thenAnswer((_) async => success);
});
```

### 3. 异步测试
```dart
test('should handle async operations', () async {
  final result = await viewModel.processAsync();
  expect(result, isNotNull);
});
```

## 🚨 故障排除

### 常见问题

#### 1. 测试环境问题
```bash
# 确保在正确的目录运行
cd /path/to/ListenPortfolioFlutter

# 重新获取依赖
flutter pub get

# 清理缓存
flutter clean
flutter pub get
```

#### 2. 覆盖率工具问题
```bash
# Ubuntu/Debian 安装 lcov
sudo apt-get install lcov

# macOS 安装 lcov
brew install lcov

# Windows 使用 WSL 或 Git Bash
```

#### 3. Mock 数据问题
```bash
# 确保 mock 资源目录存在
mkdir -p assets/mock/v1/get
mkdir -p assets/mock/v1/post

# 创建测试用的 mock 数据
echo '{"test": "data"}' > assets/mock/v1/get/test.json
```

### 调试技巧

#### 1. 详细输出
```bash
flutter test --reporter=expanded
```

#### 2. 单个测试文件
```bash
flutter test test/features/auth/login/login_view_model_test.dart
```

#### 3. 调试模式
```bash
flutter test --debug
```

## 📞 获取帮助

1. **查看本文档**: `docs/testing-guide.md` (完整测试指南)
2. **参考现有测试**: 查看 `test/features/` 下的测试文件
3. **Flutter 测试文档**: https://docs.flutter.dev/testing
4. **项目 TODO**: `docs/todo.md` 中的测试相关项目
5. **CI 日志**: GitHub Actions 中的详细测试执行日志

---

## 🔄 持续改进

### 待实现的测试功能
- [ ] Golden Tests (UI 快照测试)
- [ ] 性能回归测试
- [ ] 可访问性自动化测试
- [ ] 更多集成测试场景

### 覆盖率提升计划
1. 添加错误处理分支测试
2. 增加边界条件测试
3. 完善异步操作测试
4. 添加更多 UI 组件测试

---

**最后更新**: 2026年4月5日  
**维护者**: Flutter 开发团队  
**文件说明**: 本文档整合了原有的 `test/README.md`，为项目的唯一测试指南
