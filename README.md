# ListenPortfolioFlutter
ListenPortfolioFlutter 是一款基于 Flutter 构建的生产级个人技术作品集应用，用于展示专业技术能力与简历内容。项目以 Clean Architecture + MVI 为架构核心，代码结构清晰、可扩展性强，适用于真实生产场景。

**主要能力一览：**
- **模块化结构**：`core/`（可发布，无业务代码）· `shared/` · `uikit/`（设计系统）· `features/`
- **完整认证流程**：登录、注册、忘记/修改密码、账号注销、游客模式
- **作品集展示**：概览、关于我（登录可见）、项目展示、架构演示页
- **开发者工具链**：本地 MockServer、运行时环境切换、崩溃 Safe Mode、日志浮窗、Zone 分布式追踪
- **完整国际化**：英文/中文/日文，运行时切换（无需重启）
- **主题系统**：亮色/暗色/系统、主题色选择器、字体大小 — 全部运行时可切换

**可发布包：**
- **listen_core**：核心工具和基础类 - https://pub.dev/packages/listen_core
- **listen_uikit**：设计系统和可复用组件 - https://pub.dev/packages/listen_uikit

## 🎯 核心技术亮点

| 亮点 | 说明 |
|------|------|
| **Zone 分布式追踪** | 每个 Intent 和 API 请求运行在独立 `Zone` 中，自动生成 `traceId` 并注入请求头，支持端到端链路追踪和阶段性能标记 |
| **401 自动刷新 + 并发队列** | `AuthInterceptor` 在刷新 Token 期间将并发请求入队，刷新成功后自动重试全部请求，用户完全无感知 |
| **Safe Mode 崩溃保护** | `CrashManager` 检测到 30 秒内 ≥3 次崩溃时，自动触发设置重置，防止启动死循环 |
| **本地 Mock 服务器** | 内置 HTTP 服务器（端口 9999）提供 JSON/图片资源，支持完全离线开发，无需后端依赖 |

## 🏗️ 架构设计

### 模块依赖关系（单向）

```
features/               （auth / home / settings 业务功能模块）
  ├──► shared/          （i18n / 主题 / 路由 / 常量）
  ├────├──►uikit/       （设计系统 / 通用组件）
  └────└─────└─► core/  （网络 / 基础类 / 工具）
```

### Clean Architecture 三层结构

```
┌──────────────────────────────────────────────┐
│  数据层 Data Layer            （外部数据）      
│  RepositoryImpl ──► RemoteDataSource         
│  ApiClient (Dio + Retrofit) + 本地缓存         
├──────────────────────────────────────────────┤
│  领域层 Domain Layer          （业务规则）  
│  UseCase<T,P> ──► IRepository 接口          
│  Either<Failure, T>   （无框架依赖）       
├──────────────────────────────────────────────┤
│  表现层 Presentation Layer    （MVI / UI）     
│  Page ──► Intent ──► ViewModel               
│              ◄── State / Effect ◄──          
└──────────────────────────────────────────────┘
```
依赖规则：表现层与数据层均**向内**依赖领域层；领域层不依赖任何外层。

### 项目目录结构

```
lib/
├── features/                  # 业务功能模块
│   ├── auth/                  # 登录 · 注册 · 密码 · 账号注销
│   │   ├── data/              # DataSource、Model、RepositoryImpl
│   │   ├── domain/            # IRepository 接口、UseCase
│   │   └── presentation/      # Page、ViewModel、State、Intent
│   ├── home/                  # 概览 · 关于我 · 项目 · 架构展示
│   └── settings/              # 外观 · 语言 · 环境 · 崩溃日志
├── shared/                    # 业务共享工具（依赖 core）
│   ├── base/                  # BaseRefreshPage、BaseAuthPage
│   ├── constants/             # AppConstants、EnvConfig
│   ├── extensions/            # .f / .sp 响应式尺寸扩展
│   ├── i18n/                  # I18nKeys、zh.dart、ja.dart
│   └── utils/                 # AppInitializer、Routes、LogOverlayManager
└── main.dart                  # Core.run() — Zone 包裹的崩溃守护入口
```

### 网络请求拦截链

