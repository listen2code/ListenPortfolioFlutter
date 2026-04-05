# 标准化开发工作流

本文档定义了 Listen Portfolio Flutter 项目的标准化开发工作流程，确保团队开发效率和代码质量。

## 🚀 快速开始

### 1. 环境准备

```bash
# 克隆项目
git clone <repository-url>
cd ListenPortfolioFlutter

# 安装依赖
flutter pub get

# 启动代码生成（常驻进程）
flutter packages pub run build_runner watch --delete-conflicting-outputs
```

### 2. 首次运行

```bash
# 设置默认调试环境
export APP_ENV=mock

# 或者在 IDE 中设置 Dart 定义
# --dart-define=APP_ENV=mock

# 运行应用
flutter run --dart-define=APP_ENV=mock
```

## 🔄 代码生成工作流

### build_runner watch 常驻进程

**推荐方式**：在开发期间保持 `build_runner watch` 持续运行

```bash
# 启动常驻代码生成
flutter packages pub run build_runner watch --delete-conflicting-outputs

# 常用参数说明
# --delete-conflicting-outputs: 自动删除冲突的生成文件
# --verbose: 显示详细日志（调试时使用）
```

**优势**：
- 🚀 **实时生成**：文件变化时自动重新生成
- 🔄 **增量更新**：只重新生成变化的文件
- ⚡ **快速反馈**：编译错误立即显示
- 🛠️ **开发体验**：无需手动触发生成

**何时运行**：
- ✅ **开发期间**：持续运行
- ✅ **添加新模型**：自动生成序列化代码
- ✅ **修改 Freezed 类**：自动生成 copyWith/equals 方法
- ✅ **更新 Riverpod Provider**：自动生成 provider 代码

### 代码生成触发场景

| 场景 | 触发操作 | 生成内容 |
|------|----------|----------|
| **新增数据模型** | 修改 `.freezed.dart` | JSON 序列化、copyWith、equals |
| **添加 API 接口** | 修改 Retrofit 注解 | API 客户端代码 |
| **更新 Riverpod** | 修改 `@riverpod` 注解 | Provider 代码 |
| **修改路由** | 更新路由定义 | 路由类型安全代码 |

## 🌍 环境配置

### APP_ENV=mock 默认调试环境

**为什么使用 mock 环境**：
- 🧪 **离线开发**：无需真实服务器
- ⚡ **快速响应**：本地 mock 数据，零延迟
- 🔧 **稳定调试**：数据可控，便于测试边界情况
- 💾 **数据持久**：mock 数据可重复使用

### 环境类型说明

| 环境 | 用途 | 数据源 | 适用场景 |
|------|------|--------|----------|
| **mock** | 本地开发 | `assets/mock/` | 日常开发、功能测试 |
| **dev** | 开发测试 | 开发服务器 | 集成测试 |
| **test** | QA 测试 | 测试服务器 | 用户验收测试 |
| **prod** | 生产环境 | 生产服务器 | 正式发布 |

### 环境切换方式

#### 1. 命令行方式（推荐）
```bash
# Mock 环境（默认）
flutter run --dart-define=APP_ENV=mock

# 开发环境
flutter run --dart-define=APP_ENV=dev

# 测试环境
flutter run --dart-define=APP_ENV=test
```

#### 2. IDE 配置
**VSCode** (`.vscode/launch.json`)：
```json
{
  "name": "Mock Environment",
  "request": "launch",
  "type": "dart",
  "program": "lib/main.dart",
  "args": [
    "--dart-define=APP_ENV=mock"
  ]
}
```

**Android Studio**：
```
Run > Edit Configurations > Dart Command Line Options
添加: --dart-define=APP_ENV=mock
```

#### 3. 应用内切换
- 打开 **Settings** 页面
- 选择 **Environment** 选项
- 切换到目标环境
- 应用会自动重启

## 📊 Log Overlay 使用说明

### 什么是 Log Overlay

Log Overlay 是一个浮窗调试工具，在应用界面上实时显示日志信息，方便开发调试。

### 功能特性

- 📱 **实时显示**：应用日志实时浮窗显示
- 🎯 **源类型过滤**：支持 All / Server / App / Perf 分类过滤
- 🔍 **Trace ID 过滤**：点击日志中的 Trace ID 自动过滤关联请求链路
- � **日志复制**：一键复制所有日志到剪贴板
- 🎨 **可调整窗口**：支持拖拽移动、四角及底边缩放

### 启用 Log Overlay

#### 1. 自动初始化（SplashPage）
```dart
// LogOverlayManager 在 SplashPage 的 onReady 生命周期中自动初始化
// 参见 lib/features/splash/presentation/pages/splash_page.dart
class _SplashLifecycle extends PageLifecycle {
  @override
  void onReady() {
    LogOverlayManager.init(context); // 读取持久化偏好，自动显示/隐藏
  }
}
```

#### 2. 设置页面启用
- 打开 **Settings** 页面
- 找到 **View Logs** 开关
- 切换开关即可调用 `LogOverlayManager.show(context)` / `LogOverlayManager.hide()`

#### 3. 代码方式
```dart
// 显示浮窗
LogOverlayManager.show(context);

// 直接以展开窗口模式显示
LogOverlayManager.show(context, startExpanded: true);

// 隐藏浮窗
LogOverlayManager.hide();
```

### 使用技巧

