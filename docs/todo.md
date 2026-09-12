## TODO

说明：

- 本文件只保留执行路线，不再作为“想法池”堆叠所有可能性
- README.md 只描述当前已实现能力；未来方向、设计稿和探索项统一在此管理
- 优先级评定核心原则：**优先级 = 面试可见性 × 生产技术深度**

---

## 🎯 Now (当前高优先级执行主线)

### 1. 真实项目集扩充与原生跨栈联动 (ListenExpenseTracker 数据打通)

**状态**：✅ 已完成 (Completed)  
**现状**：已成功将作者基于现代 Android 原生最新技术栈（Kotlin 2.x + Jetpack Compose + Room Local-First + Google Credential Manager + Google Drive 云端备份）打造的独立商业级记账应用 `ListenExpenseTracker` 完整接入。  
**目标**：将 `ListenExpenseTracker` 完整接入到项目库中，打通本地 Mock 数据资产与云端 AWS 生产数据库。  
**完成情况**：
- [x] **客户端 Mock 数据**：在 `assets/mock/v1/get/projects.json`、`projects_zh.json`、`projects_ja.json` 中增补 Project ID 6，配置 5 大技术栈标签（`Kotlin`、`Jetpack Compose`、`MVI`、`Room`、`Google Drive API`），并配齐中/英/日三语本地化描述与 `project6.jpg` 图片映射。
- [x] **服务端 Flyway 增量迁移**：在 `ListenPortfolioBackend` 中创建 `V3__Add_expense_tracker_project.sql` 迁移脚本，自动向生产 MySQL 执行增量插入（`INSERT IGNORE`），保证无缝迁移与幂等性。
- [x] **跨端跳转与架构图解联动**：在 Project 详情页与项目卡片中支持点击直达 GitHub 开源仓库。

---

### 2. Google OAuth 2.0 / Credential Manager 联合登录与服务端 Token 交换 (Google Sign-In)

**状态**：📋 待排期 (Design Ready - 详见 [google_signin_specification.md](google_signin_specification.md))  
**现状**：当前客户端已抽象完成 W3C OIDC 领域模型（`GoogleAuthCredential`、`GoogleSignInResult`）与服务层业务契约抽象（`GoogleSignInService`），并在数据层落地了高保真内存沙箱与 JWT 签名模拟实现（`MockGoogleSignInServiceImpl`，7/7 项单测全绿通过）。但尚未封装原生平台 `google_sign_in` 插件与 Android `androidx.credentials` (Credential Manager) / iOS GIDSignIn 物理桥接，后端 Spring Boot 尚未接入 Google 验签依赖。  
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

### 5. AI 智能助手工程化体验与 LLMOps 观测性进阶 (AI Assistant Observability & UX Hardening)

**状态**：📋 待排期 (Planned - 详见 [ai_intro_assistant_spec.md](ai_intro_assistant_spec.md))  
**现状**：已基于官方 `firebase_ai`（Gemini 3.7 Flash）和 Firebase App Check 实现了高质量的 AI 对话助手，但在 Markdown 代码渲染、流式中断、Token 用量计量及上下文溢出防护方面仍有工程提升空间。  
**目标**：建立完整的客户端 Markdown 富文本渲染体系与实时中断控制，结合 Token 消耗实时观测微胶囊与滑动窗口裁剪机制。  
**为什么现在做**：大模型接入不仅仅是 API 的调用，代码高亮阅读体验、实时中断生成以及生产级 Token 成本控制与上下文管理，是检验高级架构师具备商业级 AI（LLMOps）落地素养的关键标准。  
**技术方案与落地要点**：
- **Markdown 富文本与代码语法高亮**：在 `AiChatMessageBubble` 中引入 `flutter_markdown`，对模型输出的 Markdown 标题、列表、加粗以及包含语言标识的代码块（Dart / Kotlin / Java 等）进行语法高亮与圆角卡片渲染，并支持代码块一键复制到剪贴板。
- **流式生成实时中断 (Stream Cancellation)**：在流式输出中将底部发送图标动态转变为“停止 (Stop)”按钮；在 ViewModel 内部维护 `StreamSubscription`，支持点击瞬间调用 `subscription.cancel()` 中断流式接收并保留已有输出。
- **Token 预计算与实时观测微胶囊 (Badge)**：在 `FirebaseAiService` 中调用 SDK 的 `countTokens` 接口，发送前预估消耗，响应结束收集 Usage Metadata；在 `AiChatHeader` 顶部动态呈现消耗 Token 数、提问轮次与网络延迟（毫秒）。
- **智能上下文滑动窗口 (Sliding Window)**：当对话轮次增加导致历史消息接近上限时，自动锚定第一条核心 System Prompt，并动态截取最近 6~8 轮核心问答，丢弃陈旧轮次，防止单次 Token 膨胀并避免触碰 API 窗口上限。

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
**现状**：当前全工程已拥有 589 项单元与 Widget 测试（100% 绿灯），但主要集中于业务逻辑、状态变更与手势分发，缺少针对底层 Canvas 自绘组件（如 `SkillsRadarChart` 技能雷达图、APM `FrameChart` 帧率曲线）的像素级黄金图像比对。  
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

### Opt-5. AI 助手会话历史本地持久化与失败消息一键重发 (AI Session Persistence & Tap-to-Retry)

**状态**：📋 待排期 (Planned - 详见 [ai_intro_assistant_spec.md](ai_intro_assistant_spec.md))  
**现状**：当前对话消息仅在内存 `AiChatState` 中驻留，应用进程退出后会话即清空；同时当网络超时或 API 异常导致消息标记 `isFailed: true` 后，用户必须在输入框重新手动键入才能重发。  
**优化方案**：
- 基于 `SpUtil` / 本地 SQLite 实现 `AiChatHistoryDataSource`，对最近 50 条消息及时间戳进行异步序列化持久化，支持热启动/冷启动后平滑恢复对话上下文。
- 在 `AiChatMessageBubble` 的失败提示区增设“点击重试”微交互，用户轻触即触发 `AiChatIntent.sendMessage(failedMessage.content)` 重新发起调用。

---

### Opt-6. AI 本地 0-Token 问答端侧轻量语义向量泛化匹配 (On-Device Semantic Vector Matcher)

**状态**：📋 待排期 (Planned - 详见 [ai_intro_assistant_spec.md](ai_intro_assistant_spec.md))  
**现状**：当前 Tier 1 本地问答拦截依赖硬编码的高频词表与关键词密度（`>= 50%`），对换用同义词、口语化变体或长句型提问的容错度有限，容易过早降级至云端 LLM。  
**优化方案**：
- 引入轻量级 TF-IDF 算法或基于 ONNX / TFLite 的微型嵌入模型（Mobile Embedding），在应用启动时离线生成本地预设 QA 的向量索引。
- 用户提问时计算余弦相似度（Cosine Similarity），若最高相似度高于 0.78 则在端侧毫秒级命中本地答案，实现 0-Token 拦截率与泛化召回率的大幅跃升。

---

### Opt-7. 动态字体排版多语言字形回退自适应与演练场 (Locale-Adaptive Typography & Playground)

**状态**：📋 待排期 (Planned - 详见 [appearance_font_family_specification.md](appearance_font_family_specification.md))  
**现状**：当前 `fontFamilyFallback` 顺序固定，中日韩共享 Unicode 编码的汉字未随 `SettingManager.language` 动态重排优先字形；外观设置页仅有 'Aa' 徽标，缺少长文本段落的实时预览；不同字形垂直度量差异可能引起极少数紧凑容器偏位。  
**优化方案**：
- 在 `AppTheme` 中感知当前 `settingManager.language`，若语言为日文（`ja`），动态将 `Hiragino Sans` / `Yu Gothic` 重排至首位，杜绝中日 Kanji 汉字笔顺混淆。
- 在 `AppearancePage` 顶部增设包含中/英/日多语言混排、数字与代码块的 “排版演练场 (Typography Playground)” 实时预览卡片。
- 在 `AppTheme` 中统一引入 `StrutStyle(forceStrutHeight: true)` 与 `TextHeightBehavior`，彻底抹平多字形基线高度差异。

---

### Opt-8. 无障碍可变字体字重与极简环境云端字体补全 (Variable Fonts & On-Demand Font Loader)

**状态**：📋 待排期 (Planned - 详见 [appearance_font_family_specification.md](appearance_font_family_specification.md))  
**现状**：当前仅有标准 (1.0x) 与大字 (1.3x) 两个档位，缺少细粒度字重（Font Weight）调节；在极度精简的 AOSP 或嵌入式系统上若缺失楷体/手写体将直接回退为系统常规无衬线体。  
**优化方案**：
- 引入无障碍字重调节滑块与 Variable Font（可变字体轴 `FontVariation`）微调体系，辅助视障群体增强文本对比度与清晰度。
- 针对特征字体建立缺失探针，当检测到设备底层未命中任何回退候选时，支持通过轻量后台微任务从 CDN 异步按需拉取开源字型子集并通过 `FontLoader` 动态注入。

---

### Opt-9. S3 / Cloudflare R2 对象存储直传与端侧高质量图像下采样 (S3/R2 Direct Upload & Client-Side Image Compression)

**状态**：📋 待排期 (Planned - 详见 [avatar_security_and_rendering_architecture.md](avatar_security_and_rendering_architecture.md))  
**现状**：当前头像直接以 Base64 格式（最大 2MB 二进制 / ~2.7MB 文本）随业务请求发送至应用服务器并持久化于 MySQL 的 `users.avatar_url` 字段中。这会显著增加 API JSON Payload 体积，并在高并发查询用户详情或列表时造成数据库 I/O 吞吐压力与网络带宽冗余。  
**优化方案**：
- **对象存储直传架构**：客户端发起上传前，先请求后端获取 AWS S3 或 Cloudflare R2 的短期预签名上传 URL（Presigned PUT URL），客户端直接向对象存储分片并发推送二进制字节流，上传完成后仅将轻量的 CDN 静态链接（如 `https://cdn.example.com/avatars/user_123.webp`）提交给后端入库。
- **端侧高质量图像下采样与格式转换**：在选择或裁剪头像后，基于 `flutter_image_compress` 在原生后台线程将图片统一等比下采样至最大 $512 \times 512$ 分辨率，并转换为现代高压缩率的 WebP 格式（质量 85%），将上传体积从 2MB 压制至 30~80KB，大幅缩短移动端上传等待耗时与流量消耗。

---

### Opt-10. BlurHash 渐进式占位图与动图帧数/尺寸配额控制 (BlurHash Progressive Placeholder & Animated Image Frame/Dimension Quota)

**状态**：📋 待排期 (Planned - 详见 [avatar_security_and_rendering_architecture.md](avatar_security_and_rendering_architecture.md))  
**现状**：当前在弱网或冷启动未命中本地图片缓存时，UI 渲染层使用通用的静态纯色占位图标，缺少现代工业级 App 具备的渐进式视觉平滑过渡；同时虽然服务端已对 GIF/WebP 进行魔数校验，但对于包含成百上千帧的高消耗恶启动态 GIF / 动效 WebP 仍缺乏细粒度的帧数与动画尺寸配额拦截。  
**优化方案**：
- **BlurHash 极速紧凑占位编码**：服务端或上传端在处理头像时，生成约 20~30 字符的极简 BlurHash 字符串随用户信息一同下发；`CommonImage` 优先利用 `flutter_blurhash` 即刻绘制高保真模糊渐变占位背景，在高清图片异步加载就绪后通过 250ms 交叉淡入动画（Fade-in Transition）替换，消除视觉突兀跳动。
- **动图资源配额与解压缩防护**：在 `UserService` 中基于 Apache Commons Imaging 或轻量流式解析器，对 GIF 与动效 WebP 实施深度元数据探针校验，限制动图帧数不得超过 60 帧、单帧时延不得低于 20ms、非压缩像素总容量（Width × Height × Frames × 4）不得超过 64MB，严防恶意构造的“图片解压炸弹 (Decompression Bomb)”耗尽客户端 GPU/内存。

---

### Opt-11. 循环依赖有向图深度检测算法与 CI/CD 架构红线门禁 (Tarjan's SCC Cycle Detection & CI Architectural Gatekeeper)

**状态**：📋 待排期 (Planned - 详见 [custom_lint_rules.md](custom_lint_rules.md))  
**现状**：当前 `_CircularDependencyLint` 在 `custom_lint` 中仅作为占位声明（由于 IDE 增量分析器只能逐文件或局部模块编译，无法跨全工程构建完整导入拓扑）；而 `tools/dependency_rules.dart` 虽具备独立的正则层级扫描，但尚未整合基于 Tarjan 强连通分量（SCC）或深度优先搜索（DFS）的拓扑环检测算法，且未在 GitHub Actions CI 流水线中设为必阻断门禁。  
**优化方案**：
- **全局有向依赖图与 Tarjan 环检测**：在 `tools/dependency_rules.dart` 中建立全工程文件的有向依赖图（Directed Dependency Graph），运用 Tarjan 强连通分量算法或 DFS 回溯链，毫秒级定位所有形式的闭环循环依赖（A $\rightarrow$ B $\rightarrow$ C $\rightarrow$ A），输出精准的成环链路路径。
- **CI/CD 架构红线刚性拦截**：在 `.github/workflows/ci.yml` 的 PR 校验流水线中添加 `dart run tools/dependency_rules.dart` 步骤；一旦检测到跨 Feature 非法耦合、Core 向上逆向依赖或循环依赖，CI 立即红牌阻断合并，捍卫 Clean Architecture 单向依赖架构边界。

---

### Opt-12. 静态分析 Quick-Fix 语法重写扩充与规则白名单分级治理 (AST Quick-Fix Expansion & Lint Rules Tiering)

**状态**：📋 待排期 (Planned - 详见 [custom_lint_rules.md](custom_lint_rules.md))  
**现状**：当前 18 项自定义 Lint 规则中，仅 8 项基础 UI 控件具备 `DartFix` 自动修复（`--fix`）能力，对于 `view_model_context_isolation`（BuildContext 隔离）、`no_direct_state_assignment`（强制 updateState）等较复杂的架构规则尚缺乏 AST 代码重写器；同时 `no_raw_color` 等规则在本地运行 `custom_lint` 时对内部调试面板（`perf_dashboard_tab.dart`）产生较多告警，缺少分级与精细化白名单策略。  
**优化方案**：
- **高级架构规则 Quick-Fix 自动化重写**：针对 `no_direct_state_assignment`，实现将 `state = state.copyWith(...)` 自动转换为 `updateState(state.copyWith(...))` 的 AST 重写引擎；针对 `no_direct_app_nav_usage`，提供一键生成 `NavigationEffect` 并替换为 `emitEffect(...)` 的快捷修复。
- **规则严重级别分级 (Severity Tiering) 与配置化白名单**：将 18 项规则划分为 `ERROR`（架构边界、循环依赖、DI 隔离）、`WARNING`（ViewModel 纯度、硬编码字符串）与 `INFO`（设计系统控件对齐、颜色规范）；在 `dependency_lint_rules.yaml` 中支持按目录、文件 Glob 表达式灵活配置规则白名单，实现工程治理的灵活松紧度控制。

---

### Opt-13. Universal Links / App Links 自动化域校验与防伪造加固 (Universal Links & App Links Verification Automation)

**状态**：📋 待排期 (Planned - 详见 [deep_link_routing_design.md](deep_link_routing_design.md))  
**现状**：当前深链接主要基于自定义 URI Scheme（如 `listenportfolio://`、`listen://`、`myapp://`）。虽然在冷启动与热启动下已通过 `app_links` 与底座 `EventBus`（sticky: true）解决了初始化时序竞争，但自定义 Scheme 协议在 Android/iOS 系统中未经验证，容易被第三方恶意应用在清单中声明同名 `<intent-filter>` 实施 Scheme 劫持（Hijacking）；而官方推荐的 Android App Links 与 iOS Universal Links 尚未配置 CI/CD 自动化签名指纹校验与域名双向绑定。  
**优化方案**：
- **App Links / Universal Links 双向安全绑定**：在 GitHub Pages / 生产服务器托管标准 `.well-known/assetlinks.json`（配置生产发布 Keystore 的 SHA-256 证书指纹）与 `apple-app-site-association`，将深链接收敛至标准的 HTTPS 权威域名（如 `https://portfolio.listen.dev/settings`）。
- **CI/CD 发布指纹一致性自动化门禁**：在 GitHub Actions 流水线中增设指纹校验步骤，自动提取 Release Keystore SHA-256 并与云端 `.well-known/assetlinks.json` 自动化比对，防止因签名证书轮换导致全网深链接唤起失效。
- **Web 端平滑降级 (Web Fallback)**：当目标设备未安装客户端时，HTTPS 链接无缝在浏览器端渲染 Flutter Web 作品集或引导至应用商店，消除自定义 Scheme 在未安装时直接提示“网页无法打开”的割裂体验。

