# Flutter 客户端测试覆盖率报告 (Flutter Test Coverage Report)

**更新时间**: 2026-08-20  
**分析工具**: Flutter Test Engine + LCOV  
**测试结果**: **529 / 529 测试用例 100% 全部通过 (All tests passed!)**

---

## 📊 Flutter 整体代码覆盖率概览

| 维度 (Dimension) | 统计数值 (Count) | 覆盖率 (Coverage) | 评估状态 |
| :--- | :--- | :--- | :--- |
| **已覆盖代码行 (Lines Hit)** | **5,978** 行 | **69.93%** (~70.0%) | 🟢 良好 |
| **总可执行代码行 (Total Lines)** | **8,548** 行 | — | — |
| **覆盖文件总数 (Total Files)** | **298** 个文件 | — | 🟢 高度覆盖 |

---

## 📦 各业务模块 (Feature / Shared) 覆盖率详情

| 模块路径 (Module Path) | 覆盖行数 / 总行数 (Lines) | 覆盖率 (Coverage) | 包含文件数 | 核心覆盖内容说明 |
| :--- | :--- | :--- | :--- | :--- |
| **`features/splash`** | **52 / 55** | **94.55%** | 5 files | 闪屏页加载、初始化与版本路由分流 |
| **`features/fault_injection`** | **458 / 537** | **85.29%** | 9 files | 7 大受控演练场景（401 重试、500 契约、超时、崩溃熔断等） |
| **`features/home`** | **1,634 / 2,001** | **81.66%** | 66 files | Overview, AboutMe (简历), Projects, Architecture 页面与状态 |
| **`features/settings`** | **1,208 / 1,596** | **75.69%** | 58 files | 主题/Material You、字体切换、语言选择、环境切换、检查更新 |
| **`features/ai_chat`** | **503 / 692** | **72.69%** | 30 files | Gemini AI 智能助手、Token 消耗统计、本地预设 FAQ 问答 |
| **`shared`** | **1,465 / 2,506** | **58.46%** | 67 files | 通用装配层、AuthManager、网络拦截器、日志浮窗、主题管理 |
| **`features/auth`** | **637 / 1,115** | **57.13%** | 61 files | 登录、注册、修改密码、忘记密码、账号注销 |
| **`main.dart`** | **21 / 45** | **46.67%** | 1 file | 应用启动入口与 Core.run 包装 |

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
