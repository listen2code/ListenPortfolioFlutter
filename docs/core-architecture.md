# Core 模块架构设计文档

## 📋 概述

`lib/core` 是一个可独立发布到 Pub 的 Flutter 底层框架，专为快速开发 Flutter 应用而设计。它提供了完整的应用基础设施，包括网络请求、状态管理、路由管理、错误处理、国际化等核心功能，可以无缝集成到任何 Flutter 项目中。

## 🏗️ 架构设计

### 设计原则
- **零业务耦合**：不包含任何业务逻辑，完全通用
- **可发布性**：可独立提取为 Pub 包
- **高度可配置**：通过配置类灵活定制行为
- **生产就绪**：包含完整的错误处理、日志、性能监控

### 模块结构

```
lib/core/
├── base/           # 基础架构层
├── config/         # 配置管理
├── core.dart       # 统一导出
├── core_initializer.dart  # 初始化管理
├── env/            # 环境配置
├── errors/         # 错误处理
├── i18n/           # 国际化
├── network/        # 网络层
├── route/          # 路由管理
└── utils/          # 工具类
```

## 🔧 核心功能模块

### 1. 基础架构层 (`base/`)

#### BaseViewModel
- **功能**：MVI 架构的 ViewModel 基类
- **特性**：状态管理、生命周期处理、副作用管理
- **使用场景**：所有页面的业务逻辑层

#### BaseLifecyclePage
- **功能**：页面生命周期管理
- **特性**：自动处理页面状态、资源释放
- **使用场景**：需要生命周期管理的页面

#### BaseScaffoldPage
- **功能**：统一页面结构
- **特性**：标准化的页面布局、导航栏、状态栏
- **使用场景**：应用中的标准页面

#### BaseEffect
- **功能**：副作用处理
- **特性**：导航、弹窗、提示等副作用统一管理
- **使用场景**：ViewModel 中的副作用处理

### 2. 网络层 (`network/`)

#### ApiClient
- **功能**：统一的 HTTP 客户端
- **特性**：
  - 自动认证拦截器
  - 401 自动刷新 + 请求队列
  - 分布式追踪支持
  - 错误统一处理
- **使用场景**：所有 API 请求

#### BaseRepository
- **功能**：数据仓库基类
- **特性**：安全调用、缓存、错误映射
- **使用场景**：数据层抽象

#### LocalMockServer
- **功能**：本地 Mock 服务器
- **特性**：
  - 端口 9999 HTTP 服务
  - JSON/图片资源服务
  - 网络延迟模拟
- **使用场景**：开发阶段离线开发

### 3. 配置管理 (`config/`)

#### NetworkConfig
- **功能**：网络相关配置
- **可配置**：HTTP 状态码、访客路径、认证键

#### ResponseConfig
- **功能**：API 响应结构配置
- **可配置**：JSON 字段名、结果码

#### LogConfig
- **功能**：日志系统配置
- **可配置**：日志限制、标签、时间格式

#### MockServerConfig
- **功能**：Mock 服务器配置
- **可配置**：端口、延迟、图片类型

### 4. 路由管理 (`route/`)

#### AppNav
- **功能**：应用路由管理
- **特性**：路由注册、导航控制、深度链接

#### RouteInterceptor
- **功能**：路由拦截器
- **特性**：访客模式检测、登录跳转、权限控制

### 5. 工具类 (`utils/`)

#### ZoneManager
- **功能**：Zone 上下文管理
- **特性**：分布式追踪、性能监控、请求取消

#### CrashManager
- **功能**：崩溃保护
- **特性**：快速崩溃检测、安全模式、自动恢复

#### LogManager
- **功能**：日志管理
- **特性**：结构化日志、实时查看、导出功能

#### EventBus
- **功能**：事件总线
- **特性**：跨组件通信、状态同步

## 🚀 快速开始

### 1. 初始化 Core

```dart
import 'package:your_app/core/core.dart';

void main() async {
  // 使用默认配置
  await Core.init(CoreConfig.defaultConfig());
  
  // 或自定义配置
  await Core.init(CoreConfig(
    networkConfig: NetworkConfig(
      visitorPaths: ['/public/api'],
    ),
    logConfig: LogConfig(maxLogs: 200),
  ));
  
  runApp(MyApp());
}
```

### 2. 创建 ViewModel

```dart
class MyViewModel extends BaseViewModel<MyState, MyIntent> {
  @override
  MyState get initialState => MyState.initial();
  
  @override
  Stream<MyState> handleIntent(MyIntent intent) async* {
    // 处理业务逻辑
  }
}
```

### 3. 创建页面

```dart
class MyPage extends BaseLifecyclePage<MyViewModel, MyState> {
  @override
  Widget buildContent(BuildContext context, MyState state) {
    return Scaffold(
      body: Center(child: Text('Hello Core')),
    );
  }
}
```

## 📦 发布到 Pub

Core 模块设计为可独立发布的 Pub 包：

### 依赖要求
```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.0.0
  riverpod: ^2.0.0
  fpdart: ^1.0.0
  # ... 其他依赖
```

### 发布步骤
1. 提取 `lib/core` 到独立仓库
2. 更新 `pubspec.yaml` 元数据
3. 发布到 Pub.dev

## 🎯 使用场景

### 适合的应用类型
- **企业级应用**：需要完整的架构支持
- **快速原型**：需要快速搭建基础框架
- **多应用项目**：需要统一的技术栈
- **开源项目**：需要标准化的架构

### 不适合的场景
- **简单工具**：过度工程化
- **特殊需求**：需要深度定制的基础设施

## 🔮 未来规划

### 短期目标
- [ ] 添加更多配置选项
- [ ] 完善单元测试覆盖率
- [ ] 优化性能监控

### 长期目标
- [ ] 支持更多平台（Web、Desktop）
- [ ] 集成更多第三方服务
- [ ] 提供可视化配置工具

---

Core 模块为 Flutter 应用提供了坚实的技术基础，让开发者专注于业务逻辑而不是基础设施搭建。
