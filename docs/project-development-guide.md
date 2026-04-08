# Listen Portfolio Flutter 项目开发指南

**Status**: `Implemented with Mixed Governance Maturity`

> 本文档同时包含“推荐架构原则”和“当前仓库中的真实工具接入状态”。
> 如与 `tools/dependency_rules.dart`、`analysis_options.yaml`、`.github/workflows/ci.yml` 冲突，应以代码和工作流配置为准。

## 📋 概述

本文档是 Listen Portfolio Flutter 项目开发指南，包含了依赖治理、APK构建工作流和项目架构规范。旨在为团队开发提供统一的技术标准和最佳实践。

---

## 🏗️ 第一部分：依赖边界与治理

### 依赖层次架构

#### 依赖方向（从底层到上层）

```
┌─────────────────────────────────────┐
│           Features                  │  ← 业务功能层
│  ┌─────────┬─────────┬─────────────┐│
│  │  Auth   │  Home   │   Settings  ││
│  └─────────┴─────────┴─────────────┘│
└─────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────┐
│             Shared                  │  ← 共享工具层
│  ┌─────────┬─────────┬─────────────┐│
│  │ Utils   │ Widgets │   Theme     ││
│  └─────────┴─────────┴─────────────┘│
└─────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────┐
│      UIKit (listen_uikit)          │  ← UI组件层
└─────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────┐
│       Core (listen_core)            │  ← 基础框架层
└─────────────────────────────────────┘
```

#### 核心原则

1. **单向依赖**: 上层可以依赖下层，下层不能依赖上层
2. **模块隔离**: Features 模块之间不能直接依赖
3. **接口导向**: 依赖抽象而非具体实现
4. **最小依赖**: 每个模块只依赖真正需要的内容

### 禁止的依赖模式

#### 1. 跨 Features 模块依赖

```dart
// ❌ 错误 - features/auth 不应依赖 features/home
import 'package:listen_portfolio_flutter/features/home/data/models/user_model.dart';

// ✅ 正确 - 将共同模型提取到 shared
import 'package:listen_portfolio_flutter/shared/models/user_model.dart';
```

#### 2. 向上依赖

**推荐原则**：优先保持 `features -> shared -> uikit -> core` 的单向依赖。

**当前工具实现**：`tools/dependency_rules.dart` 已移除 `shared -> features` 的统一阻断规则，因此当前仓库在工具层面允许 `features` 与 `shared` 互相引用；这更接近“现实约束下的宽松检查”，不应自动理解为首选设计。
```dart
// ✅ 允许 - features 可以依赖 shared
import 'package:listen_portfolio_flutter/shared/utils/auth_helper.dart';

// ✅ 允许 - shared 可以依赖 features (特殊情况)
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login_page.dart';
```

**仍禁止的依赖**：
```dart
// ❌ 禁止 - core 不能依赖上层模块
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/shared/utils/app_constants.dart';
```

#### 3. 私有实现导入

**基本规则**：
```dart
// ❌ 错误 - 直接导入私有实现
import 'package:listen_portfolio_flutter/features/auth/data/repositories/auth_repository_impl.dart';

// ✅ 正确 - 依赖抽象接口
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
```

**🔧 例外情况 - Provider 文件**：
```dart
// ✅ 允许 - Provider 文件负责依赖注入
// 文件路径应以当前 `dependency_rules.dart` 的放行条件为准
import 'package:listen_portfolio_flutter/features/auth/data/repositories/auth_repository_impl.dart';

class AuthProvider {
  final AuthRepository _repository;
  
  AuthProvider() : _repository = AuthRepositoryImpl();
}
```

