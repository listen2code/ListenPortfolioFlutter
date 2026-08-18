# AI Intro Assistant — 实现方案说明书

**Status**: `Fully Implemented (Direct Client Firebase Google AI SDK with App Check Enforcement)`

> 本文档描述了已落地的 AI 智能架构与技术咨询助手模块设计及底层数据流。目前已完全落地官方 `firebase_ai` SDK 直连模式，选用 Google Gemini 最新标准模型 **`gemini-3.7-flash`**，基于 Firebase App Check 实现强安全防刷保护，搭配全局可拖拽防抖悬浮球与独立 `AiChatPage` 页面，具备毫秒级本地预设 Q&A 模糊匹配、多模式切换与全生命周期路由返回手势支持。

## 1. 概述

### 1.1 产品定位

**架构知识库与技术介绍助手**：面试官与访客通过 AI 助手快速了解本 App 的架构设计（MVI、Zone tracing、APM、401 并发队列等）和功能实现细节，获得对候选人技术能力的深度认知。

### 1.2 核心决策摘要

| 决策项 | 选择 | 理由 |
|--------|------|------|
| 产品形态 | 架构知识库与个人作品 Q&A | 直击技术深度与工程亮点 |
| 知识注入 | 本地多路由 FAQ 检索 + 动态 Prompt 注入 | 0 Token 毫秒级命中常见问答，复杂提问走云端 LLM |
| LLM 提供商 | Google Gemini **`gemini-3.7-flash`** | Google AI 最新官方标准，响应迅速，成本低 |
| SDK 与通道 | Direct Client SDK (`FirebaseAI.googleAI`) | 纯原生直连体验，免去自建代理服务开销与延迟 |
| 安全与防护 | Firebase App Check (Play Integrity / Debug Token) | 强制设备真实性证明，杜绝 API Key 被非法逆向盗刷 |
| FAQ/LLM 切换 | 本地模糊关键词优先匹配，未命中走 Gemini | 极致节省 Token 与网络开销 |
| UI 与路由 | 全局拖拽悬浮球 (`GlobalAiChatOverlay`) + 独立页面 (`AiChatPage`) | 100% 兼容 Android Predictive Back / iOS 原生侧滑返回手势 |
| 月预算 | $0（Google AI Developer 免费层） | 充足的免费 RPM 额度，完美满足作品集演示场景 |

### 1.3 用户场景

```
面试官/访客打开 Portfolio App → 点击右下角可拖拽 AI 悬浮图标
→ 页面平滑推入 AiChatPage
→ 自动感知当前处于的页面与 Tab（如 Overview / Resume）并推荐关联的精选预设问题
→ 点击预设问题 → 立即匹配本地问答库返回权威解答（0 延迟、0 Token 消耗）
→ 输入自定义复杂问题 "你的 AuthInterceptor 并发队列和 401 刷新怎么实现的？"
→ 客户端动态拼装当前页面上下文与角色 System Prompt
→ 直连 Google Gemini 3.7 Flash 模型（受 Firebase App Check 安全防护）
→ 返回结构化 Markdown 技术解析（流式或秒级响应）
→ 侧滑或点击顶部返回，平滑退出并保留浏览状态
```

---

## 2. 系统架构

> [!IMPORTANT]
> **开发状态**：前端功能（UI 气泡、滑出面板、本地问答库匹配、页面路由/Tab关联、状态流管理、国际化）已完全落地实现并整合进主工程。后端 API（如 `/v1/ai/chat` 等）目前由 `LocalMockServer`（配置位于 `assets/mock/v1`）提供模拟响应，作为后端未来落地的协议标准。

