# 自定义静态分析规则 (Custom Lint Rules) 架构设计与实现文档

**Status**: `Implemented & Integrated`  
**Latest Update**: `2026-09-12`  
**Technology Stack**: `custom_lint 0.8.1 + custom_lint_builder + Dart Analyzer AST (8.4.0)`  
**Dual-Track Architecture**: `Language Server Plugin (IDE Real-Time & Auto-Fix) + Standalone CLI Analyzer (tools/dependency_rules.dart)`  
**Target Repository**: `ListenPortfolioFlutter` (with `ListenUiKit` and `ListenCore` linkages)  

---

## 1. 概述与核心设计哲学

### 1.1 为什么标准 `flutter_lints` 远远不够？
Flutter 官方提供的 `flutter_lints`（基于 `package:lints`）主要聚焦于 Dart 语言层面的语法规范、基础代码异味（Code Smell）与常规通用实践（如 `prefer_const_constructors`、`avoid_print` 等）。然而，在现代中大型商业级全栈 Flutter 工程中，官方规则完全无法感知并约束以下**业务架构层面的关键红线**：
1. **Clean Architecture 分层边界**：官方规则无法阻止 Presentation 层或 Domain 层直接穿透依赖 Data 层的私有实现类（`_impl.dart`），也无法感知 Feature 模块之间的非法横向双向耦合；
2. **Clean MVI 状态机纯度**：无法阻止开发者在 `ViewModel` 中滥用 `BuildContext` 导致内存泄漏，也无法阻止在 ViewModel 中直接通过 `state = ...` 破坏状态原子性与回放录制；
3. **自研设计系统与组件库（Design System / UI Kit）归一化**：无法强制全团队统一使用具备防掉帧、带缓存、带响应式缩放与无障碍规范的 `CommonImage`、`CommonClickable`、`CommonText`，导致原生 `Image`、`InkWell`、`Text` 随意滥用；
4. **设计令牌（Design Tokens）与暗黑模式安全**：无法阻止业务开发随手硬编码 `Color(0xFF...)` 或读取静态 `Colors.xxx`，导致切换暗黑主题时界面对比度失效或出现刺眼白块；
5. **国际化 (i18n) 刚性合规**：无法阻止在 UI 组件中硬编码中英文纯文本字符串，导致海外多语言发布时出现大面积“漏译”缺陷。

为了建立**不可逾越的架构刚性防线**，本项目基于 `custom_lint_builder` 构建了专属的自定义静态分析规则体系，并结合独立 CLI 工具形成了双轨制治理方案。

### 1.2 双轨制架构治理体系 (Dual-Track Enforcement Strategy)

本项目设计并落地了**“开发期实时守卫 + 编译/CI 期极速拦截”**的双轨制架构治理体系：

```mermaid
flowchart TD
    subgraph TrackA [轨道 A: IDE 实时交互与 Quick-Fix (custom_lint)]
        Code[开发者在 IDE 中编写 Dart 代码] --> LSP[Dart Analysis Server]
        LSP --> CLPlugin[DependencyBoundaryLint Plugin]
        CLPlugin --> AST[Dart AST 抽象语法树节点遍历]
        AST --> LintCheck{命中 18 项规则?}
        LintCheck -- 是 --> Squiggle[编辑器行内标红 / 错误警告提示]
        Squiggle --> QuickFix[Alt+Enter / 命令行 --fix 一键自动重构]
        LintCheck -- 否 --> Green[通过校验]
    end

    subgraph TrackB [轨道 B: 独立极速分析器与 CI 门禁 (dependency_rules.dart)]
        Terminal[CLI / Git Pre-Commit Hook / CI Pipeline] --> DepTool[dart tools/dependency_rules.dart]
        DepTool --> RegexScan[全局单向依赖与分层拓扑校验]
        DepTool --> GraphGen[--graph 生成 dependency_graph.json]
        RegexScan --> ViolationCheck{是否存在违规?}
        ViolationCheck -- 是 --> Exit1[Exit Code 1 阻断 PR 合并]
        ViolationCheck -- 否 --> Exit0[Exit Code 0 绿灯放行]
    end
```

