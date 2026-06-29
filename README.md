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
- **多语言切换**：中 / 英 / 日运行时切换，无需重启
- **主题切换**：浅色 / 深色 / 跟随系统 + 强调色 / 字号持久化 + **Material You 动态取色** (Android 12+ 平台下支持跟随系统壁纸色调自动变色)

### 架构与基础设施

- **MVI 基础骨架**：`BaseViewModel`、`BaseState`、`BaseEffect`、`BaseLifecyclePage`
- **网络层**：`ApiClient` + `BaseRepository.safeCall()` + `Either<Failure, T>`
- **版本更新自动流**：基于 `pubspec.yaml` 的描述在 CI 构建时自动提取多语言描述生成并托管 `version.json`；App 端在所有环境下均通过 Retrofit 免签拉取静态配置文件并在 repository 层手工解码（规避 GitHub 静态资源的 Content-Type 匹配与认证 Token 冲突问题）
- **401 自动刷新**：刷新期间并发请求排队，刷新成功后自动重试
- **环境切换**：支持 `mock / dev / test / prod`
- **本地 MockServer**：`APP_ENV=mock` 时提供本地 JSON / 图片资源
- **Zone tracing**：Intent / 页面 / 请求链路支持 `traceId` 和阶段打点
- **Crash Safe Mode**：快速崩溃保护与本地 crash log 持久化
- **日志浮窗**：当前项目内置开发调试窗口，可分类查看 App / Server / Perf 日志

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
- **路由参数类型安全不足**：当前路由参数仍以动态对象和 Map 为主
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
- `docs/performance_panel_spec.md`：性能面板规格说明（未完全落地）
- `docs/ai_intro_assistant_spec.md`：AI 助手规格说明（规划中）
- `docs/listencore_audit.md`：`listen_core` 架构审计报告
- `docs/push_notification_specification.md`：推送通知设计与集成规格
- `docs/fido2_implementation_design.md`：FIDO2 / Passkey 免密认证设计方案
- `docs/intent_effect_playback_spec.md`：Intent & Effect 录制与回放设计方案
- `docs/todo.md`：后续执行路线图

## 🎯 目标态（明确未全部实现）

以下内容是我希望后续逐步完成的方向，不代表已经全部落地：

- 统一错误码与 `messageId` 错误契约
- 类型安全路由参数与深链路支持
- `LogOverlay / PerformancePanel / NetInspector` 独立调试模块化
- 更完整的测试覆盖与 Golden / Integration tests
- PDF 简历导出、技能图表、AI 助手等展示能力

## 🧾 待删除备份区

以下表述因“目标态与现状混写”风险已从主文降级，先保留在此，后续继续清理：

- `NavigationEffect`、`ShareEffect` 不再作为 `listen_core` 已内建能力在主文强调
- `BaseScaffoldPage` 不再描述为“已内置完整 loading / empty / error / effect 页面框架”
- `BaseMaterialApp` 不再承担“全局错误处理中心”的主叙事；当前全局崩溃主入口仍是 `main.dart -> Core.run()`
- 调试能力（日志浮窗、性能面板、网络抓包）后续统一按“独立调试模块”思路整理

---

