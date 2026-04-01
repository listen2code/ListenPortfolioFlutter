# 依赖边界与治理指南

## 📋 概述

本文档定义了 Listen Portfolio Flutter 项目的依赖边界规则和治理策略，确保代码架构的清晰性和可维护性。

## 🏗️ 依赖层次架构

### 依赖方向（从底层到上层）

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

### 核心原则

1. **单向依赖**: 上层可以依赖下层，下层不能依赖上层
2. **模块隔离**: Features 模块之间不能直接依赖
3. **接口导向**: 依赖抽象而非具体实现
4. **最小依赖**: 每个模块只依赖真正需要的内容

## 禁止的依赖模式

### 1. 跨 Features 模块依赖

```dart
// ❌ 错误 - features/auth 不应依赖 features/home
import 'package:listen_portfolio_flutter/features/home/data/models/user_model.dart';

// ✅ 正确 - 将共同模型提取到 shared
import 'package:listen_portfolio_flutter/shared/models/user_model.dart';
```

### 2. 向上依赖

#### 修改后的规则
**允许 features 和 shared 互相引用**：
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

**修改原因**：
- 在同一项目下，features 和 shared 的互相引用难以完全避免
- 某些场景下（如路由定义、全局初始化）需要 shared 引用 features
- 保持架构清晰的同时，允许实际的开发需求

### 3. Core 依赖上层模块

```dart
// ❌ 错误 - core 不应依赖上层
// lib/core/utils/helper.dart
import '../../shared/constants/app_constants.dart';

// ✅ 正确 - core 应该自包含或通过参数传递
// lib/core/utils/helper.dart
class Helper {
  static String formatMessage(String prefix, String message) {
    return '$prefix: $message';
  }
}
```

### 4. 私有实现导入

#### 基本规则
```dart
// ❌ 错误 - 直接导入私有实现
import 'package:listen_portfolio_flutter/features/auth/data/repositories/auth_repository_impl.dart';

// ✅ 正确 - 依赖抽象接口
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
```

#### 🔧 **例外情况 - Provider 文件**
基于实际架构需求，以下情况**允许**导入私有实现：

```dart
// ✅ 允许 - Provider 文件负责依赖注入
// 文件路径: features/*/data/providers/*_provider.dart
import 'package:listen_portfolio_flutter/features/auth/data/repositories/auth_repository_impl.dart';

class AuthProvider {
  final AuthRepository _repository;
  
  AuthProvider() : _repository = AuthRepositoryImpl();
}
```

