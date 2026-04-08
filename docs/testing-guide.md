# Flutter Testing Guide
  
  **Status**: `Implemented with Partial CI Enforcement`
  
  > 本文档优先描述当前仓库里已经存在的测试资产、脚本和 CI 行为。
  > 如与 `test/`、`scripts/run_tests.*`、`.github/workflows/ci.yml` 冲突，以代码和 workflow 为准。
  > 覆盖率目标与后续补齐方向会保留，但不会再默认写成“已经完全强制执行”。
  
  ## 📋 概述
  
  本文档介绍 Listen Portfolio Flutter 项目的测试体系，包括本地测试运行、覆盖率生成，以及当前 GitHub Actions 中已经接入的测试流程。

  ## 🧪 测试结构

  ### 测试文件分布
  ```
  test/
  ├── core/
  │   ├── network/auth_interceptor_test.dart
  │   └── validators_test.dart
  ├── features/
  │   ├── auth/
  │   ├── home/
  │   ├── settings/
  │   └── splash/
  └── test_helpers/
      └── test_setup.dart
  ```

  当前仓库中可检索到 **31 个** `_test.dart` 文件，覆盖 `core`、`auth`、`home`、`settings`、`splash` 等模块。

  > 当前不存在 `test/test_config.toml` 这类外部测试配置文件；测试配置主要体现在测试代码、mock 资源，以及 `scripts/run_tests.ps1` / `scripts/run_tests.sh` 中。

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
  - **当前最低目标**: 60%
  - **来源**: `docs/todo.md` 与 `.github/workflows/ci.yml` 中的覆盖率检查逻辑
  - **当前执行方式**: CI 会输出低于 60% 的警告，但 **不会因此直接 fail job**
  - **分层覆盖率目标**: ViewModel / Repository / UseCase / Widget / Infrastructure 的细分目标更适合作为团队目标，而不是当前受 CI 强制约束的规则

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
  - **CI 产物**: `coverage-reports` artifact
  - **Codecov**: 在 `main` / `develop` 分支尝试上传，且 `fail_ci_if_error: false`

  ## 🔄 CI 集成
  
  ### 主 CI 工作流 (`.github/workflows/ci.yml`)
  
  当前仓库存在一个主工作流 `CI and APK Build`，测试相关逻辑已经接入，但覆盖率检查仍是“提示优先”的状态。
   #### **工作流结构**
  ```yaml
  jobs:
   check-conditions          # 检查是否需要构建 APK
   flutter-test             # 运行测试和覆盖率分析
   dependency-analysis      # 依赖边界检查和代码分析
   build-apk               # 构建 APK (依赖测试通过)
   skip-build              # 跳过构建的通知
  ```
  
 #### **当前测试执行流程**
 1. **flutter-test 作业**:
    - 执行 `flutter test --coverage --reporter=expanded`
    - 生成 `coverage/lcov.info` 和 HTML 报告
    - 单独再次运行 `test/features/home/projects/projects_widget_test.dart`
    - 若存在 `integration_test/` 目录，则运行集成测试
    - 上传 `coverage-reports` artifact
    - 在 `main` / `develop` 分支尝试上传 Codecov
 
 2. **dependency-analysis 作业**:
    - 执行依赖边界检查
    - 运行 `flutter analyze`
 
 3. **依赖关系**:
    - APK 构建依赖 `flutter-test` 与 `dependency-analysis` 成功
    - 如果这些作业失败，APK 构建不会继续
 
 #### **当前失败定义**
 
 ##### **1. 硬性失败 (会导致 APK 构建无法继续)**
 - ✅ **任何单元测试失败**: `flutter test` 命令返回非零退出码
 - ✅ **任何 Widget 测试失败**: 测试用例断言失败或异常
 - ✅ **任何集成测试失败**: 端到端测试失败
 - ✅ **依赖分析失败**: `dependency-analysis` 作业失败
 
 ##### **2. 软性失败 (当前仅警告，不阻止构建)**
 - ⚠️ **覆盖率不足**: 低于 60% 但测试全部通过
 - ⚠️ **覆盖率生成失败**: lcov / genhtml 问题但不影响 `flutter test` 成功
 
 ##### **3. 具体失败场景**
 ```bash
 # 场景1: 单个测试用例失败
 flutter test --coverage --reporter=expanded
 # 输出: 00:01 +2: Some test failed
 # 结果: 整个 flutter-test 作业失败 → APK 构建不会继续
 
 # 场景2: 编译错误
 flutter test test/features/auth/login/login_view_model_test.dart
 # 输出: Compilation error
 # 结果: flutter-test 作业失败 → APK 构建不会继续
 
 # 场景3: 覆盖率不足
 # 测试全部通过，但覆盖率只有 45%
 # 输出: Coverage check failed: 45% < 60%
 # 结果: 当前只警告，作业仍可能成功
 ```
 
 ##### **4. GitHub Actions 状态判断**
 ```yaml
 # build-apk 作业的条件
 if: needs.check-conditions.outputs.should_build_apk == 'true' 
     && needs.flutter-test.result == 'success' 
     && needs.dependency-analysis.result == 'success'
 ```
 
 **说明**: `needs.flutter-test.result == 'success'` 仍然要求整个 `flutter-test` 作业成功完成；但当前 workflow 中“覆盖率低于 60%”不会主动 `exit 1`。
 
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
 1. 选择 `CI and APK Build` 工作流
 2. 点击 `Run workflow`
 3. 选择环境和是否强制构建 APK
 
 ### 测试结果查看
 
 #### **1. GitHub Actions 页面**
 - 查看 `flutter-test` 与 `dependency-analysis` 作业日志
 - 下载 `coverage-reports` artifact
 - 如在 `main` / `develop` 分支，可额外查看 Codecov 上传结果
 
 #### **2. 覆盖率报告**
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
 
 **影响**: 🔴 **APK 构建不会继续**  
 **原因**: 任何测试用例的 `expect()` 断言失败或异常
 
 ##### **2. 编译错误**
 ```bash
 # 示例输出
 Error: Could not resolve the package 'listen_core' in 'test/features/auth/login/login_view_model_test.dart'.
 ```
 
 **影响**: 🔴 **APK 构建不会继续**  
 **原因**: 依赖问题、导入错误、语法错误
 
 ##### **3. 超时错误**
 ```bash
 # 示例输出
 00:30 +1: Test timeout. The test took longer than 30 seconds to complete.
 ```
 
 **影响**: 🔴 **APK 构建不会继续**  
 **原因**: 测试执行时间超过默认 30 秒超时
 
 ##### **4. 覆盖率不足**
 ```bash
 # 示例输出
 Coverage check failed: 45.2% < 60%
 Consider adding more tests to meet the minimum coverage requirement
 ```
 
 **影响**: 🟡 **当前仅警告**  
 **原因**: 当前 workflow 中覆盖率检查为软性提醒，不阻止构建
 
 #### **失败调试步骤**
 
 ##### **1. 优先本地复现**
 1. 先运行对应测试文件或目录
 2. 再运行 `flutter test --reporter=expanded`
 3. 如涉及覆盖率，再执行 `flutter test --coverage`
 4. 最后用 `lcov --summary coverage/lcov.info` 查看摘要
 
 ##### **2. 再查看 GitHub Actions 日志**
 1. 进入失败的 workflow run
 2. 查看 `flutter-test` 或 `dependency-analysis` 作业
 3. 对照本地命令和日志定位失败文件
 
 ##### **3. 本地重现示例**
 ```bash
 # 复制失败的测试命令
 flutter test --reporter=expanded test/features/auth/login/login_view_model_test.dart
 
 # 或运行所有测试查看详细输出
 flutter test --reporter=expanded
 ```
 
 ##### **4. 修复和验证**
 ```bash
 # 修复代码后，本地验证
 flutter test test/features/auth/login/login_view_model_test.dart
 
 # 确保所有测试通过
 flutter test
 
 # 检查覆盖率
 flutter test --coverage
 lcov --summary coverage/lcov.info
 ```
 
 #### **恢复策略**
 
 ##### **根本修复 (推荐)**
 1. 分析失败原因
 2. 修复测试代码或业务逻辑
 3. 增加测试覆盖率
 4. 确保所有测试通过
 
 ##### **预防措施**
 1. 本地运行完整测试再提交
 2. 优先修复 flaky / 依赖环境的测试
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

项目当前主要使用硬编码或脚本约定的测试配置，无需额外的外部 `toml` 配置文件：

#### **默认设置**
- **超时时间**: 30 秒
- **覆盖率最低要求**: 60%
- **测试环境**: mock
- **失败策略**: 覆盖率不足时当前仅警告（不阻止构建）

#### **路径配置**
- **单元测试路径**: `test/core/`, `test/features/`
- **Widget 测试路径**: `test/features/home/projects/projects_widget_test.dart`
- **集成测试路径**: `integration_test/` (如果存在)

#### **脚本行为说明**
- `run_tests.ps1` / `run_tests.sh` 会先执行 `flutter pub get`
- 两个脚本都会在运行前确保 `assets/mock/v1/get` 与 `assets/mock/v1/post` 目录存在
- 覆盖率 HTML 报告依赖本地安装 `lcov` / `genhtml`

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
