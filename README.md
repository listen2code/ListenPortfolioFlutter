# ListenPortfolioFlutter

ListenPortfolioFlutter 是一个基于 Flutter 构建的个人技术作品集应用，同时也是我用来沉淀 Flutter 应用架构、可观测性能力与工程边界的实验田。

当前文档遵循两条规则：

- **主文只描述已落地能力，或明确标注的目标态**
- **设计细节、未来方案、长规格说明统一下沉到 `docs/`**

## 项目定位

- **真实 App 优先**：先保证它是一个能长期维护、能持续迭代的应用
- **框架沉淀其次**：从项目中抽取可复用能力到 `listen_core` / `listen_uikit`
- **观测与稳定性优先于炫技功能**：优先打磨 tracing、crash、日志、错误收敛与联调路径
- **功能展示最后**：README 用于快速讲清定位、边界、现状与演进路线，而不是堆叠炫技点

## 模块边界

| 模块 | 职责 | 当前边界判断 |
|------|------|--------------|
| `listen_core` | 业务无关、可复用的基础设施 | MVI 基类、网络、错误、日志、崩溃保护、Zone tracing、存储等 |
| `listen_uikit` | 业务无关的 UI 组件库 | Button、Dialog、Loading、Empty、Input 等通用组件 |
| `shared/` | 当前 App 的装配层与项目级共通逻辑 | `SettingManager`、`Routes`、`AuthManager`、导航/分享 effect、App 初始化 |
| `features/` | 业务功能模块 | auth / home / settings 等实际页面与用例 |

## 当前已实现

### 应用能力

- **认证流程**：登录、注册、忘记密码、修改密码、账号注销、游客模式
- **作品集展示**：Overview、AboutMe（右上角支持分享当前应用）、Projects、Architecture 页面
- **设置中心**：主题、语言、环境切换、缓存清理、崩溃日志入口、检查更新（显示多语言日志并引导至下载或应用商店）、分享当前应用
- **推送通知**：基于 FCM 的推送通知接入，支持前台横幅、后台唤醒、冷启动深度跳转；Settings 中可开关通知并联动系统权限引导
- **多语言切换**：中 / 英 / 日运行时切换，无需重启；**数据库动态内容国际化**（支持拦截器注入 `Accept-Language` 请求头，由 Backend / `LocalMockServer` 直发目标语言 JSON 数据，前端移除 UI 模型上的过渡性 `.tr` 映射）
- **主题切换**：浅色 / 深色 / 跟随系统 + 强调色 / 字号持久化 + **Material You 动态取色** (Android 12+ 平台下支持跟随系统壁纸色调自动变色)
- **AI 架构与技术介绍助手**：基于官方 Firebase AI SDK (`FirebaseAI.googleAI`) + Google Gemini `gemini-3.7-flash` 模型打造的智能技术咨询助手；集成 Firebase App Check 强安全防护；全局可拖拽悬浮球 + 独立 `AiChatPage` 页面；支持多模式（访客/招聘官/架构师）切换、页面上下文/Tab 智能感知及本地预设 FAQ 零延迟零 Token 问答
- **故障注入与韧性演练中心 (Fault Injection Playground)**：用于直观验证与展示高可用架构的受控演练平台；内置 **7 大受控演练场景**（401 并发静默重试队列、500 异常契约收敛、网络超时降级、畸形 HTML 网关防崩保护、Zone 异步异常落盘、Safe Mode 连续崩溃熔断自愈、主线程 Jank 卡顿 APM 检测）；配备毫秒级实时终端控制台、`traceId` 一键复制与下钻联动 `LogOverlay` 浮窗调试闭环

### 架构与基础设施

- **MVI 基础骨架**：`BaseViewModel`、`BaseState`、`BaseEffect`、`BaseLifecyclePage`
- **网络层**：`ApiClient` + `BaseRepository.safeCall()` + `Either<Failure, T>`
- **安全注销与 Token 防泄露**：登出前进行 JWT 载荷时间戳校验，已过期则触发静默刷新后再通知服务端注销会话，确保后端 Session 彻底销毁与客户端本地状态无缝抹除
- **版本更新自动流**：基于 `pubspec.yaml` 的描述在 CI 构建时自动提取多语言描述生成并托管 `version.json`；App 端在所有环境下均通过 Retrofit 免签拉取静态配置文件并在 repository 层手工解码（规避 GitHub 静态资源的 Content-Type 匹配与认证 Token 冲突问题）
- **401 自动刷新与并发重试队列**：Token 失效期间并发发起的请求自动挂起排队，触发 1 次静默刷新后自动批量重发
- **环境切换**：支持 `mock / dev / test / prod`
- **本地 MockServer**：`APP_ENV=mock` 时提供本地 JSON / 图片资源，支持 `Accept-Language` 多语言资产路径自动路由与回退机制
- **Zone tracing**：Intent / 页面 / 请求链路支持 `traceId` 和阶段打点
- **Crash Safe Mode**：快速连续崩溃防护、自动熔断自愈与本地 crash log 持久化
- **日志浮窗与 APM 性能监控**：内置开发调试窗口（LogOverlay），支持实时帧率/Jank 监测、Net Inspector 抓包、按 `traceId` 过滤全链路日志
- **零告警工程质量与全量测试套件**：**491 项** 单元与集成测试用例 100% 绿灯通过，内置 MVI Playback 反射自检，代码通过静态分析（`No issues found!`）与架构依赖边界检查（`dependency_rules.dart`）双重零违规验证

