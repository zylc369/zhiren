# Zhiren

> Zhiren (智人) - 一个 "Ralph Loop" AI 驱动的自动化开发系统

Zhiren 是一个能够循环调用 Claude Code 直到满足用户需求的自动化开发工具。通过持续的 PLAN（规划）→ EXECUTE（执行）→ REVIEW（审查）→ FIX（修复）循环，Zhiren 可以自主地完成软件开发任务。

## 核心概念

### Ralph Loop（拉尔夫循环）

Zhiren 实现了 "Ralph Loop" 模式 - 一个持续的反馈循环，确保代码实现完全符合用户需求：

```
┌────────┐     ┌─────────┐     ┌────────┐     ┌──────┐
│  PLAN  │ ──▶ │ EXECUTE │ ──▶ │ REVIEW │ ──▶ │ FIX  │
│  规划  │     │  执行   │     │  审查  │     │ 修复 │
└────────┘     └─────────┘     └────────┘     └──────┘
     │                                                           │
     └───────────────────────────────────────────────────────────┘
                              │
                              ▼
                    所有任务完成？
                       Yes  │ No
                            │
                            ▼
                       继续循环
```

每个阶段都会自动完成，无需人工干预：
- **PLAN** - 分析下一个任务并制定实施计划
- **EXECUTE** - 按照计划实现代码
- **REVIEW** - 审查实现，发现潜在问题
- **FIX** - 修复发现的问题

## 安装

### 前置要求