**允许的条件**:
- 路径包含 `/provider/` 或 `\provider\` 时，`dependency_rules.dart` 会直接放行
- `features` 模块下位于 `/data/` 的文件，如导入 **同一 feature** 的实现类，也会被放行
- 因此，当前“实现类导入例外”是脚本规则结果，不等同于对所有 provider / repository 结构的长期推荐

### 推荐的依赖模式

#### 1. Features 依赖 Shared

```dart
// ✅ 正确 - features 可以依赖 shared
import 'package:listen_portfolio_flutter/shared/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/shared/utils/auth_helper.dart';
import 'package:listen_portfolio_flutter/shared/widgets/loading_widget.dart';
```

#### 2. Features 依赖 Core

```dart
// ✅ 正确 - features 可以依赖 core
import 'package:listen_core/core.dart';
import 'package:listen_core/network/base_repository.dart';
import 'package:listen_core/base/base_view_model.dart';
```

#### 3. 相对导入规范

```dart
// 在同一模块内使用相对导入
// lib/features/auth/presentation/pages/login/login_view_model.dart
import '../data/repositories/auth_repository.dart';
import '../../domain/usecases/login_use_case.dart';

// 跨模块使用绝对导入
import 'package:listen_portfolio_flutter/shared/constants/app_constants.dart';
```

---

## 🛠️ 第二部分：治理工具与实施

### 1. 依赖分析工具 (dependency_rules.dart)

**位置**: `tools/dependency_rules.dart`

**核心特性**:
- ✅ **上下文感知检测**: 基于文件路径智能判断违规
- ✅ **跨平台兼容**: Windows/Linux/macOS 原生支持
- ✅ **详细报告**: 分类显示违规类型和修复建议
- ✅ **依赖图生成**: JSON 格式依赖关系图
- ✅ **统计信息**: 文件数量、依赖分布等数据
- ✅ **命令行选项**: 支持模块化检查 (--check-circular, --check-layers)
- ✅ **Provider 例外**: 允许 Provider 文件导入实现类进行依赖注入

**使用方法**:
```bash
# 1. 基本依赖检查
dart tools/dependency_rules.dart

# 2. 生成依赖图
dart tools/dependency_rules.dart --graph

# 3. 检查循环依赖
dart tools/dependency_rules.dart --check-circular

# 4. 检查依赖层
dart tools/dependency_rules.dart --check-layers

# 5. 显示帮助
dart tools/dependency_rules.dart --help

# 6. 运行 Flutter 分析
flutter analyze