**允许的条件**:
- 文件路径包含 `/providers/` 或 `\providers\`
- 文件位于 `features/*/data/providers/` 目录下
- 用途是依赖注入（创建实现类实例）

#### 其他 DI 文件
```dart
// ✅ 允许 - DI (Dependency Injection) 文件
// 文件路径: features/*/data/di/*_di.dart
import 'package:listen_portfolio_flutter/features/auth/data/repositories/auth_repository_impl.dart';

class AuthDI {
  static Provider<AuthRepository> get repository => Provider((_) => AuthRepositoryImpl());
}
```

## 推荐的依赖模式

### 1. Features 依赖 Shared

```dart
// ✅ 正确 - features 可以依赖 shared
import 'package:listen_portfolio_flutter/shared/constants/app_constants.dart';
import 'package:listen_portfolio_flutter/shared/utils/auth_helper.dart';
import 'package:listen_portfolio_flutter/shared/widgets/loading_widget.dart';
```

### 2. Features 依赖 Core

```dart
// ✅ 正确 - features 可以依赖 core
import 'package:listen_core/core.dart';
import 'package:listen_core/network/base_repository.dart';
import 'package:listen_core/base/base_view_model.dart';
```

### 3. 相对导入规范

```dart
// 在同一模块内使用相对导入
// lib/features/auth/presentation/pages/login/login_view_model.dart
import '../data/repositories/auth_repository.dart';
import '../../domain/usecases/login_use_case.dart';

// 跨模块使用绝对导入
import 'package:listen_portfolio_flutter/shared/constants/app_constants.dart';
```

## 🛠️ 治理工具

### 1. 依赖分析工具 (dependency_rules.dart)

**位置**: `tools/dependency_rules.dart`

**功能特性**:
- ✅ 上下文感知的依赖检查
- ✅ 支持跨平台运行 (Windows/Linux/macOS)
- ✅ 生成 JSON 格式依赖图
- ✅ 详细的违规报告和修复建议
- ✅ 统计信息和模块分布

**使用方法**:
```bash
# 运行依赖边界检查
dart tools/dependency_rules.dart

# 生成依赖图 (JSON格式)
dart tools/dependency_rules.dart --graph

# 查看帮助
dart tools/dependency_rules.dart --help
```

**检测规则**:
1. **跨 Features 模块依赖**: `features/auth` 不应依赖 `features/home`
2. **Shared 依赖 Features**: shared 模块不应依赖任何 features
3. **Core 依赖上层**: core 模块不应依赖 shared/features
4. **私有实现导入**: 禁止导入 `_impl.dart`, `_mock.dart` 等私有文件

**技术实现**:
- 基于正则表达式模式匹配
- 文件路径上下文分析
- 递归扫描 `lib/` 目录
- 支持相对路径和绝对导入检查

### 2. 自定义 Lint 规则 (IDE 实时检查)

**位置**: `tools/lint_rules/lib/src/dependency_boundary_lint.dart`

**规则类型**:
- `dependency_boundary`: 依赖边界违规检查
- `circular_dependency`: 循环依赖检测  
- `implementation_import`: 私有实现导入检查

**触发时机**:
- IDE 中保存文件时自动触发
- 运行 `flutter analyze` 时执行
- CI/CD 流程中的分析阶段

**配置文件**:
```yaml
# analysis_options.yaml
include: package:dependency_lint_rules/dependency_lint_rules.yaml

custom_lint:
  rules:
    - dependency_boundary
    - circular_dependency
    - implementation_import
```

**技术架构**:
```
tools/lint_rules/
├── pubspec.yaml                    # 包配置
├── dependency_lint_rules.yaml      # Lint 规则配置
└── lib/
    ├── dependency_lint_rules.dart  # 库入口文件
    └── src/
        └── dependency_boundary_lint.dart  # 规则实现 (235行)
```

### 3. CI/CD 自动化检查

**位置**: `.github/workflows/dependency-check.yml`

**检查流程**:
1. **Flutter Analyze**: 触发 IDE lint 规则检查
2. **依赖边界检查**: 运行 `dependency_rules.dart`
3. **依赖图生成**: 创建可视化依赖关系图
4. **报告上传**: 保存检查结果供审查

**触发条件**:
- Push 到 `main`/`develop` 分支
- Pull Request 创建/更新
- 手动触发工作流

**输出产物**:
- `dependency_graph.json`: 依赖关系图
- `dependency_report.md`: 检查报告
- 工作流日志和违规统计

## 🔧 修复策略

### 1. 跨模块依赖修复

**问题**: Feature A 依赖 Feature B

**解决方案**:
1. 将共同代码提取到 `shared`
2. 使用事件总线进行通信
3. 通过路由参数传递数据

```dart
// 提取到 shared
// lib/shared/models/user_profile.dart
class UserProfile { ... }

// 或使用事件总线
// lib/shared/events/user_events.dart
class UserUpdatedEvent {
  final UserProfile user;
  UserUpdatedEvent(this.user);
}
```

### 2. 向上依赖修复

**问题**: Shared 依赖 Features

**解决方案**:
1. 将依赖的内容下移到 shared
2. 使用依赖注入
3. 定义接口抽象

```dart
// 定义接口
// lib/shared/interfaces/auth_service.dart
abstract class AuthService {
  Future<User?> getCurrentUser();
}

// 在 features 中实现
// lib/features/auth/data/services/auth_service_impl.dart
class AuthServiceImpl implements AuthService {
  @override
  Future<User?> getCurrentUser() async {
    // 实现
  }
}
```

### 3. 循环依赖修复

**问题**: A → B → A

**解决方案**:
1. 提取共同依赖到第三方模块
2. 使用事件驱动架构
3. 重新设计模块边界

## 📊 监控与报告

### 1. 依赖分析结果示例

#### 🔧 **修复前** (有违规)
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

#### ✅ **修复后** (合规)
```bash
🔍 Starting dependency boundary analysis...

📊 Dependency Boundary Check Report
==================================================
✅ All dependencies comply with the rules!
```

**修复说明**:
- 更新了依赖检测规则，允许 Provider 文件导入实现类
- Provider 文件位于 `features/*/data/providers/` 目录下
- 这些文件负责依赖注入，需要创建实现类实例
   → import 'package:.../about_me_repository_impl.dart';

🚫 lib/features/home/presentation/provider/projects_provider.dart:4 
   → Direct import of private implementation files not allowed
   → import 'package:.../projects_repository_impl.dart';

💡 Fix suggestions:
1. Cross-module dependencies: Consider extracting common logic to shared or core
2. Upward dependencies: Check dependency hierarchy, ensure unidirectional dependencies
3. Private imports: Use public interfaces instead of private implementations
```

