# UIKit 模块架构设计文档

## 📋 概述

`lib/uikit` 是一个专为快速搭建 Flutter 应用 UI 而设计的通用组件库。它提供了一套完整、一致、可定制的 UI 组件，支持国际化、主题适配和现代化设计，可以大幅提升开发效率和用户体验。

## 🎨 设计理念

### 核心原则
- **一致性**：统一的视觉风格和交互模式
- **可定制性**：灵活的主题和样式配置
- **国际化支持**：内置多语言文本管理
- **现代化设计**：符合 Material Design 3.0 规范
- **开发友好**：简洁的 API 和丰富的配置选项

### 设计系统
- **色彩系统**：基于 Material Design 色彩规范
- **字体系统**：支持动态字体大小和字体族
- **间距系统**：标准化的 padding 和 margin
- **动画系统**：流畅的过渡动画和微交互

## 🧩 组件分类

### 1. 基础组件 (`Basic Widgets`)

#### CommonText
- **功能**：标准化文本组件
- **特性**：
  - 多种文本样式（标题、正文、说明等）
  - 支持动态字体大小
  - 自动颜色适配（亮色/暗色主题）
  - 文本截断和省略处理
- **使用场景**：所有文本显示需求

```dart
CommonText.titleLarge('标题')
CommonText.bodyMedium('正文内容')
CommonText.labelSmall('标签文本')
```

#### CommonImage
- **功能**：图片显示组件
- **特性**：
  - 多种图片源支持（网络、本地、Asset）
  - 自适应尺寸和宽高比
  - 占位图和错误图处理
  - 圆角和边框样式
  - 缓存优化
- **使用场景**：头像、产品图片、背景图等

```dart
CommonImage.network(
  'https://example.com/image.jpg',
  width: 100,
  height: 100,
  borderRadius: 8,
)
```

#### CommonButton
- **功能**：标准化按钮组件
- **特性**：
  - 多种按钮类型（filled、outlined、text）
  - 加载状态和禁用状态
  - 图标支持
  - 触觉反馈
  - 防抖处理
  - 全宽模式
- **使用场景**：表单提交、导航、操作触发

```dart
CommonButton.filled(
  text: '提交',
  onPressed: () => handleSubmit(),
  isLoading: _isLoading,
)

CommonButton.outlined(
  text: '取消',
  onPressed: () => handleCancel(),
)
```

### 2. 输入组件 (`Input Widgets`)

#### CommonTextField
- **功能**：标准化输入框
- **特性**：
  - 多种输入类型（文本、密码、数字、邮箱）
  - 验证和错误提示
  - 清空按钮
  - 前缀和后缀图标
  - 字符计数
  - 自动聚焦
- **使用场景**：表单输入、搜索框、密码输入

```dart
CommonTextField(
  hintText: '请输入用户名',
  controller: _usernameController,
  validator: (value) => value?.isEmpty == true ? '不能为空' : null,
)
```

#### CommonSwitch
- **功能**：开关组件
- **特性**：
  - 自定义颜色和尺寸
  - 动画过渡效果
  - 状态回调
  - 触觉反馈
- **使用场景**：设置开关、功能切换

```dart
CommonSwitch(
  value: _isEnabled,
  onChanged: (value) => setState(() => _isEnabled = value),
)
```

### 3. 容器组件 (`Container & Presentation`)

#### CommonCard
- **功能**：卡片容器
- **特性**：
  - 阴影和边框样式
  - 圆角和边距配置
  - 点击效果
  - 内容布局选项
- **使用场景**：信息展示、列表项、设置项

```dart
CommonCard(
  child: Column(
    children: [
      CommonText.titleMedium('卡片标题'),
      CommonText.bodySmall('卡片内容'),
    ],
  ),
)
```

#### CommonBadge
- **功能**：徽章组件
- **特性**：
  - 多种颜色主题
  - 数字显示和文本显示
  - 位置定位（右上角、左上角等）
  - 动画效果
- **使用场景**：消息通知、状态标识、数量显示

```dart
CommonBadge(
  count: 5,
  child: Icon(Icons.notifications),
)
```

#### CommonChip
- **功能**：标签组件
- **特性**：
  - 可选中和不可选中状态
  - 删除按钮
  - 自定义颜色
  - 流式布局
- **使用场景**：标签选择、筛选器、技能展示

```dart
CommonChip(
  label: 'Flutter',
  selected: _selectedTags.contains('Flutter'),
  onSelected: (selected) => handleTagSelection('Flutter', selected),
)
```

#### CommonListItem
- **功能**：列表项组件
- **特性**：
  - 标准化列表布局
  - 前缀图标、标题、副标题、后缀图标
  - 点击和长按效果
  - 分割线支持
- **使用场景**：设置列表、菜单列表、数据列表

```dart
CommonListItem(
  leading: Icon(Icons.settings),
  title: '设置',
  subtitle: '应用设置和偏好',
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () => navigateToSettings(),
)
```

### 4. 反馈组件 (`Feedback & Loading`)

#### CommonToast
- **功能**：提示消息组件
- **特性**：
  - 多种提示类型（成功、错误、警告、信息）
  - 自动消失和手动关闭
  - 位置配置（顶部、中部、底部）
  - 自定义图标和颜色
