## TODO

说明：

- 本文件只保留执行路线，不再作为“想法池”堆叠所有可能性
- README.md 只描述当前已实现能力；未来方向、设计稿和探索项统一在此管理
- 优先级评定核心原则：**优先级 = 面试可见性 × 生产技术深度**

---

## 🎯 Now (当前高优先级执行主线)

### 1. 真实项目集扩充与原生跨栈联动 (ListenExpenseTracker 数据打通)

**状态**：🚀 进行中 (In Progress)  
**现状**：当前项目列表展示了 5 个核心项目（Portfolio Flutter、Listen Core、Listen UI Kit、Backend 与技术知识库），但尚未纳入作者近期基于现代 Android 原生最新技术栈（Kotlin 2.x + Jetpack Compose + Room Local-First + Google Credential Manager + Google Drive 云端备份）打造的独立商业级记账应用 `ListenExpenseTracker`。  
**目标**：将 `ListenExpenseTracker` 完整接入到项目库中，打通本地 Mock 数据资产与云端 AWS 生产数据库。  
**为什么现在做**：这是向面试官直接证明具备 **“Flutter 跨平台 Clean 架构”** 与 **“现代 Android 原生 Jetpack Compose 架构”** 双栖技术专家水平的最有力展示。  
**技术方案与落地要点**：
- **客户端 Mock 数据**：在 `assets/mock/v1/get/projects.json`、`projects_zh.json`、`projects_ja.json` 中增补 Project ID 6，配置 5 大技术栈标签（`Kotlin`、`Jetpack Compose`、`MVI`、`Room`、`Google Drive API`），并配齐中/英/日三语本地化描述与 `project6.jpg` 图片映射。
- **服务端 Flyway 增量迁移**：在 `ListenPortfolioBackend` 中创建 `V3__Add_expense_tracker_project.sql` 迁移脚本，在应用启动时自动向生产 MySQL 执行增量插入（`INSERT IGNORE`），保证无缝迁移与幂等性。
- **跨端跳转与架构图解联动**：在 Project 详情页与项目卡片中支持点击直达 GitHub 开源仓库，并规划架构图解展示。

---

### 2. Google OAuth 2.0 / Credential Manager 联合登录与服务端 Token 交换 (Google Sign-In)

**状态**：📋 待排期 (Design Ready - 详见 [google_signin_specification.md](google_signin_specification.md))  
**现状**：当前客户端仅支持基于账号密码的传统登录与游客体验模式，缺少主流大厂标准的第三方社交联合登录闭环。  
**目标**：打通 Flutter 端 Google 授权、Spring Boot 后端 ID Token 验签与本系统双 JWT（Access / Refresh Token）签发的完整 OAuth 2.0 链路。  
**为什么现在做**：第三方登录是现代移动 App 的标配能力，更是考察开发者对 OAuth 2.0、OpenID Connect (OIDC)、公钥验签、防重放攻击与跨端 Session 绑定的必考架构题。  
**技术方案与落地要点**：
- **客户端授权流**：引入 `google_sign_in` 插件（或原生 Android `CredentialManager` 桥接），在登录页面新增 Google 品牌图标登录入口，唤起原生 Google 授权半屏浮层获取 `id_token`。
- **服务端置换接口**：在 `ListenPortfolioBackend` 新增 `POST /v1/auth/google` 端点，基于 `google-api-client` 校验 Google 签发的 JWT 签名、`aud` 客户端 ID 及有效时钟，提取用户的 Google 主键（`sub`）、电子邮箱及头像。
- **用户对齐策略**：若用户首次使用 Google 登录则自动在 `users` 表创建账号；若邮箱已存在则完成账号关联；最终返回本系统的标准 JWT，完全复用已有的 401 刷新队列与鉴权拦截器。

---

### 3. 生物识别免密解锁与 Keystore 硬件安全防护 (Biometric Authentication)

