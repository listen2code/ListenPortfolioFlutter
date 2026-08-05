## TODO

说明：

- 本文件只保留执行路线，不再作为“想法池”堆叠所有可能性
- README.md 只描述当前已实现能力；未来方向、设计稿和探索项统一在此管理

## Now

### 1. 文档与实现继续对齐

**状态**：✅ 已完成（2026-04-09）  
**现状**：README 已开始按"现状 / 目标态"分离，但其他文档仍存在历史表述偏理想化的问题。  
**目标**：确保 README、`docs/`、代码实现三者不再互相打架。  
**为什么现在做**：这是当前最影响项目可信度的问题。  
**验收标准**：主文只描述已落地能力；设计性内容下沉到 `docs/`；过时表述放入待删除备份区。

**已完成项**：
- Backend: `security_features.md`, `development_setup.md` 已修订
- Flutter: `testing_guide.md`, `mock_data_specification.md` 已修订
- README.md 已遵循"主文只描述已落地能力"原则

**注意**：后续如有新增文档或代码变更导致不一致，需重新激活此任务。

### 2. Flutter / Backend API 契约收口

**状态**：✅ 已完成（2026-04-09）  
**现状**：主流程已可联调，但仍有字段与模型边界未彻底收口。  
**目标**：完成 Flutter mock、真实后端响应、客户端 model 的最终一致性。  
**为什么现在做**：真实 App 优先，前后端契约必须先稳定。  
**验收标准**：Flutter dev 环境请求后端时，无解析异常、无字段歧义、无 mock/real 双标准。

重点项：

- `ProjectDto.businessId` 的客户端适配
- `StatDto.id` 与 `businessId` 的最终映射策略
- `messageId` 的真实落地边界

**已完成项**：
- `auth_remote_data_source.dart`: `refreshToken` 从 `@Field` 改为 `@Query`，对齐 Backend `@RequestParam`
- `auth_remote_data_source.g.dart`: 手动更新生成代码，通过 query parameter 发送
- `projects.json`: 添加 5 个项目的 `businessId` 字段，与 Backend migration 种子数据一致
- `user.json`, `projects.json`, `aboutMe.json`: `message` 字段从 `"success"` 改为 `""`，对齐 Backend `ApiResponse.success()`
- Flutter 模型（`ProjectModel`, `AboutMeStatModel`）与 Backend DTO 字段已一致

**注意**：后续如有新增 API 或字段变更导致不一致，需重新激活此任务。

### 3. 错误契约落地

**状态**：✅ 已完成（2026-06-14）  
**现状**：已打通从“网络数据层错误码（`messageId`）”到“用户层友好文案（`tr`）”的翻译与阻断通道。  
**目标**：先把最核心的错误码与错误文案映射能力做成真实代码能力。  
**为什么现在做**：这直接影响跨端一致性、可维护性与后续框架沉淀。  
**验收标准**：在宿主 App 中拦截并映射 `Failure` 变体，支持多语言动态翻译与回退机制，并在 ViewModels 中统一引入，且通过了完整的测试校验。


### 4. 测试补强

**状态**：✅ 已完成（2026-06-14）  
**现状**：已补齐并加固了最容易出错的核心链路，完成了单元测试和端到端测试闭环。  
**目标**：优先补强最容易出错的核心链路。  
**为什么现在做**：没有测试，很多“框架优势”都只是口头优势。  
**验收标准**：已新增并稳定运行以下测试：

- `_AuthInterceptor` 401 并发队列测试 (在 `auth_interceptor_test.dart` 中完全覆盖并跑通)
- `CrashManager` Safe Mode 管道测试 (在 `crash_manager_test.dart` 中完全覆盖并跑通)
- i18n key 完整性测试 (在 `i18n_test.dart` 中实现 Key 与 Translation-Map 比对并完全跑通)
- E2E 自动化集成测试 (已在 `integration_test/app_test.dart` 中跑通，覆盖异常输入格式验证与正常登录/登出业务闭环流)

### 5. 可观测性闭环 MVP