```
HTTP 请求
  ├─ ZoneContextInterceptor  →  注入 traceId + CancelToken
  ├─ AuthInterceptor         →  注入 Bearer Token
  ├─ API 调用
  │    └─ 401？ → refreshToken() → 重试全部排队请求
  ├─ ErrorInterceptor        →  DioException → AppException 映射
  └─ LoggingInterceptor      →  记录所有请求/响应日志

注意：拦截器顺序精心设计
  onRequest：Zone → Auth → Error → Logging（正序）
  onError：  Logging → Auth → Error → Zone（逆序）
  确保 Auth 优先处理 401，Error 在最终失败后才映射异常
```

### MVI 数据流

```
用户操作 → Intent → ViewModel.handleIntent()
                            │
              ┌─────────────┼──────────────┐
              ▼             ▼              ▼
          UseCase        updateState    emitEffect
          调用            (Riverpod)    (Stream)
              │
     Either<Failure, T>
              │
         ┌────┴────┐
         ▼         ▼
      Failure     数据    →  LoadingEffect / MessageEffect
   (自动处理错误)              NavigationEffect / LogoutEffect
```

## 📐 核心架构组件

### 基础类（`listen_core`）

#### `BaseMaterialApp`
- 全局 `MaterialApp` 根组件，统一配置主题、语言、错误 Widget、系统 UI 样式
- 运行时响应 `SettingManager` 的语言/主题变更，无需重启应用
- 注册 `FlutterError.onError` 和 `PlatformDispatcher.onError` 以捕获全局未处理异常

#### `BaseLifecyclePage`（`base_lifecycle_page.dart`）
- 基于 `WidgetsBindingObserver` 的生命周期感知页面基类
- 按序驱动 ViewModel 钩子：`onInit` → `onReady` → `onVisible` → `onResume` → `onPause` → `onHide` → `onDispose`
- `active` 标志位支持 `IndexedStack` Tab 页 — 生命周期在逻辑 Tab 切换时触发，而非 Widget 重建时

#### `BaseScaffoldPage`（`base_scaffold_page.dart`）
- 标准化页面容器，含可配置 AppBar、全屏加载蒙层、空状态、错误状态及返回键处理
- `body` 回调签名为 `(context, child, viewModel, state)` — 状态驱动渲染，无模板代码
- 自动接入 `BaseViewModel` effect 流：loading/消息/导航无需手动监听

#### `BaseEffect`（`base_effect.dart`）
ViewModel 通过 `emitEffect()` 发出、页面监听消费的副作用事件：
- `LoadingEffect` — 显示/隐藏全屏加载蒙层
- `MessageEffect` — 显示 SnackBar 或 Toast（支持严重程度级别）
- `NavigationEffect` — push / pop / replace / offAll 路由（通过 `AppNav`）
- `LogoutEffect` — 广播全局退出登录信号至所有活跃页面
- `ShareEffect` — 调起系统分享面板

### `BaseViewModel`（`core/base/base_view_model.dart`）
- 生命周期钩子由 `BaseLifecyclePage` 自动驱动
- 每次 `handleIntent()` 自动在 `Zone` 中执行，实现 traceId 透传和性能标记
- `call()` / `callAll()` 工具方法封装 UseCase 调用、Loading 状态和错误处理
- `subscribeEvent<T>()` 管理 EventBus 订阅生命周期，支持 sticky 事件和 key 过滤
- `onDispose()` 时自动取消全部 Dio 请求和 EventBus 订阅，防止内存泄漏

### `ApiClient`（`core/network/api_client.dart`）
- 4 层 Dio 拦截器链，顺序精心设计确保正确处理：
  - **请求顺序**：Zone → Auth → Error → Logging
  - **错误顺序**（逆序）：Logging → Auth → Error → Zone
- `_AuthInterceptor`：使用 `Completer` 队列串行化并发 401 重试
- `kNoAuthKey`：单个请求通过 `extra` 选项跳过 Token 注入
- `visitorPath`：注册公开路径（注册/登录/刷新/项目列表）免鉴权

### `ZoneManager`（`core/utils/zone_manager.dart`）
- `run()` — 将 Intent 包裹在 Zone 中，自动记录各阶段耗时
- `runGuarded()` — 应用级错误边界，包裹 `main()`
- `runPage()` — 包裹页面 Widget，记录首帧渲染时间
- Zone 内的所有 Dio 请求自动继承 `traceId` 和 `CancelToken`

### `CrashManager`（`core/utils/crash_manager.dart`）
- 崩溃日志包含：时间戳、堆栈跟踪、设备信息、最近内存日志
- 快速崩溃检测：时间戳记录在 `SharedPreferences`，超过阈值触发 `SafeModeConfig.onReset()`
- 开发者工具：`scheduleRandomCrash()` 在 10-20 秒后注入随机类型崩溃，测试完整处理链路