**状态**：📋 待排期 (Planned)  
**现状**：用户登录成功后，Token 存储在本地，但退出应用重新打开时若 Token 过期或重新进入，缺乏金融级 App 的生物识别快捷免密解锁。  
**目标**：基于设备硬件安全模块（Android KeyStore / iOS Keychain）集成指纹/面容生物识别认证，实现安全高效的应用级免密解锁。  
**为什么现在做**：作者具备乐天证券等金融证券级 App 架构背景，生物识别认证与硬件安全防护能够直接呼应简历背景，成为面试时的王牌谈资。  
**技术方案与落地要点**：
- **服务层抽象与解耦**：在 `ListenCore` 抽象 `IBiometricService` 接口，在宿主 App 基于 `local_auth` 落地实现，支持 `canCheckBiometrics`、`getAvailableBiometrics`（Fingerprint / Face ID）与 `authenticate`。
- **硬件密钥绑定**：开启生物识别时，将 Refresh Token 通过受保护的密钥存储在 `FlutterSecureStorage`；只有在系统 `BiometricPrompt` 校验成功后才解密提取，确保即使设备 Root 或内存 dump 也无法窃取长期凭据。
- **降级与防暴力破解**：提供输入密码降级入口；当系统检测到用户在系统设置中新增或修改了指纹时（Biometric Enrollment Change），自动使已有硬件凭证失效，强制要求重新输入密码，确保绝对安全。

---

### 4. 多语言 PDF 简历动态生成与原生分享导出 (Dynamic PDF Resume Export)

**状态**：📋 待排期 (Planned - 详见 [resume_security_auth.md](resume_security_auth.md))  
**现状**：当前应用在“关于我”模块展示了极为详实的 11 年技术经历与 6 维核心技能，但猎头、HR 或技术面试官在查看后无法一键存留或离线打印一份规范美观的 PDF 文件。  
**目标**：在端侧实现基于当前用户真实履历的高保真矢量 PDF 渲染引擎，支持中/英/日多语言动态排版并一键原生调用打印或分享。  
**为什么现在做**：极大地提升作品集的实用性与求职转化率，同时在技术上展示对复杂矢量绘图、字体嵌入、多页分页流（Pagination）及系统原生分享通道的掌控力。  
**技术方案与落地要点**：
- **矢量排版引擎**：集成 `pdf` 与 `printing` 库，设计响应式单页/双页现代工程师简历布局，包含顶部头像与基本信息、6 维能力模型、核心项目概览与履历时间线。
- **CJK 字体动态嵌入**：根据当前应用选中的语言模式（`zh` / `en` / `ja`），按需从资产加载支持汉字与假名的开源 Noto Sans CJK 矢量字体，彻底杜绝 PDF 乱码与字符方块（Tofu）问题。
- **原生系统通道集成**：在“关于我”页面顶部操作栏添加 “导出简历 (Export PDF)” 按钮，调用 `Printing.sharePdf(...)` 唤起系统原生分享面板，支持保存到手机本地、隔空投送、微信/Slack 分享或无线打印。

---

### 5. AI 智能助手 Token 消耗观测看板与智能上下文防超限 (LLM Token Observability)

**状态**：📋 待排期 (Planned - 详见 [ai_intro_assistant_spec.md](ai_intro_assistant_spec.md))  
**现状**：已基于官方 `firebase_ai`（Gemini 3.7 Flash）和 Firebase App Check 实现了高质量的 AI 对话助手，但目前缺乏商业级 LLMOps 的用量计量、Token 成本感知与上下文溢出保护。  
**目标**：建立客户端 Token 消耗实时观测机制，增加可视化用量 Badge，并实现基于 Token 预算的滑动窗口会话裁剪。  
**为什么现在做**：证明自己不仅会调用 AI API，更具备大型商业级 AI 应用的成本控制、可观测性与异常防护（LLMOps）工程素养。  
**技术方案与落地要点**：
- **Token 预计算与实时收集**：在 `FirebaseAiService` 中调用 SDK 的 `countTokens` 接口，在发送消息前对 System Prompt、历史上下文和当前输入进行 Token 预算预估；收到模型流式响应后提取 Usage Metadata。
- **可观测微胶囊看板 (Badge)**：在 `AiChatHeader` 顶部栏集成轻量微胶囊，动态显示当前会话消耗的 Token 数量、提问轮次及单次交互网络延迟（毫秒）。
- **智能上下文滑动窗口 (Sliding Window)**：当会话轮次过多导致上下文接近阈值时，自动保全首条 System Prompt 并保留最近 N 轮核心问答，自动丢弃久远对话，防止触发 API 上限并有效控制单次请求开销。