---

### Opt-14. 深链接查询参数 Schema 校验器与异常降级路由兜底门禁 (Deep Link Query Schema Validator & Fallback Boundary Guard)

**状态**：📋 待排期 (Planned - 详见 [deep_link_routing_design.md](deep_link_routing_design.md))  
**现状**：当前 `AppNav.to` 在解析 URI 查询参数时直接将键值对提取为 `Map<String, dynamic>`，由业务层的 `ArgumentConverter` 尝试反序列化（例如 `SettingsArguments.fromMap`）。如果外部传入畸形数据（如无效的 Enum 值、格式错误的数字、未编码的特殊字符、或未知未注册的路由路径），虽然 `_buildPageRoute` 返回 null 拦截了跳转，但在控制台仅打印日志，缺乏针对用户的优雅降级引导与告警收集。  
**优化方案**：
- **URI Schema 契约校验中间件**：在 `ListenCore` 路由底座中抽象 `RouteSchemaValidator`，支持为每个路由注册必需参数、类型约束与白名单规则。在解析阶段对外部输入进行前置断言与安全净化（Sanitization）。
- **404 / 异常深链接优雅降级落地页**：当遇到未注册路由或参数解析严重畸变时，不再静默吞掉，而是自动降级跳转至通用的 `NotFoundPage` 404 兜底页，并展示当前链接信息与“返回首页”快捷引导。
- **APM 异常深链接监控告警**：将解析失败、非法协议或鉴权被拒的深链接事件注入 APM 诊断与错误上报管道，实时监控外部推广渠道或落地页是否存在配置失效。

---

### Opt-15. iOS 剪贴板归因合规感知与 App Clip 延迟深度链接体系 (iOS Deferred Deep Link Compliance & App Clip Attribution)

**状态**：📋 待排期 (Planned - 详见 [deferred_deep_link_specification.md](deferred_deep_link_specification.md))  
**现状**：当前 `IInstallReferrerService` 仅依托 Android 原生 `InstallReferrerClient` 实现渠道归因，而在 iOS 与 Web 平台直接返回空数据 (`kIsWeb || !Platform.isAndroid`)。在 iOS 生态中，Apple 官方未提供类似 Google Play 的免隐私授权 Install Referrer 接口，若采用静默读取系统剪贴板（UIPasteboard）方案，自 iOS 14 起会强制弹出系统级隐私窃取提示横幅，损伤用户信任与产品合规性。  
**优化方案**：
- **用户意图驱动的显式剪贴板感知 (Explicit Clipboard Attribution)**：在 Web 推广落地页 `test.html` 提供「一键复制专属推荐码并跳转 App Store」的引导微交互；App 首次冷启动时，不进行无感静默窃取，而是仅在用户从外部首装进入时提供透明提示（如「检测到您可能携带有好友邀请码，是否粘贴匹配？」）或通过 `UIPasteControl` 原生合规控件引导用户显式轻触授权。
- **轻量 App Clip 跨进程数据桥接**：为应用构建微型轻 App（App Clip，包体积 $< 15$MB），用户在未安装 App 时点击 Universal Link 直接秒级拉起 App Clip，待完整版 App 安装完成后，通过 App Group 共享容器（`NSUserDefaults(suiteName: ...)`）实现渠道参数与直达路由的无缝无感接力。

---

### Opt-16. Google Play 服务端时间戳防篡改与 CTIT 反作弊点击注入校验 (Server-Side Install Referrer Anti-Fraud & CTIT Validation)

**状态**：📋 待排期 (Planned - 详见 [deferred_deep_link_specification.md](deferred_deep_link_specification.md))  
**现状**：当前应用获取到的 `clickTimestampSeconds` 与 `installTimestampSeconds` 仅在移动端进行初步解析，且在本地或调试环境下可通过 ADB 命令行模拟广播（`com.android.vending.INSTALL_REFERRER`）伪造来源。对于商业化运营与真实推广场景，缺乏服务端二次签名校验与黑灰产反作弊拦截（例如点击注入 Click Injection、虚假刷量）。  
**优化方案**：
- **服务端签名凭据二次校验 (Google Play Voided Purchases / Verification API)**：将原生底层获取到的 `referrerClickTimestampServerSeconds` 与 `installBeginTimestampServerSeconds`（Google Play 服务端校准时间戳）随首次激活注册上报至 Spring Boot 后端，通过 Google API 鉴权服务反查该设备安装来源的真实性。
- **点击转化耗时 (CTIT) 异常阈值拦截**：建立科学的反作弊漏斗模型，计算 Click-to-Install Time（点击至安装耗时）：
  - 若 $\text{CTIT} < 5$ 秒：判定为恶意“点击注入 (Click Injection)”刷量行为，自动标记为作弊流量并降级为自然流量；
  - 若 $\text{CTIT} > 90$ 天：判定为过期长尾无效点击，静默过滤；
- **全链路归因报表与留存看板**：在后端数据库建立 `install_referrals` 归因表，将有效 `refer`、`utm_source`、`utm_campaign` 沉淀入库，在管理看板中生成不同营销渠道的次留、七留与转化 ROI 漏斗图谱。

---

### Opt-17. Uuid 纯 Dart RFC 4122 零依赖自研生成器与 `pubspec.yaml` 瘦身 (Pure Dart RFC 4122 UUID v4 Generator & Deprecate `uuid` package)

**状态**：📋 待排期 (Planned - 详见 [dependency_refactoring_plan.md](dependency_refactoring_plan.md))  
**现状**：当前 `ListenCore` 与 `ListenPortfolioFlutter` 均在 `pubspec.yaml` 中依赖了第三方的 `uuid` 包（版本 `^4.5.3`）。然而经全代码库审计，全工程中仅在 4 处调用了 `const Uuid().v4()`（分别位于 `NetworkInspectorInterceptor` 的 `requestId` 生成、`ZoneManager` 的分布式链路 `traceId` 生成、以及 `FaultInjectionViewModel` 和 `AiChatViewModel` 的临时消息 ID 生成），完全未用到 `uuid` 库所引入的 v1（时间戳/MAC）、v3/v5（MD5/SHA-1 命名空间散列）及复杂底层加密算法，形成了典型的“杀鸡用牛刀”与过度依赖。  
**优化方案**：
- **纯 Dart RFC 4122 v4 算法实现**：在 `ListenCore/lib/utils/` 下自研 `UuidUtil` 工具类，基于 Dart 内置的 `dart:math` 提供的 `Random.secure()` 加密级伪随机数生成器产生 16 字节（128-bit）随机序列。
- **位运算规范与查表性能优化**：严格按照 RFC 4122 规范设置版本位（`bytes[6] = (bytes[6] & 0x0F) | 0x40` 声明 Version 4）与变体位（`bytes[8] = (bytes[8] & 0x3F) | 0x80` 声明 Variant 10xx）；利用 16 进制常量查找表与固定 36 字符 ASCII `Uint8List` 直接组装字符串，避免频繁字符串切片与对象分配，单次生成开销低于微秒级。
- **依赖彻底移除**：从 `ListenCore` 与 `ListenPortfolioFlutter` 的 `pubspec.yaml` 中彻底移除 `uuid: ^4.5.3`，将依赖直接归零，缩减包体积与 transitive 依赖树。

---

### Opt-18. VisibilityDetector 基于 RenderBox 与 Scrollable 的轻量视口相交自研检测器 (Lightweight Viewport Intersection Detector & Deprecate `visibility_detector`)

**状态**：📋 待排期 (Planned - 详见 [dependency_refactoring_plan.md](dependency_refactoring_plan.md))  
**现状**：当前全工程仅在 `ListenCore/lib/base/base_lifecycle_page.dart` 中使用 `visibility_detector` 插件，且仅由可选开关 `widget.useVisibilityDetector` 控制用于判定页面是否曝光（`visibleFraction > 0` $\rightarrow$ `onViewVisible()` / `onViewInVisible()`）。由于 `visibility_detector` 在内部启动了全局定时器轮询（默认 500ms debounce），不仅增加了单元测试时的额外配置心智负担（必须在每个测试文件的 `setUpAll` 中注入 `VisibilityDetectorController.instance.updateInterval = Duration.zero;`），而且对滚动帧率和内存占用存在无谓开销。  
**优化方案**：
- **自研 `ViewportVisibilityDetector` 组件**：基于 Flutter 官方渲染树几何计算机制，在当前组件的外层包裹 `NotificationListener<ScrollNotification>`（监听父级滚动）以及监听路由可见性。
- **`RenderBox` 绝对坐标投影与视口矩形求交**：在绘制帧回调 `addPostFrameCallback` 或滚动通知中，通过 `context.findRenderObject() as RenderBox` 获取目标组件在屏幕中的绝对坐标 `localToGlobal(Offset.zero)`；通过 `Scrollable.of(context)` 获取滚动容器的可视视口 `Rect`（或默认屏幕尺寸 `MediaQuery.of(context).size`）；使用 `widgetRect.intersect(viewportRect)` 计算相交区域面积，求得精确的 `visibleFraction`。
- **防抖合并与测试零负担**：仅在组件首次挂载、路由切换以及滚动停顿时计算可见比例，杜绝每 500ms 定时器轮询；移除所有测试中对 `VisibilityDetectorController` 的 Hack 配置，从两个工程的 `pubspec.yaml` 中彻底删除 `visibility_detector` 依赖。

---

### Opt-19. Flutter Web 平台 LocalMockServer 纯内存 Dio 拦截器适配 (In-Memory Dio Mock Adapter for Flutter Web)

**状态**：📋 待排期 (Planned - 详见 [development_workflow.md](development_workflow.md))  
**现状**：当前 `LocalMockServer` 强依赖 `dart:io` 的底层网络套接字 API（`HttpServer.bind(InternetAddress.loopbackIPv4, 9999)`）。在 Android、iOS 移动端以及桌面端，这一机制运行良好且能够完整覆盖 Socket 网络传输链路；但在 Flutter Web 平台编译时（`kIsWeb == true`），由于浏览器沙箱环境禁止使用 `dart:io` 套接字监听，导致在 Web 端启动 `APP_ENV=mock` 会抛出平台不支持异常，迫使 Web 开发与预览时必须依赖远端真实的 `dev` 或 `prod` 服务器。  
**优化方案**：
- **Web 端 Mock 适配器分流**：在 `ListenCore` 抽象 `IMockServerAdapter` 接口，保留移动端 `HttpServerMockAdapter` 的同时，针对 Web 平台实现 `WebInMemoryMockInterceptor`。
- **Dio 适配器级请求拦截**：在 Web 运行时，不绑定物理 Socket 端口，而是将 Mock 路由逻辑直接挂载为 Dio 的 `HttpClientAdapter` 或专用 `MockInterceptor`；从 Flutter Web 的 `rootBundle.loadString` 异步提取本地 `assets/mock/` 资源，并伪造标准 HTTP 200 `ResponseBody`。
- **全平台一致的开发体验**：实现 Flutter Web 在无需任何后端微服务或 Docker 容器的情况下，仅凭浏览器即可独立完成包含多语言、图片加载与用户状态模拟的完整作品集体验。

---

### Opt-20. 跨平台开发工作流 CLI (Dart 统一工具链) 与 Git Pre-Commit / Pre-Push 质量门禁自动挂载 (Cross-Platform Dev Workflow CLI & Automated Git Hooks)

**状态**：📋 待排期 (Planned - 详见 [development_workflow.md](development_workflow.md))  
**现状**：当前项目的核心打包脚本 `buildModule.sh` 基于 Bash Shell 编写，在 Linux、macOS 以及带有 Git Bash 的 Windows 环境下运行顺畅，但在纯 Windows PowerShell 或 CMD 环境下缺乏跨平台的一致性支持；同时，本地开发者在执行 `git commit` 或 `git push` 时，缺少自动触发的静态分析与架构规则门禁拦截，若遗漏执行 `flutter analyze` 或 `tools/dependency_rules.dart`，会导致错误代码被推送到 GitHub 触发 CI 失败，延长反馈回路。  
**优化方案**：
- **纯 Dart 跨平台工作流 CLI (`tools/workflow.dart`)**：基于 Dart 纯标准库实现统一的 CLI 工具链，支持在 macOS / Linux / Windows (PowerShell/CMD) 下以统一指令执行：
  `dart run tools/workflow.dart build --target=bundle --env=prod`，无缝替代 Bash 脚本。
- **Git Hooks 自动化安装器**：在 `tools/` 提供 `setup_hooks.dart`，一键向本地 `.git/hooks/pre-commit` 与 `pre-push` 注入自动化检查：
  - `pre-commit`：自动运行 `dart format --output=none --set-exit-if-changed .` 与 `flutter analyze`；
  - `pre-push`：自动执行 `dart run tools/dependency_rules.dart` 架构边界检测与核心单元测试，阻断违规代码推向远端，建立第一道防御纵深。

---

### Opt-21. GitHub Actions CI/CD 自动化 API 文档生成与 GitHub Pages 持续交付 (Automated DartDoc CI/CD & GitHub Pages Delivery)

**状态**：📋 待排期 (Planned - 详见 [documentation_generation.md](documentation_generation.md))  
**现状**：当前 API 文档生成依赖开发者在本地手动运行 `scripts/generate_docs.ps1`，并手动将生成的 `pages/listen_portfolio_flutter` 目录提交并推送至 `main` 分支。这一手工流程容易因开发者疏忽导致线上 API 文档落后于主干代码，且在本地生成时受 Windows 环境与缓存影响，存在生成不一致的风险。  
**优化方案**：
- **CI 流水线自动化阶段**：在 `.github/workflows/ci.yml` 中新增 `deploy-docs` Job（在每次向 `main` 分支推送且通过 589 项测试后自动触发）。
- **云端环境隔离与自动推送**：使用 Linux Runner 运行 `dart doc --output pages/listen_portfolio_flutter`；通过 GitHub 官方 `actions/deploy-pages@v4` 或自动化 Bot 提交至 GitHub Pages，彻底杜绝手动执行 PowerShell 脚本与本地文件拷贝的繁琐流程。
- **文档构建状态徽章 (Status Badge)**：在 README 与文档门户首页自动展示最新文档构建状态与生成时间戳。

---

### Opt-22. 跨平台文档生成 Shell 脚本与多包离线预览本地服务 (Cross-Platform Doc Generation & Multi-Package Offline Preview)

**状态**：📋 待排期 (Planned - 详见 [documentation_generation.md](documentation_generation.md))  
**现状**：当前文档生成脚本仅有 PowerShell 实现（`scripts/generate_docs.ps1`），在 macOS 与 Linux 开发环境下缺乏对应的 Bash 脚本或跨平台 Dart 脚本支持；同时，生成的静态文档在本地直接通过浏览器以 `file:///` 协议打开时，受浏览器同源策略（CORS）限制，搜索功能（`search.json`）与 Web Worker 往往无法正常加载。  
**优化方案**：
- **跨平台脚本对齐**：补充 `scripts/generate_docs.sh` (POSIX Bash) 与 `tools/generate_docs.dart`，抹平跨操作系统执行差异。
- **内置本地文档静态预览服务**：在脚本末尾增加 `--serve` 参数选项（或提供 `dart run tools/serve_docs.dart --port 8088`），利用轻量 HTTP 服务将 `pages/` 本地挂载，支持开发者在完全脱机的环境下流畅检索和测试包含搜索索引的高保真 API 文档。

---

### Opt-23. 全链路异常指纹哈希与 APM 错误聚合去重 (Error Fingerprint Hashing & APM De-duplication)

**状态**：📋 待排期 (Planned - 详见 [error_codes_reference.md](error_codes_reference.md))  
**现状**：当前在 `ErrorInterceptor`、`BaseRepository` 与 `BaseViewModel` 中，异常通过 `appLogger.e(...)` 打印并统一转化为 `Failure` 与 `MessageEffect` 展示。然而在网络抖动、批量并发请求失败或连续快速重试时，相同的错误、堆栈与 `messageId` 会在毫秒级内被重复触发并向外广播，导致终端用户看到连续弹跳的重复 Toast，同时对 Crash 监控平台与本地日志缓冲区造成无谓的吞吐风暴（Log Spamming）。  
**优化方案**：
- **确定性错误指纹算法 (Deterministic Error Fingerprinting)**：基于 `endpoint + httpMethod + statusCode + messageId + top3StackFrames` 提取特征并通过 SHA-256 / MurmurHash 计算全局唯一的 64-bit 错误指纹 `errorFingerprint`。
- **滑动窗口冷却抑制 (Sliding Window Suppression)**：在 `BaseViewModel` 与 APM 监控管道中建立 3~5 秒的滑动窗口去重缓存（`ExpiringCache`）；同一指纹错误在冷却窗口期内仅在首次展示 Toast 并上报 APM，后续重复触发时仅自增计数器（`suppressedCount++`），并在冷却结束时打印聚合汇总，消除 UI 界面剧烈抖动与遥测雪崩。