## 📱 功能模块详解

### Auth 认证模块（`features/auth/`）
登录 · 注册 · 忘记密码 · 修改密码 · 注销账号

- Token 鉴权 + Guest 模式；`AppNav.tryLogin()` 拦截受保护路由
- 7 个 UseCase：Login / SignUp / ForgotPassword / ChangePassword / GetCurrentUser / Logout / DeleteAccount

### Home 主页模块（`features/home/`）
概览 · 关于我（登录可见）· 项目展示 · 架构展示

- `HomePage` 使用 `IndexedStack` 保持各 Tab 状态（避免重新加载）
- Drawer 导航带 `AuthBlurLevel` 模糊效果（游客可见但受限的 Tab）
- `OverviewWidget`：技能统计、经历时间线、精选项目、快捷操作

### Settings 设置模块（`features/settings/`）
外观 · 语言 · 环境 · 崩溃日志 · 隐私 · 服务条款

- 运行时语言切换（en / zh / ja），无需重启
- 运行时环境切换（mock / dev / test / prod），无需重新编译
- 日志浮窗：开发者实时查看应用日志
- 崩溃日志管理：查看、上传、删除本地崩溃报告

## 💻 关键代码示例

**ViewModel 处理 Intent**
```dart
@override
FutureOr<void> onIntent(LoginIntent intent) async {
  intent.when(
    login: (username, password) => _handleLogin(username, password),
    toggleRememberMe: () => _toggleRememberMe(),
  );
}

Future<void> _handleLogin(String username, String password) async {
  await call(
    loginUseCase.call(param: LoginParam(username: username, password: password)),
    showLoading: true,
    onSuccess: (user) {
      updateState(state.copyWith(user: user));
      emitEffect(const NavigationEffect.offAll(Routes.home));
    },
  );
}
```

**Zone 追踪（自动透明）**
```dart
// 每次 handleIntent() 自动创建 Zone
// traceId 自动注入所有 Dio 请求头 X-Trace-Id
// mark() 记录阶段耗时，最终汇总日志
ZoneManager.mark('Token saved');
// 日志输出: "Intent: - API Call: 45ms - Token saved: 12ms => Total: 87ms"
```

**环境切换**
```bash
flutter run --dart-define=APP_ENV=mock   # 本地 MockServer（无需后端）
flutter run --dart-define=APP_ENV=dev    # 开发环境后端
flutter run --dart-define=APP_ENV=prod   # 生产环境
```

## 🛠️ 技术栈

| 类别 | 依赖包 | 版本 | 用途 |
|------|--------|------|------|
| 状态管理 | flutter_riverpod | ^3.1.0 | 响应式状态 + 依赖注入 |
| 网络 | dio + retrofit | ^5.9.1 / ^4.9.2 | HTTP 客户端 + 类型安全 API |
| 代码生成 | freezed + json_serializable | ^3.0.0 | 不可变模型 + JSON 序列化 |
| 函数式 | fpdart | ^1.1.0 | `Either<Failure, T>` 错误处理 |
| 安全存储 | flutter_secure_storage | ^10.0.0 | 加密 Token 存储 |
| 图片缓存 | cached_network_image | ^3.4.1 | 网络图片缓存 |
| 链路追踪 | uuid | ^4.5.3 | TraceId 生成 |
| 测试 | mocktail + http_mock_adapter | ^1.0.3 | Mock 依赖 |

## 🌍 国际化（i18n）

- **支持语言**：英文（`en`）、简体中文（`zh`）、日文（`ja`）
- 运行时切换，无需重启，通过 `SettingManager.locale` 控制
- 所有文字 key 定义在 `I18nKeys`，翻译文件：`zh.dart` / `ja.dart`
- `key.tr` 扩展方法自动解析当前语言

## 🎨 主题系统

- **模式**：浅色 / 深色 / 跟随系统
- **强调色**：用户自选，支持自定义颜色
- **字号**：标准 / 大字号
- 所有配置通过 `SettingManager` 持久化至 `SharedPreferences`

## 🔐 安全实践

- Auth Token 存储在 `flutter_secure_storage`（Android AES-256 / iOS Keychain）
- 401 自动刷新对用户完全透明，刷新失败发出 `LogoutEffect`
- `AppNav.tryLogin()` 拦截受保护路由导航，展示登录弹窗
- 公开路径（`/auth/*` 等）通过 `ApiClient.visitorPath` 跳过 Token 注入