- **使用场景**：操作反馈、状态提示、错误提醒

```dart
CommonToast.success('操作成功')
CommonToast.error('操作失败')
CommonToast.info('提示信息')
```

#### CommonLoading
- **功能**：加载指示器
- **特性**：
  - 多种加载样式（圆形、线性、骨架屏）
  - 自定义颜色和尺寸
  - 文本提示支持
  - 全屏覆盖模式
- **使用场景**：数据加载、页面切换、异步操作

```dart
CommonLoading.circular()
CommonLoading.linear()
CommonLoading.skeleton()
```

#### CommonDialog
- **功能**：对话框组件
- **特性**：
  - 多种对话框类型（确认、警告、输入、自定义）
  - 按钮配置（确认、取消、自定义）
  - 内容区域自定义
  - 动画效果
- **使用场景**：确认操作、信息展示、用户输入

```dart
CommonDialog.confirm(
  title: '确认删除',
  content: '删除后无法恢复，确定继续？',
  onConfirm: () => handleDelete(),
)
```

#### CommonSkeleton
- **功能**：骨架屏组件
- **特性**：
  - 多种骨架样式（文本、图片、列表）
  - 渐变动画效果
  - 自定义颜色和速度
  - 响应式布局
- **使用场景**：内容加载占位、提升用户体验

```dart
CommonSkeleton.text()
CommonSkeleton.avatar()
CommonSkeleton.list()
```

#### CommonEmptyView
- **功能**：空状态视图
- **特性**：
  - 多种空状态类型（无数据、网络错误、搜索无结果）
  - 自定义图标和文本
  - 重试按钮支持
  - 国际化文本
- **使用场景**：列表空状态、错误状态、搜索结果为空

```dart
CommonEmptyView.noData(
  onRetry: () => loadData(),
)
```

#### CommonRefreshList
- **功能**：下拉刷新列表
- **特性**：
  - 下拉刷新和上拉加载
  - 自定义刷新指示器
  - 空状态和错误状态处理
  - 性能优化
- **使用场景**：数据列表、新闻列表、商品列表

```dart
CommonRefreshList(
  onRefresh: () => loadData(),
  onLoadMore: () => loadMoreData(),
  itemBuilder: (context, item) => ListItem(data: item),
)
```

## 🌍 国际化支持

### UIKitConfig
UIKit 通过 `UIKitConfig` 提供国际化支持：

```dart
UIKitConfig.init(
  stringProvider: (key) => I18nKeys.translate(key),
);
```

### 支持的文本键
- `kOk` - 确认按钮
- `kCancel` - 取消按钮
- `kLoading` - 加载文本
- `kNoData` - 无数据文本
- `kNoResults` - 无结果文本
- `kLoadFailed` - 加载失败文本
- `kRetry` - 重试按钮
- `kAccessDenied` - 访问被拒绝文本

## 🎨 主题定制

### 颜色主题
UIKit 自动适配应用的 `ThemeData`，支持：
- 亮色/暗色主题切换
- 自定义主色调
- 动态颜色（Android 12+）

### 字体主题
- 支持系统字体大小调整
- 自定义字体族
- 多级字体大小（display, headline, title, body, label）

## 🚀 快速开始

### 1. 初始化 UIKit

```dart
import 'package:your_app/uikit/uikit.dart';

void main() {
  // 初始化国际化
  UIKitConfig.init(
    stringProvider: (key) => I18nKeys.translate(key),
  );
  
  runApp(MyApp());
}
```

### 2. 使用组件

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CommonText.titleLarge('欢迎使用 UIKit'),
          CommonButton.filled(
            text: '点击我',
            onPressed: () => CommonToast.success('按钮被点击了'),
          ),
          CommonCard(
            child: CommonText.bodyMedium('这是一个卡片组件'),
          ),
        ],
      ),
    );
  }
}
```

## 📦 组件统计

| 类别 | 组件数量 | 主要用途 |
|------|----------|----------|
| 基础组件 | 5 | 文本、图片、按钮、交互 |
| 输入组件 | 2 | 表单输入、状态切换 |
| 容器组件 | 4 | 布局、展示、分组 |
| 反馈组件 | 6 | 加载、提示、错误、空状态 |
| **总计** | **17** | **完整的 UI 解决方案** |

## 🎯 使用场景

### 适合的项目类型
- **企业应用**：需要统一的 UI 规范
- **快速原型**：需要快速搭建界面
- **多应用项目**：需要一致的视觉体验
- **设计系统**：需要标准化的组件库

### 最佳实践
1. **一致性优先**：优先使用 UIKit 组件保持界面一致性
2. **主题适配**：充分利用主题系统支持多风格
3. **国际化考虑**：使用 UIKitConfig 处理多语言
4. **性能优化**：合理使用 const 构造函数

## 🔮 未来规划

### 短期目标
- [ ] 添加更多高级组件（表格、图表等）
- [ ] 完善动画效果库
- [ ] 增加主题预设模板

### 长期目标
- [ ] 支持自定义主题编辑器
- [ ] 集成设计系统工具
- [ ] 提供组件预览和文档网站

---

UIKit 模块为 Flutter 应用提供了完整、现代、易用的 UI 解决方案，让开发者能够快速构建美观、一致的用户界面。
