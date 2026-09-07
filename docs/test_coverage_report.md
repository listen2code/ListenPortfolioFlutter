# Flutter 客户端测试覆盖率报告 (Flutter Test Coverage Report)

**更新时间**: 2026-09-07  
**分析工具**: Flutter Test Engine + LCOV  
**测试结果**: **562 / 562 测试用例 100% 全部通过 (All tests passed!) (涵盖 98 个测试文件)**

---

## 📊 Flutter 整体代码覆盖率概览

| 维度 (Dimension) | 统计数值 (Count) | 覆盖率 (Coverage) | 评估状态 |
| :--- | :--- | :--- | :--- |
| **已覆盖代码行 (Lines Hit)** | **6,155** 行 | **72.01%** | 🟢 持续提升 (+0.44%) |
| **总可执行代码行 (Total Lines)** | **8,548** 行 | — | — |
| **覆盖文件总数 (Total Files)** | **298** 个文件 | — | 🟢 高度覆盖 |

---

## 📦 各业务模块 (Feature / Shared) 覆盖率详情

| 模块路径 (Module Path) | 覆盖行数 / 总行数 (Lines) | 覆盖率 (Coverage) | 包含文件数 | 核心覆盖内容说明 |
| :--- | :--- | :--- | :--- | :--- |
| **`features/splash`** | **52 / 55** | **94.55%** | 5 files | 闪屏页加载、初始化与版本路由分流 |
| **`features/fault_injection`** | **458 / 537** | **85.29%** | 9 files | 7 大受控演练场景（401 重试、500 契约、超时、崩溃熔断等） |
| **`features/home`** | **1,658 / 2,001** | **82.86%** | 66 files | Overview, AboutMe (简历), Projects (新增本地缓存测试), Architecture |
| **`features/ai_chat`** | **555 / 692** | **80.20%** | 30 files | Gemini AI 智能助手、气泡组件、预设问答、Token 统计与错误重试 |
| **`features/settings`** | **1,230 / 1,596** | **77.07%** | 58 files | 主题/Material You、字体切换、语言选择、回放磁带持久化、检查更新 |
| **`features/auth`** | **689 / 1,115** | **61.79%** | 61 files | 登录、注册、修改密码/忘记密码表单组件与业务用例 |
| **`shared`** | **1,501 / 2,506** | **59.90%** | 67 files | 通用装配层、AuthManager、网络拦截器、QuickActionsManager、Routes |
| **`main.dart`** | **21 / 45** | **46.67%** | 1 file | 应用启动入口与 Core.run 包装 |

---

## 🔍 新增单测成果 (Recent Test Additions)

1. **`ProjectsLocalDataSource`**: 新增 `projects_local_data_source_test.dart` 覆盖项目列表 `SpUtil` 缓存与损坏 JSON 处理。
2. **`QuickActionsManager`**: 新增 `quick_actions_manager_test.dart` 覆盖桌面快捷方式 Platform Channel 注册与多语言监听。
3. **`ResumeLocalDataSource` & `AboutMeLocalDataSource`**: 新增简历与个人信息缓存测试，消除 Home 模块 0% 盲区。
4. **`SettingsRepositoryImpl`**: 新增版本更新解析测试，补全设置层 Repos 覆盖。

---

## 🧪 常用测试命令

### 1. 运行全量测试并生成覆盖率文件
```bash
flutter test --coverage
```
生成文件：`coverage/lcov.info`

### 2. 本地查看 HTML 格式可视化报告 (需要 lcov 工具)
```bash
genhtml coverage/lcov.info -o coverage/html
# 浏览器打开 coverage/html/index.html
```