### 2.1 整体数据流

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Flutter App                                  │
│                                                                     │
│  ┌──────────┐    ┌──────────────┐    ┌────────────────────────┐    │
│  │ 预设问题  │    │  自由输入框   │    │   Chat 消息列表         │    │
│  │ 列表      │    │              │    │   (问题 + 回答)         │    │
│  └────┬─────┘    └──────┬───────┘    └────────────────────────┘    │
│       │                 │                                           │
│       └────────┬────────┘                                           │
│                ▼                                                     │
│       ┌────────────────┐                                            │
│       │ AiChatViewModel│  ← MVI 架构，管理对话状态                   │
│       └────────┬───────┘                                            │
│                │ POST /v1/ai/chat                                    │
└────────────────┼────────────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     Spring Boot Backend                              │
│                                                                      │
│  ┌─────────────┐    ┌──────────────┐    ┌────────────────────────┐  │
│  │ AiController │───▶│  AiService   │───▶│  FAQ 关键词匹配        │  │
│  │ POST /v1/ai │    │              │    │  (HashMap<关键词, 答案>) │  │
│  │ /chat       │    │              │    └──────────┬─────────────┘  │
│  └─────────────┘    │              │               │                │
│        ↑            │              │          命中？│                │
│   @RateLimit        │              │         ┌─────┴──────┐        │
│   (复用现有限流)     │              │         │ Yes    No  │        │
│                     │              │         ▼            ▼         │
│                     │              │    直接返回    ┌────────────┐  │
│                     │              │    FAQ 答案    │ RAG 检索   │  │
│                     │              │               │            │  │
│                     │              │               │ 1.问题Embed│  │
│                     │              │               │ 2.余弦相似 │  │
│                     │              │               │ 3.Top-K片段│  │
│                     │              │               └─────┬──────┘  │
│                     │              │                     │         │
│                     │              │                     ▼         │
│                     │              │              ┌────────────┐   │
│                     │              │              │ Prompt 拼装 │   │
│                     │              │              │ System +   │   │
│                     │              │              │ Context +  │   │
│                     │              │              │ Question   │   │
│                     │              │              └─────┬──────┘   │
│                     │              │                    │          │
│                     │              │                    ▼          │
│                     │              │            ┌──────────────┐   │
│                     │              │            │ Gemini API   │   │
│                     │              │            │ (外部调用)    │   │
│                     │              │            └──────┬───────┘   │
│                     │              │                   │           │
│                     │              │◀──────────────────┘           │
│                     │              │                               │
│                     │   ┌─────────▼──────────┐                    │
│                     │   │ 日志 + 行为记录      │                    │
│                     │   │ (question, source,  │                    │
│                     │   │  latency, tokens)   │                    │
│                     │   └────────────────────┘                    │
│                     │                                              │
└─────────────────────┼──────────────────────────────────────────────┘
                      │
                      ▼
              ┌──────────────┐
              │ Gemini API   │
              │ (Google AI)  │
              │ 免费额度      │
              └──────────────┘
```

### 2.2 RAG Pipeline 详解

```
                    ===== 离线阶段（启动时执行一次）=====

  docs/                    Chunking                  Gemini Embedding API
  ├── README.md      ──▶  按 ## heading 分块   ──▶  text-embedding-004
  ├── todo.md              每块 200-500 tokens        ──▶ 768维向量
  ├── architecture.md
  └── ...
                                                          │
                                                          ▼
                                                   ┌────────────────┐
                                                   │ 内存 Vector     │
                                                   │ Store           │
                                                   │                 │
                                                   │ List<DocChunk>  │
                                                   │  - id           │
                                                   │  - text         │
                                                   │  - source       │
                                                   │  - embedding[]  │
                                                   └────────────────┘

                    ===== 在线阶段（每次提问）=====

  用户问题                 Gemini Embedding API       余弦相似度计算
  "Zone tracing     ──▶  text-embedding-004    ──▶  与所有 chunk 比较
   怎么实现的？"           ──▶ 768维向量               ──▶ Top-3 片段
                                                          │
                                                          ▼
                                                   ┌────────────────┐
                                                   │ Prompt 拼装     │
                                                   │                 │
                                                   │ System: 你是... │
                                                   │ Context: [Top3] │
                                                   │ Question: ...   │
                                                   └───────┬────────┘
                                                           │
                                                           ▼
                                                   ┌────────────────┐
                                                   │ Gemini Flash    │
                                                   │ generateContent │
                                                   └───────┬────────┘
                                                           │
                                                           ▼
                                                       回答文本
```

### 2.3 企业级向量存储升级路径

```
阶段 1（当前）           阶段 2                    阶段 3
内存 HashMap       ──▶  MySQL + JSON 列      ──▶  Qdrant (Docker)
                        (现有基础设施)               (专业向量数据库)

适用规模:               适用规模:                  适用规模:
< 100 个向量            < 10,000 个向量            百万级向量
启动时全量加载           SQL 查询 + 应用层计算       ANN 近似最近邻搜索
余弦相似度全量扫描       支持持久化和备份             毫秒级检索