| 治理维度 | 轨道 A: `custom_lint` 插件体系 | 轨道 B: 独立 CLI `dependency_rules.dart` |
| :--- | :--- | :--- |
| **底层原理** | 基于 Dart Analyzer AST 强类型语法树语义分析 | 基于文件流与正则模式匹配的拓扑静态分析 |
| **生效时机** | IDE 编写代码时实时生效（VSCode / Android Studio） | 终端命令行、本地 Pre-commit Hook、CI/CD 流水线 |
| **执行性能** | 随文件改动增量触发；全工程运行需启动分析服务 | **毫秒级极速完成**（全工程扫描耗时 < 300ms） |
| **自动修复** | **全面支持 `DartFix`**（命令行 `dart run custom_lint --fix`） | 仅报告位置与违规描述，不修改源码 |
| **图谱可视化**| 不支持 | **支持**（一键生成全工程 `dependency_graph.json` 依赖图） |

---

## 2. 全景 18 项自定义静态规则矩阵

所有自定义规则均在 [`tools/lint_rules/lib/src/dependency_boundary_lint.dart`](../tools/lint_rules/lib/src/dependency_boundary_lint.dart) 中实现，并通过 `DependencyBoundaryLint` 统一注册：

### 2.1 规则分类对照表

| 分类领域 | 规则代码 (Lint Code) | 违规场景说明 | 推荐解决方案 / 自动修复行为 | Auto-Fix 支持 |
| :--- | :--- | :--- | :--- | :---: |
| **架构与边界** | `dependency_boundary_violation` | 跨特征模块横向依赖；Core 底层反向导入 Features 或 Shared 上层模块；导入下划线私有文件。 | 重构依赖拓扑，下沉公共逻辑或走统一路由。 | ❌ |
| **架构与边界** | `circular_dependency` | 模块间或文件间出现回环引用成环（A $\rightarrow$ B $\rightarrow$ A）。 | 提取公共接口，破坏循环链条。 | ❌ *(占位待演进)* |
| **架构与边界** | `implementation_import` | Presentation/Domain 层直接导入 Data 层私有实现类（`_impl.dart` 或 `impl/`）。 | 改为面向抽象 Repository 接口编程。 | ❌ |
| **架构与边界** | `cross_feature_relative_import` | 跨 Feature 目录使用了以 `.` 或 `..` 开头的相对路径逃逸导入。 | 必须使用以 `package:` 路径开头的命名导入或路由跳转。 | ❌ |
| **架构与边界** | `no_direct_app_nav_usage` | 在 Feature 业务组件中直接命令式调用 `AppNav.to(...)` 等原生导航方法。 | 遵循 MVI 单向数据流，通过 ViewModel 发射 `NavigationEffect`。 | ❌ |
| **Clean MVI** | `view_model_context_isolation` | 在 `_view_model.dart` 文件中引用或持有 `BuildContext`。 | ViewModel 严禁访问 UI 上下文，UI 动作统一改用 `emitEffect(...)`。 | ❌ |
| **Clean MVI** | `no_direct_state_assignment` | 在 ViewModel 中直接执行 `state = ...` 进行状态重赋值。 | 必须通过统一封装的 `updateState(...)` 触发原子更新与回放录制。 | ❌ |
| **UI 规范治理** | `use_common_image` | 直接实例化 Flutter SDK 的原生 `Image` 组件。 | 自动替换为带解码防冻结、LRU 缓存与渐进占位的 `CommonImage`。 | ✅ **(Auto-Fix)** |
| **UI 规范治理** | `use_common_clickable` | 直接实例化 Flutter 原生的 `InkWell` 或 `GestureDetector`。 | 自动替换为 `CommonClickable`；对于 `GestureDetector` 自动补全 `ripple: false`。 | ✅ **(Auto-Fix)** |
| **UI 规范治理** | `use_common_text` | 直接使用原生 `Text` 组件。 | 自动替换为应用了 7 大外观字体族回退链与防截断的 `CommonText`。 | ✅ **(Auto-Fix)** |
| **UI 规范治理** | `use_common_button` | 直接使用 `ElevatedButton`, `TextButton`, `OutlinedButton`, `FilledButton`, `CupertinoButton`。 | 自动替换为标准化视觉反馈按钮 `CommonButton`。 | ✅ **(Auto-Fix)** |
| **UI 规范治理** | `use_common_icon_button` | 直接使用原生 `IconButton` 等图标按钮。 | 自动替换为标准化 44x44 触控热区的 `CommonIconButton`。 | ✅ **(Auto-Fix)** |
| **UI 规范治理** | `use_common_dialog` | 在业务层直接调用全局函数 `showDialog`, `showGeneralDialog`, `showCupertinoDialog`。 | 统一使用 `CommonDialog` 静态方法触发，受 Single UI Binder 防重弹窗队列管理。 | ❌ |
| **UI 规范治理** | `use_common_switch` | 直接使用 `Switch` 或 `CupertinoSwitch` 组件。 | 自动替换为主题自适应的 `CommonSwitch`。 | ✅ **(Auto-Fix)** |
| **UI 规范治理** | `use_common_text_field` | 直接使用 `TextField` 或 `TextFormField` 组件。 | 自动替换为统一样式的 `CommonTextField`。 | ✅ **(Auto-Fix)** |
| **UI 规范治理** | `use_common_refresh_list` | 直接使用原生 `RefreshIndicator` 或 `CupertinoSliverRefreshControl`。 | 自动替换为整合空状态与错误重试的 `CommonRefreshList`。 | ✅ **(Auto-Fix)** |
| **设计令牌** | `no_raw_color` | 在业务层直接调用 `Color(0xFF...)` 或读取静态 `Colors.xxx`。 | 统一使用 `context.theme.xxx` 或主题扩展颜色，保障暗黑模式自适应。 | ❌ |
| **国际化合规** | `no_hardcoded_strings` | 在 `Text` 或 `CommonText` 中硬编码中/英文字符串字面量。 | 必须使用多语言翻译字典 `I18nKeys.yourKey.tr`。 | ❌ |

