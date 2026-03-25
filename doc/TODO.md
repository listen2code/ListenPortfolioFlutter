## todo

* base
    * base use case; view modelMVI
    * state roaming
    * all code can be config in core
    * BaseResponseModel serverError
* function
    * other pages, use
    * switch env: input url; mock api; config each api; separate mock
    * apm: layout check; lag check; app launch; apk size; net inspector; FPS; Cpu usage; memory;
    * app review
    * finger auth
    * CustomPainter show skills graph
    * ai intro assistant
    * markdown show, download pdf resume
    * unit test
    * profile image upload
    * channel plugin
    * jni
    * AuthInterceptor: token, refreshToken, session timeout; auto login;
    * Third login: google
    * Material You: Dynamic Color
    * accessibility a11y
    * CI CD：upload to S3
    * if (!widget.useScaffold); onBackInvoked
    * merge _effectController and eventBus in baseModel
* ide plugin
    * assets
* server
    * db data design
    * api
    * i18
    * build web
* doc: screen capture, architect, tech stack
* issue
    * ndk bundle;
    * pixel icon cache
  


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

### 🧱 架构与基础设施优化

- [ ] 明确依赖边界与治理：core/shared/uikit/features 的依赖方向检查（可用 lint/自定义脚本）
- [ ] 依赖清理或落地：移除未使用的依赖（例如 go_router/equatable/listen_core/listen_uikit），或真正引入使用并写清迁移方案
- [ ] “state roaming” 定义与实现：跨 tab/跨 page 状态共享策略（EventBus？Riverpod provider？）
- [ ] merge _effectController 和 eventBus 的设计评估与落地（统一一次性事件/全局事件的语义与生命周期）
- [ ] BaseResponseModel / Failure 体系补全：messageId -> i18n 文案映射、统一错误码表、链路 traceId 关联（客户端/服务端）
- [ ] AppNav 增强：参数解析、深链路、onBackInvoked/系统返回拦截策略统一化

### 🚀 功能补充（业务侧）

- [ ] Skills 图表：CustomPainter/Canvas 绘制技能图谱
- [ ] Markdown 展示 + PDF 简历导出/下载（移动端 & Web）
- [ ] AI intro assistant（离线提示词/在线 LLM 接入、隐私合规、可观测性）
- [ ] Profile 头像上传（image_picker + permission_handler 已引入，补齐业务流程/存储/CDN）
- [ ] 指纹/生物识别登录（local_auth，结合 token/refreshToken 安全策略）
- [ ] 第三方登录：Google（OAuth、账号绑定/解绑、隐私政策与合规）
- [ ] App Review 引导（平台能力封装 + 策略）
- [ ] Accessibility（a11y）：语义标签、可访问性测试、动态字体/对比度
- [ ] Material You 动态取色（Android 12+，与现有主题系统融合）

### 🧪 测试与质量

- [ ] 单测覆盖：ViewModel（intent->state/effect）、Repository（safeCall 分支）、i18n keys 完整性
- [ ] Widget tests：核心页面渲染与交互（登录流程、Settings 切换、Crash log 列表）
- [ ] Integration tests：端到端主流程（mock env 下稳定执行）
- [ ] Golden tests：UIKit 组件与关键页面（主题/语言/字号）

### 📈 APM / DevTools（监控与诊断）

- [ ] Net inspector：请求列表、耗时、payload、重试链、traceId 对齐
- [ ] 性能指标：FPS/jank、CPU/内存、首屏/启动耗时（与 ZoneManager 的 mark 串联）
- [ ] 布局检查：repaint boundary、layout boundary、overdraw 等（DevTools 集成策略）
- [ ] APK/AAB size 监控与拆包分析（CI 中自动化输出）

### 🤖 工程化 / CI-CD

- [ ] CI：Flutter analyze + test + build（多环境、分渠道）
- [ ] CD：产物上传到 S3（含 mapping/符号表）+ Release notes 自动化

### 🧩 插件/底层探索

- [ ] Channel plugin（平台通道封装示例）
- [ ] JNI/NDK（底层能力接入样例）

### 🗄️ 服务端（如计划自建）

- [ ] DB 数据设计
- [ ] API 设计（含错误码/traceId/鉴权/刷新 token）
- [ ] i18n（服务端文案或 messageId 体系）
- [ ] Web build / 部署策略

### 📚 文档

- [ ] Screen capture：主要页面截图/GIF
- [ ] Architecture：模块图、数据流/状态流、网络/错误/日志链路图
- [ ] Tech stack：依赖列表与选型理由（包含替代方案与取舍）

### 🐞 已知问题

- [ ] NDK bundle 相关问题
- [ ] Pixel icon cache 相关问题
