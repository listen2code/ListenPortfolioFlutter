## TODO

说明：

- 本文件用于记录“需要补充/优化”的事项，并尽量标注当前状态
- README.md 只描述当前代码已经实现的能力；未来规划统一放到这里

### ✅ 已实现（已在代码中确认）

- [x] Clean + MVI 基础骨架：Intent/State/ViewModel（Riverpod + Freezed）
- [x] BaseUseCase：`lib/core/network/base_use_case.dart`
- [x] BaseResponseModel + ApiResult：`lib/core/network/base_response_model.dart`
- [x] BaseRepository.safeCall：连接检测、Failure 映射、缓存回退：`lib/core/network/base_repository.dart`
- [x] AuthInterceptor：401 自动 refresh + 并发队列重试：`lib/core/network/api_client.dart`
- [x] Env 切换（mock/dev/test/prod）+ 本地 MockServer：`lib/core/env/app_env.dart`、`lib/core/network/local_mock_server.dart`
- [x] Crash log 落盘 + Safe Mode 快速崩溃保护：`lib/core/utils/crash_manager.dart`
- [x] Zone tracing / performance mark：`lib/core/utils/zone_manager.dart`
- [x] Log overlay（开发者浮窗）：`lib/shared/utils/log_overlay_manager.dart`
- [x] Settings 支持语言切换、环境切换、清缓存：`features/settings/presentation/pages/settings_*`
- [x] README 多语言版本（中文/英文/日文单文件，含架构图/代码示例/技术亮点）
- [x] 依赖清理或落地：明确 listen_core/listen_uikit 本地依赖路径与状态（pubspec.yaml 中的路径依赖是否仍有效）；

### 🧱 架构与基础设施优化

- [ ] 明确依赖边界与治理：core/shared/uikit/features 的依赖方向检查（可用 lint/自定义脚本）
- [ ] "state roaming" 定义与实现：跨 tab/跨 page 状态共享策略（EventBus？Riverpod provider？） 支持状态漫游，并可以在开发模式下通过示例展示
- [ ] merge _effectController 和 eventBus 的设计评估与落地（统一一次性事件/全局事件的语义与生命周期）
- [ ] BaseResponseModel / Failure 体系补全：messageId -> i18n 文案映射、统一错误码表、链路 traceId 关联（客户端/服务端）
- [ ] AppNav 增强：参数解析类型安全、深链路（Deep Link）支持、`onBackInvoked` 系统返回拦截策略统一化
- [ ] Token 过期预检查：在 `AuthInterceptor` 中提前检测 token 是否即将过期（通过 exp 字段），主动刷新以减少不必要的 401 RTT
- [ ] `shouldUseZone(intent)` 覆写规范：为高频 scroll/hover 类 Intent 统一跳过 Zone 包裹，减少 Zone 创建开销，并补充使用文档
- [ ] BaseRepository 缓存策略文档化：明确 TTL 设计、缓存 key 规范、stale-while-revalidate 模式是否采用

### 🚀 功能补充（业务侧）

- [ ] Skills 图表：CustomPainter/Canvas 绘制技能图谱
- [ ] Markdown 展示 + PDF 简历导出/下载（移动端 & Web）
- [ ] AI intro assistant（离线提示词/在线 LLM 接入、隐私合规、可观测性）
- [ ] Profile 头像上传（image_picker + permission_handler 已引入，补齐业务流程/存储/CDN），头像上传并保存（Spring项目，或AWS的S3）
- [ ] 指纹/生物识别登录（local_auth，结合 token/refreshToken 安全策略）
- [ ] 第三方登录：Google（OAuth、账号绑定/解绑、隐私政策与合规）
- [ ] App Review 引导（平台能力封装 + 策略）
- [ ] Accessibility（a11y）：语义标签、可访问性测试、动态字体/对比度
- [ ] Material You 动态取色（Android 12+，与现有主题系统融合）

### 🧪 测试与质量

