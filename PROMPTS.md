# Listen Portfolio Flutter - AI 开发指南

## 项目简介
这是一个展示个人技术技能和简历的 Flutter 应用。基于 Clean + MVI 架构，使用 Flutter 3.38.3。

## 开发规范
- 代码，日志用英文注释
- 不要随意删除我的注释，可以修改
- 只修改相关代码，不需要格式化调整

## 架构概览
- 依赖层级：lib/core <- lib/shared, lib/uikit <- lib/shared, lib/core <- lib/uikit  
- lib/core：核心架构代码，无业务逻辑，可发布到 pub
- lib/features：业务相关页面
- lib/shared：业务相关公共代码
- lib/uikit：通用组件库

## 关键规则
- 国际化：新字符串需添加到 ja.dart、zh.dart、translations_key.dart
- 存储：敏感数据用 FlutterSecureStorage，SharedPreferences 键值放在 app_constants.dart
- 网络：使用 ApiClient.dio，遵循 Retrofit 注解，错误用 Either<Failure, T>
- 状态管理：Riverpod + MVI 模式，freezed 状态类，BaseEffect 处理副作用
- 测试：新功能需有单元测试，覆盖率 60%+

## 必读核心文件
详细架构设计请参考 README.md。开发前先阅读：
- base_view_model.dart - MVI ViewModel 基类
- base_lifecycle_page.dart - 页面生命周期
- api_client.dart - 网络客户端
- app_nav.dart - 路由管理

## 文档阅读指南

### 项目概览
- **项目介绍**：阅读 `README.md` - 完整的项目架构、技术栈和使用说明
- **开发规范**：阅读本文件 `PROMPTS.md` - AI 开发规范和代码质量要求

### 功能开发
- **待办功能**：阅读 `docs/todo.md` - 未完成的功能列表和开发计划
- **详细设计**：阅读 `docs/` 目录下的所有文档 - 各模块的详细设计文档、API 设计、数据库设计等

### 架构组件
- **核心架构**：阅读 `https://pub.dev/packages/listen_core` - listen_core 包的详细文档
- **UI 组件**：阅读 `https://pub.dev/packages/listen_uikit` - listen_uikit 包的设计系统文档

## 质量要求
- 每个功能完成后添加 docs 文档和单元测试
- 遵循现有代码风格
- 使用函数式编程 (fpdart) 处理错误