---

### Opt-24. 前后端契约错误码自动化代码生成与双端类型安全强校验 (Automated Error Code Contract Code-Gen & End-to-End Type Safety)

**状态**：📋 待排期 (Planned - 详见 [error_codes_reference.md](error_codes_reference.md))  
**现状**：当前后端的 Java 错误枚举（`ErrorCode.java`）、前端 Dart 网络状态码与契约前缀（`HttpCode`、`ApiResult`、`NET_0001` 等字面量）以及多语言翻译字典（`zh.dart`、`en.dart`、`ja.dart`）均依赖人工双向手动同步维护。当后端新增业务错误码或重构现有 `messageId` 时，缺乏编译期或静态分析门禁来约束前后端契约的一致性，一旦客户端漏配对应多语言键值，运行时将降级为原始英文或技术报错文本。  
**优化方案**：
- **单一真实来源 (SSOT) 契约声明**：定义标准化的 YAML / JSON Schema 契约规范（`contracts/error_codes.yaml`），集中声明全局错误码范围（`SYS_`、`NET_`、`AUTH_`、`VAL_`、`BIZ_`、`SRV_`）、默认文案、对应 HTTP 状态码及多语言翻译模板。
- **端到端自动化代码生成**：提供纯 Dart 代码生成器（`tools/generate_error_codes.dart`），一键自动化生成后端 Java `ErrorCode.java` 枚举、前端强类型 Dart 类 `AppErrorCode` 以及 `zh/en/ja` 国际化骨架映射表。
- **CI 契约完整性强制门禁**：在 GitHub Actions CI 流水线中新增 `check-error-contract` 校验阶段，自动核对 100% 的 `messageId` 均已在三语字典中完整注册且与后端契约完全对齐，从源头上杜绝契约脱节与遗漏。

---

### Opt-25. EventBus 全局弱引用监听与生命周期安全自动注销 (WeakReference & Auto-Lifecycle EventBus Subscriptions)

**状态**：📋 待排期 (Planned - 详见 [event_bus_vs_base_effect.md](event_bus_vs_base_effect.md))  
**现状**：当前在 `BaseViewModel` 中通过 `subscribeEvent<T>()` 已能依托 `onDispose` / Riverpod `ref.onDispose` 自动注销绑定的事件监听。然而，若开发者在底层 Repository、持久化 Service、第三方 SDK 封装层或自定义 UI 组件中直接调用单例 `eventBus.on<T>()`，一旦遗漏手动执行 `StreamSubscription.cancel()`，全局 `EventBus` 的广播流控制器将永久持有该监听器闭包，导致宿主实例无法被 GC 回收，造成静默内存泄漏与后台无序重复处理。  
**优化方案**：
- **弱引用监听器体系 (WeakReference Event Subscriptions)**：引入 Dart `WeakReference` 或 `Expando` 机制重构 `EventBus` 的内部监听者列表。当宿主对象离开作用域被垃圾回收时，事件总线在下一次广播分发时自动检测死亡引用并剪除失效的流管道。
- **作用域自动注销混入 (Auto-Disposable Lifecycle Tracker)**：提供 `EventBusLifecycleMixin`，重写绑定到组件生命周期（如 `LifecycleOwner` 或 `AutoDisposeNotifier`），实现离开生命周期上下文时的零心智负担自动注销。

---

### Opt-26. BaseEffect 消费确认闭环与一次性副作用投递保障契约 (BaseEffect Acknowledgment & Exactly-Once Delivery Contract)

**状态**：📋 待排期 (Planned - 详见 [event_bus_vs_base_effect.md](event_bus_vs_base_effect.md))  
**现状**：当前 `BaseViewModel` 中的 `_effectController` 基于 Dart 标准广播流（`StreamController<BaseEffect>.broadcast()`）实现。广播流的底层物理特性是“即发即弃 (Fire-and-Forget)”——若 ViewModel 在页面初始化极早期（`onInit` 中异步网络请求极速返回）、或在路由快速切换重叠期（新旧页面订阅切换空窗）发射了 `emitEffect`，此时若尚未建立活跃的 UI 订阅者（`_activeEffectSubscription == null`），该 Effect 会被广播流静默丢弃，导致关键的业务错误弹窗或支付结果提示丢失。  
**优化方案**：
- **副作用缓冲队列 (Pending Effect Queue)**：在 `BaseViewModel` 内部维护一个轻量的暂存队列 `Queue<BaseEffect>`。当 `emitEffect` 触发时，若当前无活跃 UI 监听者或页面处于后台挂起状态，将 Effect 压入暂存队列中缓存。
- **挂载回放与消费确认 (Replay on Bind & Consumption ACK)**：在 `onBindEffect` 新页面订阅建立就绪后，按先进先出（FIFO）顺序将队列中未处理的 Effect 依次补发；UI 渲染层执行完成后回传消费确认 ACK，确保所有单向瞬时指令达成“至少一次且至多一次 (Exactly-Once)”的可靠投递保障。

---

### Opt-27. 真实物理网络与 Dio 动态混沌代理拦截器 (Dynamic Chaos Network Interceptor & Real HTTP Fault Simulation)

**状态**：📋 待排期 (Planned - 详见 [fault_injection_playground_spec.md](fault_injection_playground_spec.md))  
**现状**：当前 `FaultInjectionViewModel` 中的网络与认证故障场景（`concurrent401`、`serverError500`、`networkTimeout`、`malformedGateway`）主要基于分阶段 `Future.delayed` 延时与控制台逐步输出构建。虽然真实验证了 ViewModel 状态机流转、并发互斥锁、Trace ID 动态关联以及 `LogOverlayManager` 过滤下钻闭环，但尚未在底层物理 HTTP 传输管道中通过专用的 Dio 混沌拦截器（`ChaosNetworkInterceptor`）与本地沙箱服务 `LocalMockServer` 发起真实的物理 Socket 连接、实地经历 `AuthInterceptor` 并发队列加锁与 `BaseResponseModel.fromJson` 真实反序列化解析。  
**优化方案**：
- **动态混沌网络拦截器 (ChaosNetworkInterceptor)**：在 `ListenCore` 网络管道中新增可插拔拦截器，支持通过运行时配置动态拦截命中特定 URL 模式（如 `/api/v1/*`）的真实请求，支持按需注入：
  1. 动态网络抖动（Jitter / Latency Injection，200ms~2000ms 随机延时）；
  2. 随机丢包与连接中断（Packet Drop / Connection Reset）；
  3. 强制 HTTP 状态码模拟（HTTP 500/502/503/401）；
  4. 代理畸形报文注入（直接回传 HTML 413 Payload Too Large 网页字符流）。
- **端到端物理演练闭环**：将 Playground 的网络场景全面改造为底层物理请求驱动，点击演练时真实触发 Dio 发起 5 个并发受控请求，实地触发 `AuthInterceptor` 的 `Completer` 挂起、Token 单例刷新重试与 `NetworkInspectorInterceptor` 抓包归档，实现真实网络环境的高保真混沌演练。

---

### Opt-28. 故障注入场景编排 DSL 与自动化混沌回归测试流水线 (Chaos Scenario Orchestration DSL & Headless Chaos Runner)

**状态**：📋 待排期 (Planned - 详见 [fault_injection_playground_spec.md](fault_injection_playground_spec.md))  
**现状**：当前演练场景仅支持在 UI 界面由用户单点手动触发，各场景之间相互隔离独立，缺乏批量组合编排（Chaining Pipeline）与可编程混沌编排脚本；同时在 CI/CD 流水线中缺乏免界面的 Headless 自动化混沌测试套件，无法在每次提交代码时自动化验证复杂并发故障下的系统自愈弹性。  
**优化方案**：
- **声明式混沌编排 DSL (Chaos Pipeline DSL)**：设计链式调用 DSL（如 `ChaosPipeline.create().step(networkTimeout).then(concurrent401).withConcurrentJank(durationMs: 250).run()`），支持模拟复合型灾难级并发场景（如“在主线程发生计算卡顿的同时遭遇连续网络超时与 Token 失效”）。
- **Headless 自动化混沌测试流水线 (Headless Chaos Runner)**：开发独立执行脚本（`dart run tools/run_chaos_suite.dart` 或集成至 `integration_test/chaos_resilience_test.dart`），在 GitHub Actions CI 阶段自动化执行全量混沌演练矩阵，强制校验 100% 场景均达成 `recovered` 状态且无任何未捕获异常逃逸至 Flutter Engine，建立工业级混沌工程刚性门禁。

---

### Opt-29. Android Credential Manager 与 iOS ASAuthorizationController 原生双端 Passkey 桥接 (Native Platform Passkey Biometric Bridge)

**状态**：📋 待排期 (Planned - 详见 [fido2_implementation_design.md](fido2_implementation_design.md))  
**现状**：当前客户端已建立 W3C WebAuthn Level 3 领域模型（`PasskeyRpEntity`、`PasskeyUserEntity`、`PasskeyRegistrationOptions`、`PasskeyAssertionOptions`、`PasskeyCredential`）与业务契约抽象 `PasskeyService`，并完成了内存沙箱与重放计数模拟实现（`MockPasskeyServiceImpl`）与全量单测覆盖。但尚未封装原生平台 MethodChannel / Pigeon 插件与 Android `androidx.credentials:credentials` (Credential Manager API) 及 iOS `AuthenticationServices` (`ASAuthorizationController` / `ASAuthorizationPlatformPublicKeyCredentialProvider`) 进行真机底层双端硬件桥接。  
**优化方案**：
- **Android 原生 Credential Manager 桥接**：基于 Android 14+ 推荐的 `androidx.credentials` 规范，接入 `CreatePublicKeyCredentialRequest` 与 `GetCredentialRequest`，调度系统级底栏半屏授权面板与生物特征校验（BiometricPrompt / Screen Lock），将底层 JSON 响应规范化解析为 `PasskeyRegistrationResponse` 与 `PasskeyAssertionResponse`。
- **iOS ASAuthorizationController 原生集成**：封装 `ASAuthorizationPlatformPublicKeyCredentialRegistrationRequest` 与 `AssertionRequest`，绑定 iOS Secure Enclave / iCloud 钥匙串同步，支持 Face ID / Touch ID 硬件级零知识证明签名。
- **Flutter 插件层平滑切换与能力探测**：通过 `PasskeyService` 工厂根据运行环境自动在 `NativePlatformPasskeyServiceImpl` 与 Web `WebPasskeyServiceImpl` 间智能切换，支持 `isPasskeySupported()` 硬件前置探测与密码登录无缝降级兜底。

---

### Opt-30. Spring Boot WebAuthn4J / Yubico 服务端公钥认证引擎与凭证生命周期管理 (Spring Boot WebAuthn4J Relying Party Engine & Credential Lifecycle)

**状态**：📋 待排期 (Planned - 详见 [fido2_implementation_design.md](fido2_implementation_design.md))  
**现状**：当前后端 `ListenPortfolioBackend`（Spring Boot 3.4.2 + Java 17 + Gradle）主要基于传统的 Spring Security 与用户密码哈希（BCrypt）进行认证并签发 JWT，尚未引入符合 FIDO2 / W3C WebAuthn 规范的 Relying Party 服务端公钥密码学解析与凭据管理引擎，缺少对 COSE 公钥解析、Base64URL Challenge 随机数校验、RP ID 域名绑定校验以及单调自增签名计数器（Monotonic Counter）防重放攻击的验证机制。  
**优化方案**：
- **服务端 WebAuthn4J / Yubico 核心引擎集成**：在 `ListenPortfolioBackend/build.gradle` 引入 `com.webauthn4j:webauthn4j-core` 或 `com.yubico:webauthn-server-core`，建立工业级标准的 Relying Party (RP) 认证流水线。
- **端到端 RESTful 契约与会话管理**：
  1. `POST /api/v1/auth/fido2/register-options`：生成安全密码学随机数 Challenge（至少 32 字节高熵熵池）并存入 Redis（设置 60s 临时过期），下发 RP ID、User Entity 及允许算法（ES256 -7 / RS256 -257）。
  2. `POST /api/v1/auth/fido2/register`：接收客户端上报的 `attestationObject` 与 `clientDataJSON`，解析 CBOR 格式提取 COSE 公钥与 Credential ID，验证 origin、rpId、challenge 签名，持久化至 `user_passkey_credentials` 数据库表。
  3. `POST /api/v1/auth/fido2/authenticate-options` & `POST /api/v1/auth/fido2/authenticate`：下发认证挑战并比对签名，严格执行单调签名计数器递增校验（防止克隆硬件重放），认证通过后签发标准 JWT Access & Refresh Token，无缝对接现有 `AuthInterceptor`。
- **域名绑定资产配置**：在生产环境配置 `.well-known/assetlinks.json`（Android Digital Asset Links）与 `apple-app-site-association`（iOS AASA webcredentials），实现生产级防钓鱼物理域名绑定。

---

### Opt-31. Flutter Web Gzip / Brotli 预压缩与 Nginx 静态加速流水线 (Flutter Web Gzip / Brotli Pre-compression & Static Acceleration Pipeline)

**状态**：📋 待排期 (Planned - 详见 [flutter_web_aws_deployment_guide.md](flutter_web_aws_deployment_guide.md))  
**现状**：当前应用在 CI/CD 中通过 `flutter build web --release` 编译输出后，直接将原始的 `main.dart.js`（约 2~4MB）、CanvasKit/WASM 资产与字体文件通过 SSH 流水线上传至 Nginx。Nginx 虽配置了 7 天静态缓存（`expires 7d`），但在每次版本首访时若依赖 Nginx 运行时动态 gzip 压缩，会导致低配 EC2（如 t2.micro/t3.micro 单核）CPU 瞬间飙高打满，且客户端首次下载耗时长，造成首屏加载（FP/FCP）显著延迟。  
**优化方案**：
- **CI 构建期预压缩 (Pre-compression)**：在 GitHub Actions 流水线或 `buildModule.sh web` 编译产物后，自动执行 `gzip -k -9` 和 `brotli -k -q 11`，对所有 `.js`、`.wasm`、`.html`、`.css`、`.json` 生成对应的 `.gz` 与 `.br` 预压缩文件。
- **Nginx 静态压缩模块激活**：在 EC2 Nginx 站点配置中启用 `gzip_static on;` 和 `brotli_static on;`。当支持压缩的现代浏览器请求静态资源时，Nginx 直接零 CPU 损耗发送预压缩的静态文件，将首屏资源网络传输体积减少 65%~75%，大幅加速页面秒开。

---

### Opt-32. Flutter Web 自动化蓝绿发布与静态版本哈希回滚守卫 (Web Zero-Downtime Blue-Green Deployment & Version Hash Rollback Guard)

**状态**：📋 待排期 (Planned - 详见 [flutter_web_aws_deployment_guide.md](flutter_web_aws_deployment_guide.md))  
**现状**：当前 CI/CD 部署脚本在解压部署前直接执行 `sudo rm -rf /var/www/listen_portfolio_web/*`，随后通过 tar 流解压新产物覆盖。这一过程存在两大风险：(1) **发布窗口期短暂空白**：在旧文件被删除到新文件完全写入的数秒空窗期，正在访问站点的用户可能遭遇 HTTP 404；(2) **Chunk 资源版本不一致引发客户端崩溃**：若在线用户正在操作，浏览器尝试异步加载旧版本的 split chunk JS 时，因被强制删除而触发运行时异常，造成白屏。  
**优化方案**：
- **原子软链接发布 (Atomic Symlink Blue-Green Switching)**：将每次构建按照 Git Commit SHA 发布到独立的版本目录（如 `/var/www/listen_portfolio_releases/<git-sha>`），解压校验完毕后，通过 `ln -sfn /var/www/listen_portfolio_releases/<git-sha> /var/www/listen_portfolio_web` 实现微秒级无缝原子切换，实现真正意义上的零停机发布（Zero-Downtime Deployment）。
- **版本保留与一键秒级回滚 (Rollback Retention)**：自动保留最近 3 个历史稳定发布版本目录；当新版本探测健康检查异常时，可直接通过一条命令将软链接切回上一个版本，达成秒级应急回滚；过期版本通过 Cron 自动清理。

