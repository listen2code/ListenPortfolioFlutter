
# 终极执行计划：6 个月路线图

## 你的核心定位

> **10年+ Android / Flutter 移动技术专家，具备架构设计、性能优化、SDK 抽象能力，正在向「移动 + 后端 + 云」全栈方向扩展。**

## 时间预算

- 工作日：~3.5h × 5 = 17.5h/周
- 周末：~8h × 1.5 = 12h/周
- **总计：~30h/周 × 26周 ≈ 780h**

## 核心原则

1. **面试官 3 分钟法则**：打开 GitHub → 看到截图/GIF → 点进 README → 看到架构图 → 扫代码 → 确认你很强。**任何一个环节断裂，面试官就关了。**
2. **代码和文档 1:1 对应**：不说没实现的，实现了的必须说。
3. **优先级 = 面试可见性 × 技术深度**

---

## Phase 1（第 1-4 周）— 🎯 让项目"能看"

**目标：面试官打开 GitHub 3 分钟内产生好印象**

| 优先级 | 任务 | 预估时间 | 说明 |
|--------|------|----------|------|
| P0 | **截图 / GIF 录制** | 4h | Overview、Login、Settings、LogOverlay、CrashLogs、Architecture 页面。放到 README 顶部。**没有截图的 Portfolio = 不存在** |
| P0 | ~~**Mock 数据真实化**~~ | 3h | ✅ 已完成。`aboutMe.json`（及中/日多语言）、`projects.json`、`user.json` 替换为真实 11 年履历数据，6 维核心技能与真实评分落地 |
| P0 | **README 精简优化** | 4h | 当前 692 行太长。顶部加截图 → 一句话定位 → 技术亮点（5 条）→ 架构图 → Quick Start → 详细说明折叠 |
| P1 | ~~**CI 加 flutter test**~~ | 2h | ✅ 已在 CI 工作流中集成测试步骤，全绿跑通 557 项测试用例，包含覆盖率分析 |
| P1 | ~~**Release APK 签名**~~ | 3h | ✅ 已在 CI 流程中配置 keystore 解密，成功实现 Release 签名构建 |

**Phase 1 交付物：**
- GitHub 首页有截图、有 CI badge（analyze ✅ test ✅ build ✅）
- Mock 数据展示的是你自己的真实经历
- 任何人 clone 后能 `flutter run` 跑起来

---

## Phase 2（第 5-10 周）— 🔗 前后端打通

**目标：证明你不只是写 UI，你能搭建完整的前后端系统**

| 优先级 | 任务 | 预估时间 | 说明 |
|--------|------|----------|------|
| P0 | ~~**Spring Boot 后端核心 API 完善**~~ | 30h | ✅ 已完成。Auth + Portfolio CRUD + 6 维 Skills 多语言 API 全量落地，MyBatis-Plus ORM 架构与 Flyway 数据库迁移完全对齐 |
| P0 | ~~**Flutter 对接真实 API**~~ | 15h | ✅ 已完成。dev/prod 环境配置指向 Spring Boot 服务器，支持动态网络环境切换与 SWR 本地缓存 |
| P0 | ~~**部署后端到 AWS**~~ | 10h | ✅ 已完成。通过 GitHub Actions CI/CD 自动构建并部署至 AWS EC2（`http://13.218.192.181`），Docker Compose 自动化清库重建与运行 |
| P1 | ~~**错误码体系落地**~~ | 10h | ✅ 已完成。实现 `Failure` 变体与 `messageId` 错误码体系，让文档和代码完全对齐，后端返回标准错误码，Flutter 端映射到 i18n |
| P1 | ~~**隐私政策页面**~~ | 3h | ✅ 已完成。基于 `CommonWebView` 加载自适应暗黑/浅色主题隐私政策与服务条款，托管至 GitHub Pages |

**Phase 2 交付物：**
- Flutter app 在 dev/prod 环境下调用真实后端 API
- 后端部署在 AWS，有真实 URL 并具备自动化 CI/CD 部署流
- 错误码体系前后端对齐，文档和代码一致
- 隐私政策页面上线

---

## Phase 3（第 11-16 周）— 🚀 Google Play + 面试亮点功能

**目标：Google Play 可下载 + 2-3 个面试谈资功能**