# 7. 查看依赖图内容
cat dependency_graph.json
```

**检测规则**:
1. **跨 Features 模块依赖**: `features/auth` 不应依赖 `features/home`
2. **Core 依赖上层**: core 模块不应依赖 shared/features
3. **私有实现导入**: 默认禁止导入 `_impl.dart`, `_mock.dart` 等私有文件
4. **例外放行**: `/provider/` 路径与同 feature 的 `/data/` 导入场景会被特殊放行

### 2. 自定义 Lint 规则 (IDE 实时检查)

**位置**: `tools/lint_rules/lib/src/dependency_boundary_lint.dart`

**规则类型**:
- `dependency_boundary`: 依赖边界违规检查
- `circular_dependency`: 循环依赖检测  
- `implementation_import`: 私有实现导入检查

**当前接入状态**:
- 仓库内存在 `tools/lint_rules` 自定义 lint 包
- 但主工程 `analysis_options.yaml` 当前 **未** `include: package:dependency_lint_rules/...`
- 同时 `analysis_options.yaml` 还排除了 `tools/lint_rules/**`
- 因此这些自定义 lint 规则目前更接近“已实现但未接入主工程默认分析流程”

**如果未来要启用，可参考如下配置方向**:
```yaml
# analysis_options.yaml
include: package:dependency_lint_rules/dependency_lint_rules.yaml

custom_lint:
  rules:
    - dependency_boundary
    - circular_dependency
    - implementation_import
```

> 当前仓库真实启用的是标准 analyzer / flutter lints 规则，以及 CI 中额外运行的 `dart tools/dependency_rules.dart`。

**技术架构**:
```
tools/lint_rules/
├── pubspec.yaml                    # 包配置 (custom_lint: ^0.8.1)
├── dependency_lint_rules.yaml      # Lint 规则配置
└── lib/
    ├── dependency_lint_rules.dart  # 库入口文件
    └── src/
        └── dependency_boundary_lint.dart  # 规则实现 (235行)
```

### 3. CI/CD 自动化检查

**位置**: `.github/workflows/ci.yml`

**检查流程**:
1. **Flutter Analyze**: 运行主工程当前启用的 analyzer / flutter lints 规则
2. **依赖边界检查**: 运行 `dependency_rules.dart`
3. **依赖图生成**: 创建可视化依赖关系图
4. **测试与覆盖率**: 运行测试并上传 coverage artifacts
5. **APK 构建**: 条件满足时构建 Debug APK 并上传 artifact

**触发条件**:
- Push 到 `main`/`develop` 分支
- Pull Request 创建/更新
- 手动触发工作流

**输出产物**:
- `dependency_graph.json`: 依赖关系图
- `coverage/lcov.info` 与 `coverage/html/`: 覆盖率产物
- APK 文件 (满足构建条件时)
- `download_info.md`: APK 下载说明（工作流运行时生成并上传为 artifact）
- 工作流日志和统计信息

---

## 📊 第三部分：实施成果与监控

### 当前项目依赖状况

- **总文件数 / 违规数量**: 应通过重新运行 `dart tools/dependency_rules.dart` 实时确认
- **分析规则来源**: 当前主工程默认是 `flutter analyze` + CI 中的 `dependency_rules.dart`
- **自定义 lint 包**: 已存在，但未接入主工程默认分析入口
- **CI 运行状态**: 应以最近一次 GitHub Actions 工作流结果为准

### 修复历史

**🔧 修复前状态**:
```bash
🔍 Starting dependency boundary analysis...

📊 Dependency Boundary Check Report
==================================================
❌ Found 3 dependency violations:

🔍 Forbidden patterns (3 violations):
------------------------------
🚫 lib/features/auth/data/providers/auth_provider.dart:4 
   → Direct import of private implementation files not allowed
   → import 'package:.../auth_repository_impl.dart';

🚫 lib/features/home/data/providers/about_me_provider.dart:4 
   → Direct import of private implementation files not allowed
   → import 'package:.../about_me_repository_impl.dart';

🚫 lib/features/home/data/providers/projects_provider.dart:4 
   → Direct import of private implementation files not allowed
   → import 'package:.../projects_repository_impl.dart';
```

**✅ 修复后状态**:
```bash
🔍 Starting dependency boundary analysis...

📊 Dependency Boundary Check Report
==================================================
... 此处仅为历史示例，当前结果应以重新运行脚本后的输出为准 ...
```

### 关键修复内容

1. **跨平台路径兼容**: 修复 Windows/Linux 路径检测问题
2. **实现类导入例外**: `/provider/` 路径与同 feature 的 `/data/` 导入场景会被脚本特殊放行
3. **架构规则调整**: 允许 Features 和 Shared 互相引用（实际开发需求）
4. **CI/CD 修复**: 更新 artifact 版本和 Flutter 版本
5. **命令行扩展**: 新增 `--check-circular`, `--check-layers`, `--help` 选项

---

## 🔧 第四部分：APK 构建工作流

### 概述

这个 GitHub Actions 工作流会在满足特定条件时构建 APK 文件，并提供下载链接。当前使用统一的 CI/CD 工作流：

1. **主工作流** (`ci.yml`) - 依赖检查 + APK 构建

这个工作流集成了代码质量检查和APK构建，提供完整的CI/CD流程。

### 触发条件

#### 自动触发

工作流会在以下情况下触发：

- 推送到 `main` 或 `develop` 分支
- 创建针对 `main` 或 `develop` 分支的 Pull Request
- 手动触发（workflow_dispatch）

#### APK 构建条件

**注意：不是每次 push 都会构建 APK！**

APK 只在以下情况下构建：

1. **强制触发**：
   - Commit message 包含 `[build-apk]`、`[apk]` 或 `[deploy]`
   - Pull Request 自动触发
   - 手动触发时选择"强制构建"

2. **时间间隔**：
   - 距离上次成功构建超过 **2 小时**

3. **首次构建**：
   - 如果没有找到之前的构建记录

### 构建环境

支持的环境：
- **mock** - 模拟环境
- **dev** - 开发环境（默认）
- **test** - 测试环境
- **prod** - 生产环境

### 使用方法

#### 方法 1：Commit Message 触发

```bash
git commit -m "fix: update splash screen [build-apk]"
git commit -m "feat: add new feature [apk]"
git commit -m "hotfix: critical bug [deploy]"
```

#### 方法 2：手动触发

1. 访问 GitHub 仓库的 **Actions** 标签页
2. 选择相应的工作流
3. 点击 **Run workflow**
4. 选择环境和是否强制构建
5. 点击 **Run workflow**

#### 方法 3：等待时间间隔

- 推送代码后，如果距离上次构建超过 2 小时，会自动构建

### 工作流详情

#### 主工作流 (`ci.yml`)

**适用场景**：
- 完整的 CI/CD 流程
- 日常开发和发布流程
- 代码质量检查和 APK 构建

**文件**：`.github/workflows/ci.yml`

**执行顺序**：
1. 检查构建条件
2. 运行依赖分析
3. 如果依赖检查通过且满足构建条件，则构建 APK
4. 上传构建产物和报告

**工作流特性**：
- ✅ 集成依赖边界检查
- ✅ 智能构建条件判断
- ✅ 多环境支持 (mock/dev/test/prod)
- ✅ 手动触发选项
- ✅ 自动上传产物
- ✅ 并行执行优化
- ✅ 详细的构建日志

### 工作流架构

#### 作业流程图

```
┌─────────────────┐
│  check-build    │
│   conditions    │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│  dependency     │
│   analysis      │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│  build APK?     │ ← 条件判断
│   (if needed)   │
└─────────┬───────┘
          │
     ┌────▼────┐
     │ Yes     │ No
     ▼         ▼
┌─────────┐ ┌─────────┐
│ build   │ │ upload  │
│ APK     │ │ reports │
└────┬────┘ └─────────┘
     │
     ▼
┌─────────┐
│ upload  │
│all files│
└─────────┘
```

#### 智能构建逻辑

```bash
# 构建条件判断逻辑
SHOULD_BUILD_APK="false"

# 1. 强制构建检查
if [ "$FORCE_BUILD" == "true" ]; then
  SHOULD_BUILD_APK="true"
fi

# 2. 时间间隔检查
if [ $TIME_DIFF -ge 2 ]; then
  SHOULD_BUILD_APK="true"
fi

# 3. Commit message 检查
if echo "$COMMIT_MSG" | grep -qE "\[build-apk\]|\[apk\]|\[deploy\]"; then
  SHOULD_BUILD_APK="true"
fi

# 4. PR 自动构建
if [ "$GITHUB_EVENT_NAME" == "pull_request" ]; then
  SHOULD_BUILD_APK="true"
fi
```

### 下载 APK

#### 方法 1：GitHub Actions Artifacts（推荐）

1. 访问 GitHub 仓库的 **Actions** 标签页
2. 找到最新的工作流运行
3. 点击 **Artifacts** 部分
4. 下载名为 `lPortfolio-{environment}-apk` 的文件

#### 方法 2：Pull Request 评论

如果工作流由 Pull Request 触发，会在 PR 中自动添加评论，包含下载信息。

#### 方法 3：Release 页面

推送到 `main` 分支时，会自动创建一个 Pre-release 条目；APK 仍以上传到 Actions Artifacts 的产物为准。

### 文件说明

#### 输出文件

- **APK 文件**：`apkOutput/lPortfolio-{environment}-debug-arm64.apk`
- **下载信息**：`download_info.md`（由工作流运行时生成并上传为 artifact）

#### 保留时间

- 所有 Artifacts 保留 **30 天**
- Release 页面永久保留

### 构建脚本

项目根目录存在 `buildAndroid.sh`，但当前 GitHub Actions 工作流中的 APK 构建步骤是直接执行 `flutter build apk --debug --target-platform android-arm64 ...`，并不是通过该脚本调用。

```bash
./buildAndroid.sh apk {environment}
```

支持的环境：
- `mock`
- `dev`
- `test`
- `prod`

### 示例

#### 示例 1：强制构建

```bash
git add .
git commit -m "feat: add user authentication [build-apk]"
git push origin develop
```

#### 示例 2：手动构建

1. 进入 Actions 页面
2. 选择 "CI and APK Build" 工作流
3. 点击 "Run workflow"
4. 选择环境：`prod`
5. 勾选 "Force build APK"
6. 点击运行

#### 示例 3：等待自动构建

```bash
git add .
git commit -m "fix: minor ui issue"
git push origin develop
```

如果距离上次构建超过 2 小时，会自动构建 APK。

### 故障排除与优化

#### 常见问题解决

**1. 工作流执行失败**
```bash
# 检查步骤
1. 查看 Actions 页面的详细日志
2. 确认 Flutter 版本兼容性
3. 检查依赖解析是否成功
4. 验证构建脚本权限
```

**2. APK 构建被跳过**
```bash
# 可能原因
- 距离上次构建不足 2 小时
- Commit message 没有触发标记
- 依赖检查失败
- 手动触发时未勾选强制构建

# 解决方案
- 使用 [build-apk] 标记
- 手动触发并勾选强制构建
- 等待时间间隔
```

**3. 依赖检查失败**
```bash
# 本地调试
dart tools/dependency_rules.dart --help
dart tools/dependency_rules.dart --check-circular
dart tools/dependency_rules.dart --check-layers

# 修复步骤
1. 查看具体违规信息
2. 根据建议修改代码
3. 重新运行检查
```

#### 性能优化建议

**1. 工作流优化**
```yaml
# 缓存优化
- name: Cache Flutter dependencies
  uses: actions/cache@v3
  with:
    path: |
      ~/.pub-cache
      ~/.flutter
    key: ${{ runner.os }}-flutter-${{ hashFiles('**/pubspec.lock') }}