---

### Opt-33. 跨平台 Google Identity Services (GIS) Web 适配与 One Tap 登录浮层 (Google Identity Services Web & One Tap Prompt Bridge)

**状态**：📋 待排期 (Planned - 详见 [google_signin_specification.md](google_signin_specification.md))  
**现状**：当前针对移动端设计的 `GoogleSignInService` 契约与 `google_sign_in` 插件主要面向 Android (Google Play Services) 与 iOS (GIDSignIn)。当应用运行于 Flutter Web 时，传统的 OAuth 弹窗（Popup）常被现代浏览器默认启用的弹窗拦截器（Popup Blocker）阻断，或者因跨页面完整重定向（Redirect Flow）导致单页应用内存状态被冲刷重置。  
**优化方案**：
- **Google Identity Services (GIS) JavaScript SDK 桥接**：在 `web/index.html` 中引入 `https://accounts.google.com/gsi/client`，封装 `WebGoogleSignInServiceImpl`。
- **One Tap 免打扰半屏浮层**：网页加载就绪后，利用 `google.accounts.id.initialize` 与 `prompt()`，在页面右上角非侵入式呼出 Google One Tap 登录小部件；用户一键点击头像即可瞬间完成授权并回传 `credential` (ID Token)，免除页面跳转与密码输入。
- **自动登录凭证恢复 (Automatic Sign-in)**：结合 FedCM (Federated Credential Management API) 标准，当用户在同一浏览器中已有 Google 活跃 Session 时，支持毫秒级静默登录与 Token 换发。

---

### Opt-34. 统一第三方社交认证聚合网关与多租户 OAuth 2.0 / Apple ID 解绑安全中心 (Federated OAuth Gateway & Apple/Google Identity Center)

**状态**：📋 待排期 (Planned - 详见 [google_signin_specification.md](google_signin_specification.md))  
**现状**：当前系统架构仅规划了单一 Google OAuth 2.0 登录，未考虑苹果 App Store 审查指南 4.8 对第三方登录必须包含 Apple 登录的强制要求；同时在后端架构中缺乏扩展更多 IdP（如 GitHub、Apple ID、WeChat）的统一身份抽象层，无法在个人中心进行绑定、解绑与换绑。  
**优化方案**：
- **服务端统一社交认证网关 (FederatedAuthProvider Strategy Pattern)**：在 `ListenPortfolioBackend` 抽象 `FederatedAuthProvider` 策略接口，通过工厂模式统一纳管 `GoogleAuthProvider`（Google ID Token 验签）与 `AppleAuthProvider`（Apple Identity Token ES256 验签与 JWKS 密钥轮转），统一映射为标准 `FederatedUserDto`。
- **iOS Apple 登录无缝补齐 (Apple Sign-In Parity Guard)**：在 Flutter 侧抽象 `AppleSignInService`，在 iOS 平台遵循 App Store 规范并排渲染 Apple 黑色品牌按钮；Android/Web 侧安全隐藏。
- **多租户绑定与安全解绑中枢**：在数据表 `user_federated_identities` 中维护一对多账号绑定关系（`user_id`, `provider`, `provider_sub`, `email`）。在“设置 - 账号安全”页面提供“绑定/解绑 Google、绑定/解绑 Apple”，并设有安全防护底线（若未设置独立密码，禁止解绑唯一的第三方身份提供方，防止账户成为孤儿账号）。

---

### Opt-35. 服务端双端收据校验与 Google Play / App Store Server API 防伪造验证 (Server-Side IAP Receipt Verification & Webhook Notification Gateway)

**状态**：📋 待排期 (Planned - 详见 [iap_implementation_design.md](iap_implementation_design.md))  
**现状**：目前应用在客户端本地接收到 `PurchaseStatus.purchased` 事件后，直接调用 `iapService.completePurchase(purchase)`（并在 Android 端执行 `consumePurchase`），未将购买收据（Purchase Token / App Store JWS Transaction）发送至 Spring Boot 服务端校验。在已 Root/越狱设备或安装了虚拟 Billing 插件的逆向环境中，攻击者可伪造购买成功状态实施“零元购”绕过，存在安全隐患。  
**优化方案**：
- **双端凭据服务端二次验签流水线 (Server-Side Receipt Validation Pipeline)**：客户端在收到 `purchased` 后，仅将 `purchaseToken`、`orderId`、`productId`、`packageName`（Android）或 StoreKit 2 的 `signedTransactionInfo` JWS（iOS）上报至后端 `POST /api/v1/iap/verify-purchase`。
- **Google Play Developer API & App Store Server API 集成**：在 Spring Boot 后端配置 Google Service Account 秘钥与 Apple App Store Connect API 私钥（p8 证书），调用官方服务端接口（如 Google `purchases.products.get`、Apple `https://api.storekit.itunes.apple.com/inApps/v1/transactions/{transactionId}`）进行权威验签，确保订单状态有效且未被撤销。
- **防止重放攻击 (Replay Attack Defense)**：服务端在数据库建立唯一约束索引（`order_id` / `transaction_id`），校验通过后将订单持久化并为用户记账，只有在服务端返回 200 OK 且确认入账后，客户端才执行 `completePurchase` 和 `consumePurchase`。
- **实时开发者通知网关 (Real-Time Developer Notifications / Webhook Gateway)**：配置 Google Cloud Pub/Sub 与 Apple App Store Server Notifications V2 Webhook，实时捕获退款（REFUNDED）、撤销（REVOKED）与订阅续订事件，实现自动化对账与权益收回。

---

### Opt-36. 打赏排行榜与尊贵支持者铭牌徽章系统 (Coffee Tip Leaderboard & Supporter Badges System)

**状态**：📋 待排期 (Planned - 详见 [iap_implementation_design.md](iap_implementation_design.md))  
**现状**：目前打赏购买咖啡后，仅弹出 Toast 提示（"Thank you for your support!"）并尝试拉起应用内评分弹窗（`ReviewService`），打赏记录未持久化在云端用户账户下，缺少社交激励、正向反馈与荣誉铭牌展示，无法激发社区开发者的持续支持热情。  
**优化方案**：
- **支持者荣誉榜单 (Supporter Leaderboard & Wall of Fame)**：在“关于/设置”页面增设“赞助支持者名录 (Wall of Fame)”，按累计打赏咖啡杯数或最近打赏展示匿名/公开赞助者列表（包含用户昵称、头像与支持寄语）。
- **尊贵徽章与动态挂件 (Supporter Badges & Avatar Frame)**：购买不同档位咖啡（Tier 1: ☕ 浓缩咖啡, Tier 2: ☕ 拿铁大师, Tier 3: 🔥 终极赞助伙伴）后，云端在 `user_badges` 中点亮对应的 SVG 动态徽章与金色流光头像框，在个人详情页与评论互动中尊贵展示。
- **致谢证书导出与一键海报分享 (Digital Certificate & Social Sharing)**：打赏成功后生成包含独一无二赞助编号（如 `#SUPPORTER-0042`）的精美致谢电子贺卡/海报，支持使用 `screenshot` / `share_plus` 一键分享至 X (Twitter)、GitHub 或朋友圈。

---

### Opt-37. 智能情感倾向分流与私域反馈闭环网关 (In-App Sentiment Pre-Survey & Private Feedback Loop Gateway)

**状态**：📋 待排期 (Planned - 详见 [iar_implementation_design.md](iar_implementation_design.md))  
**现状**：当前应用在自动触发评分时直接调用平台原生 In-App Review 接口，或在设置页面直接跳转至应用商店 Listing 页。若用户在使用中遇到 Bug、卡顿或对交互设计不满，缺乏内部沟通与负反馈表达渠道，容易直接在公开应用商店提交 1 星差评，对应用在 Google Play / App Store 的公开评分造成不可逆损害。  
**优化方案**：
- **极简两步式情感满意度探测 (NPS / Sentiment Survey Modal)**：在非强制触发（非打赏黄金时刻）的自动引导场景下，前置弹出轻量友好的满意度微交互卡片（“您喜欢使用 Listen Portfolio 吗？😍 / 🙁”）。
- **智能双轨分流机制 (Smart Dual-Track Routing)**：
  - 若用户反馈正向（满意），顺理成章引导其点击“去应用商店为作者点赞”，无缝调起原生应用内评分或商店详情页；
  - 若用户反馈负向（不满意或遇到故障），立即路由至内部私域反馈通道（如“提交 Bug / 改进建议”表单，自动附带设备型号、系统版本与最近报错日志），支持通过邮件直达开发者邮箱或一键提交至 GitHub Issues。
- **合规性红线保障**：严格遵守 Google Play 开发者政策与 Apple 审查指南 5.6.1，不得采用“强制好评”、“好评返现/解锁特权”等违规手段，确保用户仍可在设置页自由直接访问商店评分页面。

---

### Opt-38. Firebase Remote Config 动态评分编排中心与智能用户行为触发器 (Remote Config Driven Dynamic Review Orchestration & Smart User Behavioral Triggers)

**状态**：📋 待排期 (Planned - 详见 [iar_implementation_design.md](iar_implementation_design.md))  
**现状**：目前评分触发阈值硬编码在客户端 `ReviewService` 源码中（`limitCount = 5`，`limitDays = 90`），无法在不发版的情况下针对特定活动、新版本上线期或特定国家区域动态调整冷却时间与启动门槛；同时仅基于被动的“启动次数”判断，无法识别高价值、深度探索的高意愿用户（如完成了 3 个开源项目详情阅读、进行了雷达图交互或在 APM 面板体验了故障注入演练）。  
**优化方案**：
- **云端参数热配置 (Firebase Remote Config / Spring Boot Config Gateway)**：将 `review_launch_count_threshold`、`review_cooldown_days`、`review_enabled_versions` 等关键阈值抽离至云端配置，支持免发版动态调控。
- **多维高价值行为积分引擎 (High-Value Engagement Scoring Engine)**：建立轻量端侧行为积分模型：用户每探索一个 Portfolio 项目（+2分）、展开架构全景图（+3分）、成功执行一次故障演练（+5分）。当综合活跃分达到 15 分且当日未触发过弹窗时，判定为优质体验时刻，智能拉起评分，大幅提升 5 星好评率与评分质量。

---

### Opt-39. Patrol 原生平台跨进程自动化与系统权限/生物识别模拟桥接 (Patrol Native Automation & System Permissions/Biometrics Bridge)

**状态**：📋 待排期 (Planned - 详见 [integration_test_plan.md](integration_test_plan.md))  
**现状**：当前 `integration_test/app_test.dart` 借助 `patrol_finders` 实现了 22 组涵盖登录、首页、设置、AI 助手、故障注入等业务流程的 Widget 树级 E2E 测试。但在真机或真实模拟器运行时，测试进程受限于 Flutter 单一渲染表面（Flutter View），无法点击或跨越 Android / iOS 原生操作系统的系统级对话框（例如：首次启动时的通知权限申请横幅、文件/相册读写授权弹窗、原生输入法键盘弹出遮挡手势靶点、生物特征 Face ID / 指纹授权弹窗等），在全真机端到端流水线中偶发因原生阻断导致的测试超时。  
**优化方案**：
- **Patrol Native Automator 原生驱动集成**：升级引入 `patrol: ^3.0.0+` 原生平台驱动桥，接入基于 Android `UiAutomator` 与 iOS `XCUITest` 的底层驱动能力。
- **跨进程系统授权与交互模拟**：在用例执行中利用 `$.native.grantPermissionWhenInUse()`、`$.native.tap(Selector(text: 'Allow'))` 自动批准系统级权限；利用 `$.native.pressBack()`、`$.native.pressHome()` 模拟物理返回与切回前台；利用 `$.native.authenticateWithBiometrics()` 模拟生物特征识别通过，达成真正的 100% 全自动化免人工干预测试。
- **原生键盘与剪贴板真实交互**：基于 `$.native.enterText()` 替代虚拟事件驱动，真实模拟软键盘呼出、输入法候选词匹配与软键盘 Done 键点击，彻底杜绝软键盘遮挡底栏引发的 `evaluates.isEmpty` 偶发假阳性。

---

### Opt-40. 自动化视觉回归像素级 Golden UI 比对与 E2E 故障快照/视频录制归档 (Visual Golden Regression & Failure Video Recording Pipeline)

**状态**：📋 待排期 (Planned - 详见 [integration_test_plan.md](integration_test_plan.md))  
**现状**：当前 22 组集成测试主要依赖 `expect(find.text(...), findsOneWidget)` 与 `find.byType(...)` 进行文本、图标与控件类型匹配，属于“逻辑断言”。对于组件渲染偏位、暗黑/浅色主题色彩渲染溢出、多语言超长文本截断、高分屏（High DPI）像素模糊或自绘 Canvas 畸变等“视觉级回归”无法自动捕获；同时在 GitHub Actions CI 流水线中，若偶遇用例失败，仅能查看控制台纯文本堆栈，缺乏直观的现场上下文。  
**优化方案**：
- **E2E 关键节点像素级黄金比对 (Visual Golden Testing Pipeline)**：在每个核心交互步骤（如登录表单校验报错、设置页深浅主题切换、技能雷达图展开）后，调用 `tester.takeScreenshot('flow_step_name')` 捕获当前帧，与基准像素图像进行差分比对（允许容差阈值 $\le 0.5\%$），任何像素级布局偏位自动亮红报警。
- **CI/CD 失败现场快照与视频自动录制流水线**：集成 Patrol / ADB 录屏服务（`adb shell screenrecord`），在 CI 运行期间后台录制全量测试过程；当捕获断言失败（AssertionError）时，自动抓取失败前 5 秒与失败时刻的屏幕截图及 `.mp4` 录屏文件，并作为 GitHub Actions Artifacts 自动打包上传归档，使开发者能在 10 秒内直观复现并锁定问题根源。

---

### Opt-41. MviPlaybackRegistry 宏 / 编译期代码生成自动化与类型安全 AST 校验 (Macro / SourceGen Automated Intent Serialization Pipeline)

**状态**：📋 待排期 (Planned - 详见 [intent_effect_playback_design.md](intent_effect_playback_design.md))  
**现状**：当前系统为了在禁用反射（`dart:mirrors`）的 Flutter AOT 运行环境下实现 Intent 意图反序列化，采用在各个 Feature 的 Intent 文件中手动编写 `registerPlayback()` 静态注册闭包（例如 `LoginIntent.registerPlayback()`），并依托单一正则表达式 `^([a-zA-Z0-9_]+)\.([a-zA-Z0-9_]+)\((.*)\)$` 进行参数键值切割解析。同时在 `initMviPlaybackRegistry()` 中需要集中显式手动调用 19 个 Feature 的初始化注册。这种纯手工维护模式存在两大隐患：
1. **契约不同步与隐蔽运行时故障**：当业务迭代新增 Intent 工厂构造或变更入参字段时，若开发者遗漏更新 `registerPlayback()`，编译期无法给出告警，直到回放执行至该步骤时才报错抛出 `Failed to deserialize Intent`；
2. **正则解析表达力受限**：基于逗号与冒号（`, ` 与 `: `）的简单正则切分难以解析包含逗号的复杂文本、嵌套 JSON 对象或 List 集合参数，限制了复杂数据意图的录制重现。  
**优化方案**：
- **基于 `source_gen` / `build_runner` 或 Dart 3.x 宏（Macro）的代码生成管线**：提供 `@MviPlaybackIntent()` 注解，利用 AST 分析器在编译期自动扫描所有继承自 `BaseIntent` 的密封类（Sealed Class）与工厂构造器。
- **自动生成双向类型安全序列化器**：自动化生成强类型 JSON 映射与反序列化胶水代码（`*.playback.g.dart`），支持嵌套对象、复杂泛型与特殊字符转义，取代脆弱的手写字符串正则切割。
- **静态分析与 CI 自动化注册校验门禁**：在自定义 Lint 或 `tools/dependency_rules.dart` 中增加校验规则，若检测到有新增 `BaseIntent` 子类未纳入录制回放代码生成体系，在静态分析阶段即给出提示，实现契约 100% 自动化对齐。

---

### Opt-42. 跨设备高保真手势坐标注入与多分辨率响应式回放适配 (Cross-Device Coordinate Injection & Responsive Viewport Scaler)

