# 剔除部分三方 Pub 依赖并自主实现的计划与可行性分析

> [!NOTE]
> **Implementation Progress**:
> - **已重构 (Refactored)**: `fpdart` 已被自定义 `Either` 实现替换并从 `pubspec.yaml` 移除。
> - **计划中 (Remaining)**: `uuid`, `logger`, `visibility_detector`, `device_info_plus`, `package_info_plus`, `connectivity_plus` 目前仍在 `pubspec.yaml` 中，将按本计划逐步替换。

作为以学习为目的的重构计划，剔除不必要的三方依赖并自主实现，不仅能让包体积更轻量、减少三方库版本冲突风险（如升级 SDK 时的各种不兼容），更能帮助深挖 Flutter 的底层渲染、Dart 语言高级特性以及原生通道（Platform Channels）机制。

## 设计思路 (Design Rationale)
本项目并非一味追求“不造轮子”，而是有选择地重构**技术壁垒较低且易于陷入依赖地狱**的周边工具库。对于 `dio` 或 `flutter_riverpod` 等经过长期社区验证的核心基建，保持引入；对于类似 `uuid` 或 `logger` 这种只需不到 100 行代码即可满足业务需求的库，自主实现能带来最高的 ROI（投入产出比）和代码掌控度。

---

## 🙋 核心疑问解答：只会 Android 不会 iOS，适合做这件事吗？

> [!IMPORTANT]
> **完全适合，甚至非常推荐！** 原因如下：
>
> 1. **很多库是纯 Dart / Flutter 实现的，不需要编写任何原生代码**：
>    像 `uuid`、`fpdart`（函数式编程接口，已完成自主替换）以及自定义日志输出等，它们 100% 运行在 Dart VM 虚拟机层。只要用纯 Dart 编写一次，就能在 Android 和 iOS 上完美运行，不需要你懂任何 iOS 原生开发。
> 2. **对于需要原生代码的库，这是学习 Platform Channel 的极佳机会**：
>    - 很多平台库（如 `device_info_plus` 或 `package_info_plus`）其实只用了极其简单的几行原生代码（例如获取 Android 的 `Build.MODEL` 或 iOS 的 `UIDevice`）。
>    - iOS 端对应的 Swift / Objective-C 代码通常非常简短（只有十几行固定写法），你完全可以通过 AI 辅助生成 iOS 端代码，而自己专注于编写熟练的 Android (Kotlin) 代码。
>    - 这将促使你真正掌握跨平台桥接（MethodChannel / EventChannel），这是 Flutter 高级开发的核心分水岭。

---

## 🗺️ 推荐自主实现的 Pub 依赖分类规划

根据实现难度和技术收益，我们把适合自主实现的依赖分为以下三个阶段：

### 阶段一：纯 Dart 实现（无原生代码，零 iOS/Android 知识门槛）

| 依赖名称 | 原依赖主要功能 | 自定义实现核心思路 | 学习收获与技术价值 | 难度等级 |
| :--- | :--- | :--- | :--- | :--- |
| **`uuid`** | 生成 v4 的 UUID 字符串 | 使用 Dart 自带的 `dart:math` 中的 `Random.secure()`，生成 128 位随机数，并按照 UUID v4 的规范格式化为 hex 字符串。 | - 随机数安全机制<br>- 位运算与进制转换 | ⭐ |
| **`fpdart`** | 提供 `Either`, `Option` 等函数式编程范式 | ✅ **已完成替换**：项目已使用自定义 `Either<L, R>` 密封类实现，`fpdart` 已从 `pubspec.yaml` 中移除。 | - Dart 泛型高级应用<br>- 代数数据类型 (ADT) 思想 | ⭐⭐ |
| **`logger`** | 控制台彩格式化日志输出 | 利用 Dart 的 `print()` 或 `dart:developer` 的 `log()`，配合 ANSI 颜色转义字符（如 `\x1B[31m`）实现彩色输出，定制调用栈解析。 | - 字符串解析与格式化<br>- 控制台渲染原理 | ⭐⭐ |

---

### 阶段二：Flutter 渲染层实现（无原生代码，探索渲染树机制）