```

**2. 并行执行**
```yaml
# 依赖检查和构建条件检查可以并行
jobs:
  check-dependencies:
    runs-on: ubuntu-latest
    
  check-build-conditions:
    runs-on: ubuntu-latest
    
  build-apk:
    needs: [check-dependencies, check-build-conditions]
    if: needs.check-build-conditions.outputs.should_build_apk == 'true'
```

**3. 构建时间优化**
- 使用 Flutter 缓存减少依赖安装时间
- 并行运行独立的检查任务
- 条件构建避免不必要的 APK 编译

#### 监控和报告

**1. 构建统计**
- 每月构建次数统计
- 构建成功率监控
- 平均构建时间跟踪

**2. 质量指标**
- 依赖违规数量趋势
- 代码覆盖率变化
- 构建产物大小监控

**3. 自动化报告**
```bash
# 生成月度报告
echo "## 月度构建报告" > monthly_report.md
echo "- 构建次数: $BUILD_COUNT" >> monthly_report.md
echo "- 成功率: $SUCCESS_RATE%" >> monthly_report.md
echo "- 平均时间: $AVG_TIME 分钟" >> monthly_report.md
```

### 模块设计

- **单一职责**: 每个模块只负责一个功能领域
- **稳定依赖**: 依赖更稳定的模块
- **接口隔离**: 定义清晰的模块接口

### 导入规范

```dart
// 导入顺序
// 1. Dart 核心库
import 'dart:async';