**状态**：📋 待排期 (Planned - 详见 [intent_effect_playback_design.md](intent_effect_playback_design.md))  
**现状**：当前 MVI Playback 录制与回放设计锚定在业务逻辑领域的 `BaseIntent` 层，这一设计的巨大优势是具备跨组件重构韧性且天然规避了物理坐标误差。然而，纯逻辑 Intent 回放存在无法覆盖的物理交互死角：
1. **纯渲染与自绘组件交互丢失**：针对非 ViewModel 驱动的原生自绘 Canvas 交互（如 `SkillsRadarChart` 技能六维多边形顶点的实时拖拽形变、旋转手势，以及个人项目图片的高保真双指缩放 Pinch-to-Zoom），此类手势未经过 MVI Intent 管道，在录制中无法被捕获与重现；
2. **跨设备多分辨率与屏幕方向回放形变**：若后续扩展原生 Pointer 级事件录制，在不同分辨率与长宽比设备间（例如在 390×844 的 iPhone 14 上录制，而在 1080×2400 的 Android 旗舰机或 1920×1080 的 Flutter Web 浏览器中回放），固定的绝对物理像素坐标会导致点击靶点偏移、落空或触发错误元素。  
**优化方案**：
- **双轨混合录制架构 (Hybrid Intent + Gesture Stream)**：保留以 MVI Intent 驱动业务逻辑为主轨的同时，为交互密集型自绘 Widget 引入轻量级 `GestureRecorder` 扩展通道。
- **归一化相对坐标空间 (Normalized Viewport Projection)**：在捕获原生 `PointerDownEvent` / `PointerMoveEvent` 时，基于当前宿主组件的 `RenderBox` 视口边界计算归一化相对坐标 $(\frac{x}{W}, \frac{y}{H})$（$x, y \in [0.0, 1.0]$）。
- **动态视口缩放与原生指针注入 (Responsive Viewport Scaler & Synthetic Pointer Injection)**：在不同尺寸的目标设备回放时，根据当前实际渲染尺寸反向映射并合成绝对物理事件，利用 `GestureBinding.instance.handlePointerEvent()` 注入虚拟物理指针流，达成兼具“业务逻辑高保真”与“图形交互连续性”的工业级跨端回放体验。

---

### Opt-43. 磁带持久化跨端导出/导入协议与 WebRTC / QR 码免线联调传输 (Tape Export/Import Protocol & QR Code / AirDrop-like P2P Sharing)

**状态**：📋 待排期 (Planned - 详见 [intent_effect_playback_spec.md](intent_effect_playback_spec.md))  
**现状**：当前磁带录像数据完全保存在宿主设备的本地 `SharedPreferences` 中（键名为 `AppConstants.playbackTapeKey + timestamp`），虽然实现了数据层 `PlaybackTapeRepository` 解耦与 UI 列表查看，但缺乏标准的外部交换通道。当 QA 测试人员在真机上录制了 Bug 复现磁带后，无法便捷导出为 `.tape.json` 文件或分享给研发电脑，研发也无法直接将磁带注入到本地模拟器或桌面端进行一键回放，限制了“磁带即缺陷凭据 (Tape as Bug Attachment)”的跨人协作价值。  
**优化方案**：
- **标准化 `.tape.json` 导出与系统原生分享 (Standard Tape File Export & Native Share Sheet)**：在 `PlaybackTapeListPage` 的每个磁带卡片操作栏增设“导出 (Export)”按钮，调用 `share_plus` 将磁带元数据与时序步骤打包为带 SHA-256 校验和的 `.tape.json` 文件，支持通过 AirDrop、邮件或 Slack 一键分享至研发电脑。
- **文件选择器导入与深链接唤起 (File Picker Import & Scheme Association)**：支持点击外部 `.tape.json` 直接通过自定义 Scheme 或文件选择器（`file_picker`）导入到当前应用的 `PlaybackTapeRepository`，实现秒级落盘与列表置顶。
- **局域网免配对 P2P 传输与微型动态二维码切片 (LAN WebSocket Sync & Chunked QR Code Transfer)**：针对无外网或安全敏感环境，设计基于本地 mDNS / WebSocket 广播的一键“无线投递 (AirDrop-like Drop)”；针对短步骤磁带，支持使用 `qr_flutter` 生成分片动态二维码，研发使用 App 内置扫描探针一扫即可完成磁带克隆。

---

### Opt-44. 桌面小部件 (AppWidget / WidgetKit) 双端原生渲染与 App Group 数据同步管道 (Cross-Platform Home Screen Widgets & App Group Shared Container)

**状态**：📋 待排期 (Planned - 详见 [launcher_widgets.md](launcher_widgets.md))  
**现状**：当前客户端已在应用内部构建了完整的作品集与技能看板，并在桌面层落地了长按快捷菜单（Launcher Quick Actions）。然而在 Android 与 iOS 移动操作系统的主屏幕（Home Screen）上，尚未提供无需点开 App 即可即时速览个人核心数据、近期精选项目与一键打赏/跳转的微件系统（Android AppWidget / iOS WidgetKit）。桌面小部件运行于独立的宿主进程沙箱（Android `RemoteViews` / iOS `WidgetExtension`），跨进程数据隔离、暗黑/浅色自适应渲染以及避免无谓耗电的静默刷新机制是落地核心痛点。  
**优化方案**：
- **跨进程共享容器管道 (Cross-Process Shared Container Bridge)**：在 iOS 侧配置 App Group Entitlements (`group.com.listen.portfolio`)，通过 `UserDefaults(suiteName:)` 共享 JSON 数据载荷；在 Android 侧基于 `SharedPreferences` 跨进程访问与 `home_widget` 统一封装，打通 Flutter 宿主与原生小部件的数据总线。
- **双端原生声明式渲染族 (Glance / SwiftUI Declarative Widget Family)**：在 Android 端基于 Jetpack Glance (Kotlin Compose API) 构建轻量卡片（支持 1×1、2×2、4×2 规格）；在 iOS 端基于 SwiftUI WidgetKit 构建小/中/大规格小部件（`systemSmall`、`systemMedium`、`systemLarge`），原生绑定 `@Environment(\.colorScheme)` 实现系统级深浅色主题无感漫游。
- **事件驱动与零轮询节能调度 (Event-Driven Zero-Polling Invalidation)**：将 Android `appwidget-provider` XML 中 `updatePeriodMillis` 强制设为 `0`，禁止系统 AlarmManager 周期性后台唤醒耗电；全面实施基于 Flutter 端用户更新数据（如编辑个人履历、切换语言、调整配置）的事件驱动定向刷新（`HomeWidget.updateWidget`），达成 0 额外电池损耗与秒级数据一致性。

---

### Opt-45. 桌面长按快捷菜单 (App Shortcuts) 动态热插拔与深链接意图参数扩展 (Dynamic Launcher Shortcuts & Parametric Deep Link Routing)

**状态**：📋 待排期 (Planned - 详见 [launcher_widgets.md](launcher_widgets.md))  
**现状**：当前 `QuickActionsManager` 已实现中/英/日三语动态本地化响应（`settingManager.addListener`）与基础的设置页跳转及邮件反馈唤起（4/4 项单测全绿通过）。但快捷菜单项（Shortcuts）目前为写死固定的 2 项静态配置，且点击回调通过简单的硬编码路由分发，缺乏动态根据用户常用项目/最近浏览动态插拔快捷项的能力，且缺少对深链接复杂参数（如带有目标 Project ID 或特定 Tab 的 Query 参数）的通用解构与防死锁派发机制。  
**优化方案**：
- **动态热插拔与使用习惯自适应 (Dynamic Shortcut Ingestion & Usage Adaptation)**：引入基于用户高频行为的动态快捷菜单推荐，根据用户最近浏览的项目或星标作品集（Starred Projects），在启动或进入后台时动态注册最多 4 个快捷入口（Android `ShortcutManager.setDynamicShortcuts` / iOS `UIApplication.shared.shortcutItems`）。
- **统一标准深链接意图派发器 (Parametric Deep Link Relay & Intent Dispatcher)**：将 Shortcut 的 `type` 抽象为标准 URI 模式（如 `listenportfolio://project/detail?id=6&from=shortcut`），与全局 `DeepLinkManager` 和 `AppNav` 统一接入路由流；
- **冷热启动防竞态事件总线缓存 (Cold/Warm Launch Race Condition Buffer)**：针对应用未启动（Cold Launch）时快捷菜单点击可能发生在 Flutter 引擎与 Navigator 尚未挂载完成的边缘场景，利用 `EventBus(sticky: true)` 机制缓存待处理意图，在 `AppNavConfig.navigatorKey` 就绪后自动消费派发，彻底杜绝冷启动丢事件与路由未响应缺陷。

---

### Opt-46. ListenCore 跨平台 Web 条件导入系统性解耦与轻量 Mock 拦截器 (Cross-Platform Web Conditional Compilation & In-Memory Mock Interceptor)

**状态**：📋 待排期 (Planned - 详见 [listencore_audit.md](listencore_audit.md))  
**现状**：当前 `ListenCore` 整体已高度成熟，但底层仍有个别模块（如 `LocalMockServer` 的 `dart:io` `HttpServer` 与 `CrashManager` 的本地文件持久化 `File`）存在对 `dart:io` 的直接硬依赖。在 Flutter Web 编译目标下，虽然宿主 App 借助 `!kIsWeb` 守卫绕过了运行时拉起，但当外部开发者直接将 `ListenCore` 作为通用底座并在 Web 端引入时，编译期或静态分析仍存在 `dart:io` 缺失警告或导入阻断。  
**优化方案**：
- **条件导入桩隔离 (Conditional Export/Import Stubbing)**：将 `LocalMockServer` 拆分为 `mock_server_interface.dart` 抽象接口，结合 `if (dart.library.io) 'local_mock_server_io.dart' else 'local_mock_server_web.dart'` 进行透明分流。在 Web 环境下提供空实现桩（Stub）以规避编译失败。
- **Web 端 Dio 内存 Mock 拦截器 (In-Memory Mock Interceptor for Web)**：针对 Web 平台无法绑定本地 `127.0.0.1:9999` Socket 的限制，提供基于 Dio `Interceptor` 的 `MockAssetInterceptor`，直接拦截 HTTP 请求并读取 `rootBundle` 资产中的 JSON 数据就地构造 `Response`，实现 Web 平台全量无缝离线开发与零代码改动。
- **Web 崩溃日志内存/IndexedDB 降级持久化 (Web Crash Persistence Fallback)**：`CrashManager` 在 `kIsWeb` 环境下自动降级为浏览器 `window.localStorage` 或 IndexedDB 持久化，杜绝 `dart:io File` 调用抛出的 `UnsupportedError`。

---

### Opt-47. ListenCore 分页加载通用契约与状态机 Mixin (Universal Pagination Abstraction & Cursor/Offset State Machine)

**状态**：📋 待排期 (Planned - 详见 [listencore_audit.md](listencore_audit.md))  
**现状**：移动与 Web 业务应用中 80% 以上的页面为列表流与分页加载场景。当前 `ListenCore` 具备强大的 MVI `BaseViewModel` 与 `safeCall` 缓存降级，但尚未提供跨业务可复用的分页领域模型（`PaginatedResponse<T>`）与状态机 Mixin（`PaginationViewModelMixin`），各个业务团队仍需在 ViewModel 内部手写 `page`、`pageSize`、`hasMore`、`isLoadingMore` 以及下拉刷新与上拉加载追加逻辑，产生样板代码。  
**优化方案**：
- **通用分页领域契约抽象 (Universal Paginated Models)**：在 `ListenCore` 中定义泛型领域模型 `PaginatedList<T>` 与 `PageCursor`，统一标准字段（`items`, `totalCount`, `currentPage`, `pageSize`, `hasMore`），支持游标（Cursor-based）与基于偏移量（Offset/Page-based）两种主流工业级分页协议。
- **可插拔分页状态机扩展 (PaginationViewModelMixin & State)**：为 `BaseViewModel` 提供 `PaginationViewModelMixin<T, I, S>`，内建节流防抖、下拉刷新（重置为第一页并覆盖缓存）、上拉追加（Append List 并更新 Page）、静默预加载（距底部 3 个元素提前触发下页拉取）以及列表空状态（Empty）与网络错误（Error with Retry）自动派发。
- **UI 下拉刷新骨架封装 (BaseRefreshWrapper in ListenUiKit)**：联动 `ListenUiKit` 规范统一的下拉刷新与加载更多动画指示器，与 Core 分页状态机原生契约对齐，使任意列表业务仅需声明数据源即可在 10 行代码内完成高弹性分页列表构建。

---

### Opt-48. LocalMockServer 故障注入联动与可控网络异常模拟引擎 (Mock Fault Injection & Dynamic Network Anomaly Simulation)

**状态**：📋 待排期 (Planned - 详见 [mock_data_specification.md](mock_data_specification.md))  
**现状**：当前 `LocalMockServer` 固定返回 HTTP 200（延时固定为 1 秒），对于复杂的生产级边界异常（如 HTTP 500 契约异常、401 Token 过期、413 Request Entity Too Large、网络抖动 SocketException 与超长超时）缺乏动态物理干预能力。目前故障注入演练主要依赖前端拦截器层面的逻辑模拟，未能真实穿透底层 Loopback Socket 与系统网络协议栈。  
**优化方案**：
- **请求头驱动的物理故障分流 (Header-Driven Physical Fault Dispatcher)**：在 `LocalMockServer` 中支持标准调试请求头（如 `X-Mock-Fault: 500`、`X-Mock-Fault: 401` 或 `X-Mock-Fault: 413`）。当检测到该请求头时，Mock 服务器直接在物理 Socket 层面写入对应的 HTTP 状态码与畸形 Payload，实现真实网络错误的全真演练。
- **动态网络抖动与延迟模拟 (Configurable Jitter & Latency Engine)**：支持通过 `X-Mock-Latency: 5000` 动态覆盖全局默认延迟，或通过 `X-Mock-Jitter: 500-2000` 模拟现实弱网环境下的随机往返时延（RTT）抖动。
- **与故障演练场深度整合 (Playground Seamless Integration)**：将 `FaultInjectionPlayground` 中的演练项与 `LocalMockServer` 物理故障引擎全面联动，支持一键在真实的本地回环套接字中重现 401 并发排队与 500 熔断降级。

---

### Opt-49. Mock JSON 模式校验 (JSON Schema Validation) 与 CI 自动化合规门禁 (Automated JSON Schema & Multi-Language Key Alignment Linter)

**状态**：📋 待排期 (Planned - 详见 [mock_data_specification.md](mock_data_specification.md))  
**现状**：当前 Mock JSON 文件均由人工手动维护。当业务迭代修改了基准模型（如 `projects.json` 新增 Project ID 6 `ListenExpenseTracker` 或新增 `githubUrl` / `techStack` 字段）时，若开发者遗漏在对应的中文版 `projects_zh.json` 或日文版 `projects_ja.json` 中同步补齐，静态编译期无法发现缺失，直到运行时用户切换语言后才引发属性解析为空（`null`）或 UI 排版畸变。  
**优化方案**：
- **基于 JSON Schema 的静态合规校验器 (Mock JSON Schema Validator)**：编写专用验证脚本 `tools/lint_mock_schemas.dart`，针对 `assets/mock/` 下的各业务模块定义标准 Schema（包含字段必填性、类型强约束与数值边界），扫描检测所有 Mock 文件。
- **多语言键值完整性自动化差分对齐 (Multi-Language Key Alignment Linter)**：脚本自动遍历所有带 `_zh.json` 与 `_ja.json` 后缀的语言文件，与对应的基准英文/中文文件进行递归 Key 比对。若发现缺失键或多余废弃键，自动高亮并阻断，杜绝漏译与数据不一致。
- **纳入 GitHub Actions CI 自动化门禁 (CI Pull Request Quality Gate)**：将 Mock 模式校验纳入 Pull Request 门禁流程，确保任何合入主干的代码其 Mock 数据资产均保持 100% 强健与同步。

---

### Opt-50. 布局渲染层级深度可视化探针与过度绘制 (Overdraw) 预警热力图 (Widget Tree Depth Profiler & Canvas Overdraw Inspector)