**状态**：✅ 已完成（2026-07-09）  
**现状**：性能指标、错误码、日志与网络请求及崩溃日志已完美闭环。  
**目标**：先完成性能指标面板、`traceId` 钻取能力、Crash / error / trace 关联与轻量 Net Inspector。  
**为什么现在做**：这是项目的核心竞争力所在。  
**验收标准**：完成性能指标面板、`traceId` 钻取能力、Crash / error / trace 关联与轻量 Net Inspector。
- **性能指标面板**：支持动态 Vsync 帧时延监测、十字准星手势拖拽、Tooltip 悬浮窗、页面路由绑定及收起态迷你图表免缓存自动刷新与视口高度动态自适应。
- **轻量 Net Inspector**：Dio 拦截并审计所有的 HTTP 流量（ headers/payloads），100 条 FIFO 环形队列防内存泄露。
- **Crash / Logs / TraceId 联动下钻**：崩溃日志在落盘时自动写入 Trace ID 与当前路由；崩溃详情展示弹窗内置 “Drill Logs” 按钮，点击一键唤起日志悬浮框、强切 Logs Tab 并利用 Trace ID 精确过滤出崩溃前的用户操作与后台网络日志上下文。

### 6. 推送通知集成

**状态**：✅ 已完成（2026-06-16）  
**现状**：已完成 FCM 推送通知的全链路接入，覆盖前台/后台/冷启动三种状态。  
**目标**：实现跨平台推送通知，支持消息接收与点击跳转路由。  
**为什么现在做**：推送通知是 App 端的核心交互能力，也是作品集中展示 FCM 集成与架构抽象的重要一环。  
**验收标准**：
- INotificationService 抽象接口在 ListenCore 中定义，FirebaseNotificationServiceImpl 在宿主 App 中实现
- 支持前台横幅展示、后台唤醒跳转、冷启动 DeepLink 路由（tab/settings/projectId）
- Settings 中通知开关联动 FCM Topic 订阅与系统权限请求
- 权限被拒时弹出引导 Dialog 跳转系统设置
- 统一 `_handleNotificationNavigation` 方法处理冷启动和后台两种场景

### 7. 启动耗时与首帧时延监测 (Launch Monitor)

**状态**：✅ 已完成（2026-07-09）  
**现状**：收集并对比历次 App 启动的各个段落（Dart 入口冷启动、初始化服务及首帧完全绘制）的耗时时延，实现 50 条 FIFO 本地基线存储。  
**验收标准**：引入基于往期 3 次以上均值偏离的回归检测算法（均值增长 25% 且绝对值增加 150ms），在 APM Dashboard 内通过健康/性能退化（Badges）卡片及可展开历史表进行精细化可视化展示。

### 8. Auth 与账户状态安全清理

**状态**：✅ 已完成（2026-07-10）  
**现状**：完成用户退出登录/多账号切换时的物理持久化缓存彻底抹除与内存 ViewModels 清空，解除敏感残留。  
**验收标准**：
- **物理缓存销毁**：在 `clearAuthData()` 时，不仅清理 Token，同步清除 `projectsData`、`aboutMeData`、`resume` 的本地物理缓存键。
- **内存安全销毁**：采用延后销毁策略，等待注销后路由转换 settles，通过 `ProviderContainer.invalidate()` 销毁 `Overview/AboutMe/Projects/Resume` 的 ViewModels，防范残留脏数据泄露。
- **设计决策变更（Token 预过期的架构权衡）**：由于本地系统时钟存在偏差（Clock Drift）所带来的高频误刷新和误失效的极高生产风险，同时服务端随时可能吊销/拉黑 Token 导致本地状态与服务端实际权限不一致。因此架构决策上选择**剔除客户端时钟强校验**，统一使用 Dio 拦截器中并发等待/刷新队列对 401 报错做终极静默重试，兼备极高可信度与极佳性能。

### 9. 强类型路由与 Deep Link 整合