- [ ] 单测覆盖率目标 60%+：ViewModel（intent->state/effect）、Repository（safeCall 分支）、UseCase 参数校验
- [ ] `_AuthInterceptor` 401 并发队列行为单元测试：模拟 3 个并发请求同时 401，验证只触发一次 refresh 且全部成功重试
- [ ] `CrashManager` safe mode 管道测试：模拟 30 秒内 3 次崩溃，验证 `onReset()` 正确触发
- [ ] i18n key 完整性测试：遍历 `I18nKeys` 的所有 key，断言 zh/ja 两个语言文件均有对应翻译
- [ ] Widget tests：核心页面渲染与交互（登录流程、Settings 切换、Crash log 列表）
- [ ] Integration tests：端到端主流程（mock env 下稳定执行）
- [ ] Golden tests：UIKit 组件与关键页面（主题/语言/字号）

### 📈 APM / DevTools（监控与诊断）

- [ ] Net inspector：请求列表、耗时、payload、重试链、traceId 对齐（可作为 Settings 内开发者面板的子页）
- [ ] 性能指标面板：FPS/jank、CPU/内存、首屏/启动耗时（与 ZoneManager 的 `mark()` 输出串联，展示在 Log Overlay 或专用页面）
- [ ] ZoneManager `runPage()` 数据持久化：将首帧耗时写入本地，支持历史对比与回归检测
- [ ] 布局检查：repaint boundary、layout boundary、overdraw 等（DevTools 集成策略）
- [ ] APK/AAB size 监控与拆包分析（CI 中自动化输出，建立 size budget）

### 🤖 工程化 / CI-CD

- [ ] CI：Flutter analyze + test + build（多环境、分渠道）
- [ ] CD：产物上传到 S3（含 mapping/符号表）+ Release notes 自动化
- [ ] CI CD：upload to S3

### 🧩 插件/底层探索

- [ ] Channel plugin（平台通道封装示例）
- [ ] JNI/NDK（底层能力接入样例）

### 🗄️ 服务端（如计划自建）

- [ ] 服务端文案i18n
- [ ] 直接将目前项目打包成web模块并部署

### 📚 文档

- [x] README 多语言版本（中文/英文/日文单文件，含架构图/代码示例/技术亮点）
- [ ] Screen capture：主要页面截图/GIF（Overview、Login、Settings、CrashLogs）
- [ ] Architecture：模块图、数据流/状态流、网络/错误/日志链路图（可用 Mermaid）
- [ ] Tech stack：依赖列表与选型理由（包含替代方案与取舍）
- [ ] CONTRIBUTING.md：贡献指南（分支策略、PR 模板、代码规范）
- [ ] ADR（Architecture Decision Records）：记录关键架构决策（Zone tracing、SafeMode、MockServer 设计背景）
- [ ] dartdoc：公开 API 文档生成（尤其是 core/ 模块，为 pub 发布准备）

### 🔧 开发体验（DX）

- [ ] 标准化开发工作流文档：`build_runner watch` 常驻代码生成、`APP_ENV=mock` 为默认调试环境、Log Overlay 使用说明
- [ ] VSCode/Android Studio launch 配置：预置 `--dart-define=APP_ENV=mock` 的 launch.json，方便一键启动
- [ ] Mock 数据维护规范：`assets/mock/v1/` 目录结构说明、新增接口时 mock 文件命名规则
- [ ] 错误码速查表：将 `AppException` 子类与业务错误码整理为文档，方便排查线上问题

### 其他
* base
    * BaseResponseModel serverError
* function
    * switch env: input url; mock api; config each api; separate mock
    * apm: layout check; lag check; app launch; apk size; net inspector; FPS; Cpu usage; memory;
    * AuthInterceptor: token, refreshToken, session timeout; auto login;
    * if (!widget.useScaffold); onBackInvoked
    * 切换账户的时候，清除上个账户的缓存，和留在画面的数据
* 开发IDE的plugin
    * json模型转换
    * asset资源生成到R.dart
* 文档
    * 画面截图
* 问题
    * NDK bundle 相关问题（Android 构建时 ndk bundle 报错，需明确 NDK 版本或 abiFilters 配置）
    * Pixel icon cache 相关问题（部分 Pixel 设备 launcher icon 缓存不刷新，需调查 adaptive icon 配置）