---

## 3. 核心架构与 AST 实现原理深度剖析

### 3.1 Dart AST 语法树遍历与监听模型
`custom_lint_builder` 运行在 Dart Analysis Server 进程中。当源码发生变动或执行分析时，分析器将 Dart 代码解析为一棵强类型的抽象语法树（AST）。
规则插件通过 `CustomLintContext.registry` 订阅特定类型的 AST 语法节点，实现高内聚、低开销的针对性扫描：

```
CompilationUnit (整文件顶级节点)
 ├── ImportDirective (导入指令) ───► 拦截: dependency_boundary, implementation_import, cross_feature
 ├── ClassDeclaration (类声明)
 │    └── MethodDeclaration (方法声明)
 │         └── Block (代码块)
 │              ├── InstanceCreationExpression (实例化表达式) ───► 拦截: use_common_xxx, no_raw_color, no_hardcoded_strings
 │              ├── MethodInvocation (方法调用) ─────────────► 拦截: no_direct_app_nav_usage, use_common_dialog
 │              ├── AssignmentExpression (赋值表达式) ────────► 拦截: no_direct_state_assignment
 │              └── SimpleIdentifier (标识符) ───────────────► 拦截: view_model_context_isolation
```

### 3.2 规则匹配逻辑模板 (Rule Lifecycle)
每个规则继承自 `DartLintRule`，并在 `run` 方法中向 `context.registry` 挂载侦听器：
```dart
class _SampleCustomRule extends DartLintRule {
  static const LintCode _code = LintCode(
    name: 'sample_rule',
    problemMessage: 'Violation description',
    correctionMessage: 'Actionable guidance to fix the issue',
  );

  const _SampleCustomRule() : super(code: _code);

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    // 1. 获取当前分析文件的绝对路径，执行全局文件级过滤（如排除 UIKit、测试文件、生成文件等）
    final filePath = resolver.source.fullName;
    if (filePath.contains('ListenUiKit') || filePath.contains('tools/')) return;

    // 2. 精准监听目标 AST 节点
    context.registry.addInstanceCreationExpression((InstanceCreationExpression node) {
      // 3. 提取节点静态类型元素并校验来源
      final typeElement = node.staticType?.element;
      if (typeElement?.library?.uri.toString().startsWith('package:flutter/') == true &&
          typeElement?.name == 'TargetWidget') {
        // 4. 定位语法树节点并向分析器报告违规
        reporter.atNode(node, _code);
      }
    });
  }
}
```

