# Zotero 文献库接入｜Phase 1

状态：工程蓝图已建立；等待本机安装、Tunnel 授权和真实文献库验收。
范围：只读接入个人 Zotero 文献库，为后续术语提取、思想检索和论文引用提供数据入口。

## 1. 验收目标

在 ChatGPT 网页端通过自定义 MCP 应用调用用户自己的 Zotero 文献库，完成：
1. 按标题、作者、关键词、标签和 Collection 搜索文献。
2. 读取元数据与 BibTeX。
3. 读取 PDF 全文或指定页内容。
4. 返回可复核的论文标识、页码和原文片段。
5. 读取已有 PDF 高亮和批注（增强验收项）。

Phase 1 采用只读权限。新增、删除、修改文献与批注全部延后。

## 2. 选定基础项目

- 上游：https://github.com/54yyyu/zotero-mcp
- PyPI：https://pypi.org/project/zotero-mcp-server/
- 上游许可证：MIT（以当前上游仓库为准）
- 安装方式：uv tool install zotero-mcp-server
- Zotero 本地连接：Zotero 7+，优先使用本地模式。
- ChatGPT 连接：OpenAI Secure MCP Tunnel。

本目录保存部署说明、验收记录和本地脚本，不复制上游实现代码。上游升级时先审阅 CHANGELOG、权限变化和工具清单，再更新版本。

## 3. 架构

~~~text
Zotero Desktop (user's library)
        |
        | local API / local SQLite read path
        v
zotero-mcp-server (read-only tool profile)
        |
        | stdio
        v
OpenAI tunnel-client (outbound HTTPS)
        |
        v
ChatGPT custom MCP app (Tunnel connection)
~~~

MCP Server 与 Tunnel Client 在同一台能够访问 Zotero 桌面程序的电脑运行。MCP Server 通过 stdio 暴露工具；Tunnel Client 使用 OpenAI 托管的 Secure MCP Tunnel 将请求转发到本机进程。无需把 Zotero MCP 服务端口公开到互联网。

## 4. Windows 本机准备

### 4.1 安装 Zotero

安装 Zotero 7 或更新版本：https://www.zotero.org/download/

### 4.2 打开本地 API

在 Zotero 中进入：

Edit → Settings → Advanced → Miscellaneous

启用：

Allow other applications on this computer to communicate with Zotero

保持 Zotero 桌面程序运行。

### 4.3 安装 Zotero MCP

安装 Python 3.10+ 和 uv，然后在 PowerShell 执行：

~~~powershell
uv tool install zotero-mcp-server
zotero-mcp --help
zotero-mcp setup-info
~~~

也可以运行本目录的 scripts/bootstrap_windows.ps1。

### 4.4 本机检查

确认 Zotero 已启动、本地 API 已启用、MCP 命令可用后，再继续 Tunnel 配置。不要把 API Key、Tunnel Runtime Key 或任何秘密写入仓库、聊天记录或截图。

## 5. ChatGPT Secure MCP Tunnel

官方文档：
- https://developers.openai.com/api/docs/guides/secure-mcp-tunnels
- https://github.com/openai/tunnel-client
- https://help.openai.com/en/articles/12584461-connecting-custom-mcp-servers-in-chatgpt

需要具备相应 OpenAI Platform Tunnel 权限，以及 ChatGPT 自定义 MCP 应用使用权限。

大致流程：
1. 在 https://platform.openai.com/settings/organization/tunnels 创建 Tunnel。
2. 在本机安装 OpenAI tunnel-client。
3. 将 Tunnel Runtime Key 安全地输入本机环境，不写入仓库。
4. 创建 stdio profile，启动命令为 zotero-mcp serve --transport stdio，环境变量设置 ZOTERO_LOCAL=true。
5. 使用 tunnel-client doctor --profile zotero --explain 检查。
6. 启动 tunnel-client run --profile zotero 并保持运行。
7. 在 ChatGPT 的 Plugins / Apps 中添加自定义 MCP Server，Connection 选择 Tunnel。
8. 创建后检查工具清单，并执行只读查询。

Tunnel 创建、组织/工作区关联和权限属于账户侧操作，需要用户在自己的 OpenAI Platform 中完成。ChatGPT 不会自动获得本机密钥。

## 6. 工具权限策略

Phase 1 只开放读取能力：文献搜索、Collection/Tag 查询、元数据读取、BibTeX 读取、PDF 全文与页码范围读取、已有批注读取。

暂缓开放：新增/导入文献、删除或合并条目、修改元数据/标签/Collection、新建或修改 PDF 批注，以及任意文件系统写入。

若上游工具集无法按工具粒度限制，需使用只读运行配置或在 MCP 前增加 allowlist 包装层；验收前不得开放写入工具。

## 7. 论文证据返回格式

| 字段 | 含义 |
|---|---|
| citekey | 稳定引用键 |
| title | 论文标题 |
| authors | 作者 |
| year | 年份 |
| doi | DOI |
| item_key | Zotero 条目键 |
| attachment_key | PDF 附件键 |
| page | PDF 页码 |
| quote | 支持结论的原文 |
| claim | AI 对原文的归纳 |
| claim_type | definition / method / result / limitation / motivation |
| source_url | DOI 或出版方链接 |

原文、AI 归纳、用户自己的研究判断必须分栏保存。引用建议必须附带可定位的来源证据；缺少原文支持时标记为待核验。

## 8. Phase 1 完成标准

见 ACCEPTANCE.md。只有 ChatGPT 真实调用成功并返回用户库中的真实条目，才可将 Phase 1 标记为通过。

## 9. 后续阶段

- Phase 2：Better BibTeX、稳定 citekey、BibTeX 导出与引用校验。
- Phase 3：GitHub Markdown 科研档案（术语、方法、实验、思想、证据位置）。
- Phase 4：跨论文语义检索与思想关系图。
- Phase 5：论文写作时的上下文检索、引用推荐和论据核验。