---

## ⚡ 核心架构与工程优化点 (Core Engineering & Architectural Optimizations)

### Opt-1. APM 性能诊断报告一键导出与全链路快照 (APM Diagnostic Report Export)

**状态**：📋 待排期 (Planned - 详见 [apm_performance_monitoring_design.md](apm_performance_monitoring_design.md))  
**现状**：项目当前在内存中维护了极其强大的 APM 体系（FPS 滑动窗口、Vsync 动态时钟、Jank 统计、RingBuffer 100 条网络请求审计与启动耗时退化检测），但这些数据在 App 关闭后即丢失，缺少线下/测试提单时的持久化快照导出能力。  
**优化方案**：
- 在调试浮窗 `LogOverlay` 中新增 “导出诊断报告 (Export Diagnostic Report)” 动作。
- 一键捕获当前设备环境（系统版本、屏幕刷新率、内存水位）、最近 50 次冷启动指标、最近 100 条 HTTP 抓包详情及最近出现的报错日志，打包序列化为标准化 JSON 或 Markdown 格式。
- 支持一键复制到剪贴板或通过系统分享导出，实现线上/线下 Bug 秒级现场还原。

---

### Opt-2. 网络层指数退避抖动重试与断网自愈策略 (Exponential Backoff Retry & Offline Recovery)

**状态**：📋 待排期 (Planned - 详见 [repository_caching_strategy.md](repository_caching_strategy.md))  
**现状**：当前 Dio 拦截器已具备 401 并发等待与静默刷新重试机制，但对于弱网抖动、Socket 超时、DNS 解析短暂失败等瞬态故障，接口直接进入失败回调，依赖用户手动下拉刷新。  
**优化方案**：
- 在 `ListenCore` 网络层引入 `RetryInterceptor`，针对所有具有幂等性的 GET 请求，在遭遇瞬态网络异常（SocketException、ConnectTimeout）时自动触发 Full Jitter 指数退避重试（最多重试 3 次，间隔 500ms、1000ms、2000ms 随机抖动）。
- 集成网络连通性广播监听，当设备从断网恢复连网时，通过事件总线自动通知处于 Error 态的活跃 ViewModel 静默重拉数据，实现“断网自愈”。

---

### Opt-3. 核心自绘组件 Golden UI 视觉回归测试 (Golden Widget Regression Tests)

**状态**：📋 待排期 (Planned - 详见 [testing_guide.md](testing_guide.md))  
**现状**：当前全工程已拥有 557 项单元与 Widget 测试（100% 绿灯），但主要集中于业务逻辑、状态变更与手势分发，缺少针对底层 Canvas 自绘组件（如 `SkillsRadarChart` 技能雷达图、APM `FrameChart` 帧率曲线）的像素级黄金图像比对。  
**优化方案**：
- 引入 Flutter Golden Test 测试框架，针对 6 维度技能雷达图及性能曲线图建立黄金像素基准图（Golden Files）。
- 覆盖暗黑/浅色主题、不同 DPI 分辨率、多语言文本渲染及极值数据状态下的图形渲染比对，确保后续无论 Flutter SDK 如何升级，自绘组件均能保持零像素级位移与畸变。