### 3.3 自动化 Quick-Fix 重写流水线 (`DartFix` & `ChangeBuilder`)
支持自动修复的规则在类中重写 `List<Fix> getFixes() => [_SampleFix()];`。当开发者在 IDE 中唤起修复建议或执行 `custom_lint --fix` 时，`DartFix.run` 被触发：

1. **碰撞区间校验**：`analysisError.sourceRange.intersects(node.sourceRange)` 确保只修复引发告警的目标节点；
2. **导入声明智能补全**：调用 `builder.importLibraryElement(Uri.parse('package:listen_uikit/uikit.dart'))`。`ChangeBuilder` 会自动检查当前文件是否已存在该 import，若无则在文件顶部最合理的依赖位置插入，**绝不重复导入**；
3. **构造器名称重写**：`builder.addSimpleReplacement(SourceRange(...), 'CommonWidget')` 精准替换标识符；
4. **参数列表智能补齐**：调用 `builder.addSimpleInsertion(...)` 在参数列表括号内动态注入必要属性。

---

## 4. 重点与难点代码实现深度剖析

### 4.1 难点一：`GestureDetector` 转换为 `CommonClickable` 时的参数注入
- **问题背景**：原生 `InkWell` 默认带有水波纹点击动效，直接换成 `CommonClickable` 体验一致；但 `GestureDetector` 在 Flutter 中通常用于**纯粹的手势捕获或无水波纹点击**。若简单地将其更名为 `CommonClickable`，会导致原本没有水波纹的交互区域突然多出涟漪，破坏 UI 设计。
- **AST 解决方案**：在 `_UseCommonClickableFix` 中，AST 分析器检查当前节点类型：若为 `GestureDetector`，通过定位参数列表的左括号结束位置（`node.argumentList.leftParenthesis.end`），就地插入 `'ripple: false, '` 参数：

```dart
// ListenPortfolioFlutter: tools/lint_rules/lib/src/dependency_boundary_lint.dart
if (typeName == 'GestureDetector') {
  builder.addSimpleInsertion(
    node.argumentList.leftParenthesis.end,
    'ripple: false, ',
  );
}
```

### 4.2 难点二：实现类导入隔离中的架构白名单豁免 (`_ImplementationImportLint`)
- **问题背景**：Clean Architecture 严格禁止上层直接导入底层实现类（如 `_impl.dart` 或 `data/repositories/xxx_repository_impl.dart`）。但如果“一刀切”拦截，依赖注入层（Riverpod Provider）将无法实例化具体的 RepositoryImpl，数据层内部各个组件也无法协同工作。
- **AST 解决方案**：设计两级豁免白名单：
  1. **DI 绑定层豁免**：路径包含 `/provider/` 或以 `_provider.dart` 结尾的文件放行；
  2. **数据层内部豁免**：当前文件本身在 `/data/` 目录下的，允许相互调用。

```dart
// ListenPortfolioFlutter: tools/lint_rules/lib/src/dependency_boundary_lint.dart
final filePath = resolver.source.fullName;

// 豁免 1: 允许 Provider 依赖注入文件导入实现类完成构造绑定
if (filePath.contains('/provider/') || filePath.endsWith('_provider.dart')) {
  return;
}

// 豁免 2: 允许 Data 层内部实现互相调用 (如 RepositoryImpl 调用 DataSourceImpl)
if (filePath.contains('/data/')) {
  return;
}
```

### 4.3 难点三：国际化硬编码字符串的 Unicode 多语言正则过滤 (`_NoHardcodedStringsRule`)
- **问题背景**：若只要在 `Text(...)` 中遇到字符串字面量就报违规，那么纯数字（`"123"`）、技术标点（`":"`、`"-"`）、数学符号（`"+"`）甚至空字符串也会被误判，造成极大的开发干扰。
- **AST 解决方案**：提取 `StringLiteral` 的真实文本内容，利用 Unicode 字符集正则匹配：
  `RegExp(r'[a-zA-Z\u4e00-\u9fa5]+')`。
  只有当字符串中包含**英文字母**或**常用汉字字符（CJK Unicode 区间 `\u4e00-\u9fa5`）**时，才被认定为人类可读的展示文案并上报违规，极大幅度降低了误报率。

