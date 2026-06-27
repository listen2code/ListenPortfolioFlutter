# 桌面小部件实现方案文档

## 目标概述
为 **ListenPortfolioFlutter** 在 **Android** 与 **iOS** 平台实现以下三种桌面小部件功能：
1. **个人简介卡** – 展示头像、姓名、简短自我介绍，点击进入 App 的个人资料页面。
2. **项目列表预览** – 显示最近 3 条项目的标题与缩略图，点击即可跳转到对应项目详情页。
3. **快速入口按钮** – 四个图标按钮（作品集、博客、联系、设置），点击后通过深度链接直接打开对应功能页面。

所有小部件的视觉风格、配色、字体均与现有 App 主题保持同步，内容在用户配置后为 **静态**（不需要周期性刷新），但支持 **深度链接** 跳转到 App 中的特定页面。

---

## 已确认的设计决策
根据用户确认，本方案将采用以下设计：

- **平台支持**：同时支持 **Android** 和 **iOS**。
- **小部件尺寸**：支持全部预设尺寸（1×1、2×2、4×2）。
- **展示顺序**：在配置页面中，允许用户自行勾选并**自定义排列模块的展示顺序**。
- **配置页预览**：配置页面**需要支持“实时预览”**功能，能够实时展示小部件在不同尺寸下的样式。
- **iOS 尺寸支持**：iOS 仅提供 **`systemMedium`** 尺寸（容纳更多内容，更美观）。
- **主题同步**：小部件完全使用 App 的当前主题和配色（支持暗黑/浅色模式自适应）。
- **深度链接路由**：
    - 个人简介 → `/profile`
    - 项目详情 → `/project/:id`
    - 作品集入口 → `/projects`
    - 博客入口 → `/blog`
    - 联系 → `/contact`
    - 设置 → `/settings`

---

## 方案设计

### 1️⃣ Flutter 层
| 文件 | 位置 | 功能 |
|------|------|------|
| `pubspec.yaml` | 项目根目录 | 新增 `home_widget: ^0.4.0` 依赖（已使用） |
| `lib/shared/models/widget_payload.dart` | `shared/models/` | 数据模型：`type`（profile / projectList / quickLaunch）<br>`data`（JSON，包含头像 URL、项目列表、按钮配置）<br>`targetRoute`（深度链接） |
| `lib/shared/constants/widget_keys.dart` | `shared/constants/` | 键名：`kWidgetPayload`、`kWidgetThemeMode` |
| `lib/features/widget/presentation/widget_manager.dart` | `features/widget/presentation/` | 封装 `HomeWidget` 调用，提供更新数据与刷新通知的核心方法。 |
| `lib/features/widget/presentation/widget_configuration_page.dart` | `features/widget/presentation/` | Settings → “桌面小部件”入口页面：支持勾选、自定义排序（拖拽/上下移）、实时预览小部件 UI，并点击“保存并更新”触发刷新。 |
| `lib/features/setting/presentation/setting_page.dart` | `features/setting/presentation/` | 在 Settings 页面底部新增 ListTile → `Widget Configuration`，点击跳转至上述配置页面。 |

### 2️⃣ Android 原生实现
| 文件 | 位置 | 关键实现 |
|------|------|----------|
| `android/app/src/main/kotlin/com/listen/portfolio/PortfolioWidgetProvider.kt` | `android/app/src/main/kotlin/com/listen/portfolio/` | 继承 `AppWidgetProvider`，在 `onUpdate` 中读取 `SharedPreferences`，解析 JSON 并使用 `RemoteViews` 渲染 UI |
| `android/app/src/main/res/xml/portfolio_widget_info.xml` | `android/app/src/main/res/xml/` | 定义小部件大小，设置 `updatePeriodMillis="0"` 避免无谓刷新。 |
| `android/app/src/main/res/layout/widget_profile_card.xml` | `android/app/src/main/res/layout/` | 头像、姓名、简介布局，自适应系统暗黑/浅色主题。 |
| `android/app/src/main/res/layout/widget_project_list.xml` | 同上 | 展示 3 条项目列表，每个 Item 绑定指向不同路由的 PendingIntent。 |
| `android/app/src/main/res/layout/widget_quick_launch.xml` | 同上 | 4 个图标按钮，对应 4 个不同页面的深度链接。 |

### 3️⃣ iOS 原生实现
| 文件 | 位置 | 关键实现 |
|------|------|----------|
| `ios/Runner/WidgetExtension/Info.plist` | `ios/Runner/WidgetExtension/` | 配置 WidgetExtension，声明支持 `systemMedium`。 |
| `ios/Runner/WidgetExtension/PortfolioWidget.swift` | 同上 | SwiftUI Widget 入口，通过 App Group 共享的 `UserDefaults` 读取数据并生成 Timeline。 |
| `ios/Runner/WidgetExtension/WidgetEntryView.swift` | 同上 | 使用 SwiftUI 编写，包含 `ProfileCardView`、`ProjectListView` 和 `QuickLaunchView`。利用 `@Environment(\.colorScheme)` 实现暗黑模式同步。 |

### 4️⃣ 数据交互与深度链接流程
1. 用户在 App 内配置小部件，点击保存。
2. Flutter 序列化配置并通过 `home_widget` 写入两端共享存储区，随后触发系统刷新。
3. 原生小部件启动，从共享存储中解析 JSON 数据渲染 native 界面。
4. 用户点击小部件上的按钮，原生层发送 `myapp://profile` 等 Schema 请求，宿主 App 捕获路由并导航到目标页面。

---

## 验证计划
- **自动化测试**：对配置数据的 JSON 序列化、路由解析进行单元测试。
- **手动验证**：
    1. 在 Android 和 iOS 主屏幕添加小部件，验证视觉风格与主题模式（暗黑/浅色）是否与 App 同步。
    2. 点击小部件上的各个按钮，验证是否能够准确打开 App 并拉起对应的深层路由（如项目详情页、个人 profile 页）。
    3. 在 App 设置里调整展示顺序和勾选项，验证桌面小部件是否立即更新。

---

## 后续步骤
1. 批准此方案后，将正式启动该功能的编码开发。