| 依赖名称 | 原依赖主要功能 | 自定义实现核心思路 | 学习收获与技术价值 | 难度等级 |
| :--- | :--- | :--- | :--- | :--- |
| **`visibility_detector`** | 监听 Widget 的曝光与可见性比例 | 利用 `ScrollController` 滚动监听，配合 `Scrollable.of(context)` 获取滚动容器边界，通过 `RenderBox.localToGlobal` 计算当前 Widget 相对视口的坐标和相交区域大小。 | - Flutter 布局与绘制机制<br>- `RenderObject` 与边界计算 | ⭐⭐⭐ |

---

### 阶段三：轻量级原生桥接实现（需 Android/iOS 少量代码，突破原生通道）

| 依赖名称 | 原依赖主要功能 | 自定义实现核心思路 | 学习收获与技术价值 | 难度等级 |
| :--- | :--- | :--- | :--- | :--- |
| **`device_info_plus`** | 获取设备型号、系统版本等 | 自定义 `MethodChannel('device_info')`：<br>- Android 端：用 Kotlin 读取 `android.os.Build` 字段。<br>- iOS 端：用 Swift 读取 `UIDevice.current` 属性（直接交由 AI 编写此 Swift 类，只有十几行）。 | - `MethodChannel` 双向通信<br>- 平台特征感知与桥接 | ⭐⭐⭐ |
| **`package_info_plus`** | 获取应用版本号、包名、构建号 | 自定义 `MethodChannel`：<br>- Android：通过 `packageManager.getPackageInfo` 获取。<br>- iOS：通过 `Bundle.main.infoDictionary` 读取。 | - 双端应用打包配置读取<br>- 原生上下文与初始化 | ⭐⭐⭐ |
| **`connectivity_plus`** | 检测当前网络连接状态 | 相比监听系统广播，更轻量的方法是在网络请求层建立心跳检测，或直接在 Dart 侧使用 `InternetAddress.lookup` 域名解析，亦可通过原生广播通道（`EventChannel`）传输网络状态变化。 | - 异步事件流 `EventChannel`<br>- 网络状态轮询与感知 | ⭐⭐⭐⭐ |

---

## 🛠️ 部分核心模块自主实现代码参考（Demo 演示）

### 示例 1：纯 Dart 极简 `Either` 实现（替代 `fpdart`）

```dart
sealed class Either<L, R> {
  const Either();

  T fold<T>(T Function(L l) left, T Function(R r) right);

  Either<L, NewR> map<NewR>(NewR Function(R r) fn) {
    return fold((l) => Left(l), (r) => Right(fn(r)));
  }

  Either<L, NewR> flatMap<NewR>(Either<L, NewR> Function(R r) fn) {
    return fold((l) => Left(l), (r) => fn(r));
  }
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  T fold<T>(T Function(L l) left, T Function(R r) right) => left(value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  T fold<T>(T Function(L l) left, T Function(R r) right) => right(value);
}
```

### 示例 2：纯 Dart 极简 `UuidV4` 生成器（替代 `uuid`）

```dart
import 'dart:math';

class UuidGenerator {
  static final Random _random = Random.secure();

  static String generateV4() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));

    // 设置 UUID v4 的版本位 (0100)
    bytes[6] = (bytes[6] & 0x0F) | 0x40;
    // 设置 UUID 的变体位 (10xx)
    bytes[8] = (bytes[8] & 0x3F) | 0x80;

    final charCodes = <int>[];
    for (var i = 0; i < 16; i++) {
      if (i == 4 || i == 6 || i == 8 || i == 10) {
        charCodes.add(45); // '-' 的 ASCII 码
      }
      final hex = bytes[i].toRadixString(16).padLeft(2, '0');
      charCodes.addAll(hex.codeUnits);
    }
    return String.fromCharCodes(charCodes);
  }
}
```

---

## 📋 下一步建议

1. **评估选择**：您可以先浏览该计划，看是否契合您的预期。
2. **第一步实践**：如果您决定开始，我建议我们从 **“阶段一”** 中的 `uuid` 或 `Either` 开始，因为改动范围非常清晰，并且不需要任何原生逻辑。
3. **逐步替换**：一旦自定义的纯 Dart 工具通过单元测试，我们就立刻在主工程中剔除原依赖，逐步“瘦身”。