---

### Opt-4. CI/CD AWS 自动化 Flyway 迁移校验与健康探针强化 (CI/CD Pipeline Hardening)

**状态**：📋 待排期 (Planned - 详见 [flutter_web_aws_deployment_guide.md](flutter_web_aws_deployment_guide.md))  
**现状**：AWS EC2 后端服务已配置自动化 CI/CD 构建部署，但在服务重启后缺少自动化健康检查探针与数据库版本自检。  
**优化方案**：
- 在 `.github/workflows/ci.yml` 的部署流水线中，容器启动后增加 HTTP 健康检查探针轮询（`curl -f http://13.218.192.181:8080/actuator/health`），若 60 秒内服务未就绪自动触发回滚。
- 确认每次部署自动运行 Flyway 校验，保证生产环境数据库结构与最新的 `V3__Add_expense_tracker_project.sql` 脚本完全一致。

---

## 📅 Next (下一阶段规划)

### 1. 体验与展示扩展
- **Interview QA / Architecture FAQ 互动检索页**：把 README 和 docs 中的核心架构决策（Zone tracing、MVI Playback、Safe Mode 熔断、防双重弹窗等）沉淀为一个可在 App 内根据关键词快速检索与查看代码高亮的交互式模块。
- **布局层级检查器 (Widget Inspector)**：在 `LogOverlay` 增加一键高亮 UI 边界、检测嵌套深度与像素溢出风险的轻量可视化探针。

### 2. 跨平台能力与构建包优化
- **APK / AAB 拆包分析与包体积优化报告**：在 CI 中自动执行 `apk-analyzer`，生成 DEX 代码、静态资产及 SO 库体积分布报告，并在 README 保持可视化。
- **iOS App Store 提审与证书自动化**：基于 fastlane 配置 iOS 构建签名与 TestFlight 分发流程。

### 3. 简历深度与项目经历多维穿透
- **一页式 Performance Case Study**：以可视化时间线方式，完整展现一次乐天证券或有赞电商真实环境下的“卡顿/内存泄漏排查全链路”（从 APM 发现、Trace 定位、日志钻取到代码修复），极具技术说服力。

---

## ⏳ Later (中远期探索项)

- **FIDO2 / Passkey 免密安全登录**：基于 WebAuthn 规范，实现基于客户端安全硬件的无密码公私钥签名认证（详见 [fido2_implementation_design.md](fido2_implementation_design.md)）。
- **JNI / NDK 底层高性能计算样例**：在 Android 侧集成轻量 C++ 原生库，展示 JNI 通信与底层代码优化经验。
- **桌面小部件 (AppWidget / WidgetKit)**：在 Android / iOS 桌面提供个人作品集与状态速览（详见 [launcher_widgets.md](launcher_widgets.md)）。

---

## 🏛️ Completed Baseline (已落地核心基石 - 历史全量成就归档)

项目目前已全面实现并跑通以下 **28 项关键能力与技术基石**（全量 557 项测试 100% 绿灯，静态分析零警告）：

