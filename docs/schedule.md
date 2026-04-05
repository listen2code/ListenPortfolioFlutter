
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
| P0 | **Mock 数据真实化** | 3h | [aboutMe.json](cci:7://file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/assets/mock/v1/get/aboutMe.json:0:0-0:0) 替换为真实履历（公司可脱敏）；[projects.json](cci:7://file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/assets/mock/v1/get/projects.json:0:0-0:0) 后端技术栈改为 Spring Boot；[user.json](cci:7://file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/assets/mock/v1/get/user.json:0:0-0:0) 补 `messageId` |
| P0 | **README 精简优化** | 4h | 当前 692 行太长。顶部加截图 → 一句话定位 → 技术亮点（5 条）→ 架构图 → Quick Start → 详细说明折叠 |
| P1 | **CI 加 flutter test** | 2h | 当前 CI 缺少测试步骤，31 个测试文件是你的优势，必须跑起来并显示 badge |
| P1 | **Release APK 签名** | 3h | 配置 keystore + CI release 构建，为 Google Play 正式发布做准备 |

**Phase 1 交付物：**
- GitHub 首页有截图、有 CI badge（analyze ✅ test ✅ build ✅）
- Mock 数据展示的是你自己的真实经历
- 任何人 clone 后能 `flutter run` 跑起来

---

## Phase 2（第 5-10 周）— 🔗 前后端打通

**目标：证明你不只是写 UI，你能搭建完整的前后端系统**

| 优先级 | 任务 | 预估时间 | 说明 |
|--------|------|----------|------|
| P0 | **Spring Boot 后端核心 API 完善** | 30h | Auth（login/signup/refresh/logout）+ Portfolio CRUD（aboutMe/projects/user）。确保与 Flutter mock 数据格式一致 |
| P0 | **Flutter 对接真实 API** | 15h | dev/prod 环境配置指向 Spring Boot 服务器。你已经有完善的环境切换机制，这一步应该很顺 |
| P0 | **部署后端到 AWS** | 10h | EC2 或 Elastic Beanstalk，最小化部署。配合你 advice2026.md 中的 AWS 方向 |
| P1 | **错误码体系落地** | 10h | 实现 [error-codes-reference.md](cci:7://file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/docs/error-codes-reference.md:0:0-0:0) 中设计的错误码。让文档和代码完全对齐。后端返回标准错误码，Flutter 端映射到 i18n |
| P1 | **隐私政策页面** | 3h | 写一个简单的隐私政策，托管到 GitHub Pages。Google Play 审核必需 |

**Phase 2 交付物：**
- Flutter app 在 dev 环境下调用真实后端 API
- 后端部署在 AWS，有真实 URL
- 错误码体系前后端对齐，文档和代码一致
- 隐私政策页面上线

---

## Phase 3（第 11-16 周）— 🚀 Google Play + 面试亮点功能

**目标：Google Play 可下载 + 2-3 个面试谈资功能**

| 优先级 | 任务 | 预估时间 | 说明 |
|--------|------|----------|------|
| P0 | **Google Play 正式发布** | 8h | Internal Testing → Closed Testing → Open Testing。签名、版本号、应用截图、描述。你已经有内部测试经验，升级不难 |
| P0 | **Skills 图表** | 15h | CustomPainter 绘制技能雷达图/图谱。这是面试中展示 **Canvas/自定义绘制能力** 的最佳切入点 |
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
| P0 | **测试覆盖率 → 60%+** | 20h | 补充 ViewModel、Repository、UseCase 单测。你已有 31 个测试文件，扩展覆盖率 |
| P0 | **ADR 文档** | 8h | 记录 3-5 个关键架构决策（Zone tracing、SafeMode、MockServer、依赖治理、MVI 选型）。面试时的谈资 |
| P1 | **Architecture Mermaid 图** | 4h | 模块依赖图、数据流图、网络请求链路图。放到 README 和 docs 中 |
| P1 | **listen_core / listen_uikit 版本升级** | 8h | 完善 pub.dev 包，补充 README、example、changelog |
| P2 | **Net Inspector 面板** | 12h | 请求列表、耗时、payload 展示。DevTools 级别的功能，面试谈资 |
| P2 | **Integration Tests** | 10h | 端到端测试，mock 环境下跑通主流程 |

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