# AI Intro Assistant — 实现方案说明书

## 1. 概述

### 1.1 产品定位

**架构知识库问答助手**：面试官在面试前通过 AI 助手了解本 App 的架构设计和功能实现细节，获得对候选人技术能力的初步认知。

### 1.2 核心决策摘要

| 决策项 | 选择 | 理由 |
|--------|------|------|
| 产品形态 | 架构知识库 Q&A | 面试官关心的是技术深度，不是 App 导览 |
| 知识注入 | RAG（检索增强生成） | 学习目的 + 可扩展 + 面试亮点 |
| LLM 提供商 | Gemini 1.5 Flash | 免费额度充足、官方 Flutter SDK、成本最低 |
| API Key 架构 | 后端代理（Spring Boot） | 安全、可控、复用现有限流体系 |
| FAQ/LLM 切换 | 关键词匹配优先，未命中走 LLM | 平衡成本与体验 |
| 向量存储 | 内存 HashMap（后续可升级 MySQL/Qdrant） | 先理解原理，数据量小无需重型方案 |
| 月预算 | $0（Gemini 免费额度） | 15 RPM / 100 万 tokens/月，Portfolio 场景足够 |

### 1.3 用户场景

```
面试官收到简历 → 下载/打开 Portfolio App → 点击 AI 助手
→ 看到预设热门问题列表（FAQ）
→ 点击预设问题 → 立即返回答案（本地匹配，无延迟）
→ 输入自定义问题 "你的 AuthInterceptor 并发队列怎么实现的？"
→ 关键词匹配未命中 → 触发 RAG + Gemini
→ 后端检索相关文档片段 → 拼入 prompt → Gemini 生成回答
→ 面试官看到详细的技术解答（2-3 秒延迟）
```

---

## 2. 系统架构

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

| 组件 | 用途 | 依赖 |
|------|------|------|
| `AiChatPage` | 聊天 UI 页面 | 无新增依赖 |
| `AiChatViewModel` | MVI 状态管理 | Riverpod + Freezed（已有） |
| `AiChatState` | 对话状态（消息列表、加载中、错误） | Freezed（已有） |
| `AiRemoteDataSource` | Retrofit 接口定义 | Retrofit（已有） |
| `AiRepository` | 数据层（safeCall） | 复用 BaseRepository |
| `AskQuestionUseCase` | 用例层 | 复用 BaseUseCase |

> **零新增 pub 依赖**：完全复用现有 MVI + Retrofit + Riverpod 架构。

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

### Phase 3：前端 — Flutter Chat UI（2-3 天）

| 步骤 | 任务 | 文件 |
|------|------|------|
| 3.1 | 创建 `AiChatState`（Freezed） | `features/ai_chat/presentation/state/` |
| 3.2 | 创建 `AiChatIntent`：SendMessage / SelectFaq / Retry | 同上 |
| 3.3 | 创建 `AiChatViewModel`（BaseViewModel） | `features/ai_chat/presentation/viewmodel/` |
| 3.4 | 创建 `AiRemoteDataSource`（Retrofit） | `features/ai_chat/data/` |
| 3.5 | 创建 `AiRepository`（BaseRepository + safeCall） | `features/ai_chat/data/` |
| 3.6 | 创建 `AskQuestionUseCase` | `features/ai_chat/domain/` |
| 3.7 | 创建 `AiChatPage` UI | `features/ai_chat/presentation/pages/` |
| 3.8 | 添加路由注册到 `AppNav` | `shared/navigation/app_nav.dart` |
| 3.9 | i18n：中文/日文/英文 | `shared/i18n/` |

**UI 设计**：

```
┌──────────────────────────────┐
│  ← AI 架构助手                │  AppBar
├──────────────────────────────┤
│                              │
│  ┌────────────────────────┐  │  热门问题（FAQ 快捷入口）
│  │ 🏗️ 整体架构是什么？     │  │
│  │ 🔐 JWT 认证流程？       │  │
│  │ 📱 状态管理方案？        │  │
│  │ 🌐 网络层设计？          │  │
│  └────────────────────────┘  │
│                              │
│  ┌─ 面试官 ──────────────┐   │  对话气泡
│  │ 你的 AuthInterceptor  │   │
│  │ 并发队列怎么实现的？    │   │
│  └───────────────────────┘   │
│                              │
│  ┌─ AI 助手 ─────────────┐   │
│  │ AuthInterceptor 使用   │   │
│  │ Completer 队列模式...  │   │
│  │                        │   │
│  │ 📄 来源: api_client.dart│  │  引用来源标注
│  └───────────────────────┘   │
│                              │
├──────────────────────────────┤
│ [请输入您的问题...]    [发送] │  输入栏
└──────────────────────────────┘
```

**Phase 3 交付标准**：完整的 Chat UI，支持预设问题点击 + 自由输入，符合现有 MVI 架构。

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
**状态**: 待执行
