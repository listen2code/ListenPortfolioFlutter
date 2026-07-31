# ListenPortfolioFlutter 集成测试计划书

本计划书旨在基于项目现有测试用例 [app_test.dart](file:///C:/Users/liste/Downloads/github/ListenPortfolioFlutter/integration_test/app_test.dart) 和已落地能力，为项目制定一套覆盖更广、深度更强的端到端（E2E）集成测试方案。

---

## 1. 测试架构与环境配置

集成测试基于 Flutter 官方 `integration_test` 库运行，采用本地 Mock 环境，完全脱离真实后端服务依赖，确保测试在 CI 环境及本地具有 100% 的确定性和极快的运行速度。

### 1.1 环境桩（Test Doubles）与配置
在集成测试启动前，必须通过 `setUpAll` 统一注册并注入桩服务，以规避原生系统弹窗挂起（Hang）或动画时延问题：
- **`LocalMockServer`**：网络层对接本地 Mock 数据，网络延迟配置为极低值（如 `10ms`），规避请求竞争。
- **`FakeIapService`**：模拟内购（IAP）服务，直接返回成功或空列表，不触发应用商店通道。
- **`FakeNotificationService`**：模拟 FCM 推送服务，自动同意通知权限，防止系统级权限弹框阻断测试。
- **`VisibilityDetectorController`**：更新间隔设置为 `Duration.zero`，消除可见性检测延时对 widget pump 的干扰。

---

## 2. 既存测试覆盖分析 (Phase 1)

目前已在 `app_test.dart` 中实现了一个**单管道长链路测试**，验证了以下主业务流程闭环：

```mermaid
graph LR
    Splash[Splash 启动] --> Home[Home 主页]
    Home --> Drawer[打开 Drawer]
    Drawer --> LoginPage[导航至登录页]
    LoginPage --> ForgotPwd[找回密码验证]
    ForgotPwd --> SignUp[注册流程验证]
    SignUp --> Login[正常登录]
    Login --> VerifyProfile[校验 Profile 状态]
    VerifyProfile --> Logout[安全注销]
```

### 既存用例细节亮点
- **找回密码异常输入**：覆盖了空输入限制及无效邮箱格式拦截。
- **注册流程输入阻断**：包含密码长度不足 6 位限制、二次确认密码不一致拦截。
- **登录状态校验**：登录成功后，验证 Drawer 头部信息（用户名及邮箱）是否正确绑定。
- **注销确认拦截**：验证 Logout 弹窗二次确认后才彻底退回 LoginPage，防止误操作。

---

## 3. 新增集成测试用例规划 (Phase 2 & 3)

为了实现核心底层框架与重点业务能力的 100% 覆盖，规划引入以下 6 大集成测试用例组：

### Case 组 1：设置中心与动态主题（Settings & Theme）
**目标**：验证国际化（i18n）、持久化存储切换、主题变换和系统通知开关联动。

| 用例 ID | 测试点描述 | 测试步骤 | 预期验证结果 |
| :--- | :--- | :--- | :--- |
| **SET-01** | 多语言运行时无缝切换 | 1. 导航到 SettingsPage<br>2. 点击语言选择，切换至 English<br>3. 返回首页，切换至 Japanese | 1. 页面文案立刻变为对应语言版本，无需重启 App<br>2. SP 持久化存储已写入对应语言 key |
| **SET-02** | 主题切换与 Material You 取色 | 1. 在 SettingsPage 切换 Deep/Light 主题<br>2. 在 Android 12+ 平台下启用 "Material You 动态取色" | 1. 界面对应的 ThemeData 属性动态更新<br>2. 取色通道回调成功，未发生 Render 错误 |
| **SET-03** | 缓存清理功能 (DiskCleanupUtil) | 1. 点击“清除缓存”按钮<br>2. 检测本地临时文件路径大小 | 1. 弹出清理成功 Toast<br>2. 临时文件和 Projects 等本地物理缓存被清空 |
| **SET-04** | 推送通知权限联动 | 1. SettingsPage 切换通知开关<br>2. 模拟系统权限已拒绝场景 | 1. 开关状态同步更新<br>2. 权限被拒时弹出引导 Dialog 提示跳转系统设置 |

---

### Case 组 2：作品集与 SWR 缓存加载（Portfolio & SWR）
**目标**：测试 `BaseRepository.safeCall` 在无网/弱网下的离线缓存及 SWR（后台静默刷新）性能表现。

| 用例 ID | 测试点描述 | 测试步骤 | 预期验证结果 |
| :--- | :--- | :--- | :--- |
| **PORT-01** | SWR 离线秒开与后台刷新 | 1. 物理断网（模拟无网络状态）<br>2. 启动 OverviewPage / ProjectsPage<br>3. 物理联网，触发重新获取 | 1. 页面直接读取历史缓存，瞬间渲染无白屏<br>2. 联网后后台静默发起 fetch 并刷新 UI，无全屏 Loading 遮蔽 |
| **PORT-02** | 500 报错拦截防脏写 | 1. 配置 MockServer 使 Projects 接口返回 500 严重错误<br>2. 导航至 Projects 页面 | 1. UI 抛出 `ServerFailure` 对应红牌错误页<br>2. 本地已有的 Projects 缓存**不被**空数据或脏数据覆写 |
| **PORT-03** | 文本溢出与自适应折行 (Wrap) | 1. 模拟 Projects 包含极长描述和多标签数据<br>2. Pump 列表项，触发视图渲染 | 1. 徽章（Badge）区域使用 `Wrap` 正常折行<br>2. 动态文本无 `RenderFlex overflowed` 异常 |

---

### Case 组 3：可观测性与 Trace 联动下钻（APM & Trace Drill-down）
**目标**：验证 Zone tracing 记录链路、轻量 Net Inspector 环形队列及 Crash 详情 Drill Down 行为。

| 用例 ID | 测试点描述 | 测试步骤 | 预期验证结果 |
| :--- | :--- | :--- | :--- |
| **APM-01** | 性能指标面板交互 | 1. 唤起 APM 悬浮窗面板<br>2. 拖拽面板，折叠/展开迷你图表 | 1. Vsync 帧时延、FPS 动态绘制<br>2. 手势拖拽未卡死，图表视口高度自适应 |
| **APM-02** | 崩溃 TraceID 联动下钻 | 1. 注入一个除零异常/空指针导致 App 发生业务层崩溃<br>2. 弹出本地崩溃详情对话框<br>3. 点击对话框中的 "Drill Logs" 按钮 | 1. 调试日志悬浮窗一键弹出<br>2. 强切到 Logs Tab 并依据当前崩溃的 Trace ID 过滤日志<br>3. 列表精准展示崩溃发生前关联的网络包和意图 |
| **APM-03** | Net Inspector 环形队列审计 | 1. 连续发起 120 次 Mock 请求<br>2. 打开网络审计面板，检查请求审计记录 | 1. 最早的 20 条记录被安全丢弃（防内存泄露）<br>2. 剩余 100 条请求的 Headers 和 Payloads 状态展示完备 |

---

### Case 组 4：Crash Safe Mode 快速崩溃恢复（Safe Mode Boot）
**目标**：测试冷启动连续闪退检测及 Safe Mode 紧急自救界面。

| 用例 ID | 测试点描述 | 测试步骤 | 预期验证结果 |
| :--- | :--- | :--- | :--- |
| **SAFE-01** | 3次快速崩溃进入 Safe Mode | 1. 模拟 App 启动 2 秒内发生 3 次致命崩溃<br>2. 再次执行 App 冷启动 | 1. App 不再尝试加载主页面<br>2. 屏幕直接渲染 Crash Safe Mode 紧急恢复界面<br>3. 界面显示崩溃原因和日志 |
| **SAFE-02** | 安全自救与重置 | 1. 在 Safe Mode 界面点击“重置本地 SP 缓存”<br>2. 点击“重启 App” | 1. 全局 SP 缓存键被清空<br>2. App 退出死锁状态，能够成功冷启动至首屏 |

---

### Case 组 5：路由与 Deep Link 强类型解析（Routing & Deep Links）
**目标**：验证 `AppNavConfig` 注册、原生 Scheme 唤起、类型安全反序列化和路由去重防重叠。

| 用例 ID | 测试点描述 | 测试步骤 | 预期验证结果 |
| :--- | :--- | :--- | :--- |
| **RUT-01** | Deep Link 强类型唤起 | 1. 模拟通过原生 Link 唤起 `listenportfolio://projects?id=proj_001`<br>2. 拦截导航分发 | 1. `AppNav.registerArgumentConverter` 正确捕获并反序列化强类型参数<br>2. 页面准确跳转到项目详情页，并加载 `proj_001` 数据 |
| **RUT-02** | 路由动画去重防冲突 | 1. 在 `ProjectsPage` 再次触发 push 同一页面路由<br>2. 在 300ms 路由跳转动画重叠期内触发返回手势 | 1. `BaseLifeCyclePage` 联动 `pop` 同步注销监听<br>2. 规避 ViewModel 重用导致的双重弹窗和通道混乱问题 |

---

### Case 组 6：Intent & Effect 录制与回放（Playback System）
**目标**：验证在沙箱环境下自动恢复状态，拦截返回键，自动旁路对话框。

| 用例 ID | 测试点描述 | 测试步骤 | 预期验证结果 |
| :--- | :--- | :--- | :--- |
| **PLAY-01** | 动作序列录制与沙箱回放 | 1. 开启 Playback 录制开关<br>2. 执行：点击登录 -> 输入密码 -> 点击注销<br>3. 保存并重置 App 状态<br>4. 执行回放序列 | 1. 录制系统以 JSON 格式捕获完整的 Intent 序列<br>2. 回放期间，界面以无人工干预方式自动执行对应操作<br>3. 回放完成后，页面状态与录制结束时保持绝对一致 |
| **PLAY-02** | 对话框自动旁路拦截 | 1. 回放过程中触发系统级对话框（如权限弹窗或内购成功弹窗） | 1. 录制回放系统自动触发旁路等待机制<br>2. 稳定跳过或静默返回，确保回放流不发生挂起 |

---

## 4. 执行计划与 CI/CD 集成

### 4.1 本地测试执行指令
在 Android 模拟器或物理设备已连接的情况下，运行以下命令执行集成测试：

```bash
# 运行全部集成测试
flutter test integration_test/app_test.dart
```

### 4.2 GitHub Actions 持续集成集成 (ci.yml)
为确保代码合入时不发生回归（Regression），可在 `.github/workflows/ci.yml` 中新增集成测试作业（Job）。由于真机在 CI 环境不可用，建议基于 Android 模拟器容器（如 `ReactiveCircus/android-emulator-runner`）运行：

```yaml
integration-test:
  runs-on: macos-latest # 使用 macos 以获得更好的 Android 模拟器加速支持
  steps:
    - uses: actions/checkout@v3

    - name: Set up Java
      uses: actions/setup-java@v3
      with:
        distribution: 'zulu'
        java-version: '17'

    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.44.1'

    - name: Install dependencies
      run: flutter pub get

    - name: Run Build Runner
      run: dart run build_runner build --delete-conflicting-outputs

    - name: Run Integration Tests (Emulator)
      uses: reactivecircus/android-emulator-runner@v2
      with:
        api-level: 33
        target: google_apis
        arch: x86_64
        profile: Nexus 6
        script: flutter test integration_test/app_test.dart
```

---

> [!NOTE]
> 在实际编写上述用例时，应优先考虑在 `integration_test/` 下拆分出多个小文件（如 `settings_test.dart`, `apm_test.dart`, `safemode_test.dart`），使测试边界更聚焦，避免单个长流水线测试因为中间步骤挂起而导致全局阻塞。