#### 日志级别过滤
```
[DEBUG] 详细调试信息
[INFO]  一般信息
[WARN]  警告信息
[ERROR] 错误信息
```

#### 常用过滤关键字
- **网络请求**: `HTTP`, `API`, `Network`
- **状态管理**: `Riverpod`, `State`, `ViewModel`
- **错误调试**: `Error`, `Exception`, `Failure`
- **性能监控**: `Performance`, `Zone`, `Trace`

#### 浮窗操作
- **拖拽移动**：拖拽浮球按钮或展开窗口的标题栏移动位置
- **展开/收起**：点击浮球按钮展开日志窗口，点击收起按钮缩回浮球
- **调整大小**：拖拽窗口四角或底边调整窗口尺寸
- **过滤日志**：点击 Filter 图标展开过滤栏，选择 All/Server/App/Perf
- **Trace ID 搜索**：点击日志中绿色的 Trace ID 自动填入搜索栏
- **复制日志**：点击 Copy 图标复制所有日志到剪贴板
- **清除日志**：点击 Clear 图标清除所有日志
- **关闭浮窗**：点击红色电源图标完全关闭 Log Overlay

### 最佳实践

#### 1. 日志记录规范
```dart
// 使用 Logger 记录日志
logger.d('Debug information: $data');  // Debug
logger.i('User action: $action');       // Info  
logger.w('Warning: $warning');         // Warning
logger.e('Error: $error', error: error); // Error
```

#### 2. 性能敏感场景
```dart
// 避免在频繁调用的地方记录详细日志
// 使用 shouldUseZone(intent) 跳过高频操作
if (shouldUseZone(intent)) {
  logger.d('Performance sensitive operation: $intent');
}
```

#### 3. 生产环境
```dart
// LogOverlayManager.init() 使用 SpUtil 持久化开关状态
// 生产环境可通过 Settings 页面禁用，无需代码层面控制
// 状态通过 SpUtil.getBool('log_overlay_key') 读取
```

## 🛠️ 开发工具链

### IDE 配置推荐

#### VSCode 扩展
```json
{
  "recommendations": [
    "dart-code.flutter",
    "dart-code.dart-code",
    "nash.awesome-flutter-snippets",
    "jeroen-meijer.pubspec-assist",
    "robert-brunhage.flutter-riverpod-snippets"
  ]
}
```

#### Android Studio 插件
- **Flutter**: Flutter 官方插件
- **Dart**: Dart 语言支持
- **Flutter Riverpod Snippets**: Riverpod 代码片段

### 常用命令速查

```bash
# 依赖管理
flutter pub get                    # 安装依赖
flutter pub upgrade               # 升级依赖
flutter pub outdated              # 检查过期依赖

# 代码生成
flutter packages pub run build_runner build              # 单次生成
flutter packages pub run build_runner watch              # 常驻生成
flutter packages pub run build_runner clean             # 清理生成文件

# 运行测试
flutter test                       # 运行所有测试
flutter test --coverage            # 运行测试并生成覆盖率报告

# 代码分析
flutter analyze                    # 静态代码分析
dart format .                      # 格式化代码

# 构建应用
flutter build apk --debug          # 构建 debug APK
flutter build apk --release        # 构建 release APK
flutter build web                  # 构建 Web 应用
```

## 📋 开发检查清单

### 开发前检查
- [ ] 确认 `APP_ENV=mock` 环境设置
- [ ] 启动 `build_runner watch`
- [ ] 启用 Log Overlay（如需调试）
- [ ] 检查依赖版本兼容性

### 开发中检查
- [ ] 代码生成文件及时更新
- [ ] 日志记录规范使用
- [ ] 遵循架构分层原则
- [ ] 及时运行静态分析

### 提交前检查
- [ ] 运行 `flutter analyze` 无错误
- [ ] 运行 `flutter test` 通过
- [ ] 代码格式化 `dart format .`
- [ ] 检查是否有 TODO/FIXME 标记

## 🔧 故障排除

### 常见问题

#### 1. build_runner 冲突
```bash
# 清理并重新生成
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### 2. 环境变量不生效
```bash
# 确认环境变量设置
echo $APP_ENV

# 或在命令行中直接指定
flutter run --dart-define=APP_ENV=mock
```

#### 3. Log Overlay 不显示
```dart
// 确认 SplashPage 中 LogOverlayManager.init(context) 已执行
// 确认 SpUtil 中 'log_overlay_key' 值为 true
// 或手动调用：LogOverlayManager.show(context);
```

#### 4. Mock 数据不加载
- 检查 `assets/mock/` 目录结构
- 确认 `pubspec.yaml` 中 assets 配置
- 验证 MockServer 启动状态

### 性能优化建议

1. **build_runner 优化**
   - 使用 `--watch` 避免重复构建
   - 定期清理生成文件 `build_runner clean`

2. **Log Overlay 优化**
   - 生产环境禁用
   - 合理设置日志级别
   - 避免高频日志记录

3. **环境切换优化**
   - 开发时固定使用 mock 环境
   - 使用 IDE 配置预设环境参数

## 📚 相关文档

- [项目架构](../README.md)
- [错误码参考](error-codes-reference.md)
- [Mock 数据维护规范](mock-data-specification.md)
- [项目开发指南](project-development-guide.md)
- [文档生成指南](documentation-generation.md)

---

**更新日期**: 2026-04-03  
**维护者**: 开发团队  
**版本**: 1.0.0
