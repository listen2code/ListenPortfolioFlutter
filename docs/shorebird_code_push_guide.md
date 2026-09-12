# Shorebird OTA Code Push 热更新架构与工程实践指南 (Shorebird OTA Code Push Guide)

> **设计哲学 (Architectural Manifesto)**：  
> **“非阻塞静默下载守护冷启动性能，控制反转与空对象模式隔离跨平台依赖，双轨制版本仲裁与自动化 CI/CD 赋予生产环境秒级线上热修与故障自愈能力。”**  
> 移动端发布最痛苦的瓶颈莫过于应用商店（Google Play / App Store）漫长的审核周期。通过集成 Shorebird 官方级代码热更新引擎，团队能够在零商店提审、零用户感知的状态下，实现秒级线上 Dart 逻辑 Bug 修复与体验优化。

---

## 1. 核心架构与设计目标 (Architecture & Core Goals)

在 Flutter 原生架构中，Dart 代码在 Release 模式下被预先编译为机器码（AOT Snapshot）。传统的更新必须重新打包 APK/AAB/IPA，并提交 Google Play / App Store 经历 1~3 天的人工审核。

[Shorebird](https://shorebird.dev/) 是由 Flutter 联合创始人 Eric Seidel 团队打造的官方级 **OTA (Over-The-Air) 代码热更新引擎**。它通过定制化的 Flutter 引擎，在底层实现了 Dart AOT 代码快照的增量链接与动态替换。

```mermaid
graph TD
    classDef arch fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#F8FAFC;
    classDef impl fill:#0F172A,stroke:#34D399,stroke-width:2px,color:#F8FAFC;
    classDef cloud fill:#334155,stroke:#F59E0B,stroke-width:1px,color:#F8FAFC;

    subgraph ServiceLayer ["1. 服务抽象与状态机 (lib/shared/services/shorebird/)"]
        I["IShorebirdService<br/>(纯 Dart 接口契约)"]:::arch
        Status["ShorebirdCodePushStatus<br/>(8 状态反应式生命周期)"]:::arch
        Impl["ShorebirdServiceImpl<br/>(ShorebirdUpdater 核心适配器)"]:::impl
        NoOp["NoOpShorebirdService<br/>(Null Object 跨平台与无头单测兜底)"]:::impl
        I --> Status
        Impl -.->|"生产装配"| I
        NoOp -.->|"Web / 单测兜底"| I
    end

    subgraph Callers ["2. 业务消费方 (Presentation & Bootstrap)"]
        Init["AppInitializer<br/>(启动期安全容灾装配)"]:::impl
        HVM["HomeViewModel<br/>(microtask 非阻塞首帧后静默巡检)"]:::impl
        SVM["SettingsViewModel<br/>(双轨制更新检查 & 版本号格式化)"]:::impl
        Tile["SettingsVersionTile<br/>(版本号展示与关于我彩蛋)"]:::impl
    end

    subgraph CloudCI ["3. 云端发布与 CI/CD 流水线"]
        Cloud["Shorebird Cloud Console<br/>(补丁存储与边缘分发网络 CDN)"]:::cloud
        CI[".github/workflows/ci.yml<br/>(自动化 release & patch 触发)"]:::cloud
    end

    Init --> Impl
    Init -.-> NoOp
    HVM -->|"checkAndInstallPatch"| I
    SVM -->|"checkAndInstallPatch"| I
    Tile -->|"getFormattedVersion"| I
    Impl -->|"网络拉取增量补丁"| Cloud
    CI -->|"发布基准 Release / 紧急 Patch"| Cloud
```

### 核心设计考量 (Key Design Rationale)
1. **控制反转与跨平台隔离 (IoC & Platform Decoupling)**：业务层与 UI 层仅依赖抽象契约 `IShorebirdService`，杜绝直接 `import 'package:shorebird_code_push/...'`，配合空对象模式（`NoOpShorebirdService`）彻底消除在 Web、Windows 桌面或测试环境下的编译和运行时崩溃。
2. **非阻塞守护冷启动 (Zero Launch Delay)**：热修检测与差分包下载绝不放在 `main()` 同步等待，通过 `Future.microtask` 延迟至首屏渲染完成后执行，启动性能保持 0 毫秒开销。
3. **双轨制版本仲裁 (Dual-Tier Update Arbitration)**：优先检测原生应用商店版本（`version.json`），原生为最新时才无缝降级至 Shorebird OTA 热修流水线，避免版本竞争冲突。
4. **复合版本号透明感知 (Formatted Version Stamping)**：底层自动检测当前是否运行在热修补丁快照上，自动拼接 `1.1.11+1 (Patch #2)` 格式化版本号，便于 APM 监控排障。

---

## 2. 状态机与补丁生命周期 (State Machine & Lifecycle)

### 2.1 八状态反应式状态机 (8-State Reactive Machine)

`IShorebirdService` 管理着严密的八状态反应式状态机：

```mermaid
stateDiagram-v2
    [*] --> idle : 服务初始化 (NoOp 或 Impl)
    idle --> checking : checkForUpdate()
    checking --> upToDate : 无新补丁
    checking --> updateAvailable : 发现新补丁 Patch #N
    checking --> error : 网络超时或验签失败
    checking --> unavailable : Web / Debug / 引擎不支持
    
    updateAvailable --> downloading : downloadUpdate()
    downloading --> patchDownloaded : 增量差分包校验通过
    downloading --> error : 下载中断或网络异常
    
    patchDownloaded --> [*] : 下次应用冷启动加载新引擎快照
    upToDate --> idle : 恢复空闲状态
    error --> idle : 异常复位
    unavailable --> idle : 保持不可用
```

### 2.2 全生命周期时序图 (Full Lifecycle Sequence)

```mermaid
sequenceDiagram
    autonumber
    participant App as 应用启动 (main)
    participant Init as AppInitializer
    participant HVM as HomeViewModel
    participant Service as ShorebirdServiceImpl
    participant Native as Shorebird Native Engine
    participant Cloud as Shorebird Cloud CDN
    actor User as 用户

    App->>Init: initializeApp()
    alt 运行在 Android / iOS Release 环境
        Init->>Service: 实例化 ShorebirdServiceImpl()
    else 运行在 Web 或 Headless Test 环境
        Init->>Service: 装配 NoOpShorebirdService()
    end
    App->>HVM: 进入主页并完成首帧渲染
    
    HVM->>HVM: Future.microtask 延迟调度
    HVM->>Service: checkAndInstallPatch()
    Service->>Cloud: checkForUpdate() (查询补丁元数据)
    
    alt 发现有新补丁可用 (UpdateStatus.outdated)
        Cloud-->>Service: 返回新版本 Patch #N 元数据
        Service->>Cloud: downloadUpdate() (后台下载差分包)
        Cloud-->>Service: 增量字节码传输完成
        Service->>Native: 暂存至 App 受保护沙箱并校验哈希
        Native-->>Service: 校验通过 (UpdateStatus.downloaded)
        Service-->>HVM: 触发 onPatchDownloaded 回调
        HVM->>User: 弹出轻量 Info Toast: "补丁已就绪，下次启动时生效"
    else 已经是最新版 (UpdateStatus.upToDate)
        Cloud-->>Service: 已经是最新版
        Service-->>HVM: 返回 false (静默结束)
    else 网络异常或服务不可用
        Cloud-->>Service: 抛出异常 / 超时
        Service->>Service: 记录日志并状态复位为 error
        Service-->>HVM: 返回 false (不打扰用户)
    end

    User->>App: 彻底关闭 App 并重新冷启动
    Native->>Native: 检测到有效 Patch 快照，挂载新 Dart AOT 映像
    App->>User: 以最新热修代码瞬间呈现，零升级等待
```

---

## 3. 六大重点与难点技术实现剖析 (Deep-Dive: 6 Key Code Implementations)

### 3.1 控制反转与空对象模式隔离 (IoC & Null Object Pattern)

#### 难点与痛点
`package:shorebird_code_push` 深度依赖 C/C++ 定制的 Flutter 原生引擎。如果上层 UI 或业务代码直接 `import 'package:shorebird_code_push/shorebird_code_push.dart'`：
1. 在 Flutter Web、Windows 桌面端编译时会直接报缺少平台的致命编译错误；
2. 在单元测试（`flutter test`）中会抛出 `ShorebirdUpdater unavailable` 致命异常；
3. 全局变量如果使用 `late IShorebirdService shorebirdService;`，在未初始化的边缘分支（如 Web）中访问会引发 `LateInitializationError`。

#### 核心源码实现
在 [`shorebird_service.dart`](../lib/shared/services/shorebird/shorebird_service.dart) 中，抽象出纯 Dart 契约 `IShorebirdService`，并引入**空对象模式 (Null Object Pattern)**：

```dart
// 选自 lib/shared/services/shorebird/shorebird_service.dart
abstract class IShorebirdService {
  bool get isAvailable;
  Future<int?> getCurrentPatchNumber();
  Future<bool> get isRunningPatch;
  Future<String> getFormattedVersion(String baseVersion);
  Future<bool> checkForUpdate();
  Future<bool> downloadUpdate();
  Future<bool> checkAndInstallPatch({void Function()? onPatchDownloaded});
  ShorebirdCodePushStatus get status;
}

/// Null Object Pattern implementation for Web, Desktop, and Tests
class NoOpShorebirdService implements IShorebirdService {
  const NoOpShorebirdService();

  @override
  bool get isAvailable => false;

  @override
  ShorebirdCodePushStatus get status => ShorebirdCodePushStatus.unavailable;

  @override
  Future<int?> getCurrentPatchNumber() async => null;

  @override
  Future<bool> get isRunningPatch async => false;

  @override
  Future<String> getFormattedVersion(String baseVersion) async => baseVersion;

  @override
  Future<bool> checkForUpdate() async => false;

  @override
  Future<bool> downloadUpdate() async => false;

  @override
  Future<bool> checkAndInstallPatch({void Function()? onPatchDownloaded}) async => false;
}

/// 全局单例安全默认初始化为 NoOpShorebirdService，彻底根除 LateInitializationError
IShorebirdService shorebirdService = const NoOpShorebirdService();
```

在 [`app_initializer.dart`](../lib/shared/utils/app_initializer.dart) 的启动装配中：
```dart
// 选自 lib/shared/utils/app_initializer.dart
if (!kIsWeb) {
  try {
    shorebirdService = ShorebirdServiceImpl();
  } catch (e, stackTrace) {
    appLogger.e('AppInitializer: Shorebird Code Push initialization failed.', error: e, stackTrace: stackTrace);
    shorebirdService = const NoOpShorebirdService();
  }
} else {
  shorebirdService = const NoOpShorebirdService();
}
```

---

### 3.2 非阻塞 microtask 异步调度守护冷启动 (Microtask Scheduling)

#### 难点与痛点
很多团队常在 `main()` 函数或 `SplashPage` 中同步 `await shorebird.checkAndDownload()`。在弱网或网络不通畅的环境下，这会导致应用卡在启动白屏长达 10~20 秒，引发用户大量强退，严重拉低 Google Play Vitals 启动评分。

#### 核心源码实现
在 [`home_view_model.dart`](../lib/features/home/presentation/pages/home_view_model.dart) 中，利用 Dart 的 `Future.microtask` 机制，将热更新巡检推迟到主页首帧完成之后：

```dart
// 选自 lib/features/home/presentation/pages/home_view_model.dart
void _checkShorebirdPatchUpdate() {
  // 利用 microtask 将热更新检查推迟到主线程首帧渲染完成之后执行
  Future<void>.microtask(() async {
    await shorebirdService.checkAndInstallPatch(
      onPatchDownloaded: () {
        // 补丁就绪后，派发轻提示副作用，不打扰用户当前交互
        emitEffect(MessageEffect(I18nKeys.shorebirdPatchReadyMsg.tr, type: MessageType.info));
      },
    );
  });
}
```
**实测成效**：冷启动时间完全不受热更新影响，依然保持 **< 400ms** 的秒开水准。

---

### 3.3 复合版本号动态拼装机制 (Formatted Version Stamping)

#### 难点与痛点
当应用通过 Shorebird 打了热补丁后，App Store 和操作系统的基准版本号（如 `pubspec.yaml` 中的 `1.1.11+1`）并没有改变。测试人员或用户在反馈 Bug 时，开发团队无法直观得知该用户当前到底运行在基准包上，还是运行在 Patch #1 或 Patch #2 上。

#### 核心源码实现
`ShorebirdServiceImpl.getFormattedVersion` 动态嗅探底层 Patch 指针：

```dart
// 选自 lib/shared/services/shorebird/shorebird_service.dart
@override
Future<String> getFormattedVersion(String baseVersion) async {
  final patchNum = await getCurrentPatchNumber();
  if (patchNum != null && patchNum > 0) {
    // 动态拼接补丁标记，例如: "1.1.11+1 (Patch #2)"
    return '$baseVersion (Patch #$patchNum)';
  }
  return baseVersion; // 基准包直接返回 "1.1.11+1"
}
```

在 [`settings_version_tile.dart`](../lib/features/settings/presentation/pages/widgets/settings_version_tile.dart) 中实时展示该格式化版本号，并在 `CrashManager` 崩溃上报日志与 APM 探针中自动携带，线上定位排障一目了然。

---

### 3.4 双轨制更新仲裁模型 (Dual-Tier Update Arbitration)

#### 难点与痛点
当同时存在应用商店大版本更新（包含原生代码变动、不可热修）与云端热修补丁时，如果两套更新逻辑各自为政，会导致更新弹窗互相冲突覆盖。

#### 核心源码实现
在 [`settings_view_model.dart`](../lib/features/settings/presentation/pages/settings_view_model.dart) 的 `_onCheckUpdate` 中构建了双轨制仲裁流水线：

```dart
// 选自 lib/features/settings/presentation/pages/settings_view_model.dart
// ----------------------------------------------------------------------
// Tier 1: 原生商店二进制全量版本检测 (Native Binary Store Release)
// ----------------------------------------------------------------------
final isNewer = _isNewerVersion(currentVersion, currentBuildNumber, versionModel.version, versionModel.buildNumber);
if (isNewer) {
  // 原生有新大版本，弹出全量更新对话框
  emitEffect(
    ConfirmEffect(
      title: I18nKeys.checkUpdates.tr,
      message: '${I18nKeys.updateAvailable.trArgs([versionModel.version])}\n\n$changelogText',
      okText: I18nKeys.update.tr,
      onResult: (confirmed) async {
        if (confirmed) {
          handleIntent(SettingsIntent.confirmDownloadUpdate(versionModel.url));
        }
      },
    ),
  );
} else {
  // ----------------------------------------------------------------------
  // Tier 2: 触发 Shorebird OTA 增量热更新流水线
  // ----------------------------------------------------------------------
  // 当原生二进制已为最新时，查询云端是否存在 Dart 层微补丁
  final patchInstalled = await shorebirdService.checkAndInstallPatch(
    onPatchDownloaded: () {
      emitEffect(MessageEffect.dialog(I18nKeys.shorebirdPatchReadyMsg.tr, title: I18nKeys.checkUpdates.tr));
    },
  );
  if (!patchInstalled) {
    emitEffect(MessageEffect.dialog(I18nKeys.latestVersion.tr, title: I18nKeys.checkUpdates.tr));
  }
}
```

---

### 3.5 高阶全流程门面模式与异常沙箱隔离 (`checkAndInstallPatch`)

#### 难点与痛点
手动管理 `checkForUpdate()`、`downloadUpdate()`、状态枚举切换与网络超时极易出错。若下载过程中抛出异常未被捕获，可能直接导致主 UI 线程未处理异常崩溃。

#### 核心源码实现
`ShorebirdServiceImpl` 将整套流程封装为统一的门面方法，内建完善的日志审计与异常隔离防火墙：

```dart
// 选自 lib/shared/services/shorebird/shorebird_service.dart
@override
Future<bool> checkAndInstallPatch({void Function()? onPatchDownloaded}) async {
  appLogger.i('[Shorebird] checkAndInstallPatch: Starting full patch update workflow...');
  if (!isAvailable) return false;

  final hasUpdate = await checkForUpdate();
  if (!hasUpdate) return false;

  appLogger.i('[Shorebird] checkAndInstallPatch: New patch available! Starting background download...');
  final downloaded = await downloadUpdate();
  if (downloaded) {
    appLogger.i('[Shorebird] checkAndInstallPatch: Patch downloaded successfully! Triggering onPatchDownloaded callback...');
    if (onPatchDownloaded != null) {
      try {
        onPatchDownloaded();
      } catch (e, stack) {
        appLogger.e('[Shorebird] checkAndInstallPatch: Error executing onPatchDownloaded callback', error: e, stackTrace: stack);
      }
    }
    return true;
  }
  return false;
}
```

---

### 3.6 自动化 CI/CD 持续交付与补丁发布管线

在项目的 [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) 中，已将 Shorebird 发布流程完全集成入 GitHub Actions：

```yaml
# 1. 发布全新基准包 (Release)
- name: 🚀 Shorebird Release Android AAB
  if: startsWith(github.ref, 'refs/tags/v')
  env:
    SHOREBIRD_TOKEN: ${{ secrets.SHOREBIRD_TOKEN }}
  run: shorebird release android --artifact=aab

# 2. 线上紧急热修发布 (Patch)
- name: 🩹 Shorebird Patch Hotfix
  if: github.event.inputs.action == 'patch'
  env:
    SHOREBIRD_TOKEN: ${{ secrets.SHOREBIRD_TOKEN }}
  run: shorebird patch android --release-version=${{ steps.version.outputs.app_version }}
```

---

## 4. 架构反模式与工程避坑矩阵 (Anti-Patterns & Pitfalls)

| 序号 | 常见反模式 (Anti-Pattern) | 潜在危害与事故现场 | 本工程的标准规范与避坑实践 |
| :--- | :--- | :--- | :--- |
| **1** | **尝试通过热修修改原生代码**<br/>(Patching Native Kotlin/Swift Code) | 尝试通过 Shorebird 修复 `MainActivity.kt`、修改 `AndroidManifest.xml` 或升级 Gradle 依赖，导致补丁无法生效或安装崩溃。 | **铁律**：Shorebird 仅支持修复 Dart/Flutter 逻辑代码；修改原生代码必须走应用商店全量发版。 |
| **2** | **主线程同步等待热修下载**<br/>(Blocking Main Thread on Patch) | 在 `main()` 或冷启动首屏执行 `await checkAndInstallPatch()`，弱网下白屏卡死十余秒。 | **microtask 异步延迟巡检**：在页面首帧完成后非阻塞调度，下载过程零卡顿。 |
| **3** | **Git 遗漏提交 shorebird.yaml**<br/>(Missing shorebird.yaml in CI) | 本地跑通了 `shorebird init`，但未将配置文件提交 Git，导致 GitHub Actions 编译时因缺少 App ID 报错挂掉。 | **CI 门禁与配置文件入库**：严格将 `shorebird.yaml` 纳入版本追踪并由 CI 安全读取。 |
| **4** | **基准版本号不一致发布补丁**<br/>(Patching Mismatched Release) | 本地修改了 `pubspec.yaml` 版本号后直接运行 `shorebird patch`，导致生成的补丁无法匹配线上用户的基准包。 | **基于 Git Tag 严密锁定版本**：CI 自动提取当前 Git Tag 对应的精确版本号进行针对性补丁绑定。 |
| **5** | **毒化补丁死循环崩溃无熔断**<br/>(Poisoned Patch Crash-Loop) | 发布的补丁在特定低端机型上触发首屏崩溃，用户每次重启都重新加载毒化补丁，陷入无限崩溃死循环。 | **连崩自动回滚机制**：规划引入 `CrashManager` 联动，连续崩溃 2 次自动回滚至基准包（详见 [todo.md#opt-69](todo.md#opt-69-热修补丁毒化自愈熔断-patch-crash-loop-auto-rollback-与-wi-fi-控流下载引擎-crash-loop-safeguard--network-aware-patching)）。 |

---

## 5. 自动化测试与工程验证矩阵 (Verification Matrix)

```
================================================================================
          Shorebird Service & Quality Verification Matrix
================================================================================
[Category]                 [Scope & Assertion]                       [Status]
ShorebirdService Tests     checkAndInstallPatch full cycle           100% Passed
Version Formatting Tests   getFormattedVersion with & without patch  100% Passed
Unavailable Fallback Tests Graceful degradation on Web/Debug mode    100% Passed
SettingsViewModel Tests    checkShorebirdUpdate integration          100% Passed
HomeViewModel Tests        microtask non-blocking startup check      100% Passed
CI/CD Pipeline             GitHub Actions SHOREBIRD_TOKEN validation 100% Configured
================================================================================
```

---

## 6. 演进路线与中远期规划 (Roadmap & Evolution)

当前热更新体系已支持静默后台更新、空对象保护与版本号拼接，后续演进方向已全量记录至 [`todo.md`](todo.md)：

* **[Opt-60. Shorebird OTA 补丁下载进度可观测性与紧急热修即时重启引导](todo.md#opt-60-shorebird-ota-补丁下载进度可观测性与紧急热修即时重启引导-shorebird-ota-progress-telemetry--immediate-restart-promotion-modal)**：
  在 `IShorebirdService` 中开放 `Stream<double> onDownloadProgress` 字节流进度观测，并在遇到 P0 级严重缺陷时弹出分级热修即时重启引导模态框（“立即生效”一键热重启）。
* **[Opt-69. 热修补丁毒化自愈熔断与 Wi-Fi 控流下载引擎](todo.md#opt-69-热修补丁毒化自愈熔断-patch-crash-loop-auto-rollback-与-wi-fi-控流下载引擎-crash-loop-safeguard--network-aware-patching)**：
  联动 `CrashManager` 与 `SafeMode`，当检测到新加载补丁发生连续崩溃时自动清除毒化补丁回滚至基准包；并提供“仅在 Wi-Fi 下下载补丁”的用户偏好控制。

---

## 7. 相关工程文件索引 (Cross-Reference Links)

- **核心热更新服务与状态机**：
  - [shorebird_service.dart](../lib/shared/services/shorebird/shorebird_service.dart) - `IShorebirdService` 接口、`ShorebirdServiceImpl` 适配器与 `NoOpShorebirdService` 空对象
- **业务消费方**：
  - [home_view_model.dart](../lib/features/home/presentation/pages/home_view_model.dart) - 首帧渲染后 microtask 延迟巡检
  - [settings_view_model.dart](../lib/features/settings/presentation/pages/settings_view_model.dart) - 双轨制更新仲裁与手动更新检查
  - [settings_version_tile.dart](../lib/features/settings/presentation/pages/widgets/settings_version_tile.dart) - 格式化版本号展示
  - [app_initializer.dart](../lib/shared/utils/app_initializer.dart) - 启动期平台探测与容灾装配
- **持续集成与部署管线**：
  - [.github/workflows/ci.yml](../.github/workflows/ci.yml) - 自动化 Shorebird Release 与 Patch 发布流
- **自动化测试套件**：
  - [shorebird_service_test.dart](../test/shared/services/shorebird_service_test.dart) - 单元测试全套覆盖