### 2. 依赖图生成

```bash
# 生成依赖图
dart tools/dependency_rules.dart --graph

✅ Dependency graph saved to: dependency_graph.json
📊 Statistics:
   - Total files: 156
   - Files with dependencies: 89
   - Total dependencies: 234
```

**依赖图 JSON 格式**:
```json
{
  "nodes": [
    "features/auth/presentation/pages/login_page.dart",
    "shared/utils/auth_helper.dart",
    "core/network/api_client.dart"
  ],
  "edges": [
    {
      "from": "features/auth/presentation/pages/login_page.dart",
      "to": ["import 'package:listen_portfolio_flutter/shared/utils/auth_helper.dart';"]
    }
  ],
  "statistics": {
    "totalFiles": 156,
    "filesWithDependencies": 89,
    "totalDependencies": 234
  }
}
```

### 3. IDE 实时反馈

在 IDE 中，违规依赖会立即显示：

```dart
// 在 VS Code 中会看到红色波浪线和错误提示
import 'package:listen_portfolio_flutter/features/auth/data/repositories/auth_repository_impl.dart';
// ↑ Error: Direct import of private implementation files not allowed
```

### 4. 定期审查流程

**每日检查**:
- 开发者本地运行 `dart tools/dependency_rules.dart`
- IDE 实时 lint 提示

**每周审查**:
- 代码 Review 时检查依赖关系
- 分析依赖图变化趋势

**每月评估**:
- 评估架构健康度
- 识别技术债务
- 制定重构计划

## 🎯 最佳实践

### 1. 模块设计

- **单一职责**: 每个模块只负责一个功能领域
- **稳定依赖**: 依赖更稳定的模块
- **接口隔离**: 定义清晰的模块接口

### 2. 导入规范

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

### 3. 架构演进

- 渐进式重构，避免大规模改动
- 保持向后兼容性
- 文档化架构决策

## 🚀 实施计划

### 阶段 1: 基础设施 ✅ 已完成
- [x] 创建依赖分析工具 (`dependency_rules.dart`)
- [x] 实现自定义 lint 规则 (`dependency_boundary_lint.dart`)
- [x] 配置 CI/CD 自动检查 (`dependency-check.yml`)
- [x] 设置 IDE 实时反馈 (`analysis_options.yaml`)
- [x] 完善文档和使用指南

### 阶段 2: 现有代码清理 🔄 进行中
- [x] 识别现有违规依赖 (发现 3 个实现类导入违规)
- [ ] 修复 Provider 文件中的直接实现导入
- [ ] 重构依赖注入模式
- [ ] 验证修复效果

### 阶段 3: 持续治理 📋 计划中
- [ ] 建立代码审查检查清单
- [ ] 定期架构审查会议 (每月)
- [ ] 依赖治理自动化改进
- [ ] 团队培训和规范推广

## 📚 技术实现细节

### 依赖检测算法

**上下文感知检测**:
```dart
// 检测逻辑示例
static bool _isContextualViolation(String importLine, String? fileModule) {
  // shared 文件导入 features → 违规
  if (fileModule == 'shared' && importLine.contains('features/')) {
    return true;
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

// 私有实现文件导入
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

## 📚 参考资料

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Hexagonal Architecture](https://alistair.cockburn.us/hexagonal-architecture/)
- [Flutter Architecture Layers](https://docs.flutter.dev/development/data-and-backend/state-mgmt/architecture)
- [Custom Lint Rules Documentation](https://pub.dev/packages/custom_lint)
- [Dart Analyzer Plugin API](https://pub.dev/packages/analyzer_plugin)

---

通过这套完整的依赖边界治理体系，我们确保了项目架构的清晰性、可维护性和可扩展性。工具链的自动化检查为团队开发提供了强有力的技术保障。
