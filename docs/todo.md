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

**现状**：性能指标、错误码与日志仍未形成闭环。  
**目标**：先完成性能指标面板、`traceId` 钻取能力、Crash / error / trace 关联与轻量 Net Inspector。  
**为什么现在做**：这是项目的核心竞争力所在。  
**验收标准**：完成性能指标面板、`traceId` 钻取能力、Crash / error / trace 关联与轻量 Net Inspector。

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

## Next

### 1. 路由与状态治理增强

- 类型安全路由参数
- Deep Link 支持
- `onBackInvoked` 系统返回策略统一
- ✅ Intent & Effect 录制与回放系统已完成整体设计、沙箱备份恢复、页面/弹窗返回拦截、轮询等待机制、对话框自动旁路并交付生产（详见 [设计与实现文档](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/docs/intent_effect_playback_design.md)）
- `_effectController` 与 `EventBus` 的职责评估

### 2. Auth 与缓存策略增强

- Token 过期预检查，减少不必要的 401 RTT
- BaseRepository 缓存策略文档化：TTL、key 规范、是否采用 stale-while-revalidate
- 切换账户时清除上个账户缓存与残留画面状态

### 3. 文档与展示补强

- Architecture 文档：模块图、状态流、网络链路图
- 可观测性说明图：trace、log、crash、mock、backend 联调路径如何串起来
- ADR：记录 Zone tracing、SafeMode、MockServer、401 refresh queue 等关键决策
- 一篇“为什么这个项目优先做可观测性与稳定性”的短文档，用于对外解释项目取向
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

- 启动耗时、页面首帧、关键操作耗时的基线记录与回归对比
- Error metrics / fault injection 的可视化验证入口
- 布局检查
- APK/AAB size 监控与拆包分析

### 3. 调试与观测扩展

- 性能指标面板 MVP：基于 `FrameMonitor + PerfTraceStore` 展示 FPS、jank、内存趋势、页面首帧与 Intent traces
- `traceId` 钻取能力：日志浮窗支持更稳定的 trace 过滤、定位与回看路径
- Crash / error / trace 关联：让 crash log、`messageId`、请求链路能形成最小闭环，而不是分散在不同入口
- 轻量 Net Inspector：先完成请求时间线、状态码、错误体、traceId 的最小可视化，而不是一次做成抓包平台

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

- switch env: input url / separate mock / config each api
- apm: layout check / lag check / app launch / apk size / net inspector / FPS / CPU / memory
- `if (!widget.useScaffold)` 等零散页面能力想法
- IDE plugin：json 模型转换、asset 资源生成到 `R.dart`