**状态**：✅ 已完成（2026-07-10）  
**现状**：重构应用内路由与外部 URI Scheme 唤起入参为强类型参数，实现解耦和类型安全。  
**验收标准**：
- **底座解耦注册**：`ListenCore` 中不硬编码任何具体业务模型与 Scheme。支持在 `AppNavConfig` 动态注册 Scheme（如 `listenportfolio`、`myapp`），并提供 `AppNav.registerArgumentConverter<T>` 委托进行强类型反序列化。
- **宿主业务适配**：在 `app_initializer.dart` 中注册转换委托与原生 Schemes。
- **原生层 Scheme 配置**：配置 Android `AndroidManifest.xml` 的 `intent-filter` 匹配 Scheme 以及 iOS `Info.plist` 的 `CFBundleURLTypes`。
- **设计决策文档**：输出详细设计与 Native vs `app_links` 的架构权衡文档（详见 [设计与实现文档](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/docs/deep_link_routing_design.md)）。
- **路由重用与去重防冲突（重磅补强）**：
  - 支持可选的 `replaceIfExists` 参数决定是否在已处于目标页面时执行 `pushReplacement` 替换当前路由，抑或直接静默返回（默认）。
  - 在 `BaseViewModel` 引入 `_activeEffectSubscription`，实现新页面绑定时自动同步注销老页面订阅；在 `BaseLifeCyclePage` 实现 `onPop` 同步注销监听句柄，彻底规避 `pushReplacement` 期间 (300ms 动画重叠期) ViewModel 重用导致的双重弹窗问题。

## Next

### 1. 路由与状态治理增强

- ✅ `onBackInvoked` 系统返回策略与 IndexedStack 拦截失效治理已完成（对齐 native Predictive Back 行为且保证 IndexedStack 非激活 Tab 不会强行截获返回手势）
- ✅ 路由拦截器与 `AppNav.tryLogin` 体系合并统一（已废弃冗余代码，并实现卫士式的 RouteInterceptor 过滤链流式导航）
- ✅ `CacheManager` 职责纠偏与重命名（已正式更名为 `DiskCleanupUtil`，规避与 Repository 缓存策略概念冲突）
- ✅ 在 `ListenCore` 补充高频常用扩展（BuildContext 快捷属性，String 格式校验与转换，消灭样板代码，已合并至主线）
- ✅ Intent & Effect 录制与回放系统已完成整体设计、沙箱备份恢复、页面/弹窗返回拦截、轮询等待机制、对话框自动旁路并交付生产（详见 [设计与实现文档](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/docs/intent_effect_playback_design.md)）
- ✅ `_effectController` 与 `EventBus` 的职责评估与规范设计文档已正式沉淀（详见 [设计与实现文档](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/docs/event_bus_vs_base_effect.md)）

### 2. Auth 与缓存策略增强

- ✅ `BaseRepository` 缓存与数据降级策略设计规范文档化（已完成 TTL 缓存与 SWR 后台静默刷新模式规约，详见 [设计与实现文档](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/docs/repository_caching_strategy.md)）
- [x] 数据库动态内容国际化 (已于 2026-08-04 完成)
  - [x] Flutter 端在 `AuthInterceptor` 请求拦截器中自动注入当前语言请求头 `Accept-Language`，`LocalMockServer` 自动解析并优先匹配多语言资产（`_zh.json` / `_ja.json`）
  - [x] 彻底去除 UI 模型属性上的过渡性 `.tr` 静态翻译映射（`label`、`tag`、`major`、`certifications`），统一由数据源下发对应目标语言文本
- [x] 静态代码分析警告清理 (已于 2026-08-04 完成)
  - [x] 修复全部 14 个 `cascade_invocations` 与 `one_member_abstracts` 等 `info` 级别代码风格警告，实现全项目 0 警告 (`No issues found!`)
- [x] 优化 Logout 流程防止 Session 泄露 (已于 2026-08-04 完成)
  - [x] 当 Access Token 过期时，在客户端登出前先执行静默刷新（Silent Refresh）拿到新 Token，再发起 Logout API 请求，确保后端能成功销毁服务端的 Refresh Token。

### 3. 文档与展示补强

- Architecture 文档：模块图、状态流、网络链路图
- 可观测性说明图：trace、log、crash、mock、backend 联调路径如何串起来
- ADR：记录 Zone tracing、SafeMode、MockServer、401 refresh queue 等关键决策
- ✅ 一篇“为什么这个项目优先做可观测性与稳定性”的短文档已沉淀，用于对外解释项目选型与质量取向（详见 [设计与实现文档](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/docs/project_philosophy.md)）
- Screen capture / GIF：Overview、Login、Settings、CrashLogs
- Tech stack 选型说明

### 4. 质量与工程化

- Widget tests：登录流程、Settings、Crash logs
- Golden tests：UIKit 组件与关键页面

## Later

### 1. 可展示增强项