1. **Clean Architecture + MVI 模式**：基于 `BaseViewModel`、`BaseState`、`BaseEffect` 构建，彻底解耦 UI 与状态机。
2. **401 并发等待与静默重试队列**：Dio 拦截器捕获 Token 失效，单例排队刷新并一键批量重发请求。
3. **安全注销与 Token 防泄露**：登出前时间戳校验，过期则静默刷新后再通知服务端彻底销毁会话。
4. **全链路 Zone Tracing**：基于 Dart `Zone` 上下文为每次 Intent、路由跳转与 HTTP 请求注入全局唯一 `traceId`。
5. **Crash Safe Mode 熔断自愈**：连续崩溃检测与安全模式拦截，支持本地 crash log 持久化与一键重置。
6. **APM 性能监控看板 (LogOverlay)**：动态 Vsync 帧时延监测、FPS 滑动窗口滤波、Jank 分类、十字准星探针与 Net Inspector。
7. **启动耗时监控 (Launch Monitor)**：冷启动分段时延统计，50 条 FIFO 本地基线与回归预警。
8. **故障注入演练场 (Fault Injection Playground)**：7 大受控演练场景（401并发、500契约、超时、畸形数据、Zone异常、SafeMode、主线程Jank），支持一键 Trace 下钻。
9. **交互式技能雷达图 (Skills Radar Chart)**：`CustomPainter` 自绘 6 维多边形、防截断钳位算法，卡片左右滑动与雷达图双向手势联动。
10. **多语言自动路由 (LocalMockServer & Spring Boot)**：请求头注入 `Accept-Language`，支持中/英/日多语言动态下发与自动回退，零硬编码。
11. **动态主题与外观字体族**：跨平台 5 大通用字体族矩阵，`SettingManager` 全局热重构，内置实时 `Aa` 字体徽标预览。
12. **强类型路由与 Deep Link 整合**：原生 Scheme 匹配、`replaceIfExists` 路由去重与 Single UI Binder 防双弹窗机制。
13. **Google Play 延迟深度链接 (Deferred Deep Link)**：基于 `InstallReferrerClient` 原生通道，支持 90 天时钟去重、脏数据清洗与落地页 `test.html` 验证。
14. **Firebase AI 智能咨询助手**：官方 `firebase_ai` (`gemini-3.7-flash`) + Firebase App Check 强安全防护，可拖拽悬浮球与本地预设 FAQ 检索。
15. **Firebase 推送通知 (FCM)**：前台横幅、后台唤醒与冷启动路由统一调度，通知开关联动系统权限引导。
16. **应用内评分引导 (ReviewService)**：启动计数（5次）与 90 天控流策略，支持打赏成功后黄金时机拉起评价。
17. **应用内打赏购买 (IAP)**：Clean MVI 架构、`CoffeePurchaseProviderImpl` 解耦支付业务。
18. **Shorebird OTA 热更新**：集成官方代码热修复服务，支持增量补丁非阻塞下载与版本拼接展示。
19. **商用级 `CommonWebView`**：支持弹窗自适应高度、手势重定向拦截与暗黑/浅色自适应主题。
20. **Google Play 合规性数据注销页**：提供合规的在线账户数据注销表单与邮件唤起通道。
21. **Spring Boot 后端核心微服务**：Auth + Portfolio CRUD + 6 维 Skills 多语言 API 全量落地，MyBatis-Plus + Redis 缓存架构。
22. **AWS EC2 容器化部署**：Docker Compose + Nginx 80 端口同源反代，彻底消除浏览器跨域与 OPTIONS 预检。
23. **错误契约统一体系**：`Failure` 领域模型与 `messageId` 前后端契约规范，客户端自动映射 i18n 多语言文案。
24. **自动化版本流与检查更新**：CI 提取 `pubspec.yaml` 自动生成 `version.json`，客户端免签安全解析与更新日志弹窗。
25. **架构依赖边界治理**：基于 `tools/dependency_rules.dart` 自动化校验架构单向依赖规则，零违规保障。
26. **自动化 API 文档生成**：配置 `dartdoc` 并通过脚本部署至 GitHub Pages。
27. **全自动化 CI/CD 流水线**：GitHub Actions 自动执行分析、运行 557 项测试、构建签名 Release AAB 并发布至 Google Play Internal 通道。
28. **全量测试套件保障**：**557 项** 自动化测试 100% 绿灯通过，代码覆盖率达 **71.57%**。

---

## 💡 Idea Pool Backup (想法池备份)

- 探索 `talker_flutter`、`storybook_flutter`、`pubviz` 等生态工具在开发期调试中的深度结合。
- 自动化执行 Patrol E2E 测试时，每步 Intent 操作自动截取屏幕并导出归档。
- 布局层级过深检测与过度绘制警告探针。