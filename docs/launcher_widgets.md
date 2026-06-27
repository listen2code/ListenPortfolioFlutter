# 桌面小部件实现方案文档

## 目标概述
为 **ListenPortfolioFlutter** 在 **Android** 与 **iOS** 平台实现三种桌面小部件功能：
1. **个人简介卡** – 展示头像、姓名、简短自我介绍，点击进入 App 的个人资料页面。
2. **项目列表预览** – 显示最近 3 条项目的标题与缩略图，点击即可跳转到对应项目详情页。
3. **快速入口按钮** – 四个图标按钮（作品集、博客、联系、设置），点击后通过深度链接直接打开对应功能页面。

所有小部件的视觉风格、配色、字体均与现有 App 主题保持同步，内容在用户配置后为 **静态**（不需要周期性刷新），但支持 **深度链接** 跳转到 App 中的特定页面。

---

## 需要确认的事项
| 项目 | 说明 | 待确认选项 |
|------|------|------------|
| **小部件尺寸** | 1×1、2×2、4×2 三种尺寸均已准备。用户可在设置页选择想要添加的尺寸。 | 需要哪些尺寸（全部或子集）？ |
| **展示顺序** | 在配置页面中，用户可勾选 1‑2 项组合，并自行排列顺序。 | 是否允许自行排列或固定顺序？ |
| **深度链接路径** | 约定的路由：<br>• 个人简介 → `/profile` <br>• 项目详情 → `/project/:id` <br>• 作品集入口 → `/projects` <br>• 博客入口 → `/blog` <br>• 联系 → `/contact` <br>• 设置 → `/settings` | 如有其他自定义页面，请补充路由。 |
| **图标资源** | 使用现有项目图标（已在 `assets/icons/`），若需新增请提供 SVG/PNG。 | 是否需要新增图标？ |
| **主题同步** | 小部件读取 App 的暗/亮模式标识 (`isDarkMode`) 并使用相同 `ColorScheme`。 | 是否使用当前主题或自定义配色？ |

---

## 待决问题
1. 是否提供 1×1 小部件仅用于快速入口按钮，或全部三种均支持？
2. 配置页面是否需要 “预览” 功能（实时展示小部件在不同尺寸下的样式）？
3. iOS 是否同时提供 `systemSmall` 与 `systemMedium` 两种 family，还是仅 `systemMedium`（容纳更多内容）？

---

## 方案设计
### 1️⃣ Flutter 层
| 文件 | 位置 | 功能 |
|------|------|------|
| `pubspec.yaml` | 项目根目录 | 新增 `home_widget: ^0.4.0` 依赖（已使用） |
| `lib/shared/models/widget_payload.dart` | `shared/models/` | 数据模型：`type`（profile / projectList / quickLaunch）<br>`data`（JSON，包含头像 URL、项目列表、按钮配置）<br>`targetRoute`（深度链接） |
| `lib/shared/constants/widget_keys.dart` | `shared/constants/` | 键名：`kWidgetPayload`、`kWidgetThemeMode` |
| `lib/features/widget/presentation/widget_manager.dart` | `features/widget/presentation/` | 封装 `HomeWidget.saveWidgetData`、`HomeWidget.updateWidget`，提供 `saveProfileCard()`、`saveProjectList()`、`saveQuickLaunch()` 方法 |
| `lib/features/widget/presentation/widget_configuration_page.dart` | `features/widget/presentation/` | Settings → “桌面小部件”入口页面：<br>① 勾选模块（CheckboxListTile）<br>② 选择尺寸（Dropdown）<br>③ 配置深度链接（使用默认路由）<br>④ “保存并更新” 按钮调用 `WidgetManager` 并触发 `HomeWidget.updateWidget` |
| `lib/features/setting/presentation/setting_page.dart` | `features/setting/presentation/` | 在 Settings 页面底部新增 ListTile → `Widget Configuration`，点击跳转至上述配置页面 |

### 2️⃣ Android 实现
| 文件 | 位置 | 关键实现 |
|------|------|----------|
| `android/app/src/main/kotlin/com/listen/portfolio/PortfolioWidgetProvider.kt` | `android/app/src/main/kotlin/com/listen/portfolio/` | 继承 `AppWidgetProvider`，在 `onUpdate` 中读取 `SharedPreferences`（键 `kWidgetPayload`），解析 JSON，使用 `RemoteViews` 填充对应布局 |
| `android/app/src/main/res/xml/portfolio_widget_info.xml` | `android/app/src/main/res/xml/` | 定义三种尺寸（`minWidth`/`minHeight`），`android:updatePeriodMillis="0"`（不自动刷新） |
| `android/app/src/main/res/layout/widget_profile_card.xml` | `android/app/src/main/res/layout/` | 头像、姓名、简介 TextView，使用 `android:background` 与 App 主题颜色 |
| `android/app/src/main/res/layout/widget_project_list.xml` | 同上 | 3 行 `LinearLayout`，每行展示项目缩略图 + 标题，点击时触发 `PendingIntent`（深度链接） |
| `android/app/src/main/res/layout/widget_quick_launch.xml` | 同上 | 4 个 `ImageButton`，分别绑定对应 `PendingIntent`（如 `myapp://projects`） |
| `android/app/src/main/java/com/listen/portfolio/DeepLinkUtil.kt` | 新建 | 辅助生成 `Intent`，打开 `MainActivity` 并通过 `Navigator` 跳转到目标路由 |