核心原理完全相同：embedding → cosine similarity → top-K retrieval
```

---

## 3. 技术栈

### 3.1 后端新增（Spring Boot）

| 组件 | 用途 | 依赖 |
|------|------|------|
| `AiController` | 新增 REST endpoint | 无新增依赖 |
| `AiService` | FAQ 匹配 + RAG 编排 + Gemini 调用 | 无新增依赖 |
| `FaqRepository` | 预设 Q&A 存储（内存 HashMap） | 无新增依赖 |
| `VectorStore` | 文档向量存储 + 相似度搜索 | 无新增依赖 |
| `GeminiClient` | 调用 Gemini API（REST） | Spring WebClient（已有） |
| `DocumentLoader` | 启动时加载 + 分块文档 | 无新增依赖 |

> **零新增 Maven 依赖**：Gemini API 是标准 REST，用 Spring 自带的 WebClient/RestTemplate 即可调用。

### 3.2 前端新增（Flutter）

### 3.2 前端新增（Flutter）

### Phase 3：前端 — Flutter 独立页面与组件化架构（已完全落地）

目前前端架构已根据 Clean Architecture + MVI 设计模式完全落实：

| 模块 | 功能 | 落地文件 |
|------|------|----------|
| **Page Route** | AI 对话独立页面，承载 `Scaffold` 并原生支持 Android Predictive Back 与 iOS 边缘滑动返回 | [ai_chat_page.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/ai_chat/presentation/pages/ai_chat_page.dart) (`Routes.aiChat`) |
| **Global Overlay** | 全局可拖拽悬浮入口（智能防抖识别点击/拖拽，并感知路由动态隐藏/显示） | [global_ai_chat_overlay.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/ai_chat/presentation/pages/global_ai_chat_overlay.dart) |
| **Floating Button** | 磨砂毛玻璃圆形悬浮球，支持触摸位移防抖判断与平滑拖曳 | [ai_chat_floating_button.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/ai_chat/presentation/widgets/ai_chat_floating_button.dart) |
| **AI Panel** | 对话面板主体（包含状态监听、自动滚动与主题自适应） | [ai_chat_panel.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/ai_chat/presentation/widgets/ai_chat_panel.dart) |
| **Header & Mode** | 顶部栏（支持长文本标题截断防护、清除历史）与三种 Persona 模式切换器 | [ai_chat_header.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/ai_chat/presentation/widgets/ai_chat_header.dart)<br>[ai_chat_mode_selector.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/ai_chat/presentation/widgets/ai_chat_mode_selector.dart) |
| **Chat Stream & FAQ** | 消息气泡列表（Markdown 高亮渲染、重发逻辑）与页面级预设 FAQ 推荐 | [ai_chat_message_list.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/ai_chat/presentation/widgets/ai_chat_message_list.dart)<br>[ai_preset_questions.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/ai_chat/presentation/widgets/ai_preset_questions.dart) |
| **Input Bar** | 底部消息输入与发送控制条 | [ai_chat_input_bar.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/ai_chat/presentation/widgets/ai_chat_input_bar.dart) |
| **State & Intent** | MVI 状态与意图（消息列表、三种模式、加载/失败状态、FAQ 字典） | [ai_chat_state.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/ai_chat/presentation/pages/ai_chat_state.dart)<br>[ai_chat_intent.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/ai_chat/presentation/pages/ai_chat_intent.dart) |
| **ViewModel** | 状态机分发、本地 FAQ 模糊快速检索、Firebase AI 远程交互编排 | [ai_chat_view_model.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/features/ai_chat/presentation/pages/ai_chat_view_model.dart) |
| **Firebase AI Service** | 官方 `firebase_ai` SDK 直连驱动 (`FirebaseAI.googleAI` + `gemini-3.7-flash`) | [firebase_ai_service.dart](file:///c:/Users/liste/Downloads/github/ListenPortfolioFlutter/lib/shared/services/firebase/firebase_ai_service.dart) |

#### 3.8 核心机制与设计考量

##### 3.8.1 独立页面路由与原生返回手势支持
为彻底解决多平台系统级边缘滑动返回（如 Android 13/14+ Predictive Back 与 iOS 侧滑手势）被浮层事件吞噬的问题，我们将展开后的 AI Chat 升级为独立的二级标准页面 `AiChatPage` (`Routes.aiChat = '/ai_chat'`):
* 浮层 `GlobalAiChatOverlay` 仅负责悬浮球的可拖拽交互和页面唤起。
* 点击悬浮球调用标准路由 `AppNav.to(Routes.aiChat)`。
* 物理返回键、系统预测性手势、iOS 边缘滑动均由 Flutter 路由栈原生安全接管。

##### 3.8.2 悬浮球手势智能防抖
针对真机触摸屏上微小手指抖动可能导致 `GestureDetector.onPanUpdate` 吞掉 `onTap` 的问题，在 `AiChatFloatingButton` 中加入了智能位移判定（位移 < 6.0px 视为点击），确保 100% 灵敏触发跳转。

##### 3.8.3 本地预设 QA 机制与 0-Token 防刷保护
* **本地快速匹配**：启动时获取全量预设问答 `portfolio_qa.json` 缓存在本地。
* **Tab 动态联动**：自动感知用户浏览到的路由与 Tab（如 `/home?tab=resume`），实时刷新当前页面专属的热门问题。
* **模糊关键词命中**：用户自由提问时，优先检索本地 QA 库，命中即刻返回，0 延迟且 0 Token 消耗。

##### 3.8.4 Direct Client + Firebase App Check 安全
* 使用官方 `firebase_ai` 的 `FirebaseAI.googleAI` 直接向 Google Gemini `gemini-3.7-flash` 发起请求。
* 结合 Firebase App Check（Play Integrity / App Attest / Debug Token）对请求设备进行合法性背书，防止 API 凭证被逆向滥用。

### 3.3 环境变量新增

```properties
# application.properties 新增
# Gemini API（后端代理调用）
gemini.api.key=${GEMINI_API_KEY:}
gemini.api.model=${GEMINI_MODEL:gemini-1.5-flash}
gemini.api.embedding-model=${GEMINI_EMBEDDING_MODEL:text-embedding-004}
gemini.api.base-url=https://generativelanguage.googleapis.com/v1beta

