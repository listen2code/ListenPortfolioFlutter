# ListenPortfolioFlutter

> **Language / 语言 / 言語**: [English](#english) | [中文](#chinese) | [日本語](#japanese)

---

<a id="english"></a>

# 🇬🇧 English

ListenPortfolioFlutter is a production-ready personal portfolio application built with Flutter, designed to showcase professional technical skills and resume content. It demonstrates enterprise-level mobile development practices through a clean, scalable architecture suitable for real-world projects.

**Key capabilities:**
- **Modular structure**: `core/` (publishable, no business code) · `shared/` · `uikit/` · `features/`
- **Complete auth flow**: login, signup, forgot/change password, account deletion, guest mode
- **Portfolio showcase**: overview, about me *(login-gated)*, projects, architecture demo page
- **Developer tooling**: local mock server, runtime env switching, crash safe mode, log overlay, Zone-based tracing
- **Full i18n**: English / Chinese / Japanese with runtime switching (no restart)
- **Theming**: light / dark / system, accent color picker, font size — all runtime-switchable

## 🎯 Core Technical Highlights

| Highlight | Description |
|-----------|-------------|
| **Zone-based Tracing** | Every Intent and API call runs in its own `Zone` with an auto-generated `traceId`, enabling distributed tracing and per-stage performance marks |
| **401 Auto-Refresh + Queue** | `AuthInterceptor` queues concurrent requests during token refresh and retries them all automatically — zero user-visible interruption |
| **Safe Mode Crash Protection** | `CrashManager` detects ≥3 crashes within 30s and triggers an automatic settings reset to prevent boot loops |
| **Local Mock Server** | Built-in HTTP server (port 9999) serves JSON/image assets, enabling full offline development without any backend |
| **Publishable Core** | `core/` has zero business-layer coupling and can be extracted as a standalone pub package |

## 🏗️ Architecture Design

### Module Dependency (Unidirectional)

```
features/ (auth / home / settings)
  ├──► shared/  (i18n / theme / routes / constants)
  ├──► uikit/   (design system / common widgets)
  └──► core/    (network / base / utils)

shared/ ──► core/
uikit/  ──► core/
core/   ──► (none — publishable standalone)
```

### Clean Architecture Layers

```
┌──────────────────────────────────────────────┐
│  Data Layer                     (external)   │
│  RepositoryImpl ──► RemoteDataSource         │
│  ApiClient (Dio + Retrofit) + LocalCache     │
├──────────────────────────────────────────────┤
│  Domain Layer               (business rules) │
│  UseCase<T,P> ──► IRepository interface      │
│  Either<Failure, T>    (no framework deps)   │
├──────────────────────────────────────────────┤
│  Presentation Layer           (MVI / UI)     │
│  Page ──► Intent ──► ViewModel               │
│              ◄── State / Effect ◄──          │
└──────────────────────────────────────────────┘
```
Dependency rule: both Presentation and Data depend **inward** on Domain.
Domain has no dependency on outer layers.

### Project Directory Structure

```
lib/
├── core/                      # Publishable — zero business coupling
│   ├── base/                  # BaseMaterialApp, BaseLifecyclePage, BaseScaffoldPage
│   │                          # BaseViewModel, BaseEffect, BaseProvider
│   ├── env/                   # AppEnv, environment management
│   ├── errors/                # Failure, AppException hierarchy
│   ├── network/               # ApiClient, BaseRepository, LocalMockServer, UseCase
│   ├── route/                 # AppNav, RouteInterceptor
│   └── utils/                 # CrashManager, ZoneManager, SecureStorage
├── features/                  # Business feature modules
│   ├── auth/                  # Login · SignUp · Password · DeleteAccount
│   │   ├── data/              # DataSources, Models, RepositoryImpl
│   │   ├── domain/            # IRepository interfaces, UseCases
│   │   └── presentation/      # Pages, ViewModels, State, Intent
│   ├── home/                  # Overview · AboutMe · Projects · Architecture
│   └── settings/              # Appearance · Language · Env · CrashLogs
├── shared/                    # Business-shared utilities (depends on core)
│   ├── base/                  # BaseRefreshPage, BaseAuthPage
│   ├── constants/             # AppConstants, EnvConfig
│   ├── extensions/            # .f / .sp responsive size helpers
│   ├── i18n/                  # I18nKeys, zh.dart, ja.dart
│   └── utils/                 # AppInitializer, Routes, LogOverlayManager
├── uikit/                     # Design system & reusable widgets (depends on core)
└── main.dart                  # Core.run() — crash-guarded Zone entry point
```

### Network Request Flow

```
Request
  ├─ ZoneContextInterceptor  →  inject traceId + CancelToken
  ├─ AuthInterceptor         →  inject Bearer token
  ├─ API Call
  │    └─ 401? → refreshToken() → retry all queued requests
  ├─ ErrorInterceptor        →  DioException → AppException
  └─ LoggingInterceptor      →  log every attempt
```

### MVI Data Flow

```
User Action → Intent → ViewModel.handleIntent()
                            │
              ┌─────────────┼──────────────┐
              ▼             ▼              ▼
          UseCase        updateState    emitEffect
              │           (Riverpod)   (Stream)
              ▼
     Either<Failure, T>
              │
         ┌────┴────┐
         ▼         ▼
      Failure     Data    →  LoadingEffect / MessageEffect
    (handleFailure)           NavigationEffect / LogoutEffect
```

## 📐 Core Architecture Components

### Base Classes (`core/base/`)

#### `BaseMaterialApp`
- Root app widget wrapping `MaterialApp` with global configurations: theme, locale, error widget, system UI overlay
- Reactively rebuilds locale and theme from `SettingManager` at runtime without restarting the app
- Registers `FlutterError.onError` and `PlatformDispatcher.onError` for global uncaught error capture

#### `BaseLifecyclePage` (`base_lifecycle_page.dart`)
- Lifecycle-aware page base powered by `WidgetsBindingObserver`
- Drives ViewModel hooks in sequence: `onInit` → `onReady` → `onVisible` → `onResume` → `onPause` → `onHide` → `onDispose`
- `active` flag for `IndexedStack` tabs — lifecycle events fire on logical tab activation, not widget rebuilds

#### `BaseScaffoldPage` (`base_scaffold_page.dart`)
- Standardized scaffold with configurable AppBar, loading overlay, empty state, error state, and back-press handling
- `body` callback signature: `(context, child, viewModel, state)` — clean state-driven rendering with zero boilerplate
- Auto-wires `BaseViewModel` effect stream: loading, messages, navigation handled without manual listener setup

#### `BaseEffect` (`base_effect.dart`)
Side effects emitted by ViewModels via `emitEffect()`, consumed by page listeners:
- `LoadingEffect` — show/hide full-screen loading overlay
- `MessageEffect` — display snackbar or toast with severity level
- `NavigationEffect` — push / pop / replace / offAll routes via `AppNav`
- `LogoutEffect` — broadcast global logout signal to all active pages
- `ShareEffect` — open OS-level share sheet

### `BaseViewModel` (`core/base/base_view_model.dart`)
- Lifecycle hooks automatically driven by `BaseLifecyclePage`
- Every `handleIntent()` call runs inside a `Zone` for automatic traceId propagation and performance marking
- `call()` / `callAll()` helpers wrap UseCase results with loading state and error handling
- `subscribeEvent<T>()` manages EventBus subscriptions with automatic cleanup on `onDispose()`
- Auto-cancels pending Dio requests and all EventBus subscriptions on page disposal

### `ApiClient` (`core/network/api_client.dart`)
- 4-layer Dio interceptor chain ordered deliberately:
  - **Request order**: Zone → Auth → Error → Logging
  - **Error order** (reversed): Logging → Auth → Error → Zone
- `_AuthInterceptor` uses a `Completer` queue to serialize concurrent 401 retries
- `kNoAuthKey` extra option lets individual requests opt out of auth injection
- `visitorPath` registers public paths (`/auth/*`, `/projects`) to skip auth injection

### `ZoneManager` (`core/utils/zone_manager.dart`)
- `run()` — wraps an Intent in a Zone; auto-logs stage durations via `mark()`
- `runGuarded()` — app-level error boundary (wraps `main()`)
- `runPage()` — wraps a page widget and records time-to-first-frame
- `currentTraceId` / `currentCancelToken` — propagated automatically to all Dio calls

### `CrashManager` (`core/utils/crash_manager.dart`)
- Saves crash log to `getApplicationDocumentsDirectory()` with timestamp, stack trace, and recent in-memory logs
- Rapid-crash detection: records timestamps in `SharedPreferences`; triggers `SafeModeConfig.onReset()` on threshold
- `scheduleRandomCrash()` — developer tool to inject a randomized crash after 10–20 s for testing the whole pipeline

## 📱 Feature Modules

### Auth (`features/auth/`)
Login · SignUp · ForgotPassword · ChangePassword · DeleteAccount

- Token-based auth with guest mode; `AppNav.tryLogin()` intercepts protected routes
- All 7 UseCases: `LoginUseCase`, `SignUpUseCase`, `ForgotPasswordUseCase`, `ChangePasswordUseCase`, `GetCurrentUserUseCase`, `LogoutUseCase`, `DeleteAccountUseCase`

### Home (`features/home/`)
Overview · AboutMe *(login-gated)* · Projects · Architecture Showcase

- Single `HomePage` with `IndexedStack` preserving sub-page state
- Drawer navigation with `AuthBlurLevel` for guest-visible blur on restricted tabs
- `OverviewWidget`: stats, experience timeline, featured projects, quick actions

### Settings (`features/settings/`)
Appearance · Language · Environment · CrashLogs · Privacy · Terms

- Runtime language switching (en / zh / ja) without restart
- Runtime environment switching (mock / dev / test / prod) without rebuild
- Log Overlay: floating developer window showing live logs
- Crash Log List: view, upload, and delete persisted crash reports

## 💻 Key Code Examples

**Handling an Intent in ViewModel**
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

**Zone-based Tracing (automatic)**
```dart
// Every handleIntent() call automatically runs inside a Zone:
// - traceId is injected into all Dio request headers as X-Trace-Id
// - mark() records elapsed time at each stage
// - Final summary is logged on completion or error
ZoneManager.mark('Intent [Login] Started');
// ... API call ...
ZoneManager.mark('Token saved');
// Output: "Intent: - Token saved: 42ms  => Total: 87ms"
```

**Running with different environments**
```bash
flutter run --dart-define=APP_ENV=mock   # LocalMockServer at localhost:9999
flutter run --dart-define=APP_ENV=dev    # Dev backend
flutter run --dart-define=APP_ENV=prod   # Production
```

## 🛠️ Technical Stack

| Category | Package | Version | Purpose |
|----------|---------|---------|---------|
| State Management | flutter_riverpod | ^3.1.0 | Reactive state + DI |
| Networking | dio + retrofit | ^5.9.1 / ^4.9.2 | HTTP client + type-safe API |
| Code Generation | freezed + json_serializable | ^3.0.0 | Immutable models + JSON |
| Functional | fpdart | ^1.1.0 | `Either<Failure, T>` |
| Secure Storage | flutter_secure_storage | ^10.0.0 | Encrypted token storage |
| Image | cached_network_image | ^3.4.1 | Network image caching |
| Tracing | uuid | ^4.5.3 | TraceId generation |
| Testing | mocktail + http_mock_adapter | ^1.0.3 | Mock dependencies |

## 🌍 Internationalization

- **Supported**: English (`en`), Chinese (`zh`), Japanese (`ja`)
- Runtime switching via `SettingManager.locale` — no restart required
- All keys defined in `I18nKeys` (`translations_key.dart`); translations in `zh.dart` / `ja.dart`
- `key.tr` extension resolves the current locale automatically

## 🎨 Theme System

- **Modes**: Light / Dark / System (follows OS)
- **Accent Color**: User-selectable with custom color picker
- **Font Size**: Standard / Large
- All controlled via `SettingManager` backed by `SharedPreferences`

## 🔐 Security Practices

- Auth tokens stored in `flutter_secure_storage` (AES-256 on Android, Keychain on iOS)
- 401 auto-refresh is transparent to the user; failed refresh emits `LogoutEffect`
- `AppNav.tryLogin()` intercepts any navigation to a protected route and shows a login dialog
- Visitor paths (`/auth/*`, `/projects`) skip auth header injection via `ApiClient.visitorPath`

## 🧪 Testing Strategy

- **Unit tests**: ViewModel intent→state/effect, Repository `safeCall` branches
- **Widget tests**: Key page render and interaction flows
- **Mocking**: `Mocktail` for domain layer; `HttpMockAdapter` for network layer
- Test files under `test/presentation/` and `test/data/`

## 🔧 Development Environment

### Environment Configurations

| Env | Base URL | Notes |
|-----|----------|-------|
| `mock` | `http://localhost:9999` | Fully offline — `LocalMockServer` serves `assets/mock/` |
| `dev` | configurable | Local development backend |
| `test` | configurable | Integration / QA test backend |
| `prod` | `https://api.lPortfolio.com` | Live production |

### Environment Management Features
- **Runtime Switching**: Change environments from **Settings → Switch Environment** without rebuild or restart
- **Independent Configs**: Each env has its own base URL, timeout, and feature flags (`lib/shared/constants/env_config.dart`)
- **Env-aware Code**: `Core.env` is accessible everywhere; use `Core.env.isMock` for env-specific branching
- **Composition Root**: `AppInitializer.init()` wires all env-specific implementations at startup (`lib/shared/utils/app_initializer.dart`)

### Local Mock Server
`LocalMockServer` (`lib/core/network/local_mock_server.dart`) starts automatically when `APP_ENV=mock`:
- Serves REST responses from `assets/mock/v1/*.json`
- Serves images from `assets/mock/images/*` via the `/v1/resource/...` path
- Configurable response delay to simulate real network latency
- Zero code changes needed to add new mock endpoints — just add a JSON file

### Build Commands

```bash
# Run with mock environment (no backend required)
flutter run --dart-define=APP_ENV=mock

# Run with dev environment
flutter run --dart-define=APP_ENV=dev

# Generate Freezed / Riverpod / Retrofit code (run after model changes)
dart run build_runner build --delete-conflicting-outputs

# Build release APK for production
flutter build apk --release --dart-define=APP_ENV=prod
```

## 📈 Performance Optimization

- `ZoneManager.runPage()` records time-to-first-frame for every page
- `IndexedStack` in `HomePage` preserves sub-widget state across tab switches
- `CachedNetworkImage` with in-memory + disk cache for all remote images
- `shouldUseZone(intent)` override allows high-frequency intents to skip Zone overhead

## 🚀 Getting Started

```bash
# Requirements: Flutter 3.38.3+, Dart 3.10.1+

flutter pub get

# Generate Freezed / JSON / Riverpod / Retrofit code
dart run build_runner build --delete-conflicting-outputs

# Run on mock environment (no backend required)
flutter run --dart-define=APP_ENV=mock
```

```bash
# Run tests
flutter test
```

```bash
# Check dependency boundaries (architecture compliance)
dart tools/dependency_rules.dart

# Generate dependency graph for visualization
dart tools/dependency_rules.dart --graph
```

## 📌 Implementation Notes

| Concern | File |
|---------|------|
| App entry + crash guard | `lib/main.dart` |
| Composition root | `lib/shared/utils/app_initializer.dart` |
| Route registry | `lib/shared/utils/routes.dart` |
| Navigation + login intercept | `lib/core/route/app_nav.dart` |
| Dio client + interceptors | `lib/core/network/api_client.dart` |
| Repository safe-call + cache | `lib/core/network/base_repository.dart` |
| Env configs | `lib/shared/constants/env_config.dart` |
| Mock server | `lib/core/network/local_mock_server.dart` |
| Crash log + safe mode | `lib/core/utils/crash_manager.dart` |
| Zone tracing + perf | `lib/core/utils/zone_manager.dart` |
| Log overlay | `lib/shared/utils/log_overlay_manager.dart` |

## 🔮 Future Roadmap

- **AI Assistant**: Intelligent portfolio introduction via on-device or cloud LLM
- **PDF Export**: Markdown → PDF resume generation and download
- **Skills Chart**: `CustomPainter` radar/bar chart for skill visualization
- **Biometric Login**: Fingerprint / Face ID with secure token binding
- **Third-party Login**: Google OAuth with account link/unlink
- **Material You**: Dynamic color on Android 12+
- **CI/CD**: Automated test + multi-env build pipeline with S3 artifact upload
- **Accessibility**: Full a11y semantic labels and contrast compliance

---

<a id="chinese"></a>

# 🇨🇳 中文

ListenPortfolioFlutter 是一款基于 Flutter 构建的生产级个人技术作品集应用，用于展示专业技术能力与简历内容。项目以 Clean Architecture + MVI 为架构核心，代码结构清晰、可扩展性强，适用于真实生产场景。

**主要能力一览：**
- **模块化结构**：`core/`（可发布，无业务代码）· `shared/` · `uikit/` · `features/`
- **完整认证流程**：登录、注册、忘记/修改密码、账号注销、游客模式
- **作品集展示**：概览、关于我（登录可见）、项目展示、架构演示页
- **开发者工具链**：本地 MockServer、运行时环境切换、崩溃 Safe Mode、日志浮窗、Zone 分布式追踪
- **完整 i18n**：中文 / 英文 / 日文，运行时切换无需重启
- **主题系统**：浅色 / 深色 / 跟随系统、强调色选择、字号调节 — 全部运行时可切换

## 🎯 核心技术亮点

| 亮点 | 说明 |
|------|------|
| **Zone 分布式追踪** | 每个 Intent 和 API 请求运行在独立 `Zone` 中，自动生成 `traceId` 并注入请求头，支持端到端链路追踪和阶段性能标记 |
| **401 自动刷新 + 并发队列** | `AuthInterceptor` 在刷新 Token 期间将并发请求入队，刷新成功后自动重试全部请求，用户完全无感知 |
| **Safe Mode 崩溃保护** | `CrashManager` 检测到 30 秒内 ≥3 次崩溃时，自动触发设置重置，防止启动死循环 |
| **本地 Mock 服务器** | 内置 HTTP 服务器（端口 9999）提供 JSON/图片资源，支持完全离线开发，无需后端依赖 |
| **可发布 Core 包** | `core/` 模块零业务耦合，可直接提取为独立 pub 包供其他项目复用 |

## 🏗️ 架构设计

### 模块依赖关系（单向）

```
features/ （auth / home / settings 业务功能模块）
  ├──► shared/  （i18n / 主题 / 路由 / 常量）
  ├──► uikit/   （设计系统 / 通用组件）
  └──► core/    （网络 / 基础类 / 工具）

shared/ ──► core/
uikit/  ──► core/
core/   ──► （无依赖 — 可独立发布）
```

- `core/`：可发布的核心模块（网络/基础类/工具），不含任何业务逻辑
- `shared/`：业务共享层（i18n/主题/路由/常量），仅依赖 core
- `uikit/`：设计系统与通用组件，仅依赖 core
- `features/`：各功能模块（auth/home/settings），可依赖 shared、uikit、core

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
├── core/                      # 可发布 — 零业务耦合
│   ├── base/                  # BaseMaterialApp、BaseLifecyclePage、BaseScaffoldPage
│   │                          # BaseViewModel、BaseEffect、BaseProvider
│   ├── env/                   # AppEnv、环境管理
│   ├── errors/                # Failure、AppException 异常体系
│   ├── network/               # ApiClient、BaseRepository、LocalMockServer、UseCase
│   ├── route/                 # AppNav、RouteInterceptor
│   └── utils/                 # CrashManager、ZoneManager、SecureStorage
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
├── uikit/                     # 设计系统与通用组件（依赖 core）
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

### 基础类（`core/base/`）

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

<a id="japanese"></a>

# 🇯🇵 日本語

ListenPortfolioFlutterは、Flutterで構築したプロダクションレベルのパーソナル技術ポートフォリオアプリです。プロフェッショナルな技術スキルと履歴書内容をアピールするために設計され、Clean Architecture + MVIをアーキテクチャの中核に、実创業アプリに即度应用可能なクリーンでスケーラブルなコード構成を実現しています。

**主な機能一覧：**
- **モジューラー構成**: `core/`（公開可能、ビジネスコードなし）· `shared/` · `uikit/` · `features/`
- **完全な認証フロー**: ログイン・サインアップ・パスワード忘れ/変更・アカウント削除・ゲストモード
- **ポートフォリオ展示**: 概要・自己紹介（ログイン必須）・プロジェクト・アーキテクチャデモページ
- **開発者ツール**: ローカルモックサーバー・ランタイム環境切り替え・クラッシュSafe Mode・ログオーバーレイ・Zone分散トレーシング
- **完全なi18n**: 日本語/英語/中国語、再起動不要のランタイム切り替え
- **テーマシステム**: ライト/ダーク/システム連動・アクセントカラー・フォントサイズ — すべてランタイム切り替え可能

## 🎯 コア技術のハイライト

| ハイライト | 説明 |
|-----------|------|
| **Zoneベース分散トレーシング** | すべてのIntentとAPIリクエストは独立した`Zone`で実行され、`traceId`が自動生成・伝播されます。ステージごとのパフォーマンス計測も自動記録されます |
| **401自動リフレッシュ + キュー** | `AuthInterceptor`はトークンリフレッシュ中に並行リクエストをキューに入れ、成功後に全件自動リトライします。ユーザーへの影響はゼロです |
| **Safe Modeクラッシュ保護** | `CrashManager`が30秒以内に3回以上のクラッシュを検知すると、起動ループを防ぐため設定を自動リセットします |
| **ローカルモックサーバー** | 組み込みHTTPサーバー（ポート9999）がJSON/画像アセットを配信し、バックエンドなしで完全オフライン開発が可能です |
| **公開可能なCoreパッケージ** | `core/`はビジネスロジックと完全に分離されており、独立したpubパッケージとして公開・再利用できます |

## 🏗️ アーキテクチャ設計

### モジュール依存関係（単方向）

```
features/ (auth / home / settings 機能モジュール)
  ├──► shared/  (i18n / テーマ / ルーティング / 定数)
  ├──► uikit/   (デザインシステム / 共通ウィジェット)
  └──► core/    (ネットワーク / 基底クラス / ユーティリティ)

shared/ ──► core/
uikit/  ──► core/
core/   ──► (依存なし — 単体pubパッケージとして公開可能)
```

- `core/`：ビジネスコードを持たない公開可能なコアモジュール（ネットワーク/基底クラス/ユーティリティ）
- `shared/`：ビジネス共有レイヤー（i18n/テーマ/ルーティング/定数），coreのみに依存
- `uikit/`：デザインシステムと共通ウィジェット，coreのみに依存
- `features/`：各機能モジュール（auth/home/settings）、shared・uikit・coreに依存可能

### クリーンアーキテクチャ 3レイヤー構成

```
┌──────────────────────────────────────────────┐
│  データ層 Data Layer         （外部データ）   
│  RepositoryImpl ──► RemoteDataSource       
│  ApiClient (Dio + Retrofit) + ローカルキャッシュ 
├──────────────────────────────────────────────┤
│  ドメイン層 Domain Layer      （ビジネスルール）  
│  UseCase<T,P> ──► IRepositoryインターフェース   
│  Either<Failure, T>  （フレームワーク依存なし）  
├──────────────────────────────────────────────┤
│  プレゼンテーション層 Presentation  （MVI / UI） 
│  Page ──► Intent ──► ViewModel               
│              ◄── State / Effect ◄──          
└──────────────────────────────────────────────┘
```
依存ルール：プレゼンテーション層とデータ層はどちらもドメイン層へ**内向き**に依存する。
ドメイン層は外部レイヤーに依存しない。

### プロジェクトディレクトリ構成

```
lib/
├── core/                      # 公開可能 — ビジネス結合ゼロ
│   ├── base/                  # BaseMaterialApp、BaseLifecyclePage、BaseScaffoldPage
│   │                          # BaseViewModel、BaseEffect、BaseProvider
│   ├── env/                   # AppEnv、環境管理
│   ├── errors/                # Failure、AppException階層
│   ├── network/               # ApiClient、BaseRepository、LocalMockServer、UseCase
│   ├── route/                 # AppNav、RouteInterceptor
│   └── utils/                 # CrashManager、ZoneManager、SecureStorage
├── features/                  # ビジネス機能モジュール
│   ├── auth/                  # ログイン · サインアップ · パスワード · アカウント削除
│   │   ├── data/              # DataSource、Model、RepositoryImpl
│   │   ├── domain/            # IRepositoryインターフェース、UseCase
│   │   └── presentation/      # Page、ViewModel、State、Intent
│   ├── home/                  # 概要 · 自己紹介 · プロジェクト · アーキテクチャ
│   └── settings/              # 外観 · 言語 · 環境 · クラッシュログ
├── shared/                    # ビジネス共有ユーティリティ（coreに依存）
│   ├── base/                  # BaseRefreshPage、BaseAuthPage
│   ├── constants/             # AppConstants、EnvConfig
│   ├── extensions/            # .f / .sp レスポンシブサイズヘルパー
│   ├── i18n/                  # I18nKeys、zh.dart、ja.dart
│   └── utils/                 # AppInitializer、Routes、LogOverlayManager
├── uikit/                     # デザインシステムと共通ウィジェット（coreに依存）
└── main.dart                  # Core.run() — Zoneでガードされたアプリエントリー
```

### ネットワークリクエストフロー

```
HTTPリクエスト
  ├─ ZoneContextInterceptor  →  traceId + CancelToken を注入
  ├─ AuthInterceptor         →  Bearerトークンを注入
  ├─ API呼び出し
  │    └─ 401? → refreshToken() → キューの全リクエストをリトライ
  ├─ ErrorInterceptor        →  DioException → AppException に変換
  └─ LoggingInterceptor      →  すべての試行をログ記録

インターセプター順序の設計意図:
  onRequest: Zone → Auth → Error → Logging（正順）
  onError:   Logging → Auth → Error → Zone（逆順）
  → AuthがErrorより先に401を処理し、リトライ後にのみErrorがマッピングする
```

### MVIデータフロー

```
ユーザー操作 → Intent → ViewModel.handleIntent()
                               │
               ┌───────────────┼───────────────┐
               ▼               ▼               ▼
           UseCase         updateState     emitEffect
           呼び出し         (Riverpod)      (Stream)
               │
      Either<Failure, T>
               │
          ┌────┴────┐
          ▼         ▼
       Failure     データ  →  LoadingEffect / MessageEffect
    (自動エラー処理)            NavigationEffect / LogoutEffect
```

## 📐 コアアーキテクチャコンポーネント

### 基底クラス（`core/base/`）

#### `BaseMaterialApp`
- グローバル`MaterialApp`ルートウィジェット：テーマ・ロケール・エラーウィジェット・システムUIオーバーレイを一元管理
- `SettingManager`の言語/テーマ変更にランタイムで反応、アプリの再起動不要
- `FlutterError.onError`と`PlatformDispatcher.onError`を登録してグローバル未処理例外をキャプチャ

#### `BaseLifecyclePage`（`base_lifecycle_page.dart`）
- `WidgetsBindingObserver`ベースのライフサイクル対応ページ基底クラス
- ViewModelフックを順序どおり駆動：`onInit` → `onReady` → `onVisible` → `onResume` → `onPause` → `onHide` → `onDispose`
- `IndexedStack`タブ向け`active`フラグ — ウィジェットの再構築でなくタブの論理的切り替え時にライフサイクル発火

#### `BaseScaffoldPage`（`base_scaffold_page.dart`）
- 標準化スカフォールド：設定可能なAppBar・ローディングオーバーレイ・空ステート・エラーステート・戻る処理
- `body`コールバックシグネチャ: `(context, child, viewModel, state)` — ボイラープレートゼロのステート駆動レンダリング
- `BaseViewModel`のeffectストリームを自動接続：loading/メッセージ/ナビゲーションを手動リスナー不要

#### `BaseEffect`（`base_effect.dart`）
ViewModelが`emitEffect()`で発行しページがリスナーで消費する副作用イベント：
- `LoadingEffect` — 全画面ローディングオーバーレイの表示/非表示
- `MessageEffect` — スナックバーまたはトースト表示（重大度レベル対応）
- `NavigationEffect` — `AppNav`経由のpush / pop / replace / offAll
- `LogoutEffect` — 全アクティブページへのグローバルログアウトシグナルブロードキャスト
- `ShareEffect` — OSレベルのシェアシートを開く

### `BaseViewModel`（`core/base/base_view_model.dart`）
- `BaseLifecyclePage`によってライフサイクルフックを自動駆動
- すべての`handleIntent()`呼び出しはZone内で実行され、traceId伝播とパフォーマンス計測が自動化
- `call()` / `callAll()`ヘルパーはUseCaseの呼び出し・ローディング状態・エラー処理を統一
- `subscribeEvent<T>()`はEventBusサブスクリプションをライフサイクル管理、sticky イベントとkeyフィルタ対応
- `onDispose()`で全DioリクエストとEventBusサブスクリプションを自動キャンセルしメモリリークを防止

### `ApiClient`（`core/network/api_client.dart`）
- 順序を精密に設計した4層Dioインターセプターチェーン：
  - **リクエスト順**: Zone → Auth → Error → Logging
  - **エラー順**（逆順）: Logging → Auth → Error → Zone
- `_AuthInterceptor`: `Completer`キューで並行401リトライをシリアライズ
- `kNoAuthKey`: `extra`オプションで特定リクエストのトークン注入をスキップ
- `visitorPath`: 認証不要の公開パス（`/auth/*`、`/projects`）を登録

### `ZoneManager`（`core/utils/zone_manager.dart`）
- `run()` — IntentをZoneで包み、各ステージの経過時間を自動ログ出力
- `runGuarded()` — アプリレベルのエラーバウンダリ（`main()`をラップ）
- `runPage()` — ページWidgetをラップし、初回フレームのレンダリング時間を記録
- Zone内のすべてのDioリクエストに`traceId`と`CancelToken`が自動継承

### `CrashManager`（`core/utils/crash_manager.dart`）
- クラッシュログにはタイムスタンプ・スタックトレース・デバイス情報・最近のメモリログが含まれる
- ラピッドクラッシュ検知: タイムスタンプを`SharedPreferences`に記録し、閾値超過で`SafeModeConfig.onReset()`を起動
- `scheduleRandomCrash()`: 10〜20秒後にランダムな例外を注入する開発者テストツール

## 📱 機能モジュール

### Auth 認証（`features/auth/`）
ログイン · サインアップ · パスワード忘れ · パスワード変更 · アカウント削除

- トークン認証 + ゲストモード; `AppNav.tryLogin()`で保護されたルートをインターセプト
- 7つのUseCase: Login / SignUp / ForgotPassword / ChangePassword / GetCurrentUser / Logout / DeleteAccount

### Home ホーム（`features/home/`）
概要 · 自己紹介（ログイン必須）· プロジェクト · アーキテクチャショーケース

- `IndexedStack`でタブ切り替え時のサブページ状態を保持
- Drawerナビゲーションに`AuthBlurLevel`によるゲスト向けブラー表示
- `OverviewWidget`: スキル統計・経歴タイムライン・注目プロジェクト・クイックアクション

### Settings 設定（`features/settings/`）
外観 · 言語 · 環境 · クラッシュログ · プライバシー · 利用規約

- ランタイム言語切り替え（en / zh / ja）、再起動不要
- ランタイム環境切り替え（mock / dev / test / prod）、再ビルド不要
- ログオーバーレイ: アプリログをリアルタイム表示する開発者用フローティングウィンドウ
- クラッシュログ管理: ローカルのクラッシュレポートを表示・アップロード・削除

## 💻 コードサンプル

**ViewModelでのIntent処理**
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

**Zoneトレーシング（自動・透明）**
```dart
// handleIntent()の各呼び出しは自動的にZone内で実行される
// traceIdはすべてのDioリクエストヘッダー(X-Trace-Id)に自動注入
// mark()でステージ経過時間を記録し、完了時に集計ログを出力
ZoneManager.mark('Token saved');
// ログ出力例: "Intent: - API Call: 45ms - Token saved: 12ms => Total: 87ms"
```

**環境の切り替え**
```bash
flutter run --dart-define=APP_ENV=mock   # LocalMockServer（バックエンド不要）
flutter run --dart-define=APP_ENV=dev    # 開発環境バックエンド
flutter run --dart-define=APP_ENV=prod   # 本番環境
```

## 🛠️ 技術スタック

| カテゴリ | パッケージ | バージョン | 用途 |
|---------|-----------|-----------|------|
| 状態管理 | flutter_riverpod | ^3.1.0 | リアクティブ状態管理 + DI |
| ネットワーク | dio + retrofit | ^5.9.1 / ^4.9.2 | HTTPクライアント + 型安全API |
| コード生成 | freezed + json_serializable | ^3.0.0 | イミュータブルモデル + JSON |
| 関数型 | fpdart | ^1.1.0 | `Either<Failure, T>` |
| セキュアストレージ | flutter_secure_storage | ^10.0.0 | 暗号化トークン保存 |
| 画像キャッシュ | cached_network_image | ^3.4.1 | ネットワーク画像キャッシュ |
| トレーシング | uuid | ^4.5.3 | TraceId生成 |
| テスト | mocktail + http_mock_adapter | ^1.0.3 | モック依存性 |

## 🌍 国際化（i18n）

- **対応言語**: 英語（`en`）、中国語（`zh`）、日本語（`ja`）
- `SettingManager.locale`経由でランタイム切り替え、再起動不要
- すべてのキーは`I18nKeys`で定義; 翻訳ファイル: `zh.dart` / `ja.dart`
- `key.tr`拡張メソッドで現在のロケールを自動解決

## 🎨 テーマシステム

- **モード**: ライト / ダーク / システム連動
- **アクセントカラー**: ユーザーが選択可能（カスタムカラーピッカー対応）
- **フォントサイズ**: 標準 / 大
- すべての設定は`SettingManager`を介して`SharedPreferences`に永続化

## 🔐 セキュリティプラクティス

- 認証トークンは`flutter_secure_storage`に保存（Android: AES-256、iOS: Keychain）
- 401自動リフレッシュはユーザーに透明; リフレッシュ失敗時に`LogoutEffect`を発行
- `AppNav.tryLogin()`が保護されたルートへのナビゲーションをインターセプトし、ログインダイアログを表示
- 公開パス（`/auth/*`等）は`ApiClient.visitorPath`でトークン注入をスキップ

## 🧪 テスト戦略

- **ユニットテスト**: ViewModel intent→state/effect変換、Repository `safeCall`分岐
- **Widgetテスト**: 主要ページのレンダリングとインタラクション
- **モック戦略**: `Mocktail`（ドメイン層）+ `HttpMockAdapter`（ネットワーク層）
- テストファイルは`test/presentation/`と`test/data/`配下

## 🔧 開発環境

### 環境設定

| 環境 | Base URL | 説明 |
|-----|----------|------|
| `mock` | `http://localhost:9999` | 完全オフライン — `LocalMockServer`が`assets/mock/`を配信 |
| `dev` | 設定可能 | ローカル開発バックエンド |
| `test` | 設定可能 | 結合テスト / QAバックエンド |
| `prod` | `https://api.lPortfolio.com` | 本番環境 |

### 環境管理機能
- **ランタイム切り替え**: **設定 → 環境切り替え**から再ビルド・再起動不要で変更可能
- **独立設定**: 各環境は独自のBaseURL・タイムアウト・機能フラグを保持（`lib/shared/constants/env_config.dart`）
- **環境対応コード**: `Core.env`はどこからでもアクセス可能；`Core.env.isMock`で環境別分岐処理を記述
- **コンポジションルート**: `AppInitializer.init()`が起動時に全環境固有実装を配線（`lib/shared/utils/app_initializer.dart`）

### ローカルモックサーバー
`LocalMockServer`（`lib/core/network/local_mock_server.dart`）は`APP_ENV=mock`時に自動起動：
- `assets/mock/v1/*.json`からRESTレスポンスを配信
- `/v1/resource/...`パスで`assets/mock/images/*`の画像を配信
- レスポンス遅延を設定可能にし実際のネットワーク遅延をシミュレート
- 新エンドポイントの追加はJSONファイルを追加するだけでコード変更不要

### ビルドコマンド

```bash
# モック環境で起動（バックエンド不要）
flutter run --dart-define=APP_ENV=mock

# 開発環境で起動
flutter run --dart-define=APP_ENV=dev

# コード生成（モデル変更後に実行）
dart run build_runner build --delete-conflicting-outputs

# 本番環境向けRelease APKをビルド
flutter build apk --release --dart-define=APP_ENV=prod
```

## 🚀 はじめに

```bash
# 要件: Flutter 3.38.3+、Dart 3.10.1+

flutter pub get

# コード生成（Freezed / JSON / Riverpod / Retrofit）
dart run build_runner build --delete-conflicting-outputs

# モック環境で実行（バックエンド不要）
flutter run --dart-define=APP_ENV=mock
```

```bash
# テスト実行
flutter test
```

```bash
# 依存関係境界のチェック（アーキテクチャ準拠）
dart tools/dependency_rules.dart

# 依存関係グラフの生成（可視化分析）
dart tools/dependency_rules.dart --graph
```

## 📌 実装ノート（コード参照）

| 関心事 | ファイル |
|--------|---------|
| アプリエントリー + クラッシュガード | `lib/main.dart` |
| コンポジションルート | `lib/shared/utils/app_initializer.dart` |
| ルートレジストリ | `lib/shared/utils/routes.dart` |
| ナビゲーション + ログインインターセプト | `lib/core/route/app_nav.dart` |
| Dioクライアント + インターセプター | `lib/core/network/api_client.dart` |
| Repository safeCall + キャッシュ | `lib/core/network/base_repository.dart` |
| 環境設定 | `lib/shared/constants/env_config.dart` |
| モックサーバー | `lib/core/network/local_mock_server.dart` |
| クラッシュログ + Safe Mode | `lib/core/utils/crash_manager.dart` |
| Zoneトレーシング + パフォーマンス | `lib/core/utils/zone_manager.dart` |
| ログオーバーレイ | `lib/shared/utils/log_overlay_manager.dart` |

## 🔮 今後のロードマップ

- **AIアシスタント**: オンデバイスまたはクラウドLLMによるインテリジェントなポートフォリオ紹介
- **PDFエクスポート**: Markdown → PDF履歴書の生成とダウンロード
- **スキルチャート**: `CustomPainter`によるレーダーチャート/棒グラフ描画
- **生体認証ログイン**: 指紋 / Face IDとセキュアなトークンバインディング
- **サードパーティログイン**: Google OAuthとアカウントリンク/リンク解除
- **Material You**: Android 12+のダイナミックカラー対応
- **CI/CD**: 自動テスト + マルチ環境ビルド + S3アーティファクトアップロード
- **アクセシビリティ**: 完全なa11yセマンティクスラベルとコントラスト準拠
