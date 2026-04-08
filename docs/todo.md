## TODO

说明：

- 本文件只保留执行路线，不再作为“想法池”堆叠所有可能性
- README.md 只描述当前已实现能力；未来方向、设计稿和探索项统一在此管理

## Now

### 1. 文档与实现继续对齐

**现状**：README 已开始按“现状 / 目标态”分离，但其他文档仍存在历史表述偏理想化的问题。  
**目标**：确保 README、`docs/`、代码实现三者不再互相打架。  
**为什么现在做**：这是当前最影响项目可信度的问题。  
**验收标准**：主文只描述已落地能力；设计性内容下沉到 `docs/`；过时表述放入待删除备份区。

### 2. Flutter / Backend API 契约收口

**现状**：主流程已可联调，但仍有字段与模型边界未彻底收口。  
**目标**：完成 Flutter mock、真实后端响应、客户端 model 的最终一致性。  
**为什么现在做**：真实 App 优先，前后端契约必须先稳定。  
**验收标准**：Flutter dev 环境请求后端时，无解析异常、无字段歧义、无 mock/real 双标准。

重点项：

- `ProjectDto.businessId` 的客户端适配
- `StatDto.id` 与 `businessId` 的最终映射策略
- `messageId` 的真实落地边界

### 3. 错误契约落地

**现状**：`error-codes-reference.md`、`messageId -> i18n`、`ErrorMetrics / ErrorInjector` 还主要停留在设计阶段。  
**目标**：先把最核心的错误码与错误文案映射能力做成真实代码能力。  
**为什么现在做**：这直接影响跨端一致性、可维护性与后续框架沉淀。  
**验收标准**：至少完成一条从后端 `messageId` 到 Flutter 展示文案的真实闭环。

### 4. 测试补强

**现状**：测试策略有方向，但覆盖度与关键链路验证仍不足。  
**目标**：优先补强最容易出错的核心链路。  
**为什么现在做**：没有测试，很多“框架优势”都只是口头优势。  
**验收标准**：新增并稳定运行以下测试：

- `_AuthInterceptor` 401 并发队列测试
- `CrashManager` Safe Mode 管道测试
- i18n key 完整性测试
- 至少一条 mock env 下的集成主流程测试

### 5. 可观测性闭环 MVP

**现状**：性能指标、错误码与日志仍未形成闭环。  
**目标**：先完成性能指标面板、`traceId` 钻取能力、Crash / error / trace 关联与轻量 Net Inspector。  
**为什么现在做**：这是项目的核心竞争力所在。  
**验收标准**：完成性能指标面板、`traceId` 钻取能力、Crash / error / trace 关联与轻量 Net Inspector。

## Next

### 1. 路由与状态治理增强

- 类型安全路由参数
- Deep Link 支持
- `onBackInvoked` 系统返回策略统一
- `state roaming` 的定义与实现边界明确
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
- Release APK 构建与签名配置
- 隐私政策页面

## Later

### 1. 可展示增强项

- Accessibility（a11y）
- Material You 动态取色
- 指纹 / 生物识别登录
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

- Google Play 发布流程自动化
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
- 依赖边界治理与 dartdoc 生成

### 暂时降级的想法池条目

- switch env: input url / separate mock / config each api
- apm: layout check / lag check / app launch / apk size / net inspector / FPS / CPU / memory
- `if (!widget.useScaffold)` 等零散页面能力想法
- IDE plugin：json 模型转换、asset 资源生成到 `R.dart`
- NDK bundle / Pixel icon cache 等平台特定问题，后续按 issue 单独跟踪