- [Anthropic Claude Code CLI](https://claude.ai/code) 已安装
- Bash 3.2+（macOS 默认版本即可）
- （可选）Docker - 用于 Safe Mode

### 安装步骤

```bash
# 克隆仓库
git clone [链接]
cd zhiren

# 执行安装
./install.sh

# 将以下行添加到你的 shell 配置文件（~/.bashrc、~/.zshrc 等）
export PATH="$PATH:$HOME/.local/bin"

# 重新加载配置
source ~/.bashrc  # 或 source ~/.zshrc
```

### 验证安装

```bash
zhiren --help
zhiren-init --help
zhiren-refresh --help
```

## 快速开始

### 1. 初始化项目

创建一个 `idea.md` 文件，描述你的项目需求：

```markdown
# 我的博客系统

我想要创建一个简单的博客系统，具有以下功能：
- 用户可以发布文章
- 支持 Markdown 编辑
- 文章列表和详情页
- 简单的用户认证

使用技术栈：
- 后端：Node.js + Express
- 前端：React
- 数据库：SQLite
```

然后运行：

```bash
# 新项目
zhiren-init -f idea.md

# 已有项目（在现有代码库基础上添加功能）
zhiren-init -f idea.md
# 会提示你是否已有项目

# 使用 Safe Mode（Docker 隔离环境）
zhiren-init -f idea.md --safe
```

初始化完成后，Zhiren 会创建：
- `.zhiren/CONTEXT.md` - 项目上下文和理解
- `.zhiren/TASKS.md` - 任务列表
- `.zhiren/specs/` - 详细规格说明

### 2. 开始开发

```bash
# 开始自动开发循环
zhiren

# 指定最大迭代次数
zhiren 50

# 批量模式（一次处理多个相关任务）
zhiren --batch

# 自定义批量大小
zhiren --batch=10
```

Zhiren 会自动循环执行 PLAN → EXECUTE → REVIEW → FIX，直到所有任务完成。

### 3. 添加新需求

在开发过程中，如果需要添加新功能或修复 bug：

创建一个 `notes.md` 文件：

```markdown
# 新需求

需要添加以下功能：
- 文章评论功能
- 邮件通知
```

然后运行：

```bash
zhiren-refresh notes.md
```

Zhiren 会保留现有的 CONTEXT.md 和 TASKS.md，并将新任务添加到任务列表底部。

## 命令详解

### zhiren-init

根据用户需求初始化项目。

```bash
zhiren-init [选项]

选项:
  -f, --file FILE    指定需求文档路径（必需，或使用当前目录的 idea.md）
  --safe             启用 Safe Mode（Docker 隔离环境）
  -h, --help         显示帮助信息
```

**功能：**
- 检测现有代码库（如果有）
- 自动识别技术栈（Node.js、Python、Go、Rust 等）
- 生成初始任务列表和项目上下文
- 可选启用 Safe Mode
- 自动初始化 Git 仓库

### zhiren

执行主开发循环。

```bash
zhiren [选项] [迭代次数]

选项:
  --batch[=N]        启用批量模式（默认处理 5 个相关任务）
  -b, -bN            批量模式的简写形式

参数:
  迭代次数           最大迭代次数（默认：2 × 剩余任务数）
```

**功能：**
- 持续执行 4 阶段循环
- 自动保存进度（可从任意阶段恢复）
- 完成任务自动归档
- 支持批量处理相关任务

### zhiren-refresh

添加新需求到现有项目。

```bash
zhiren-refresh <notes.md>
```

**功能：**
- 保持现有上下文和任务列表
- 将新需求添加为任务
- 自动分组相关新任务
- 支持功能新增和 bug 修复

## 工作流程

### 完整开发流程

```bash
# 1. 初始化项目
zhiren-init -f idea.md

# 2. 开始开发
zhiren

# 3. 如果中断，直接再次运行即可（自动恢复进度）
zhiren

# 4. 需要添加新功能时
zhiren-refresh new-features.md

# 5. 继续开发
zhiren
```

### 任务状态追踪

任务列表 (`.zhiren/TASKS.md`) 使用 Markdown checkbox 格式：

```markdown
## 任务列表

### 后端开发
- [x] 设计数据库 schema
- [x] 实现 API 路由
- [ ] 实现用户认证
- [ ] 添加文章管理功能

### 前端开发
- [ ] 创建布局组件
- [ ] 实现文章列表页
- [ ] 实现文章详情页
```

- `[ ]` - 待处理
- `[x]` - 已完成（会自动归档到 `.zhiren/task_history/`）

## 高级特性

### Safe Mode（安全模式）

Safe Mode 在 Docker 容器中运行开发环境，提供隔离和安全性：

```bash
# 初始化时启用 Safe Mode
zhiren-init -f idea.md --safe
```

**Safe Mode 特性：**
- 自动检测技术栈并生成 Dockerfile
- 只读挂载凭证文件
- 隔离的依赖卷挂载（node_modules、.venv 等）
- 非 root 用户运行

**支持的技术栈：**
- Node.js / TypeScript
- Python (requirements.txt, pyproject.toml)
- PHP (composer.json)
- Go (go.mod)
- Rust (Cargo.toml)
- Dart/Flutter (pubspec.yaml)
- Java (pom.xml)

### Batch Mode（批量模式）

批量模式可以一次性处理多个相关任务，提高效率：

```bash
# 默认批量大小（5个任务）
zhiren --batch

# 自定义批量大小
zhiren --batch=10
zhiren -b10
```

**批量模式优势：**
- 减少上下文切换
- 识别相关操作
- 更高效的迭代

### 进度恢复

Zhiren 自动保存执行进度到 `.zhiren/zhiren_current_step`：

```json
{
  "step": "EXECUTE",
  "state": "Running",
  "nextStep": "REVIEW"
}
```

即使中断，再次运行时会从当前步骤继续。

### 会话持久化

Zhiren 使用 Claude Code 的会话功能保持上下文：

- 新会话：使用 `--session-id <id>` 创建新会话
- 恢复会话：使用 `-r <id>` 恢复现有会话

会话 ID 存储在 `.zhiren/claude_session_id` 中。

## 项目结构

```
zhiren/
├── zhiren                   # 主命令
├── zhiren_init             # 初始化命令
├── zhiren_refresh          # 刷新命令
├── zhiren_clean_project    # 清理命令
├── install.sh              # 安装脚本
├── lib/                    # 核心库
│   ├── tools.sh            # 工具函数
│   ├── consts.sh           # 常量定义
│   ├── log.sh              # 日志系统
│   ├── prompts.sh          # 提示词管理
│   ├── claude.sh           # Claude API 封装
│   ├── task_manager.sh     # 任务管理
│   ├── session_manager.sh  # 会话管理
│   ├── safe_mode.sh        # Safe Mode 管理
│   └── prompt/             # 提示词模块
│       ├── prompt_common.sh
│       ├── prompt_init.sh
│       ├── prompt_plan.sh
│       ├── prompt_execute.sh
│       ├── prompt_review.sh
│       └── prompt_fix.sh
└── resources/              # 提示词模板
    ├── prompt_*.md         # 各阶段提示词
    └── prompts/            # 代码片段模板
```

### 运行时目录 (.zhiren/)

```
.zhiren/
├── CONTEXT.md              # 项目上下文
├── TASKS.md                # 任务列表
├── specs/                  # 详细规格
├── task_history/           # 已完成任务归档
├── logs/                   # 执行日志
├── claude_session_id       # Claude 会话 ID
├── zhiren_current_step     # 当前执行步骤
└── Dockerfile              # Safe Mode 配置（如启用）
```

## 日志和调试

### 日志位置

- 主日志：`.zhiren/logs/zhiren.log`
- AI 参数日志：`.zhiren/logs/ai_params.log`
- AI 响应日志：`.zhiren/logs/ai_responses.log`

### 临时文件

每次运行都会创建临时目录用于命令输出重定向：

```
/tmp/zhiren-<scene>-<pid>-<timestamp>/
```

临时目录会在脚本退出时自动清理。

## 配置

### 常量配置 (lib/consts.sh)

```bash
MAX_RETRIES=3           # Claude API 最大重试次数
RETRY_DELAY=10          # 重试延迟（秒）
SAFE_MODE_IMAGE_NAME    # Docker 镜像名称
SAFE_MODE_DOCKERFILE    # Dockerfile 路径
```

### 环境变量

- `ZHIREN_EXECUTE_SCENE` - 执行场景（init/main/refresh）
- `ZHIREN_TMP_DIR` - 临时目录路径
- `ZHIREN_CLAUDE_SESSION_ID` - Claude 会话 ID

## 常见问题

### Q: 如何在中断后继续开发？

A: 直接再次运行 `zhiren`，会自动从上次中断的步骤继续。

### Q: 如何重新构建 Docker 镜像？

A: 使用 `zhiren --rebuild` 强制重新构建。

### Q: 如何查看当前进度？

A: 查看 `.zhiren/zhiren_current_step` 和 `.zhiren/TASKS.md`。

### Q: 如何清理项目？

A: 运行 `zhiren-clean-project` 清理运行时文件。

### Q: API 使用上限怎么办？

A: Zhiren 会自动检测 5 小时使用上限错误并停止，等待配额恢复后继续。

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License

---

**Zhiren** - 让 AI 为你编写代码