# AI 功能配置
ai.faq.enabled=true
ai.rag.enabled=true
ai.rag.top-k=3
ai.rag.similarity-threshold=0.7
ai.rate-limit.max-requests=10
ai.rate-limit.time-window-seconds=60
```

```bash
# .env.example 新增
GEMINI_API_KEY=your-gemini-api-key
```

---

## 4. 分步执行计划

### Phase 0：准备工作（1 天）

| 步骤 | 任务 | 产出 |
|------|------|------|
| 0.1 | 申请 Google AI Studio API Key | API Key |
| 0.2 | 本地测试 Gemini API（curl 验证连通性） | 确认免费额度可用 |
| 0.3 | 梳理知识库文档清单（哪些 docs 需要喂给 RAG） | 文档清单 |

```bash
# 0.2 验证 Gemini API
curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=YOUR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"Hello"}]}]}'
```

### Phase 1：后端 — FAQ 基础（2 天）

| 步骤 | 任务 | 文件 |
|------|------|------|
| 1.1 | 创建 `AiController`：`POST /v1/ai/chat` | `api/v1/ai/AiController.java` |
| 1.2 | 创建 `AiChatRequest` / `AiChatResponse` DTO | `api/v1/ai/dto/` |
| 1.3 | 创建 `FaqRepository`：HashMap 存储 30-50 个预设 Q&A | `service/ai/FaqRepository.java` |
| 1.4 | 创建 `AiService`：先实现纯 FAQ 匹配逻辑 | `service/ai/AiService.java` |
| 1.5 | 添加 `@RateLimit` 限流（10次/分钟/IP） | 复用现有 `@RateLimit` |
| 1.6 | 单元测试：FAQ 匹配命中/未命中 | `test/.../AiServiceTest.java` |

**FAQ 数据结构**：

```java
public class FaqEntry {
    private List<String> keywords;  // 触发关键词
    private String question;         // 标准问题文本
    private String answer;           // 预设回答
    private String category;         // 分类：architecture / feature / tech-stack
}
```

**FAQ 匹配逻辑**：

```
用户输入 → 分词/小写化 → 逐条 FAQ 计算关键词命中数
→ 命中数 >= 阈值 → 返回匹配度最高的 FAQ 答案
→ 命中数 < 阈值 → 标记为 "FAQ_MISS"，进入 Phase 2 的 RAG 流程
```

**Phase 1 交付标准**：FAQ 能独立工作，curl 可测试，覆盖 30+ 常见架构问题。

### Phase 2：后端 — RAG Pipeline（3-4 天）

| 步骤 | 任务 | 文件 |
|------|------|------|
| 2.1 | 创建 `DocumentLoader`：读取 docs/*.md + README.md | `service/ai/rag/DocumentLoader.java` |
| 2.2 | 实现文档分块（Chunking）：按 `##` heading 切分，每块 200-500 tokens | `service/ai/rag/DocumentChunker.java` |
| 2.3 | 创建 `GeminiClient`：封装 Embedding + Generate 两个 API | `service/ai/GeminiClient.java` |
| 2.4 | 创建 `VectorStore`：内存存储 + 余弦相似度搜索 | `service/ai/rag/VectorStore.java` |
| 2.5 | 实现 `@PostConstruct` 初始化：启动时加载文档 → 分块 → 向量化 → 存入内存 | `service/ai/rag/RagInitializer.java` |
| 2.6 | 实现 RAG 检索 + Prompt 拼装 + Gemini 调用 | `service/ai/AiService.java` 扩展 |
| 2.7 | 集成测试：FAQ 未命中 → RAG 返回合理答案 | `test/.../RagIntegrationTest.java` |