**状态**：📋 待排期 (Planned - 详见 [performance_panel_spec.md](performance_panel_spec.md))  
**现状**：当前 `LogOverlay` 性能面板聚焦于宏观帧时延（Build/Raster 微秒）、FPS 折线图及冷启动耗时，但缺乏对微观 UI 渲染质量的深度诊断工具。当页面存在不合理的深度嵌套（如深达 20~30 层的嵌套 Container/Padding）、未隔离的动画重绘（缺少 `RepaintBoundary`）或重叠的不透明色块引发严重的 GPU 过度绘制（Overdraw）时，开发者无法在 App 运行时直观观测，必须连接外部 DevTools 进行排查，增加了性能调优门槛。  
**优化方案**：
- **树层级深度扫描探针 (Widget Tree Depth Profiler)**：在 `LogOverlay` 中集成轻量级 Element 树遍历器，通过 `Element.visitChildren` 递归计算当前路由根节点到叶子节点的最大深度与节点总数，当嵌套深度超过阈值（如 > 25 层）时在 APM 看板中给出黄色预警。
- **过度绘制染色热力图 (Overdraw Visualizer Layer)**：利用自定义 `CustomPainter` 与半透明着色图层（Stencil Buffer / BlendMode 模拟），对屏幕重叠渲染区域以经典色彩编码渲染：1x（原色）、2x（浅蓝）、3x（浅绿）、4x+（红/粉红），帮助开发者秒级定位无谓背景涂色与不必要重叠卡片。
- **RepaintBoundary 隔离建议指示器**：对高频更新但未包裹 `RepaintBoundary` 的 RenderObject 进行轮廓高亮，引导开发者就地完成渲染隔离优化。

---

### Opt-51. APM 异常丢帧现场堆栈关联与卡顿微秒级归因快照 (Jank Microsecond Trace Attribution & Call Stack Profiler Snapshot)

**状态**：📋 待排期 (Planned - 详见 [performance_panel_spec.md](performance_panel_spec.md))  
**现状**：当前 `FrameMonitor` 能精确捕获单帧 Build 与 Raster 超时（`isJank` / `isSevereJank`），并记录了当前发生卡顿的页面路由（`metric.routeName`）。然而，当帧耗时突增至 50ms~100ms 时，开发者只能获知“哪一个页面发生了卡顿”，但无法立刻得知“该卡顿究竟是由哪一段 Dart 耗时计算、JSON 反序列化，还是由哪一个特定的 ViewModel Intent 引发”，仍需依赖繁琐的全文搜索或插桩复现。  
**优化方案**：
- **Jank 现场微秒级快照捕获器 (Jank Trace Snapshotter)**：当 `FrameTiming` 判定 `isJank == true`（特别是 `totalSpan > 33.3ms` 严重卡顿）时，联动 `ZoneManager` 和 `PerfTraceStore` 自动提取在该卡顿帧物理时间窗口内（`[vsyncStart, vsyncStart + totalDuration]`）正在并发执行的活跃 `Intent` 与 Task。
- **高耗时调用链上下文绑定**：将最耗时的前 3 个异步任务及其阶段（如 `Api Call: 320ms`, `JSON Parse: 45ms`）作为 `FrameMetric.attribution` 结构化元数据附着于该帧记录上。
- **探针十字准星联动归因查看器**：在 `_FpsLineChart` 左右拖动锁定红点卡顿帧时，Tooltip 区域不仅展示页面名与耗时，进一步提供“查看现场归因”按钮，直接展开当时引发主线程卡顿的调用栈与 Intent 记录，实现秒级归因闭环。

---

### Opt-52. 基于 Dart Analyzer AST 的编译器级架构依赖图谱与导出穿透分析器 (Compiler-Grade AST Dependency Graph & Export Leakage Analyzer)

**状态**：📋 待排期 (Planned - 详见 [project_development_guide.md](project_development_guide.md))  
**现状**：当前 `tools/dependency_rules.dart` 依赖简单的逐行正则表达式字符串匹配（`RegExp(rule.pattern)`）进行依赖边界检测。这种轻量方案在绝大多数场景下执行迅速，但在以下边缘场景存在局限：1) 多行格式化的 `import` 语句或条件导入（`if (dart.library.io)`）；2) 模块间通过 `export 'xxx_impl.dart'` 间接向外泄漏内部实现类（导出穿透）；3) 无法精确推导类型别名（`typedef`）与隐式传递依赖。  
**优化方案**：
- **深度迁移至 Dart Analyzer AST 遍历器**：将 `dependency_rules.dart` 底层扫描引擎升级为基于官方 `package:analyzer` 的 AST 访问者模式（`RecursiveAstVisitor`），精确捕获 `ImportDirective` 与 `ExportDirective` 节点。
- **导出穿透与泄漏拦截 (Export Leakage Guard)**：检测公共 API 入口（如 `feature.dart` 或 `domain.dart`）是否非法导出了内部私有数据源或实现类（`_impl.dart`），防止边界防线被间接绕透。
- **高阶拓扑图谱与环路阻断 (Tarjan SCC & Graphviz/Mermaid Export)**：引入 Tarjan 强连通分量算法（SCC），在生成 `dependency_graph.json` 的同时输出工业级 Mermaid/DOT 拓扑图，秒级定位深层微环路。

---

### Opt-53. Custom Lint 分析服务端增量缓存与按需降级调度引擎 (Incremental AST Linting Cache & Analysis Server Daemon Optimization)

**状态**：📋 待排期 (Planned - 详见 [project_development_guide.md](project_development_guide.md))  
**现状**：当前主工程已在 `analysis_options.yaml` 中深度接入 `custom_lint` 插件，并激活了 15 条严格的 AST 规则（包括 MVI 纯洁度、Clean Architecture 依赖倒置、UI 组件收敛以及硬编码字符串/颜色拦截）。然而，在 IDE（VS Code / Android Studio）进行日常高频编辑保存时，`custom_lint` 守护进程频繁对全量语法树进行深层遍历，在低配机器或数十个文件同时改动时，容易引发 Dart Analysis Server 内存膨胀（> 1.5GB）及补全延迟（500ms~1000ms）。  
**优化方案**：
- **AST 签名增量缓存机制 (Content-Hash Incremental AST Cache)**：基于文件 SHA-256 内容哈希建立语法树缓存，当文件未变更或仅发生不影响导入与类型的空白改动时，跳过重复 AST 规则遍历，直接复用上一次分析结果。
- **规则分级与按需降级调度 (Tiered Rules & On-Save Throttle)**：将 15 条规则分为核心阻塞级（架构边界与空安全）与建议警告级（样式收敛与硬编码）；在 IDE 实时键入时仅运行轻量级规则，将全量 AST 深度检查降级至保存文件（On-Save）或 Git Pre-commit 阶段，彻底根除 IDE 补全卡顿与内存飙升。

---

### Opt-54. 远程可观测性日志云端聚合上报与分布式 Trace 端到端联动协议 (Remote Observability Collector & OpenTelemetry Compatible Trace Exporter)

**状态**：📋 待排期 (Planned - 详见 [project_philosophy.md](project_philosophy.md))  
**现状**：当前应用具备基于 `ZoneManager` 和 `LogManager` 的高保真本地日志与分布式 Trace 体系，并在 `LogOverlay` 中实现了 100 条环形缓冲区的就地下钻排障。然而，当前诊断数据完全局限于设备本地内存与本地沙箱文件系统，缺乏端到端上报与云端集中式检索能力。当真实生产环境下的外部用户发生偶发异常或闪退时，仍需依赖用户主动打开调试面板导出报告或提交 issue，无法实现主动式、无感知的故障雷达告警与跨端全链路追踪（Client -> Nginx -> Spring Boot MDC -> Trace Collector）。  
**优化方案**：
- **OpenTelemetry / W3C Trace Context 协议对齐**：将 `ZoneManager` 分配的 `traceId` 与 `X-Trace-Id` 升级为完全兼容 W3C TraceContext（`traceparent: 00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01`）标准格式，打通客户端与后端 Spring Boot 微服务分布式链路的统一标准。
- **批量压缩与低功耗退避上传引擎 (Batching & Gzip Telemetry Exporter)**：设计后台低优先级上报通道，针对 Error 级别日志与崩溃快照在冷启动自愈后自动触发上报；支持 SQLite 本地脱机持久化队列（容量上限 5MB）、数据 Gzip 高压缩比打包、仅在 Wi-Fi/非低电量模式下批量发送，规避移动端流量与电量消耗。
- **动态采样率与远程脱敏策略下发 (Dynamic Sampling & PII Redaction Engine)**：云端下发采样比率配置（如对 200 成功请求 1% 采样，对 5xx 与 Crash 100% 采样），并在上报前严格通过敏感词词典与正则规则对用户 Token、密码、邮箱进行全自动脱敏，符合 GDPR 与金融级合规要求。

---

### Opt-55. Safe Mode 崩溃熔断等级阶梯演进与动态诊断沙箱隔离 (Graduated Safe Mode Tiers & Diagnostic Sandbox Isolation)

**状态**：📋 待排期 (Planned - 详见 [project_philosophy.md](project_philosophy.md))  
**现状**：当前 `CrashManager` 采用二元判决机制（正常模式 vs 连续 3 次崩溃触发的 Safe Mode 阻断弹窗）。一旦触碰熔断阈值，应用会完全拦截核心视图树渲染并提示一键重置（清空全部 SharedPreferences 缓存）。这种“全有或全无”的激进熔断在极度恶劣的启动闪退下确实保障了应用可用，但存在两点改善空间：1) 重置粒度过于粗糙，将用户的合法持久化偏好（如主题、多语言、字体偏好）与损坏的数据缓存一同抹除；2) 如果崩溃并非由配置引起而是由某一特定子组件（如损坏的首页 Feed 流 JSON 或某个损坏的字体文件）触发，缺乏“模块级隔离降级”机制。  
**优化方案**：
- **三级渐进式熔断阶梯 (Three-Tier Graduated Resilience Matrix)**：
  - **Tier 1 (轻度降级 - 连续 1 次 Crash)**：保留用户偏好，仅清理非关键内存二级缓存与临时图片解码缓存，静默重新加载。
  - **Tier 2 (安全沙箱隔离 - 连续 2 次 Crash)**：自动降级为只读游客模式或本地离线 Mock 模式，禁用高风险的第三方动态插件与外部字体渲染，保留核心 UI 骨架。
  - **Tier 3 (阻断重置模式 - 连续 3+ 次 Crash)**：激活当前具备完整交互的 `SafeModeDialog`，并在重置界面提供“细粒度勾选擦除”（如：仅重置网络缓存/仅重置外观配置/深度恢复出厂设置）。
- **崩溃诊断隔离沙箱 (Crash Diagnostic Isolated Sandbox)**：在 `SafeMode` 激活时，自动将导致崩溃的最近一次堆栈、持久化配置镜像及 `ZoneManager` Trace 现场单独隔离拷贝至独立的 `crash_dump_sandbox.json`，确保即使用户执行了全量缓存清空，崩溃现场的核心排障证据依然能够持久保存并在恢复后安全提取。

---

### Opt-56. 动态通知频道分级治理与富媒体扩展呈现 (Dynamic Notification Channels & Rich Media Push Presentation)

**状态**：📋 待排期 (Planned - 详见 [push_notification_specification.md](push_notification_specification.md))  
**现状**：当前应用在 Android 侧仅注册了一个静态的高优先级通知频道（`AppConstants.notificationChannelId: listen_portfolio_updates`），且前台横幅仅展示标准文本标题与内容（`title` + `body`）。随着作品集项目后续增补系统运维告警、版本升级推送、互动评论与打赏反馈等多类型消息，单一频道无法满足用户在 Android 8.0+ 系统设置中对不同消息类型的细粒度开关诉求，且缺乏大图展开（BigPictureStyle）、操作按钮（Action Buttons）等商用级富媒体展示能力。  
**优化方案**：
- **多维度通知频道矩阵 (Multi-Channel Grouping)**：在 Android 侧按消息业务属性分化为 3 大独立频道：`updates_channel`（高优先级，带声音与悬浮横幅）、`social_channel`（中优先级，震动无声音）、`marketing_channel`（低优先级，仅静默展示在通知栏），赋予用户自主选择权。
- **富媒体通知渲染器 (Rich Media Push Renderer)**：在 `NotificationPayload` 中增补 `imageUrl`、`largeIcon` 与 `actionButtons` 字段；前台与后台接收到富媒体载荷时，利用 `flutter_local_notifications` 的 `BigPictureStyleInformation` 异步拉取并呈现高清项目封面或头像，并在横幅下方提供“立即查看”与“忽略”等快捷操作动作。
- **自定义通知铃声与呼吸灯配置 (Custom Sound & LED Indicator)**：针对重大版本更新或高危安全提示，允许绑定独立的无版权品牌音频资产，增强品牌辨识度。

---

### Opt-57. 推送 Token 离线刷新容灾队列与服务端用户会话对齐 (FCM Token Refresh Offline Sync & Server Session Binding Protocol)

**状态**：📋 待排期 (Planned - 详见 [push_notification_specification.md](push_notification_specification.md))  
**现状**：当前 `FirebaseNotificationServiceImpl` 监听了 `onTokenRefresh` 事件，但该事件触发后仅在本地控制台输出日志，尚未将刷新后的设备 Token 通过安全认证接口上报至后端微服务（`ListenPortfolioBackend`），也未与当前登录用户的 User ID 或设备指纹建立持久化绑定。当用户跨设备登录或 Token 在离线期间被 Google Play 强制轮转重置时，云端无法精准下发单播通知（1-to-1 Push），且在设备断网恢复后缺乏 Token 离线同步与重试机制。  
**优化方案**：
- **后端设备会话对齐接口 (Device Session Registration Endpoint)**：在 `ListenPortfolioBackend` 增设 `POST /v1/notifications/device-token` 鉴权接口，记录 `userId`、`deviceToken`、`platform`（Android/iOS/Web）及最后活跃时间戳。
- **离线持久化与指数退避上报队列 (Offline Sync & Exponential Backoff Uploader)**：在客户端构建轻量级 Token 同步状态机；当监听到 `onTokenRefresh` 发生时，将新 Token 标记为“待同步”并写入安全本地存储。在网络就绪或用户登录认证成功后自动触发上报；若遇网络抖动或 5xx 错误，按 2s/4s/8s 指数退避重试，确保 Token 100% 成功入库。
- **多端互斥与失效 Token 自动清洗 (Stale Token Eviction & Multi-Device Invalidation)**：当用户在新设备登录或主动执行退出登录（Sign Out）时，客户端通知服务端注销该设备 Token；服务端集成 FCM Batch API 并在收到 Google `UNREGISTERED` 或 `INVALID_ARGUMENT` 响应时自动剔除坏死 Token，杜绝资源浪费。

---

### Opt-58. 统一二级缓存治理引擎与基于 LRU/TTL 的本地持久化淘汰机制 (Unified Two-Level Cache Engine with LRU/TTL Eviction Policy)

**状态**：📋 待排期 (Planned - 详见 [repository_caching_strategy.md](repository_caching_strategy.md))  
**现状**：当前 `BaseRepository` 的 `safeCall` 管道已具备离线无网秒开、网络成功透明写入以及网络故障向 `CacheDataSource<T>` 降级的完整闭环。然而，当前具体的缓存实现（如 `ProjectsLocalDataSource`、`AboutMeLocalDataSource`）底层依赖轻量级 `SharedPreferences` 进行 JSON 字符串全量持久化。这种方案在小规模简单对象下表现轻便，但存在三大生产瓶颈：1) 缺乏统一的生存时限（TTL）与自动过期清理机制，陈旧脏缓存若长期未被覆盖将一直驻留磁盘；2) 缺乏总体容量配额与 LRU（最近最少使用）淘汰算法，当用户浏览大量包含长文本或 Base64 数据的项目后，易引发磁盘存储膨胀；3) 全量 JSON 编解码在列表数据较大时会在主线程造成额外 CPU 阻塞。  
**优化方案**：
- **引入带 TTL 与版本指纹的通用元数据缓存包装器 (CacheEnvelope<T>)**：将缓存数据统一包裹为 `{data: T, timestamp: int, ttlMs: int, schemaVersion: int}` 结构；在 `getCached` 读取时毫秒级自动判决过期态，一旦过期自动触发后台静默清理并返回 `null`。
- **基于 SQLite / Isar 的结构化二级缓存引擎 (Structured Storage Migration)**：将大体积业务数据从 SharedPreferences 迁移至嵌入式轻量数据库，支持异步非阻塞 I/O、按需分页读取与属性索引，彻底解除主线程 JSON 序列化卡顿。
- **全局缓存配额守护与 LRU 自动淘汰调度器 (LRU Cache Eviction Daemon)**：在应用启动或进入后台时，后台调度器扫描本地缓存目录，若总大小超过设定阈值（如 50MB），自动依访问频次与时间戳淘汰最旧的数据项；并在设置页面提供“一键清空网络缓存”的细粒度统计与清理动作。