### 3️⃣ iOS 实现
| 文件 | 位置 | 关键实现 |
|------|------|----------|
| `ios/Runner/WidgetExtension/Info.plist` | `ios/Runner/WidgetExtension/` | 声明 `CFBundleDisplayName`、`NSExtension` → `Widget`，支持 `.systemSmall`（快速入口） 与 `.systemMedium`（个人简介 + 项目列表） |
| `ios/Runner/WidgetExtension/PortfolioWidget.swift` | 同上 | SwiftUI `Widget`，`TimelineProvider` 从 `UserDefaults(suiteName:)` 读取 `kWidgetPayload`，根据 `type` 生成相应视图 |
| `ios/Runner/WidgetExtension/WidgetEntryView.swift` | 同上 | 包含三种子视图：`ProfileCardView`、`ProjectListView`、`QuickLaunchView`。使用 `@Environment(\.colorScheme)` 与 App 主题保持一致 |
| `ios/Runner/WidgetExtension/WidgetKeys.swift` | 同上 | 常量定义 `kWidgetPayload`、`kWidgetThemeMode` |
| `ios/Runner/WidgetExtension/DeepLinkHandler.swift` | 同上 | 通过 `Link` 或 `widgetURL` 将点击事件传回宿主 App（`myapp://...`），在 `AppDelegate` 中拦截并使用 `Navigator` 打开对应页面 |

### 4️⃣ 数据交互流程
1. 用户在 **Settings → 小部件配置** 页面勾选模块并保存。
2. `WidgetManager` 将 `WidgetPayload` 序列化为 JSON，调用 `HomeWidget.saveWidgetData(key: kWidgetPayload, value: json)` 并 `HomeWidget.updateWidget(name: "listen_portfolio_widget")`。
3. **Android**：`AppWidgetProvider` 读取 `SharedPreferences` 中的 JSON，解析后更新对应 `RemoteViews`。
4. **iOS**：`TimelineProvider` 读取 `UserDefaults` 中的 JSON，生成对应 SwiftUI 视图。
5. 用户点击小部件时，分别触发 **深度链接**（`myapp://profile`、`myapp://project/123`、`myapp://projects` 等），宿主 App 在 `onGenerateRoute` 中解析并跳转。

---

## 验证计划
### 自动化测试
- `WidgetManagerTest`：验证 `save*` 方法的 JSON 序列化、Key 写入、`HomeWidget.updateWidget` 调用。
- `WidgetConfigurationPageTest`：UI 测试：勾选/取消、切换尺寸、保存后 UI 状态保持。
- `DeepLinkHandlerTest`（iOS）：确认 `myapp://` URL 被正确解析并路由到目标页面。

### 手动验证
| 步骤 | 期望结果 |
|------|----------|
| **Android**：长按主屏 → 小部件 → 选择 “ListenPortfolio” → 看到配置的模块（个人简介卡、项目列表、快速入口） | UI 与 App 主题一致，点击任意元素打开对应页面。 |
| **iOS**：编辑主屏 → 添加小部件 → 选择配置好的尺寸 → 预览并确认内容 | 同上，深度链接能够打开对应页面。 |
| **配置修改**：在 Settings → 小部件配置 页面修改内容 → 保存 → 小部件立即更新 | 更新后小部件显示最新配置，且不需要系统刷新周期。 |
| **主题切换**：切换 App 暗/亮模式 → 小部件随之变更颜色 | 小部件背景/文字颜色与 App 同步。 |

---

## 后续步骤
1. **确认**：请提供以下信息以完成最终实现：
    - 需要的尺寸组合（如全部或仅 2×2/4×2）。
    - 是否允许用户自行排列模块顺序。
    - 任何额外的深度链接路由或自定义图标。
    - 是否使用默认主题同步或自定义配色。
2. **批准**：确认该文档后，我将开始创建对应的代码文件、平台原生实现以及配置页面。

---

> **文档说明**：本方案已充分考虑 UI 统一、深度链接、主题同步以及无需周期性刷新的需求。随时欢迎您提出修改或补充意见。