### 4.4 难点四：设计令牌与色彩硬编码的精细排除矩阵 (`_NoRawColorRule`)
- **问题背景**：项目要求业务 UI 不可硬编码 `Color(...)` 或 `Colors.xxx`。然而，主题定义文件（`app_theme.dart`）、主题扩展、国际化文件以及 MVI 的 State/Intent/ViewModel 纯数据类可能需要承载颜色模型。
- **AST 解决方案**：构建精确的多维度排除矩阵：
  ```dart
  if (filePath.contains('ListenUiKit') || 
      filePath.contains('tools/') || 
      filePath.endsWith('_view_model.dart') || 
      filePath.endsWith('_state.dart') || 
      filePath.endsWith('_intent.dart') || 
      filePath.contains('/theme/') ||
      filePath.contains('app_theme.dart') ||
      filePath.contains('/i18n/')) return;
  ```
  该策略将检测靶心严格收束在 `lib/features/**/presentation/` 与 `lib/shared/widgets/` 的具体 UI 绘制节点上。

### 4.5 难点五：独立 CLI 依赖拓扑图导出器 (`tools/dependency_rules.dart`)
除了逐行校验违规外，`tools/dependency_rules.dart` 实现了全工程导入关系的拓扑抽取，支持生成可视化数据图谱：
```bash
dart tools/dependency_rules.dart --graph
```
该命令递归扫描 `lib/` 下所有 Dart 源码文件，提取 `features/`、`shared/`、`core/` 的依赖引用，生成标准化的 `dependency_graph.json`：
```json
{
  "nodes": ["features/home/presentation/pages/home_page.dart", ...],
  "edges": [
    {
      "from": "features/home/presentation/pages/home_page.dart",
      "to": ["import 'package:listen_core/listen_core.dart';", ...]
    }
  ],
  "statistics": {
    "totalFiles": 142,
    "filesWithDependencies": 128,
    "totalDependencies": 856
  }
}
```
可直接导入 Gephi、Cytoscape 或前端 ECharts 进行全站架构拓扑可视化渲染。

---

## 5. 命令行使用与自动化修复工作流

### 5.1 轨道 A：`custom_lint` 命令行全量检测与一键自动修复

```bash
# 1. 清理分析器缓存，保证加载最新的自定义规则逻辑
dart run custom_lint --clean

# 2. 运行全量静态分析并输出检测报告
dart run custom_lint

# 3. 执行一键批量自动修复 (Auto-Fix)
# 自动将工程内所有原生 Image、Text、InkWell 等批量重写为 CommonWidget，并自动注入 import
dart run custom_lint --fix
```

> [!TIP]
> 执行 `dart run custom_lint --fix` 后，可通过 `git diff` 审查重构变动。自动生成的重写代码完全符合 Dart 官方格式化规范。

### 5.2 轨道 B：独立分析器 CLI 执行与架构门禁

```bash
# 1. 运行完整依赖边界检查 (秒级完成)
dart tools/dependency_rules.dart

# 2. 仅检查是否存在反向分层越级依赖 (Core 依赖上层)
dart tools/dependency_rules.dart --check-layers

# 3. 仅检查是否存在循环依赖
dart tools/dependency_rules.dart --check-circular

# 4. 生成架构全景依赖拓扑 JSON 图谱
dart tools/dependency_rules.dart --graph
```

---

## 6. 目前存在的不足与未来演进路线 (Limitations & Roadmap)

结合当前静态分析工具链的实际落地情况，我们在工程架构的深度完备性与 CI 自动化方面识别出以下不足与演进方向。相关任务已正式录入 [docs/todo.md](todo.md)：

