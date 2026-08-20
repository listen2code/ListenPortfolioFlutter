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
  │   ├── validators_test.dart
  │   ├── crash_manager_test.dart
  │   ├── frame_monitor_test.dart
  │   ├── ring_buffer_test.dart
  │   ├── network_inspector_store_test.dart
  │   ├── launch_monitor_test.dart
  │   ├── lifecycle_route_filtering_test.dart
  │   ├── app_nav_test.dart
  │   ├── error_mapper_test.dart
  │   └── i18n_test.dart
  ├── features/
  │   ├── ai_chat/
  │   ├── auth/
  │   ├── fault_injection/
  │   ├── home/
  │   ├── settings/
  │   └── splash/
  ├── shared/
  │   ├── extensions/
  │   ├── mock_data_consistency_test.dart
  │   └── utils/playback_test.dart
  ├── utilities/
  │   ├── mock_helpers.dart
  │   └── widget_test_setup.dart
  ├── widget/
  │   ├── coffee_product_card_test.dart
  │   └── coffee_purchase_bottom_sheet_test.dart
  └── test_helpers/
      └── test_setup.dart
  ```

  当前仓库中已补齐并运行着 **529 个** 单元、组件与集成测试用例，覆盖 `core`、`ai_chat`、`auth`、`fault_injection`、`home`、`settings`、`splash`、`shared` 等全部模块，测试通过率保持 **100% 绿灯**，全工程手写业务代码行覆盖率达到 **70.71%**（详见 [单测代码覆盖率报告](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/docs/test_coverage_report.md)）。
  当前仓库已包含 `integration_test/app_test.dart` 集成测试，支持端到端（E2E）模拟器与真机上的自动化流程验证，并配有针对 MVI Playback 录制/回放的反序列化反射校验测试 (`test/shared/utils/playback_test.dart`)。

  > 测试相关的模拟数据主要由本地 `LocalMockServer` 以及 `assets/mock/` 中的 JSON 结构提供，测试行为可通过 PowerShell 脚本或 Bash 脚本一键启动。

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
  - **来源**: `.github/workflows/ci.yml` 中 `Analyze test coverage` 步骤的最低阈值
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
    - 若存在 `integration_test/` 目录，则运行集成测试；当前仓库中该目录不存在，因此通常会跳过
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
 
 - **测试用例失败**
   - **影响**: 🔴 **APK 构建不会继续**
   - **原因**: `expect()` 断言失败、未捕获异常、测试逻辑不满足预期

 - **编译错误**
   - **影响**: 🔴 **APK 构建不会继续**
   - **原因**: 依赖问题、导入错误、语法错误

 - **超时错误**
   - **影响**: 🔴 **APK 构建不会继续**
   - **原因**: 测试执行时间超过默认超时

 - **覆盖率不足**
   - **影响**: 🟡 **当前仅警告**
   - **原因**: workflow 中覆盖率检查目前为软性提醒，不阻止构建

 ##### **编译错误示例**
 ```bash
 # 示例输出
 Error: Could not resolve the package 'listen_core' in 'test/features/auth/login/login_view_model_test.dart'.
 ```

 ##### **超时错误示例**
 ```bash
 # 示例输出
 00:30 +1: Test timeout. The test took longer than 30 seconds to complete.
 ```

 ##### **覆盖率不足示例**
 ```bash
 # 示例输出
 Coverage check failed: 45.2% < 60%
 Consider adding more tests to meet the minimum coverage requirement
 ```
 
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
  ## 🎯 已实现的特色核心测试场景

### 1. AuthInterceptor 401 并发队列测试
- **文件**：`test/core/network/auth_interceptor_test.dart`
- **内容**：模拟 3 个并发请求同时收到 401 Unauthorized 响应，验证有且仅触发了一次 Token 刷新请求，且在刷新成功后所有挂起的请求都会被依次正确重试并获得成功响应。

### 2. CrashManager 安全模式测试
- **文件**：`test/core/crash_manager_test.dart`
- **内容**：验证 CrashManager 正确在本地落盘 crash 日志，并在检测到 30 秒内发生 3 次及以上快速连续崩溃时，正确触发 `onReset()` 安全恢复流程以防 App 进入死循环崩溃。

### 3. I18n 键完整性测试
- **文件**：`test/core/i18n_test.dart`
- **内容**：动态映射遍历 `I18nKeys` 常量列表中的所有字段，与中、英、日语言配置 Map 进行比对，确保没有遗漏的翻译项。

### 4. E2E 端到端集成测试 (真机/模拟器)
- **文件**：`integration_test/app_test.dart`
- **内容**：在真实的模拟器或手机设备上进行 Splash 启动 ➡️ 进入首页 ➡️ Drawer 路由跳转 ➡️ 输入校验（覆盖空校验、非法邮箱校验、过短文本校验、密码不一致校验等异常提示）➡️ 正常表单提交 ➡️ 登录账号验证 ➡️ Drawer 侧边栏动态 Profile 信息校验 ➡️ Logout 对话框登出整条业务链的闭环自动化控制。

### 5. APM 核心算法测试
- **文件组**：`test/core/ring_buffer_test.dart`、`test/core/frame_monitor_test.dart`、`test/core/network_inspector_store_test.dart`、`test/core/launch_monitor_test.dart`
- **内容**：验证环形队列越界防护、自适应高刷 Budget Jank 检测、物理时钟 FPS 计算、网络抓包内存队列、冷启动性能退化警报算法等。

### 6. 路由与生命周期测试
- **文件**：`test/core/app_nav_test.dart`、`test/core/lifecycle_route_filtering_test.dart`
- **内容**：验证强类型路由解析、Deep Link Scheme 剥离、生命周期路由过滤逻辑。

### 7. IAP 购买流程 Widget 测试
- **文件组**：`test/widget/coffee_product_card_test.dart`、`test/widget/coffee_purchase_bottom_sheet_test.dart`、`test/features/settings/widgets/coffee_purchase_view_model_test.dart`
- **内容**：验证咖啡购买卡片渲染、BottomSheet 交互、ViewModel 状态机转换。

  ## 🛠️ 测试环境

### 测试环境设置 (`test/test_helpers/test_setup.dart`)
```dart
class TestEnvConfig implements BaseEnvConfig {
  @override
  AppEnvironment get env => AppEnvironment.test;