| 优先级 | 任务 | 预估时间 | 说明 |
|--------|------|----------|------|
| P0 | **Google Play 正式发布** | 8h | Internal Testing → Closed Testing → Open Testing。签名、版本号、应用截图、描述。你已经有内部测试经验，升级不难 |
| P0 | ~~**Skills 图表**~~ | 15h | ✅ 已完成。CustomPainter 绘制 6 维度技能雷达图，防截断边缘自适应算法，支持「雷达图/清单」双模式，且卡片支持左右滑动手势（PageView）与上方按钮/雷达图双向无缝联动同步 |
| P1 | **Google OAuth 登录** | 12h | 第三方登录 + 账号绑定。展示 OAuth 流程理解 + 安全策略 |
| P1 | **PDF 简历导出** | 8h | Markdown 渲染 + PDF 生成下载。实用功能 + 技术深度 |
| P2 | **指纹/生物识别登录** | 6h | `local_auth` 集成，结合 token 安全策略 |

**Phase 3 交付物：**
- Google Play 可搜索下载
- 2-3 个有技术深度的特色功能
- 面试时可以说："你可以在 Google Play 搜索下载我的 app"

---

## Phase 4（第 17-22 周）— 📈 质量拉满 + 面试准备

**目标：测试覆盖率、文档、架构深度达到面试自信水平**

| 优先级 | 任务 | 预估时间 | 说明 |
|--------|------|----------|------|
| P0 | ~~**测试覆盖率 → 60%+**~~ | 20h | ✅ 已完成。全量 557 项单元/Widget/集成测试 100% 绿灯全覆盖（ViewModels、Repositories、UseCases、Widgets、E2E 集成测试） |
| P0 | ~~**ADR 文档**~~ | 8h | ✅ 已完成。已沉淀 `event_bus_vs_base_effect.md`、`repository_caching_strategy.md`、`deep_link_routing_design.md`、`skills_radar_chart_design.md` 等架构决策文档 |
| P1 | ~~**Architecture Mermaid 图**~~ | 4h | ✅ 已完成。在 README 和 docs 中包含完整模块依赖图与 MVI 数据流架构图 |
| P1 | ~~**Firebase Push 推送通知**~~ | 12h | ✅ 已完成（todo.md Now §6）。接入 FCM/APNs，并结合 EventBus 实现 Deep Linking 唤醒与路由跳转 |
| P1 | **listen_core / listen_uikit 版本升级** | 8h | 完善 pub.dev 包，补充 README、example、changelog |
| P2 | ~~**Net Inspector 面板**~~ | 12h | ✅ 已完成。请求列表、耗时、payload 展示。DevTools 级别的功能，面试谈资 |
| P2 | ~~**Integration Tests**~~ | 10h | ✅ 已完成。端到端测试，mock 环境下跑通主流程 |

**Phase 4 交付物：**
- 测试覆盖率 60%+ 且 CI 可见
- 3-5 篇 ADR 文档展示架构思考深度
- listen_core / listen_uikit 在 pub.dev 有完整文档

---

## Phase 5（第 23-26 周）— 🎤 求职冲刺

**目标：简历、GitHub、Google Play 三位一体准备完毕**

| 任务 | 预估时间 | 说明 |
|------|----------|------|
| **简历更新** | 4h | 加入 Portfolio 项目经验：「独立设计并实现 Flutter + Spring Boot 全栈项目，发布到 Google Play」|
| **技术博客 / 文章** | 10h | 写 2-3 篇技术文章（Zone tracing 实践、Flutter MVI 架构、依赖治理方案），发布到 Qiita/Medium |
| **面试话术准备** | 6h | 针对每个技术点准备 STAR 格式回答 |
| **模拟面试** | 4h | 对着项目讲 10 分钟，练习到流畅 |

---

## 时间分配总览

| Phase | 周数 | 核心交付 | 面试价值 |
|-------|------|----------|----------|
| **Phase 1** | 1-4 | 项目可看 | ⭐⭐⭐⭐⭐ |
| **Phase 2** | 5-10 | 前后端打通 | ⭐⭐⭐⭐⭐ |
| **Phase 3** | 11-16 | Google Play + 亮点功能 | ⭐⭐⭐⭐ |
| **Phase 4** | 17-22 | 质量拉满 | ⭐⭐⭐ |
| **Phase 5** | 23-26 | 求职冲刺 | ⭐⭐⭐⭐ |

---

## 给你的三条铁律

1. **Phase 1 是生死线** — 没有截图和真实数据的 Portfolio 项目，面试官不会往下看。先花 2 周把「门面」做好。
2. **Spring Boot 后端是你最大的差异化** — 日本市场 Flutter 开发者多，但能同时拿出前后端的少。Phase 2 必须完成。
3. **每完成一个 Phase 就可以开始投简历** — 不要等到完美。Phase 2 完成后你已经有一个有截图、有真实 API、有 CI、有测试的 Flutter + Spring Boot 全栈项目，足够面试了。