### 6.1 局限点 1：循环依赖检测在 `custom_lint` 中仍为占位状态
- **现状**：`_CircularDependencyLint` 在 `dependency_boundary_lint.dart` 中当前仅作为占位声明（`run` 方法内未执行实际逻辑）。这是因为 `custom_lint_builder` 的运行模型是将单个文件或目录作为增量编译单元（Compilation Unit）隔离加载，无法跨全工程构建完整闭包图。而独立工具 `tools/dependency_rules.dart --check-circular` 目前仅依赖行级正则扫描，尚未集成严格的有向环检测图算法。
- **演进路线**：推进 **[Opt-11] 循环依赖有向图深度检测算法与 CI/CD 架构红线门禁**。在 `tools/dependency_rules.dart` 中实现基于 Tarjan 强连通分量（SCC）或深度优先搜索（DFS）回溯的成环定位算法，毫秒级输出成环链路（如 `A -> B -> C -> A`）。

### 6.2 局限点 2：缺少 CI/CD 架构红线必阻断流水线
- **现状**：当前 `dart tools/dependency_rules.dart` 只能在线下由开发者手动执行，尚未被编排进 `.github/workflows/ci.yml` 的 PR 校验流水线中。如果开发者在提交代码时绕过本地检查，非法依赖仍可能潜入主干分支。
- **演进路线**：推进 **[Opt-11] CI/CD 刚性门禁集成**。在 GitHub Actions CI 流水线中将 `dart run tools/dependency_rules.dart` 设为必选 Check；若检测到违规立即以非 0 状态码阻断 PR 合并，彻底捍卫 Clean Architecture 单向依赖架构边界。

### 6.3 局限点 3：复杂架构规则缺少 AST Quick-Fix 自动重写支持
- **现状**：当前 18 项规则中，仅 8 项基础 UI 控件具备 `DartFix` 自动替换能力。对于 `view_model_context_isolation`（将 Context 移除并改写为 emitEffect）、`no_direct_state_assignment`（将 `state = ...` 转换为 `updateState(...)`）、`no_direct_app_nav_usage`（将 `AppNav.to` 转换为 `emitEffect(NavigationEffect(...))`）等复杂场景，开发者仍需手动查阅文档进行繁琐的代码重构。
- **演进路线**：推进 **[Opt-12] 静态分析 Quick-Fix 语法重写扩充**。为状态机赋值与导航跳转编写高级 `ChangeBuilder` AST 转换器，支持在 IDE 中一键无缝重构为标准 MVI 数据流代码。

### 6.4 局限点 4：规则严重度未分级与内部工具面板的误报干扰
- **现状**：本地执行 `dart run custom_lint` 时会扫描全工程，由于 APM 监控看板（`perf_dashboard_tab.dart`）等内部调试面板大量使用了特定颜色（如红黄绿性能指标），触发了 300+ 条 `no_raw_color` 告警；且当前所有规则一律输出为 `INFO`，无法对严重架构越界（如 Core 依赖 Features）与轻量 UI 替换进行分级治理。
- **演进路线**：推进 **[Opt-12] 规则严重级别分级 (Severity Tiering) 与配置化白名单**。在 `dependency_lint_rules.yaml` 中将规则划分为 `ERROR`（架构越界、私有实现穿透）、`WARNING`（ViewModel 纯度、未翻译文案）与 `INFO`（设计系统控件对齐），并支持按 Glob 模式灵活配置白名单目录。

---

## 7. 关联配置文件与代码文件相对索引

- **自定义分析规则插件源码**: [`tools/lint_rules/lib/src/dependency_boundary_lint.dart`](../tools/lint_rules/lib/src/dependency_boundary_lint.dart)
- **自定义分析规则插件导出库**: [`tools/lint_rules/lib/dependency_lint_rules.dart`](../tools/lint_rules/lib/dependency_lint_rules.dart)
- **独立架构依赖检查器 CLI**: [`tools/dependency_rules.dart`](../tools/dependency_rules.dart)
- **分析插件依赖声明文件**: [`tools/lint_rules/pubspec.yaml`](../tools/lint_rules/pubspec.yaml)
- **分析器规则配置文件**: [`analysis_options.yaml`](../analysis_options.yaml)
- **工程主依赖声明文件**: [`pubspec.yaml`](../pubspec.yaml)
- **UI 设计系统组件库**: [`ListenUiKit/uikit.dart`](../../ListenUiKit/lib/uikit.dart)
- **核心框架底层库**: [`ListenCore/core.dart`](../../ListenCore/lib/core.dart)
- **后续优化演进路线追踪**: [`docs/todo.md`](todo.md)