  @override
  String get baseUrl => 'http://api.test.com';
}

class MockEnvConfig implements BaseEnvConfig {
  @override
  AppEnvironment get env => AppEnvironment.mock;

  @override
  String get baseUrl => 'http://localhost:9999';
}

Future<void> setupTestEnvironment() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  try {
    await AppEnv.init([TestEnvConfig(), MockEnvConfig()]);
  } catch (_) {
    // AppEnv may already be initialized in some test runs.
  }
}
```

### 测试配置说明

项目当前主要使用硬编码或脚本约定的测试配置，无需额外的外部 `toml` 配置文件：

#### **默认设置**
- **超时时间**: 30 秒
- **覆盖率最低要求**: 60%
- **测试环境**: 由测试代码决定；`test_setup.dart` 当前会注册 `test` 与 `mock` 两套环境配置
- **失败策略**: 覆盖率不足时当前仅警告（不阻止构建）

#### **路径配置**
- **单元与组件测试路径**: `test/` (运行所有单元与 Widget 测试)
- **集成测试路径**: `integration_test/app_test.dart` (运行端到端真机测试)

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

1. **查看本文档**: `docs/testing_guide.md` (完整测试指南)
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

**最后更新**: 2026年8月5日  
**维护者**: Flutter 开发团队  
**文件说明**: 本文档是当前仓库中的集中测试指南；如与测试代码或 CI workflow 冲突，以实际实现为准