---

### Opt-59. 动态简历访问审批流与敏感 PII 数据差异化脱敏引擎 (Dynamic Resume Access Approval Workflow & Differential PII Redaction Engine)

**状态**：📋 待排期 (Planned - 详见 [resume_security_auth.md](resume_security_auth.md))  
**现状**：当前应用在“关于我/简历”模块已具备基于 `GetResumeUseCase` 的 Markdown 加载与通过 `Printing.layoutPdf` 进行系统原生打印/分享导出的完整闭环。但在安全性上，当前简历内容通过公开路径拉取，对于电话、私人微信、邮箱及前司敏感情报缺乏差异化访问控制。任何安装 App 的访客均能直接查阅全部详细内容，存在个人隐私泄露与爬虫批量抓取风险。  
**优化方案**：
- **服务端授权状态机与申请单存储 (Backend Approval State Machine)**：在 `ListenPortfolioBackend` 创建 `resume_requests` 实体表与三套接口：`GET /v1/resume/status`（查询当前访客权限）、`POST /v1/resume/request`（提交公司/职位/目的申请单）、`GET /v1/resume/content`（权限鉴权下发）。
- **签名哈希一键审批邮件服务 (HMAC Signed One-Click Email Approval)**：当收到申请单时，服务端通过 SMTP / SendGrid 向作者推送包含一次性时钟签名链接的邮件；作者无需登录后台，点击邮件中的 Approve / Reject 按钮即可秒级变更访客权限。
- **客户端 MVI 权限横幅与差异化脱敏渲染 (Client Glassmorphic Access Banner)**：在客户端扩展 `ResumeState.accessStatus`（`none` / `pending` / `approved` / `rejected`）；未授权时展示毛玻璃提示卡片并渲染打码脱敏的演示简历（`resume_demo.md`），授权后平滑解锁真实简历与完整版高保真矢量 PDF 导出。

---

### Opt-60. Shorebird OTA 补丁下载进度可观测性与紧急热修即时重启引导 (Shorebird OTA Progress Telemetry & Immediate Restart Promotion Modal)

**状态**：📋 待排期 (Planned - 详见 [shorebird_code_push_guide.md](shorebird_code_push_guide.md))  
**现状**：当前 `ShorebirdServiceImpl` 的 `downloadUpdate()` 采取后台静默下载策略，一旦下载完成仅通过 `onPatchDownloaded` 回调向控制台输出日志，并向 UI 派发轻量级的 `MessageEffect`（告知“补丁将在下次启动时生效”）。但在以下两个生产场景中存在改善空间：1) 弱网或大补丁包下载过程中，缺乏细粒度的字节级下载进度（`Stream<double> progress`）可观测性，用户在设置页面点击检查更新后无法感知后台是否在传输；2) 遇到致命线上 Crash 或支付漏洞时，必须等待用户完全关闭杀进程后再次冷启动才能生效，缺乏“紧急补丁即刻热重启（Force Restart Modal）”的强触达机制。  
**优化方案**：
- **补丁下载进度流与 APM 耗时归因 (Patch Progress Stream & APM Telemetry)**：在 `IShorebirdService` 扩充 `Stream<double> get onDownloadProgress`，并在 `SettingsPage` 呈现环形进度条或百分比文本；联动 `LogManager` 与 APM 探针记录补丁下载时延与吞吐率。
- **分级热修即时重启引导弹窗 (Immediate Restart Promotion Dialog)**：引入补丁紧急等级标识（`critical` vs `normal`）；当下载到紧急高危补丁时，弹出防阻断交互模态框：“检测到关键安全热修复补丁已就绪，建议立即重启应用以消除隐患 [立即生效] [稍后手动重启]”；点击立即生效利用系统通道安全拉起热重启。
- **CI/CD 多通道补丁灰度追踪 (Multi-Track Canary Patch Delivery)**：在 GitHub Actions 流水线中支持传入 `--track canary | beta | stable`，支持在作者内部测试机率先验证热修补丁稳定性后，再一键提升至全量轨道。

---

### Opt-61. 技能雷达图多维度岗位对比基准线与高保真矢量 SVG 导出 (Interactive Role Benchmark Overlay & Vector SVG Radar Export)

**状态**：📋 待排期 (Planned - 详见 [skills_radar_chart_design.md](skills_radar_chart_design.md))  
**现状**：当前 `SkillsRadarChart` 能够以正六边形自绘网络与极坐标动画优雅展现候选人的 6 维能力得分。然而，当前雷达图仅展示了候选人单一维度的绝对分数，缺乏与业界资深架构师（Staff / Principal Engineer）或特定岗位画像的基准线对比（Benchmark Line）。在技术面试评估场景下，面试官难以直观对比“候选人实际模型 vs 岗位期望模型”。此外，当前雷达图仅能在客户端交互渲染，无法一键导出为矢量 SVG 或透明 PNG 图片供技术分享或简历外发。  
**优化方案**：
- **多层数据多边形与虚线基准轮廓 (Dual-Polygon Benchmark Overlay)**：支持在雷达图上叠加次级基准图层（例如：通过虚线 `dashPath` 绘制期望基准能力模型），形成双层对比多边形；并在触摸点击时联动显示相对偏离度（如 `+12% vs Senior Benchmark`）。
- **极坐标平滑曲线拟合 (Catmull-Rom Polar Spline)**：提供传统折线多边形与平滑贝塞尔圆角弧线两种渲染模式，使数据包络面更具视觉张力与科技感。
- **自绘 Canvas 矢量 SVG / PNG 离线渲染导出器 (Vector Export Pipeline)**：封装 `RadarImageExporter`，基于 `PictureRecorder` 与 `toImage()` 异步将雷达图离线光栅化为 4K 高清透明图片或生成 W3C 标准 SVG 矢量字符串，支持一键保存至相册或复制到剪贴板。

---

### Opt-62. CI 自动化覆盖率差分门禁与增量代码覆盖率阻断器 (CI Differential Coverage Gate & PR Patch Coverage Enforcer)

**状态**：📋 待排期 (Planned - 详见 [test_coverage_report.md](test_coverage_report.md))  
**现状**：当前主工程覆盖率已达到 77.53%（6,196 / 7,992 行），且有 `tools/calculate_coverage.dart` 准确过滤生成文件并输出各模块指标。然而在 GitHub Actions CI 流水线中，覆盖率仅作为控制台日志打印输出，尚未建立刚性门禁。当开发者提交新的 Pull Request 时，如果新增代码缺乏单测（Patch Coverage 极低），或者无意删除了关键用例导致整体覆盖率下滑，CI 无法自动拦截；同时缺乏自动在 PR 评论中生成可视化的覆盖率差分报告（Coverage Diff Summary），阻碍了代码审查效率。  
**优化方案**：
- **增量补丁覆盖率刚性门禁 (PR Patch Coverage Gate >= 80%)**：在 CI 中引入 `diff-cover` 或自研 Dart 脚本，提取 `git diff origin/main...HEAD` 变动行并映射至 `lcov.info`，若 PR 新增/修改的可执行代码行覆盖率低于 80%，CI 立即亮红牌阻断合并。
- **总覆盖率防衰减下限检查 (Zero-Coverage-Drop Guard)**：对比基准分支（main）与 PR 分支的总覆盖率，允许浮动阈值 $\le 0.1\%$，防止存量核心模块被静默稀释。
- **PR 自动化覆盖率徽标与 Markdown 差分卡片评论 (PR Coverage Bot Comment)**：通过 GitHub Actions 自动将模块覆盖率变化（如 `features/auth: 88.92% (+1.2%)`）以高保真 Markdown 表格与状态徽标（Coverage Badge）形式发布在 PR 讨论区，提升团队工程透明度。

---

### Opt-63. 自动化内存泄漏探测与微秒级渲染性能回归门禁 (Automated Memory Leak Detector & Render Benchmark Performance Gate)

**状态**：📋 待排期 (Planned - 详见 [testing_guide.md](testing_guide.md))  
**现状**：当前全工程 589 项测试专注于“逻辑正确性”（Functional Correctness），例如 Intent 状态机流转、异常降级、SpUtil 本地缓存落地与 Widget 树元素断言。然而，对于核心路径的微秒级渲染耗时基线（Micro-Benchmarks）与 ViewModel / StreamController 内存泄漏缺乏自动化回归检测手段。若开发者在 `build()` 周期中无意引入高开销正则表达式重复编译、超长大列表无缓存映射，或在页面退出后遗漏取消 `StreamSubscription`，功能性测试依然 100% 绿灯，但在低端设备上会造成严重的帧率下跌（Jank）与内存常驻膨胀。  
**优化方案**：
- **ViewModel 与控制器内存泄露自动化探测器 (Memory Retention & Leak Tracker)**：利用 Dart 弱引用（`WeakReference`）与垃圾回收探针（`leak_tracker`），在 Widget 测试中执行页面 `pop()` 或 ViewModel `dispose()` 后，主动触发强制 GC 并断言目标实例是否在 500ms 内被顺利析构；若发现强引用残留，测试立即抛出 `MemoryLeakException` 阻断。
- **微秒级渲染时延基线测试 (Headless Widget Render Micro-Benchmark)**：针对高频核心卡片（`SkillsRadarChart`、`AiChatMessageList`、`ProjectsWidget`），在测试中执行 100 次连续重绘并统计平均 `build()` 耗时；若单次构建耗时突破 8ms（60FPS 预算的 50%），测试自动预警，防止性能劣化。
- **CI 性能基线防衰退差分对比 (Automated Performance Diff Pipeline)**：将基准渲染时延与内存分配指标沉淀至基线文件，在 CI 中对比 PR 分支与主干分支的性能抖动，一旦劣化幅度超过 10%，自动在 PR 留言提出优化警示。

---

### Opt-64. Flutter / Dart 废弃 API 自动化迁移检测器与跨版本 SDK 静态巡检脚本 (Automated Deprecated API Modernization Linter & Multi-Version SDK Auditor)

**状态**：📋 待排期 (Planned - 详见 [upgrade_flutter_3_44_1.md](upgrade_flutter_3_44_1.md))  
**现状**：在主工程平稳升级至 Flutter 3.44.1 (Dart 3.12.1) 后，团队手动完成了 `Color` 宽色域浮点转换、Built-in Kotlin 移除冗余 KGP 以及与 `listen_core` (0.0.53) 的三方 Plus 插件版本对齐。然而，随着后续 Flutter 3.47+、4.0 的持续演进，依赖人工肉眼查阅官方 Release Notes 巡检控制台告警耗时费力且容易遗漏（例如未及时迁移的 `withRed/withGreen/withBlue`、`PopScope` vs `WillPopScope` 等渐进废弃项）；在 CI 中也缺乏针对已废弃（`@deprecated`）API 的增量门禁，容易将过时语法带入新功能分支。  
**优化方案**：
- **基于 AST 的废弃 API 自动化巡检与一键重写工具 (`tools/modernize_flutter_apis.dart`)**：基于 `package:analyzer` 扫描语法树，自动检测并支持一键将遗留的 `withOpacity(a)` 转换为 `withValues(alpha: a)`、将旧式属性与构造器一键 AST 重写为 Flutter 3.44+ 推荐规范。
- **CI 增量废弃成员警告刚性门禁 (Zero Deprecation Warning Policy for New PRs)**：在 PR 校验流水线中解析 `flutter analyze` 输出，若 Pull Request 引入了新增的 `deprecated_member_use` 警告，自动亮起黄牌并在 PR 评论中直接指出推荐替代 API。
- **Android Gradle Plugin 与 Built-in Kotlin 矩阵兼容度自动扫描**：在升级 Gradle 或 AGP 时，自动化脚本核验 `gradle.properties` 的 `android.builtInKotlin=true`、`android.newDsl=true` 以及 Kotlin 2.2+ / Java 17 的双向兼容性，提前规避 Android 编译配置雪崩。

---

### Opt-65. 原生 C/C++ Native Crash (SIGSEGV/SIGBUS) 捕获与 Tombstone 增量符号化归档管线 (Native Breakpad/Crashpad Signal Trap & Tombstone Symbolication Pipeline)

**状态**：📋 待排期 (Planned - 详见 [project_philosophy.md](project_philosophy.md))  
**现状**：当前 `CrashManager` 专注于捕获 Dart VM 层面的未捕获异常（通过 `PlatformDispatcher.instance.onError` 与 `Zone.current.handleUncaughtError`）。然而，当发生原生 C/C++ 层的严重段错误（如 Linux 信号 `SIGSEGV`、`SIGBUS`、`SIGFPE`，常见于 Flutter 引擎底层 Impeller 渲染崩溃、JNI 内存越界或第三方 SO 库崩溃）时，操作系统会直接强杀进程，Dart 层的 `CrashManager` 完全无法收到回调，也无法将崩溃日志持久化到本地沙箱。  
**优化方案**：
- **原生 Linux 信号监听陷阱 (Native Signal Trap via Breakpad/NDK)**：在 Android 侧通过轻量 NDK 库注册 `sigaction` 捕获 `SIGSEGV`、`SIGABRT` 与 `SIGBUS`；在崩溃瞬间（Crash Handler），使用 async-signal-safe 信号安全函数将当前线程调用栈（PC/LR 寄存器与动态库内存映射表 `/proc/self/maps`）紧急导出至磁盘沙箱 `native_crash.dump`。
- **冷启动原生崩溃自愈探针 (Cold Launch Native Tombstone Harvester)**：在下一次冷启动时，Dart 层的 `CrashManager` 检测该 dump 文件，若发现存在未处理的 Native Crash，同样计入崩溃熔断计数器并激活 Safe Mode，杜绝底层原生崩溃导致的死循环。
- **CI/CD 增量符号化工具链 (NDK Stack Symbolication)**：在服务端或本地编写 `ndk-stack` 包装脚本，结合构建时留存的带符号表 `.so` 库，自动将原始 PC 地址还原为精确的 C++ 源码文件与行号，达成全栈深度排障闭环。

---

### Opt-66. 基于后台静默推送 (Data Messages / Silent Push) 的本地离线缓存增量预同步引擎 (Background Silent Push & Cache Warm-Up Pipeline)

**状态**：📋 待排期 (Planned - 详见 [push_notification_specification.md](push_notification_specification.md))  
**现状**：当前应用主要依托带有前台/通知栏 UI 载荷（`notification: {title, body}`）的显式通知。当云端有新项目发布或简历更新时，用户必须手动点击通知栏横幅拉起 App 后，客户端才开始发起 HTTP 请求从零拉取数据；在弱网或网络抖动环境下，用户仍需面对 1~2 秒的骨架屏等待。此外，纯数据消息（Silent Push / Data-only message with `content_available: true`）受限于后台独立 Isolate 的生命周期与资源约束，目前尚未打通后台静默预热落盘通道。  
**优化方案**：
- **后台隔离区静默处理器 (FirebaseMessaging.onBackgroundMessage)**：注册纯静态/顶级后台回调函数，在应用处于后台休眠时接收高优先级静默数据推送（`priority: high`, `content_available: true`），完全不打扰用户弹窗。
- **离线缓存后台静默预热 (Background Cache Warm-Up)**：后台 Isolate 唤醒后，直接调度轻量 `ProjectsLocalDataSource` 与 `SpUtil` 将推送载荷中携带的项目增量 JSON 直接落盘持久化，或由后台微任务静默向后端拉取差分数据。
- **冷热启动 0 毫秒即开即看 (Zero-Latency Rendering)**：当用户随后主动点击桌面图标或通知打开 App 时，最新数据已就绪命中本地一级缓存，实现 0 毫秒无感秒开，彻底消除弱网白屏与骨架屏等待感。

---

### Opt-67. 仓储层并发请求合并 (SingleFlight) 与 L1/L2 多级响应式缓存流 (In-Flight Request Coalescing & Reactive L1/L2 Cache Stream)