// 2. Flutter 框架
import 'package:flutter/material.dart';

// 3. 第三方包
import 'package:riverpod/riverpod.dart';

// 4. 项目内部（按层次）
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/features/auth/auth.dart';

// 5. 相对导入（同模块内）
import '../data/models/user_model.dart';
import '../../domain/usecases/login_use_case.dart';
```

### 架构演进

- 渐进式重构，避免大规模改动
- 保持向后兼容性
- 文档化架构决策

### 开发工作流最佳实践

1. **开发阶段**：使用 `[build-apk]` 标记触发构建
2. **测试阶段**：使用手动触发选择 `test` 环境
3. **发布阶段**：使用 `[deploy]` 标记触发 `prod` 环境构建
4. **日常开发**：依赖时间间隔自动构建，避免频繁构建

---

## 🚀 第六部分：故障排除与维护

### 依赖治理故障排除

#### 构建被跳过

1. 检查 commit message 是否包含触发标记
2. 确认距离上次构建时间是否超过 2 小时
3. 使用手动触发强制构建

#### 依赖检查失败

1. 查看依赖检查报告
2. 修复依赖违规问题
3. 重新推送代码

#### APK 构建失败

1. 检查 `buildAndroid.sh` 脚本
2. 确认环境配置正确
3. 查看构建日志

### 自定义配置

#### 修改时间间隔

在工作流文件中修改时间检查：

```bash
# 修改为 4 小时
if [ $TIME_DIFF -ge 4 ]; then
  SHOULD_BUILD_APK="true"
  echo "Building due to time interval (4+ hours since last build)"