- FIDO2 / Passkey 免密安全登录（见 [fido2_implementation_design.md](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/docs/fido2_implementation_design.md)）
- Google 第三方登录

### 2. 体验与平台能力

- Error metrics / fault injection 的可视化验证入口
- 布局检查
- APK/AAB size 监控与拆包分析

### 3. 调试与观测扩展

- ✅ 性能指标面板 MVP：基于 `FrameMonitor + PerfTraceStore` 展示 FPS、jank、内存趋势、页面首帧与 Intent traces（已合并至 Now §5）
- ✅ `traceId` 钻取能力：日志浮窗支持 trace 过滤、定位与回看路径（已合并至 Now §5）
- ✅ Crash / error / trace 关联：crash log、`messageId`、请求链路形成闭环（已合并至 Now §5）
- ✅ 轻量 Net Inspector：请求时间线、状态码、错误体、traceId 可视化（已合并至 Now §5）

### 4. 更能体现个人强项的增强项

- 一页式 Performance Case Study：展示一次卡顿 / 异常排查从现象、trace、日志到修复的完整链路
- Resume / Portfolio 数据联动：把项目经历、架构判断、性能与稳定性案例做成可浏览内容，而不是只放静态简介
- Interview QA / Architecture FAQ 页面：沉淀对架构、观测、稳定性方案的可检索回答
- 故障注入演示页：用最小可控场景展示错误契约、重试、降级与恢复路径

### 5. 工程化扩展

- CD：产物上传到 S3 + Release notes 自动化
- Channel plugin 示例
- JNI/NDK 底层能力样例

## Archive / Idea Pool Backup

以下内容不再进入当前执行主线，先保留为备份：

### 已确认存在的能力

- Clean + MVI 基础骨架
- `BaseUseCase`
- `BaseResponseModel + ApiResult`
- `BaseRepository.safeCall`
- `AuthInterceptor` 的 401 refresh + 并发队列
- 环境切换 + 本地 MockServer
- Crash log 落盘 + Safe Mode
- Zone tracing / performance mark
- Log overlay
- Settings 的语言 / 环境 / 清缓存能力
- Material You 动态取色（集成 dynamic_color，支持主题根据系统壁纸自动着色与回退）
- 无障碍支持（Accessibility / a11y，包含图片/圆圈按钮语义层修饰与大字号防溢出适配）
- 依赖边界治理与 dartdoc 生成
- Release APK 构建与签名配置（CI 流程已跑通，支持自动解密签名）
- Google Play 发布流程自动化（CI 自动比对商店版本、编译 AAB 并发布至 Internal 通道）
- 自动检查更新流程（CI 提取 pubspec.yaml 自动生成/托管 version.json，App 端安全免签解析，已全量覆盖单元测试）
- 推送通知集成（INotificationService 抽象 + FCM 实现，支持前台横幅/后台唤醒/冷启动路由，通知开关联动系统权限引导）
- 分享当前应用（在“关于我”页面右上角及“设置”中心提供分享入口，触发 `ShareEffect` 调用系统原生分享，已完成单元测试覆盖）
- 商用级 `CommonWebView`（基于 `flutter_inappwebview` 封装，支持弹窗自适应高度模式、基于手势/重定向标识的跳转拦截）
- 隐私政策与服务条款落地（基于 `CommonWebView` 加载并适配了全新的 HSL 暗黑/浅色自适应主题，完善了 FCM 及 Billing 声明）
- Google Play 合规性网页端数据注销页面落地（提供 `delete_account.html` 交互表单并完美支持邮件客户端唤起与剪贴板复制降级方案）
- App 内评分引导服务集成（基于 `in_app_review` 封装了 `ReviewService`，支持启动计数与 90 天控流，且在赞助成功后黄金时机强制拉起评价）

### 暂时降级的想法池条目

- switch env: config each api
- apm: layout check / lag check / app launch / apk size / FPS / CPU / memory
- `if (!widget.useScaffold)` 等零散页面能力想法
- IDE plugin：json 模型转换、asset 资源生成到 `R.dart`
- 剔除部分三方pub，能自定义实现的，尽量自己实现，学习目的
- 切换账户后，4个tab的刷新问题，LogoutProviderImpl是否要invalidate(overviewViewModelProvider)等代码？
- 编译，发布一个web版本，可以通过浏览器查看
- 发布到ios市场