## 🧪 测试策略

- **单元测试**：ViewModel intent→state/effect 转换、Repository `safeCall` 分支
- **Widget 测试**：关键页面渲染与交互流程
- **Mock 方案**：`Mocktail`（领域层）+ `HttpMockAdapter`（网络层）
- 测试文件位于 `test/presentation/` 和 `test/data/`

## 🔧 开发环境

### 环境配置

| 环境 | Base URL | 说明 |
|------|----------|------|
| `mock` | `http://localhost:9999` | 完全离线 — `LocalMockServer` 提供 `assets/mock/` 数据 |
| `dev` | 可配置 | 本地开发后端服务 |
| `test` | 可配置 | 集成测试 / QA 后端 |
| `prod` | `https://api.lPortfolio.com` | 生产环境 |

### 环境管理特性
- **运行时切换**：在 **设置 → 切换环境** 中切换，无需重新编译或重启
- **独立配置**：每个环境有独立的 BaseURL、超时时间和功能开关（`lib/shared/constants/env_config.dart`）
- **环境感知**：`Core.env` 全局可访问，可用 `Core.env.isMock` 编写环境分支逻辑
- **组合根**：`AppInitializer.init()` 在启动时装配所有环境相关实现（`lib/shared/utils/app_initializer.dart`）

### 本地 Mock 服务器
`LocalMockServer`（`lib/core/network/local_mock_server.dart`）在 `APP_ENV=mock` 时自动启动：
- 从 `assets/mock/v1/*.json` 提供 REST 响应
- 通过 `/v1/resource/...` 路径提供 `assets/mock/images/*` 图片资源
- 可配置响应延迟以模拟真实网络延迟
- 新增接口仅需添加 JSON 文件，无需改动任何代码

### 构建命令

```bash
# 以 Mock 环境运行（无需后端）
flutter run --dart-define=APP_ENV=mock

# 以开发环境运行
flutter run --dart-define=APP_ENV=dev

# 代码生成（模型变更后执行）
dart run build_runner build --delete-conflicting-outputs

# 构建生产环境 Release APK
flutter build apk --release --dart-define=APP_ENV=prod
```

## 🚀 快速开始

```bash
# 环境要求：Flutter 3.38.3+，Dart 3.10.1+

flutter pub get

# 生成代码（Freezed / JSON / Riverpod / Retrofit）
dart run build_runner build --delete-conflicting-outputs

# 以 Mock 环境运行（无需后端）
flutter run --dart-define=APP_ENV=mock
```

```bash
# 运行测试
flutter test
```

```bash
# 检查依赖边界（架构合规性）
dart tools/dependency_rules.dart

# 生成依赖关系图（可视化分析）
dart tools/dependency_rules.dart --graph
```

## 📌 代码索引

| 关注点 | 文件 |
|--------|------|
| 应用入口 + 崩溃守护 | `lib/main.dart` |
| 组合根（依赖注入） | `lib/shared/utils/app_initializer.dart` |
| 路由注册表 | `lib/shared/utils/routes.dart` |
| 导航 + 登录拦截 | `lib/core/route/app_nav.dart` |
| Dio 客户端 + 拦截器 | `lib/core/network/api_client.dart` |
| Repository safeCall + 缓存 | `lib/core/network/base_repository.dart` |
| 环境配置 | `lib/shared/constants/env_config.dart` |
| Mock 服务器 | `lib/core/network/local_mock_server.dart` |
| 崩溃日志 + Safe Mode | `lib/core/utils/crash_manager.dart` |
| Zone 追踪 + 性能 | `lib/core/utils/zone_manager.dart` |
| 日志浮窗 | `lib/shared/utils/log_overlay_manager.dart` |

## 🔮 后续规划

- **AI 助手**：接入本地或云端 LLM，实现智能简历介绍
- **PDF 导出**：Markdown → PDF 简历生成与下载
- **技能图表**：`CustomPainter` 绘制技能雷达图/柱状图
- **生物识别登录**：指纹 / Face ID 与安全 Token 绑定
- **第三方登录**：Google OAuth，支持账号绑定/解绑
- **Material You**：Android 12+ 动态取色，融合现有主题系统
- **CI/CD**：自动化测试 + 多环境构建 + S3 产物上传
- **Accessibility**：完整语义标签和对比度合规

---