fi
```

#### 修改触发标记

```bash
# 添加更多触发标记
if echo "$COMMIT_MSG" | grep -qE "\[build-apk\]|\[apk\]|\[deploy\]|\[release\]|\[package\]"; then
  SHOULD_BUILD_APK="true"
fi
```

#### 修改默认环境

```yaml
environment:
  description: 'Build environment'
  required: true
  default: 'test'  # 修改默认环境
  type: choice
```

---

## 📚 第七部分：技术实现细节

### 依赖检测算法

**上下文感知检测**:
```dart
// 检测逻辑示例
static bool _isContextualViolation(String importLine, String? fileModule) {
  // shared 文件导入 features → 违规 (已修改为允许特殊情况)
  if (fileModule == 'shared' && importLine.contains('features/')) {
    return false; // 修改后允许
  }
  // core 文件导入上层模块 → 违规
  if (fileModule == 'core' && 
      (importLine.contains('features/') || importLine.contains('shared/'))) {
    return true;
  }
  return false;
}
```

**正则表达式模式**:
```dart
// 跨 features 模块依赖
r'import.*features/[^/]+/.*features/[^/]+/'

// 私有实现文件导入 (Provider 文件例外)
r"import.*listen_portfolio_flutter/.*_(impl|mock|test|internal|private)\.dart"