### 更能代表当前项目取向的能力

- **可观测性优先**：`Zone tracing` 为页面、Intent、请求提供统一 `traceId` 与阶段打点；crash log 会先本地持久化，再交给业务层决定恢复策略。
- **支撑型后端联动**：Flutter App 不只停留在纯 mock 展示，而是围绕认证、错误契约、联调环境与监控入口逐步完成真实前后端闭环。
- **离线优先开发流**：`mock` 环境与 `LocalMockServer` 保证前后端未完全联通时，页面、状态与交互仍可继续稳定推进。
- **边界持续收敛**：日志浮窗等调试能力当前保留在 App `shared/` 层，而不是提前包装成 `listen_core` 的既有能力。

### 代码组织

```text
lib/
├── features/                  # 业务模块
├── shared/                    # App 装配层与共通逻辑
├── main.dart                  # 应用入口，使用 Core.run() 包裹
└── ...
```

## 🏗️ 关键架构判断

### MVI 与分层

- **表现层**：页面 + Intent + ViewModel + State
- **领域层**：UseCase + Repository 接口
- **数据层**：RemoteDataSource / RepositoryImpl / Model

这套结构的目标不是“教科书分层”，而是：

- 页面状态可预测
- 错误处理统一
- ViewModel 易测
- 数据源可替换

### 网络错误处理

- `BaseRepository.safeCall()` 负责把接口调用结果统一收敛为 `Either<Failure, T>`
- `ApiClient` 内部通过多层拦截器处理 traceId、认证、日志和错误映射
- `AuthInterceptor` 负责 401 刷新与重试队列

### 环境与离线开发

- `mock` 环境下由 `LocalMockServer` 提供本地 API 资源
- 便于前后端未联通时继续开发页面、状态与交互

## ⚠️ 当前限制与已知差距

- **文档与实现刚开始收口**：部分历史文档会比代码更理想化，正在逐步收敛

- **调试能力尚未模块化**：日志浮窗仍属于当前 App 的 `shared`，目标态会拆到独立调试模块
- **`listen_core` 边界仍在收紧**：部分适合 App 装配层的能力，历史上放置位置并不完全理想

## 🚀 快速开始

```bash
# 环境要求：Flutter 3.44.1+，Dart 3.12.1+
flutter pub get

# 生成代码
dart run build_runner build --delete-conflicting-outputs

# 启动 mock 环境（无需后端）
flutter run --dart-define=APP_ENV=mock
```

```bash
# 运行测试
flutter test
```

```bash
# 依赖边界检查
dart tools/dependency_rules.dart

# 可视化依赖图
dart tools/dependency_rules.dart --graph
```

## 🔧 环境说明

| 环境 | 说明 |
|------|------|
| `mock` | 使用本地 `LocalMockServer`，适合离线开发与稳定演示 |
| `dev` | 对接本地/测试后端，用于前后端联调 |
| `test` | 预留给集成测试或 QA 环境 |
| `prod` | 生产环境配置 |

## 📚 文档索引

- `docs/project_development_guide.md`：项目开发指南
- `docs/testing_guide.md`：测试策略与执行说明
- `docs/error_codes_reference.md`：错误码设计参考（当前仍以设计为主）
- `docs/performance_panel_spec.md`：性能面板原始设计方案（已实现，最新请参考 `apm_performance_monitoring_design.md`）
- `docs/apm_performance_monitoring_design.md`：APM 性能监控面板设计与实现文档
- `docs/fault_injection_playground_spec.md`：故障注入与韧性演练中心设计与实现文档（已实现）
- `docs/ai_intro_assistant_spec.md`：AI 助手规格说明与架构设计（已实现）
- `docs/listencore_audit.md`：`listen_core` 架构审计报告
- `docs/event_bus_vs_base_effect.md`：EventBus 与 BaseEffect 架构通信设计规范
- `docs/repository_caching_strategy.md`：BaseRepository 二级缓存与数据降级规范
- `docs/project_philosophy.md`：项目选型与质量取向说明（为什么优先做观测与稳定性）
- `docs/push_notification_specification.md`：推送通知设计与集成规格
- `docs/fido2_implementation_design.md`：FIDO2 / Passkey 免密认证设计方案
- `docs/intent_effect_playback_spec.md`：Intent & Effect 录制与回放设计方案
- `docs/shorebird_code_push_guide.md`：Shorebird OTA Code Push 热更新集成与使用指南
- `docs/todo.md`：后续执行路线图

## 🎯 目标态（明确未全部实现）

以下内容是我希望后续逐步完成的方向，不代表已经全部落地：

- `LogOverlay / PerformancePanel / NetInspector` 独立调试模块化
- Golden Tests 补齐
- PDF 简历导出、技能图表等展示能力拓展

## 🧾 待删除备份区

以下表述因“目标态与现状混写”风险已从主文降级，先保留在此，后续继续清理：

- `NavigationEffect`、`ShareEffect` 不再作为 `listen_core` 已内建能力在主文强调
- `BaseScaffoldPage` 不再描述为“已内置完整 loading / empty / error / effect 页面框架”
- `BaseMaterialApp` 不再承担“全局错误处理中心”的主叙事；当前全局崩溃主入口仍是 `main.dart -> Core.run()`
- 调试能力（日志浮窗、性能面板、网络抓包）后续统一按“独立调试模块”思路整理

---