**Prompt 模板**：

```
[System]
你是 Listen 的 Portfolio App 技术助手。你的职责是根据提供的技术文档，
准确回答面试官关于这个 Flutter + Spring Boot 项目的架构和实现问题。

规则：
- 只基于提供的文档内容回答，不要编造
- 如果文档中没有相关信息，诚实地说"这部分暂未文档化"
- 回答保持专业、简洁，适合技术面试场景
- 可以引用具体的文件路径和类名

[Context — RAG 检索结果]
--- 文档片段 1 (来源: README.md > JWT Token 流程) ---
{chunk_1_text}

--- 文档片段 2 (来源: docs/todo.md > 架构与基础设施) ---
{chunk_2_text}

--- 文档片段 3 (来源: PROMPTS.md > 架构概览) ---
{chunk_3_text}

[User]
{用户的问题}
```

**Phase 2 交付标准**：完整 RAG pipeline 工作，FAQ 未命中时自动 fallback 到 RAG + Gemini。

### Phase 3：前端 — Flutter Chat UI（已完成）

> [!NOTE]
> 前端 UI 与架构设计已于 Phase 3 落地完成。具体实现细节、架构文件层级及核心机制设计考量，请参见 **[3.2 章节 — 前端完成状态 (Frontend Complete)](#32-前端新增flutter)**。

**Phase 3 交付标准**：完整的 Chat UI，支持根据页面关联推荐预设问题 + 自由输入，完全契合 Clean & MVI 架构，测试套件 100% 通过。

### Phase 4：隐私合规（1 天）

| 步骤 | 任务 | 产出 |
|------|------|------|
| 4.1 | 创建隐私政策页面（App 内 + Web URL） | `privacy_policy.html` |
| 4.2 | AI 功能首次使用时弹出知情同意弹窗 | `AiConsentDialog` |
| 4.3 | Settings 页面添加 AI 数据设置（开关 + 删除历史） | Settings 扩展 |
| 4.4 | 后端：不持久化用户问题原文，只记录脱敏摘要 | 日志脱敏 |

**知情同意弹窗内容**：

```
┌──────────────────────────────┐
│  AI 助手隐私说明              │
│                              │
│  本功能使用 Google Gemini     │
│  AI 服务处理您的提问。        │
│                              │
│  • 您的问题会发送到 Google    │
│    服务器进行处理             │
│  • 我们不会存储您的对话内容   │
│  • 您可以随时在设置中关闭     │
│    此功能                    │
│                              │
│  [查看隐私政策]              │
│                              │
│  [拒绝]          [同意并继续] │
└──────────────────────────────┘
```

**合规要点**：

| 要求 | 实现方式 |
|------|----------|
| 数据最小化 | 只发送问题文本，不发送用户身份信息 |
| 知情同意 | 首次使用弹窗 + Settings 中可撤回 |
| 第三方披露 | 隐私政策明确说明使用 Google Gemini |
| 数据删除权 | 不持久化对话，无需删除 |
| 日本个人情報保護法 | 同上，无个人信息离开设备 |
| Google Play 要求 | 隐私政策 URL 可公开访问 |

### Phase 5：可观测性（1 天）

| 步骤 | 任务 | 产出 |
|------|------|------|
| 5.1 | 后端：每次请求记录结构化日志 | JSON 日志 |
| 5.2 | 后端：Prometheus 指标（请求数、延迟、token 用量） | Actuator 指标 |
| 5.3 | 后端：行为分析数据表（脱敏） | MySQL 表 |
| 5.4 | Grafana：AI 功能仪表板 | Dashboard JSON |

**结构化日志**：

```json
{
  "timestamp": "2026-04-10T14:30:00Z",
  "event": "ai_chat_request",
  "source": "FAQ | RAG",
  "question_category": "architecture",
  "question_length": 45,
  "answer_length": 320,
  "latency_ms": 1850,
  "tokens_used": 580,
  "faq_matched": false,
  "rag_top_similarity": 0.82,
  "rag_chunks_used": 3
}
```

**Prometheus 指标**：

```
ai_chat_requests_total{source="faq|rag"}     — 请求总数
ai_chat_latency_seconds{source="faq|rag"}    — 响应延迟直方图
ai_chat_tokens_total                          — token 消耗总量
ai_chat_faq_hit_ratio                         — FAQ 命中率
ai_chat_errors_total{type="gemini|timeout"}   — 错误计数
```

**行为分析表**（脱敏，不存原文）：

```sql
CREATE TABLE ai_chat_analytics (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source ENUM('FAQ', 'RAG') NOT NULL,
    question_category VARCHAR(50),       -- architecture / feature / tech-stack
    question_token_count INT,
    answer_token_count INT,
    latency_ms INT,
    faq_entry_id VARCHAR(50),            -- 命中的 FAQ ID（如有）
    rag_top_similarity DECIMAL(4,3),     -- RAG 最高相似度
    session_id VARCHAR(36)               -- 匿名会话 ID（UUID，不关联用户）
);
```

**行为分析价值**（回答你之前"未定"的问题）：

| 指标 | 用途 |
|------|------|
| FAQ 命中率 | 如果 < 50%，说明 FAQ 覆盖不足，需要补充 |
| 高频问题分类 | 面试官最关心什么？架构 > 功能 > 技术栈？ |
| RAG 相似度分布 | 如果大量 < 0.5，说明知识库有盲区 |
| 平均对话深度 | 面试官通常问几个问题？1 个还是 5 个？ |
| 延迟分布 | Gemini API 是否稳定？P95 延迟多少？ |

---

## 5. FAQ 知识库内容规划

### 5.1 分类与示例（建议 30-50 条）

#### 架构类（~15 条）

| # | 预设问题 | 关键词 |
|---|----------|--------|
| 1 | 项目的整体架构是什么？ | `架构, architecture, 设计, design` |
| 2 | 为什么选择 Clean + MVI 而不是 MVVM？ | `MVI, MVVM, 状态管理, state` |
| 3 | 你的网络层是怎么设计的？ | `网络, network, API, Retrofit, Dio` |
| 4 | 错误处理机制是什么？ | `错误, error, Failure, Either` |
| 5 | BaseRepository 的 safeCall 是什么？ | `safeCall, Repository, 缓存, cache` |
| 6 | 你的依赖层级是怎么划分的？ | `依赖, dependency, core, shared, uikit` |

#### 功能实现类（~15 条）

| # | 预设问题 | 关键词 |
|---|----------|--------|
| 7 | JWT 认证流程是怎么实现的？ | `JWT, token, 认证, auth, 登录` |
| 8 | AuthInterceptor 的 401 并发队列是怎么工作的？ | `401, refresh, 并发, queue, interceptor` |
| 9 | CrashManager 的 Safe Mode 是什么？ | `crash, safe mode, 崩溃, 保护` |
| 10 | Zone tracing 是做什么的？ | `Zone, tracing, 性能, performance` |
| 11 | 限流系统是怎么实现的？ | `限流, rate limit, Redis, AOP` |
| 12 | 邮件服务是怎么实现的？ | `邮件, email, SMTP, 密码重置` |

#### 技术栈类（~10 条）

| # | 预设问题 | 关键词 |
|---|----------|--------|
| 13 | 为什么选 Riverpod 而不是 Bloc？ | `Riverpod, Bloc, Provider, 状态` |
| 14 | 为什么用 Freezed？ | `Freezed, 不可变, immutable, union` |
| 15 | 后端为什么用 Spring Boot 而不是 Node.js？ | `Spring Boot, Node, 后端, backend` |
| 16 | 数据库迁移用什么方案？ | `Flyway, migration, 迁移, 数据库` |

#### 部署与运维类（~5 条）

| # | 预设问题 | 关键词 |
|---|----------|--------|
| 17 | Docker 部署架构是什么？ | `Docker, 部署, deploy, compose` |
| 18 | 监控方案是什么？ | `Prometheus, Grafana, 监控, metrics` |
| 19 | CI/CD 流程是怎样的？ | `CI, CD, GitHub Actions, 自动化` |

### 5.2 FAQ 维护策略

- FAQ 内容以 **JSON 文件**形式存放在 `src/main/resources/ai/faq.json`
- 每次更新知识库，只需编辑 JSON 文件 + 重启即可
- 通过行为分析发现高频 RAG 问题后，可提炼为新的 FAQ 条目

---

## 6. API 设计

### 6.1 请求

```http
POST /v1/ai/chat
Content-Type: application/json

{
  "question": "你的状态管理方案是什么？",
  "sessionId": "550e8400-e29b-41d4-a716-446655440000"
}
```

> `sessionId`：客户端生成的 UUID，用于行为分析的会话关联（匿名，不关联用户身份）。

### 6.2 响应

```json
{
  "result": "0",
  "messageId": "",
  "message": "Success",
  "body": {
    "answer": "本项目使用 Riverpod + MVI 架构进行状态管理...",
    "source": "FAQ",
    "category": "architecture",
    "references": [
      {
        "file": "README.md",
        "section": "架构设计 > 状态管理"
      }
    ]
  }
}
```

### 6.3 限流策略

```java
@RateLimit(
    types = {RateLimitType.IP},
    maxRequests = 10,
    timeWindowSeconds = 60
)
@PostMapping("/chat")
public ResponseEntity<ApiResponse<AiChatResponse>> chat(@RequestBody AiChatRequest request) {
    // ...
}
```

---

## 7. 风险与缓解

| 风险 | 影响 | 缓解措施 |
|------|------|----------|
| Gemini API 不可用/超时 | 用户无法获得 LLM 回答 | FAQ 作为降级方案始终可用；超时设置 10s |
| Gemini 免费额度用尽 | LLM 功能停止 | 监控 token 用量；FAQ 覆盖核心问题 |
| LLM 回答不准确/幻觉 | 面试官获得错误信息 | System Prompt 限制只基于文档回答；RAG 提供上下文 |
| API Key 泄露 | 被盗用产生费用 | Key 只存后端环境变量；免费额度无费用风险 |
| 回答延迟过高 (>5s) | 用户体验差 | 前端展示 typing 动画；超时后显示"请稍后重试" |

---

## 8. 时间线总览

```
Phase 0: 准备          ████                              1 天
Phase 1: 后端 FAQ      ████████                          2 天
Phase 2: 后端 RAG      ████████████████                  3-4 天
Phase 3: 前端 UI       ████████████                      2-3 天
Phase 4: 隐私合规      ████                              1 天
Phase 5: 可观测性      ████                              1 天
                       ─────────────────────────────────
                       总计：10-12 天
```

**建议执行顺序**：Phase 0 → 1 → 2 → 3 → 4 → 5（严格串行，每个 Phase 可独立验证）

---

## 9. 后续升级方向

| 升级项 | 触发条件 | 改动范围 |
|--------|----------|----------|
| 向量存储迁移到 MySQL | 文档超过 100 篇 | 仅改 `VectorStore` 实现 |
| 向量存储迁移到 Qdrant | 需要毫秒级检索 | Docker 新增容器 + 改 `VectorStore` |
| 多轮对话支持 | 用户反馈需要追问 | 前端维护对话历史 + prompt 拼入历史 |
| 流式响应（SSE） | 回答太长等待太久 | 后端改为 SSE + 前端逐字显示 |
| 多语言回答 | 支持英文/日文面试官 | System Prompt 加语言检测指令 |

---

**文档版本**: v1.0
**决策参与者**: Listen + Cascade
**创建日期**: 2026-04-07
**状态**: 部分实现（前端已完成，后端 RAG 待接入）