// 相对路径向上依赖
r'import.*\.\./.*features/|import.*\.\./.*shared/'
```

### Lint 规则架构

**插件入口**:
```dart
class DependencyLintPlugin extends Plugin {
  @override
  List<LintRule> getLintRules() => [
    const DependencyBoundaryLint(),
    const CircularDependencyLint(),
    const ImplementationImportLint(),
  ];
}
```

**AST 遍历检查**:
```dart
context.registry.addImportDirective((node) {
  final uri = node.uri.stringValue;
  if (uri == null) return;
  
  final filePath = resolver.source.fullName;
  // 执行各种违规检查
  _checkCrossFeatureDependency(uri, filePath, node, reporter);
  _checkUpwardDependency(uri, filePath, node, reporter);
});
```

---

## 🔮 第八部分：后续计划

### 短期优化 (1-2周)
- [ ] **完善规则精度**: 优化正则表达式，减少误报
- [ ] **添加更多检查**: 循环依赖检测、接口使用检查
- [ ] **性能优化**: 大型项目的扫描性能优化

### 中期改进 (1-2月)
- [ ] **可视化工具**: 开发依赖关系图可视化界面
- [ ] **集成测试**: 添加依赖规则的单元测试
- [ ] **智能修复**: 提供自动修复建议和代码生成

### 长期规划 (3-6月)
- [ ] **多语言支持**: 支持其他语言的依赖检查
- [ ] **插件生态**: 发布为公共包，供其他项目使用
- [ ] **AI 辅助**: 集成 AI 进行架构建议和重构指导

---

## 📚 相关文档与资源

### 核心文档
- [API 文档](../api.json) - 服务端 API 规范
- [分析配置](../analysis_options.yaml) - Lint 规则配置
- [CI/CD 配置](../.github/workflows/ci.yml) - 统一CI/CD工作流
- [项目配置](../pubspec.yaml) - 依赖和版本管理

### 技术资源
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) - 架构设计原则
- [Hexagonal Architecture](https://alistair.cockburn.us/hexagonal-architecture/) - 六边形架构
- [Flutter Architecture Layers](https://docs.flutter.dev/development/data-and-backend/state-mgmt/architecture) - Flutter 架构层
- [Custom Lint 文档](https://pub.dev/packages/custom_lint) - 自定义规则开发指南
- [Dart Analyzer API](https://pub.dev/packages/analyzer) - 静态分析工具

### 工具文件
- `tools/dependency_rules.dart` - 主要依赖边界分析工具
- `tools/lint_rules/lib/src/dependency_boundary_lint.dart` - 自定义 Lint 规则实现（当前未接入主工程默认分析配置）
- `tools/lint_rules/pubspec.yaml` - Lint包配置
- `buildAndroid.sh` - APK构建脚本
- `.github/workflows/ci.yml` - 统一CI/CD工作流

---

## 🎉 总结

### 🎯 **最终状态**
- **依赖治理工具**: 已具备 `dependency_rules.dart` 与自定义 lint 包两个层次
- **主工程默认检查**: 当前以 `flutter analyze` + CI 工作流为主
- **自定义 lint 集成度**: 工具已存在，但仍需显式接入 `analysis_options.yaml`
- **APK 自动化**: 已实现条件触发的 Debug APK 构建与 artifact 上传

### 🔧 **关键改进**
1. **工作流简化**: 从多个工作流合并为统一的 `ci.yml`
2. **文档整合**: 3个独立文档合并为1个综合指南
3. **架构优化**: 允许 Features 和 Shared 互相引用
4. **工具完善**: Provider 文件例外支持
5. **流程优化**: 智能构建条件和并行执行

### 🎉 **使用效果**
```bash
# 建议在本地重新执行确认当前状态
$ dart tools/dependency_rules.dart
🔍 Starting dependency boundary analysis...

📊 Dependency Boundary Check Report
==================================================
... 以本次运行输出为准 ...

# CI/CD 工作流状态
... 以 GitHub Actions 最近一次运行结果为准 ...
```

### 📈 **项目价值**
1. **开发效率**: 统一的CI/CD流程，减少重复工作
2. **代码质量**: 自动化依赖检查，保证架构健康
3. **团队协作**: 统一的文档和规范，降低沟通成本
4. **可维护性**: 清晰的架构边界，便于长期维护
5. **扩展性**: 为未来功能扩展奠定坚实基础

### 🚀 **快速开始**

**新团队成员入门**:
1. 阅读本文档了解项目架构
2. 运行 `dart tools/dependency_rules.dart` 检查环境
3. 使用 `[build-apk]` 标记测试构建流程
4. 遵循导入规范编写代码

**日常开发流程**:
1. 编写代码 → IDE 实时 lint 提示
2. 提交代码 → 自动依赖检查
3. 推送代码 → 条件性 APK 构建
4. 下载测试 → 验证功能完整性

---

**维护者**: 开发团队  
**最后更新**: 2026-04-02  
**版本**: v3.0 (简化统一版)  
**文档状态**: ✅ 已完成并投入使用  
**工作流状态**: ✅ 简化为单一 ci.yml  
**架构状态**: ✅ 依赖违规清零