**状态**：📋 待排期 (Planned - 详见 [repository_caching_strategy.md](repository_caching_strategy.md))  
**现状**：当前 `BaseRepository.safeCall` 管道在离线降级与透明持久化方面运行稳健，但在高并发交互与多组件联动时仍存在三大进阶瓶颈：1) **缺乏请求合并（SingleFlight）防击穿机制**：当多个 ViewModel（例如 OverviewViewModel 与 ProjectsViewModel）在同一时刻并发调用 `getProjects()`，或用户快速重复触发下拉刷新时，底层会并发向 Dio 发起多次完全相同的 HTTP 请求，造成网络流量浪费并对服务端施加无谓压力；2) **缺乏 L1 内存热缓存层**：每次读取即便命中本地，也必须经过 `SpUtil` 进行完整的磁盘 I/O 与 `jsonDecode` 反序列化，高频访问下在主线程造成额外的 CPU 算力开销；3) **缺乏响应式缓存变更感知流**：当前 `CacheDataSource` 仅暴露单次 `Future<T?> getCached()`，当某个后台任务（如 FCM 静默推送、后台同步）更新本地缓存时，挂载在屏幕上的其他页面无法自适应响应更新。  
**优化方案**：
- **SingleFlight 并发请求合并器 (In-Flight Request Deduplication)**：在 `BaseRepository` 引入轻量级并发映射表 `Map<String, Future<Either<Failure, dynamic>>> _inFlightRequests`；当探测到相同业务语义的请求正在空中传输时，后续调用直接复用现有 `Future`，待完成后广播分发，彻底杜绝并发网络风暴。
- **L1 In-Memory LRU 热缓存层 (Zero-Cost Memory Cache)**：在 `CacheDataSource` 磁盘持久化（L2）之上引入带有微超时（如 30s TTL）的内存对象缓存，直接以强类型 Dart 对象形式返回，将首屏重复读取耗时从毫秒级进一步压降至微秒级（0 CPU 反序列化开销）。
- **响应式缓存变更广播流 (Reactive Stream / Event Bus Channel)**：扩展 `CacheDataSource<T>` 接口，增加 `Stream<T> watchCached()` 方法；底层数据回写更新时自动向订阅流推送最新实体，驱动 UI 实现类似 Room / CoreData 的声明式自愈刷新。

---

### Opt-68. 动态简历时钟溯源水印 (Forensic Watermark) 与 CJK 矢量字体零乱码排版引擎 (Zero-Tofu CJK Vector Font & Forensic Watermark Pipeline)

**状态**：📋 待排期 (Planned - 详见 [resume_security_auth.md](resume_security_auth.md))  
**现状**：当前应用在“关于我/简历”模块已具备 Markdown 解析与调用系统原生打印生成矢量 PDF 的能力。但在实际跨设备与敏感隐私防护场景下存在两大改进空间：1) **跨平台 CJK 字体缺失风险（Tofu 豆腐块现象）**：目前 HTML 模板依赖客户端操作系统预装的系统字体（`-apple-system`, `PingFang SC`, `Microsoft YaHei`）。当用户在精简版 Linux/Android 模拟器或缺少中文默认字库的海外版 Android 设备上导出 PDF 时，`Printing.convertHtml` 会因找不到字形而将中日文字符渲染为方块乱码（Tofu）；2) **缺乏泄露溯源水印与截屏保护机制**：简历包含核心项目、经历评价与技能评级等敏感情报，当前屏幕渲染及导出的 PDF 均为无水印纯净版；一旦被未经授权的第三方截图或传播，作者无法溯源泄露源头与时间戳。  
**优化方案**：
- **CJK 动态矢量子集化字库嵌入 (Zero-Tofu Font Injection)**：在 `PrintPdfProviderImpl` 中集成 Google Fonts 或本地轻量 Noto Sans SC/JP 矢量字体，通过 CSS `@font-face` 直接将 Base64 或本地文件字体注入 HTML 头部，确保任何无中文字库的极端设备均能 100% 像素级忠实渲染。
- **全景半透明平铺动态时钟防伪水印 (Forensic Dynamic Watermark)**：在 HTML 打印模板以及 Flutter UI 界面上层叠加半透明旋转倾斜（-25度）的动态水印矩阵，内容由当前访客账号标识、设备指纹及精确到秒的 UTC 时钟哈希（如 `Visitor: ID-8842 | 2026-09-12 20:30 UTC | Confidential`）动态生成，即便遭遇截图或拍摄也能精准定位泄露源头。
- **敏感窗口防截屏与录屏拦截 (FLAG_SECURE Toggle)**：集成安全窗口控制器，当简历处于未授权模式或特定保密等级时，调用原生安全通道激活 Android `FLAG_SECURE` 与 iOS 录屏遮挡遮罩，从操作系统层严防物理截屏。

---

### Opt-69. 热修补丁毒化自愈熔断 (Patch Crash-Loop Auto-Rollback) 与 Wi-Fi 控流下载引擎 (Crash-Loop Safeguard & Network-Aware Patching)

**状态**：📋 待排期 (Planned - 详见 [shorebird_code_push_guide.md](shorebird_code_push_guide.md))  
**现状**：当前应用已建立完整的 `IShorebirdService` 抽象层与后台静默更新下载机制。但在以下两类生产极端边界条件下仍有进一步加固空间：1) **毒化补丁死锁循环（Poisoned Patch Crash-Loop）**：若发布的补丁在特定机型或特定 OS 版本上引发首屏或启动阶段的未捕获崩溃，应用每次重启后都会重新加载该故障补丁，可能导致用户彻底陷入无限崩溃死循环，无法进入主界面或设置页面进行自愈；2) **蜂窝移动流量消耗无限制**：在野外弱网或国际漫游场景下，大体积补丁（如包含较多资源或大型类重构的 10MB+ 差分包）会在移动蜂窝网络下静默下载，可能消耗用户高额流量费用，缺乏“仅在 Wi-Fi 下下载补丁”的用户偏好控制。  
**优化方案**：
- **热修健康度探针与连崩自动回滚 (Patch Health Sentinel & Auto-Rollback)**：联动 `CrashManager` 与 `SafeMode`；记录补丁激活后的启动计数与存活时长（如启动后 15 秒内无崩溃即标记为健康）。若检测到应用在加载 Patch #N 后连续发生 2 次未捕获崩溃，立即触发熔断机制，调用底层通道清除本地有毒补丁（Rollback to Base Store Release），回退至干净基准包并向 APM 上报毒化告警。
- **Wi-Fi 网络类型感知与断点控流策略 (WiFi-Only Policy Guard)**：在 `SettingsPage` 提供“仅允许在 Wi-Fi 下自动下载热修补丁”开关；在 `downloadUpdate()` 前置探测网络类型（`ConnectivityResult.wifi`），若处于蜂窝移动数据则仅标记 `updateAvailable` 并提示用户确认，避免资费争议。

---

### Opt-70. 技能雷达图平滑极坐标样条插值拟合 (Catmull-Rom Polar Spline) 与交互式动态能力推演沙盒 (Interactive Skills Simulation Sandbox)

**状态**：📋 待排期 (Planned - 详见 [skills_radar_chart_design.md](skills_radar_chart_design.md))  
**现状**：当前 `SkillsRadarChart` 能够以 Canvas 绘制 6 维线段连接多边形（`lineTo` 折线连接），并通过极坐标点击拾取对应维度。然而在高端视觉表现与深度交互场景下，仍有进一步演进空间：1) **折线多边形视觉略显生硬**：相邻顶点分数落差较大时（如 97 分与 84 分），直线折角过渡较为突兀，缺乏现代前沿科技风格的平滑曲面张力与有机拟合（Smooth Organic Spline）；2) **缺乏交互式能力推演沙盒 (What-If Simulation Sandbox)**：当前雷达图仅能单向展示作者既定分数，面试官或用户无法直观进行“若该岗位需要将 DevOps 提升至 95 分、或将 Backend 调整为 90 分时的综合匹配度推演”；3) **缺乏微交互触觉与音效反馈**：滑动或切换维度时仅依赖屏幕重绘，缺乏多模态微震动触觉引导。  
**优化方案**：
- **极坐标闭合 Catmull-Rom / Hermite 平滑曲线拟合 (Polar Smooth Spline)**：在 `_drawDataPolygon` 中实现三阶贝塞尔极坐标样条插值算法；在闭合多边形相邻顶点间自动推导切线控制点，将直线轮廓平滑升级为有机曲面水滴/气泡包络态，并提供平滑曲面与经典棱角多边形双模式一键切换。
- **交互式顶点拖拽推演沙盒 (Interactive Simulation Sandbox)**：支持在沙盒调试模式下长按顶点沿轴线向外/向内动态拖拽调整分数，动态计算并展示“调整后综合评分”与“岗位匹配度余弦相似度（Cosine Similarity Index）”；配备“恢复作者真实评分”重置动作。
- **微模态触觉反馈集成 (Haptic Feedback Ticks)**：在手势跨越不同扇区或拖拽数值跨过 60/80/90 等关键评级分水岭时，触发系统微触觉震动（`HapticFeedback.selectionClick()`），增强触控物理质感。

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

项目目前已全面实现并跑通以下 **35 项关键能力与技术基石**（全量 589 项测试 100% 绿灯，纯净代码覆盖率达 **77.53%**，静态分析零警告）：

1. **Clean Architecture + MVI 模式**：基于 `BaseViewModel`、`BaseState`、`BaseEffect` 构建，彻底解耦 UI 与状态机。
2. **401 并发等待与静默重试队列**：Dio 拦截器捕获 Token 失效，单例排队刷新并一键批量重发请求。
3. **安全注销与 Token 防泄露**：登出前时间戳校验，过期则静默刷新后再通知服务端彻底销毁会话。
4. **全链路 Zone Tracing**：基于 Dart `Zone` 上下文为每次 Intent、路由跳转与 HTTP 请求注入全局唯一 `traceId`。
5. **Crash Safe Mode 熔断自愈**：连续崩溃检测与安全模式拦截，支持本地 crash log 持久化与一键重置。
6. **APM 性能监控看板 (LogOverlay)**：动态 Vsync 帧时延监测、FPS 滑动窗口滤波、Jank 分类、十字准星探针与 Net Inspector。
7. **启动耗时监控 (Launch Monitor)**：冷启动分段时延统计，50 条 FIFO 本地基线与回归预警。
8. **故障注入演练场 (Fault Injection Playground)**：7 大受控演练场景（401并发、500契约、超时、畸形数据、Zone异常、SafeMode、主线程Jank），支持一键 Trace 下钻。
9. **交互式技能雷达图 (Skills Radar Chart)**：`CustomPainter` 自绘 6 维多边形、防截断钳位算法，卡片左右滑动与雷达图双向手势联动（详见 [skills_radar_chart_design.md](skills_radar_chart_design.md)）。
10. **多语言自动路由 (LocalMockServer & Spring Boot)**：请求头注入 `Accept-Language`，支持中/英/日多语言动态下发与自动回退，零硬编码。
11. **动态主题与外观字体族**：跨平台 5 大通用字体族矩阵，`SettingManager` 全局热重构，内置实时 `Aa` 字体徽标预览（详见 [appearance_font_family_specification.md](appearance_font_family_specification.md)）。
12. **强类型路由与 Deep Link 整合**：原生 Scheme 匹配、`replaceIfExists` 路由去重与 Single UI Binder 防双弹窗机制（详见 [deep_link_routing_design.md](deep_link_routing_design.md)）。
13. **Google Play 延迟深度链接 (Deferred Deep Link)**：基于 `InstallReferrerClient` 原生通道，支持 90 天时钟去重、脏数据清洗与落地页 `test.html` 验证（详见 [deferred_deep_link_specification.md](deferred_deep_link_specification.md)）。
14. **Firebase AI 智能咨询助手**：官方 `firebase_ai` (`gemini-3.7-flash`) + Firebase App Check 强安全防护，可拖拽悬浮球与本地预设 FAQ 检索（详见 [ai_intro_assistant_spec.md](ai_intro_assistant_spec.md)）。
15. **Firebase 推送通知 (FCM)**：前台横幅、后台唤醒与冷启动路由统一调度，通知开关联动系统权限引导（详见 [push_notification_specification.md](push_notification_specification.md)）。
16. **应用内评分引导 (ReviewService)**：启动计数（5次）与 90 天控流策略，支持打赏成功后黄金时机拉起评价（详见 [iar_implementation_design.md](iar_implementation_design.md)）。
17. **应用内打赏购买 (IAP)**：Clean MVI 架构、`CoffeePurchaseProviderImpl` 解耦支付业务（详见 [iap_implementation_design.md](iap_implementation_design.md)）。
18. **Shorebird OTA 热更新**：集成官方代码热修复服务，支持增量补丁非阻塞下载与版本拼接展示（详见 [shorebird_code_push_guide.md](shorebird_code_push_guide.md)）。
19. **商用级 `CommonWebView`**：支持弹窗自适应高度、手势重定向拦截与暗黑/浅色自适应主题。
20. **Google Play 合规性数据注销页**：提供合规的在线账户数据注销表单与邮件唤起通道。
21. **Spring Boot 后端核心微服务**：Auth + Portfolio CRUD + 6 维 Skills 多语言 API 全量落地，MyBatis-Plus + Redis 缓存架构。
22. **AWS EC2 容器化部署**：Docker Compose + Nginx 80 端口同源反代，彻底消除浏览器跨域与 OPTIONS 预检（详见 [flutter_web_aws_deployment_guide.md](flutter_web_aws_deployment_guide.md)）。
23. **错误契约统一体系**：`Failure` 领域模型与 `messageId` 前后端契约规范，客户端自动映射 i18n 多语言文案（详见 [error_codes_reference.md](error_codes_reference.md)）。
24. **自动化版本流与检查更新**：CI 提取 `pubspec.yaml` 自动生成 `version.json`，客户端免签安全解析与更新日志弹窗。
25. **架构依赖边界治理**：基于 `tools/dependency_rules.dart` 自动化校验架构单向依赖规则，零违规保障（详见 [custom_lint_rules.md](custom_lint_rules.md)）。
26. **自动化 API 文档生成**：配置 `dartdoc` 并通过脚本部署至 GitHub Pages（详见 [documentation_generation.md](documentation_generation.md)）。
27. **全自动化 CI/CD 流水线**：GitHub Actions 自动执行分析、运行 589 项测试、构建签名 Release AAB 并发布至 Google Play Internal 通道。
28. **全量测试套件保障**：**589 项** 自动化测试 100% 绿灯通过，代码覆盖率达 **77.53%**（涵盖 103 个测试文件，6,196 / 7,992 行纯净代码覆盖，详见 [test_coverage_report.md](test_coverage_report.md) 与 [testing_guide.md](testing_guide.md)）。
29. **原生跨栈项目资产打通 (ListenExpenseTracker)**：增补 Project ID 6，打通本地中/英/日三语 Mock 与云端 AWS MySQL 生产库（Flyway V3 迁移）。
30. **头像数据流安全防腐与高弹性渲染**：`CommonImage` 异步解码错误隔离（`errorBuilder`）、`Base64ImageCache` 复合指纹 Key 优化、Web/HTTP 存储平滑降级，彻底根除 UI 假死与 Event Loop 饿死风险（详见 [avatar_security_and_rendering_architecture.md](avatar_security_and_rendering_architecture.md)）。
31. **云端 Docker 孤儿构建层自动深度清理引擎**：基于 GraphDriver 依赖拓扑反查，彻底解决 EC2 磁盘构建层雪崩堆积问题。
32. **简历 Markdown 动态解析与高保真矢量 PDF 导出**：基于 `GetResumeUseCase` 与 `Printing.layoutPdf` 实现商用级矢量 PDF 生成、系统打印与跨应用分享，会话登出时自动注销清理凭证（详见 [resume_security_auth.md](resume_security_auth.md)）。
33. **Shorebird OTA 热更新双向通信与状态机**：集成官方热修引擎，构建 8 状态响应式状态机，支持非阻塞后台下载与运行时动态补丁版本拼接展示（详见 [shorebird_code_push_guide.md](shorebird_code_push_guide.md)）。
34. **Flutter 3.44.1 与 Built-in Kotlin 现代工具链全面升级**：Wide Gamut 宽色域浮点色彩重构、移除冗余 KGP、对齐 AGP 8.11.1、Kotlin 2.2.20 与 Java 17，解决 win32 ^6.0.1 跨平台依赖冲突（详见 [upgrade_flutter_3_44_1.md](upgrade_flutter_3_44_1.md)）。
35. **无头测试环境平台通道拦截与 SVG 图像解码桩**：`setupTestEnvironment` 接管 MethodChannel 二进制通信与 HttpOverrides 图像解码，保证 589 项测试在 Linux CI 环境毫秒级无头稳定运行（详见 [testing_guide.md](testing_guide.md) 与 [test_coverage_report.md](test_coverage_report.md)）。

---

## 💡 Idea Pool Backup (想法池备份)

- 探索 `talker_flutter`、`storybook_flutter`、`pubviz` 等生态工具在开发期调试中的深度结合。
- 自动化执行 Patrol E2E 测试时，每步 Intent 操作自动截取屏幕并导出归档。
- 布局层级过深检测与过度绘制警告探针。