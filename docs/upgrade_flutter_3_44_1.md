# ListenPortfolioFlutter - Flutter 3.44.1 升级指南与变更记录

本篇文档记录了主工程 `ListenPortfolioFlutter` 从 Flutter **3.38.3** 升级至 **3.44.1**（对应 Dart SDK 为 **3.12.1**）的核心变更点、依赖调整详情、代码适配方案以及未来标准升级流程。

---

## 1. 核心变更点对照表 (Flutter 3.38.3 -> 3.44.1)

以下为 Flutter 3.38.3 至 3.44.1 版本之间，官方发布的所有核心破坏性变更（Breaking Changes）与废弃特性。针对每一个变更点，本文提供了官方说明 URL、原理解释、适配方法以及在当前项目中的实际影响评估。

### 1.1 宽色域支持与 Color 属性废弃 (Color Class & Wide Gamut Support)
- **官方说明 URL**: [https://docs.flutter.dev/release/breaking-changes/wide-gamut-color](https://docs.flutter.dev/release/breaking-changes/wide-gamut-color)
- **变更点说明**: 为了适配现代设备的 Wide Gamut (如 Display P3) 宽色域，Flutter 将 `Color` 类的内部表示从 8 位整数通道重构为 normalized 浮点数通道。因此，传统返回 0-255 整数的 `red`、`green`、`blue`、`alpha`、`opacity` 属性以及 `withOpacity(...)` 方法已被废弃。
- **改动方法**: 
  - 属性替换：`red` -> `(r * 255.0).round().clamp(0, 255)`，同理适用于 `green` (`g`), `blue` (`b`), `alpha` (`a`)。
  - 透明度设置替换：`color.withOpacity(0.5)` -> `color.withValues(alpha: 0.5)`。
- **当前项目是否需要改动**: **是**。
  - **影响位置**: [appearance_page.dart](../lib/features/settings/presentation/pages/appearance/appearance_page.dart) 中的 RGB 颜色调节滑动条逻辑。
  - **改造详情**: 已将 `selectedColor.red`、`selectedColor.green`、`selectedColor.blue` 均适配修改为 `(selectedColor.r * 255.0).round().clamp(0, 255)`。

### 1.2 Android 构建向 Built-in Kotlin 迁移 (Migrate to Built-in Kotlin)
- **官方说明 URL**: [https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin)
- **变更点与警告产生原因**:
  在新版 Flutter 3.44.1 中，Flutter 引擎引入了 **Built-in Kotlin** 机制，由 Flutter 编译工具链自动为 Android 项目配置 Kotlin 编译器。如果项目或三方插件在 `build.gradle` (或 `build.gradle.kts`) 中继续手动应用 `id("kotlin-android")` 或 Kotlin Gradle Plugin (KGP)，将会导致冗余的编译配置以及 classpath 冲突，并会在执行 `flutter run` / `flutter build` 时打印如下警告：
  ```
  WARNING: Your Android app project: app located at: .../build.gradle.kts applies the Kotlin Gradle Plugin, which will cause build failures in future versions of Flutter.
  WARNING: Your app uses the following plugins that apply Kotlin Gradle Plugin (KGP): device_info_plus, package_info_plus, share_plus
  ```
- **改动与解决策略**:
  1. **对于应用主工程 (App Project)**:
     - 在 [android/app/build.gradle.kts](../android/app/build.gradle.kts) 的 `plugins` 块中**删除** `id("kotlin-android")` 插件。
     - 在 [android/settings.gradle.kts](../android/settings.gradle.kts) 的 `plugins` 块中，**保留并升级** Kotlin 声明，即 `id("org.jetbrains.kotlin.android") version "2.2.20" apply false`，以此作为全局 Kotlin 编译器版本约束，而不在应用子模块中直接应用。
     - 在 [android/gradle.properties](../android/gradle.properties) 中开启内置 Kotlin 和新版 DSL 开关：
       ```properties
       android.builtInKotlin=true
       android.newDsl=true
       ```
     - *效果评估*：应用层本身的 KGP 警告已完全消失。
  2. **对于三方开源插件 (Plugins)**:
     - 警告中提到的 `device_info_plus`、`package_info_plus`、`share_plus` 等三方开源库，由于其内部源码尚在向 Built-in Kotlin 过渡期，仍在内部 `build.gradle` 中声明了 KGP。
     - *解决与应对*：这属于 Flutter 生态整体迁移的渐进过程。当前 Flutter 3.44.1 具有向后兼容兼容层，因此**该警告目前不会阻碍构建（已成功编译出 app-debug.apk）**。我们需要在后续开发中关注这些 Plus 插件的版本发布，及时升级至彻底移除了 KGP 应用的最新大版本即可消除三方插件警告。
- **当前项目是否需要改动**: **是**。
  - **影响位置**: Android 模块构建配置 (`android/app/build.gradle.kts`、`android/settings.gradle.kts`、`android/gradle.properties`)。
  - **改造详情**: 已按照上述方法对主工程进行了完全的 Built-in Kotlin 改造（去除 app 模块 KGP，升级 Kotlin 版本，开启 properties 标志位），主工程警告已消退，单元测试与打包均一次性通过。

### 1.3 MaterialState 重命名为 WidgetState (MaterialState renamed to WidgetState)
- **官方说明 URL**: [https://docs.flutter.dev/release/breaking-changes/material-state-renamed-to-widget-state](https://docs.flutter.dev/release/breaking-changes/material-state-renamed-to-widget-state)
- **变更点说明**: 为了让状态共享机制更加通用，原本专属 Material 库的 `MaterialState` 及其相关属性（如 `MaterialStateProperty`、`MaterialStateColor` 等）已迁移为通用的 `WidgetState`（例如 `WidgetStateProperty`）。
- **改动方法**: 将代码中所有 `MaterialState` 替换为 `WidgetState`。可运行 `dart fix --apply` 自动迁移。
- **当前项目是否需要改动**: **否**。
  - **改造详情**: 本项目目前无直接使用 `MaterialState` 状态的自定义组件属性，已确认代码中不存在该类型的废弃调用。

### 1.4 DropdownButton enabled 属性及 onChanged 可空化
- **官方说明 URL**: [https://docs.flutter.dev/release/breaking-changes/dropdown-button-enabled-on-changed](https://docs.flutter.dev/release/breaking-changes/dropdown-button-enabled-on-changed)
- **变更点说明**: `DropdownButton` 新增了 `enabled` 属性。原本通过令 `onChanged = null` 来禁用下拉菜单的做法，现在推荐使用 `enabled: false`，且 `onChanged` 回调被标记为可选（Optional）。
- **改动方法**: 显式使用 `enabled: false` 控制禁用态，或保持 `onChanged: null`（引擎会进行兼容）。
- **当前项目是否需要改动**: **否**。
  - **改造详情**: 本项目的下拉菜单组件均为常态启用，且均声明了 `onChanged` 回调。

### 1.5 IconData 声明为 final 类 (IconData class final)
- **官方说明 URL**: [https://docs.flutter.dev/release/breaking-changes/icondata-class-final](https://docs.flutter.dev/release/breaking-changes/icondata-class-final)
- **变更点说明**: 为了提高 API 安全性并防范意外修改，`IconData` 类被正式标记为 `final`，不允许再被外部类 `extends` 或 `implements`。
- **改动方法**: 若有自定义图标类继承了 `IconData`，需改为以组合方式使用，或者直接实例化 `IconData` 实例。
- **当前项目是否需要改动**: **否**。
  - **改造详情**: 本项目完全基于原生 Material Icons 以及自定义 SVG 资源进行渲染，未使用自定义子类继承 `IconData` 的写法。

### 1.6 ListTile 禁用在彩色容器中直接包裹 (ListTile error when wrapped in a colored widget)
- **官方说明 URL**: [https://docs.flutter.dev/release/breaking-changes/listtile-wrapped-in-colored-widget](https://docs.flutter.dev/release/breaking-changes/listtile-wrapped-in-colored-widget)
- **变更点说明**: 为了防止 Material 3 墨水波纹（Ink Splash）效果因背景色而被遮挡，新版 Flutter 在 Debug 模式下如果检测到 `ListTile` 被非透明的背景颜色组件（如包裹了 `color` 的 `Container` 或 `ColoredBox`）直接嵌套，会抛出断言错误。
- **改动方法**: 将背景色设置在 `ListTile.tileColor` 属性上，或者外层包裹 `Material` 组件并设置 `color`。
- **当前项目是否需要改动**: **否**。
  - **改造详情**: 项目内所有的 `ListTile` 背景颜色均通过 Material Theme 样式或者 `ListTile.tileColor` 直接设定，不存在违法包裹的行为。

### 1.7 滚动视图缓存属性 cacheExtent 废弃 (cacheExtent Deprecation)
- **官方说明 URL**: [https://docs.flutter.dev/release/breaking-changes/cache-extent-deprecation](https://docs.flutter.dev/release/breaking-changes/cache-extent-deprecation)
- **变更点说明**: 滚动视图（如 `ListView`）中的 `cacheExtent` 和 `cacheExtentStyle` 属性现已被废弃，统一推荐使用新命名的 `scrollCacheExtent` 属性以更好地符合滚动上下文命名规范。
- **改动方法**: 将 `cacheExtent` 替换为 `scrollCacheExtent`。
- **当前项目是否需要改动**: **否**。
  - **改造详情**: 本项目列表组件均为常规列表渲染，未对滚动缓存机制做过自定义参数修改，使用默认值即可。

### 1.8 CupertinoTabBar 强制要求 Localizations 父级 (CupertinoTabBar requires Localizations)
- **官方说明 URL**: [https://docs.flutter.dev/release/breaking-changes/cupertinotabbar-requires-localizations](https://docs.flutter.dev/release/breaking-changes/cupertinotabbar-requires-localizations)
- **变更点说明**: `CupertinoTabBar` 内部实现由于引入了文本防重叠及本地化自适应逻辑，现在其在组件树中的父级节点必须包含 `Localizations`（一般通过 `MaterialApp` 或 `CupertinoApp` 自动供给）。
- **改动方法**: 确保在单独的 Widget 测试或独立渲染树中使用 `CupertinoTabBar` 时，外层包裹 `Localizations`。
- **当前项目是否需要改动**: **否**。
  - **改造详情**: 本项目不包含 `CupertinoTabBar`，使用的是标准的 Material 底部导航或自定义组件。

### 1.9 其它次要/底层变更评估
- **TextInputConnection.setStyle 废弃**: 推荐改用 `updateStyle`。本项目不涉及底层 TextInput 通信，**无影响**。
- **RawMenuAnchor 关闭回调顺序调整**: 优化了菜单关闭时的回调时序。本项目未使用 `RawMenuAnchor` 进行复杂菜单自定义开发，**无影响**。
- **FontWeight 控制可变字体属性 (Variable Fonts)**: `FontWeight` 现在能够直接映射并控制 Variable Fonts 的 weight 属性。本项目目前仅使用静态外部字体，**无影响**。
- **SliverList 分离器 findChildIndexCallback 废弃**: 更名为 `findItemIndexCallback`。本项目 ListView 暂无需要显式索引追踪的高级复杂场景，**无影响**。

---

## 2. 本次升级依赖升级与冲突解决

升级 Dart SDK 至 `^3.12.1` 后，由于本地模块 `listen_core` (0.0.5) 依赖的更新，主工程触发了若干版本冲突，具体升级改造如下：

| 依赖库 (Pub Lib) | 升级前版本 | 升级后版本 | 升级原因与解决冲突点 |
| :--- | :---: | :---: | :--- |
| **`device_info_plus`** | `^12.3.0` | `^13.1.0` | 升级以适配 Dart 3.12.1 环境，并与 `listen_core` 保持同步。 |
| **`package_info_plus`** | `^9.0.0` | `^10.1.0` | 解决主工程与 `listen_core` (0.0.5) 因 package_info_plus 跨大版本依赖导致的编译失败。 |
| **`share_plus`** | `^12.0.1` | `^13.1.0` | `device_info_plus` (v13) 依赖 `win32 ^6.0.1`，而旧版 `share_plus` (v12) 依赖 `win32 ^5.5.3` 产生冲突。升级 `share_plus` 至 v13 以统一对齐 win32 依赖版本。 |

---

## 3. 代码适配详情

### Color 属性弃用警告修复
在调色板弹窗逻辑中，修复了 `Color.red` 等属性的使用警告：
- **文件**：`lib/features/settings/presentation/pages/appearance/appearance_page.dart`
- **改造内容**：
  ```text
  // 改造前 (触发 deprecated_member_use 警告)
  selectedColor.red
  selectedColor.green
  selectedColor.blue

  // 改造后 (适配新版 Color 宽色域规范)
  (selectedColor.r * 255.0).round().clamp(0, 255)
  (selectedColor.g * 255.0).round().clamp(0, 255)
  (selectedColor.b * 255.0).round().clamp(0, 255)
  ```

---

## 4. 标准升级与修改流程 (SOP)

为便于今后进一步升级至更高的 Flutter 版本，请遵循以下标准流程进行操作和验证：

### 第一步：SDK 切换与缓存清理
1. 确认或切换当前系统的 Flutter SDK 版本：
   ```bash
   flutter --version
   ```
2. 清理历史构建缓存，防止旧版本的 build 产物干扰：
   ```bash
   flutter clean
   ```

### 第二步：编辑 pubspec.yaml 并更新依赖
1. 将 `pubspec.yaml` 中的最低 `sdk` 限制修改为对应的最新 Dart SDK 版本（例如 `sdk: ^3.12.1`）。
2. 执行依赖升级：
   ```bash
   flutter pub upgrade
   ```
   *注意：如果遇到版本冲突，可以先使用 `flutter pub upgrade --major-versions --dry-run` 观察哪些库需要进行跨主版本调整，并手动写入 `pubspec.yaml` 后再次拉取。*

### 第三步：运行自动修复与代码生成
1. 尝试使用官方修复工具自动更正已知的 API 变动：
   ```bash
   dart fix --apply
   ```
2. 重新编译生成代码（Retrofit, Freezed, Riverpod 等生成的 `.g.dart` 和 `.freezed.dart` 文件）：
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### 第四步：静态分析与代码调整
1. 执行代码静态分析，查看是否有未适配的编译警告或类型错误：
   ```bash
   flutter analyze
   ```
2. 根据 analyze 输出，手动修复剩余的代码适配点（如上文提及的 `Color` 属性弃用等问题）。

### 第五步：单元测试与打包验证
1. 运行所有单元测试以确保基础功能正常：
   ```bash
   flutter test
   ```
2. 验证 Android 打包逻辑是否完备：
   ```bash
   flutter build apk --debug
   ```
   *若出现严重的 Kotlin 或 Gradle 兼容编译错误，可在 `android/gradle.properties` 中添加以下临时避让参数（不推荐长期使用）：*
   ```properties
   android.newDsl=false
   android.builtInKotlin=false
   ```
