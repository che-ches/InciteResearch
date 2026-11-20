# Phase 1 验收清单

状态：NOT RUN。文档和脚本建立本身不代表真实连接通过。

## A. 本机准备
- [ ] Zotero 7+ 已安装并运行。
- [ ] 已开启 Allow other applications on this computer to communicate with Zotero。
- [ ] Python 3.10+ 可用。
- [ ] uv 可用。
- [ ] zotero-mcp-server 安装成功。
- [ ] zotero-mcp --help 正常返回。
- [ ] zotero-mcp setup-info 能定位安装和配置。

## B. Secure MCP Tunnel
- [ ] OpenAI Platform Tunnel 已创建。
- [ ] Tunnel 已关联目标 ChatGPT workspace。
- [ ] 操作者拥有 Tunnel Read + Use 权限。
- [ ] Runtime Key 仅保存在本机安全环境中。
- [ ] tunnel-client doctor --profile zotero --explain 通过。
- [ ] Tunnel Client 显示 healthy / ready / polling。
- [ ] ChatGPT 中已创建 Tunnel 类型自定义 MCP 应用。
- [ ] ChatGPT 工具扫描成功。

## C. 真实文献读取考试

选择用户 Zotero 库中一篇已知论文作为 fixture，记录 citekey 或标题，不将私人 PDF 提交到公共仓库。

- [ ] 按完整标题搜索，返回目标条目。
- [ ] 按作者搜索，返回目标条目。
- [ ] 按关键词或语义查询，返回相关条目。
- [ ] 读取元数据，作者、年份、DOI 与 Zotero 条目一致。
- [ ] 读取 BibTeX，citekey 与 Better BibTeX（若已安装）一致。
- [ ] 读取 PDF 指定页，页码与原 PDF 对应。
- [ ] 返回至少一段可在 PDF 中复核的原文。
- [ ] 区分 PDF 印刷页码与 PDF 文件页序（若两者不同）。
- [ ] 对扫描件、公式或表格提取失败时，明确返回需要页面图像复核。

## D. 安全考试
- [ ] MCP 工具清单中没有写入工具，或写入工具被 allowlist 明确屏蔽。
- [ ] 未将 Zotero API Key、OpenAI Runtime Key 写入 Git。
- [ ] 未将私人 PDF 上传到公共仓库。
- [ ] MCP Server 未监听公网地址。
- [ ] 使用 OpenAI Secure MCP Tunnel，而非无认证公网隧道。

## E. 结果记录

| 字段 | 结果 |
|---|---|
| Zotero 版本 | 待填写 |
| zotero-mcp-server 版本 | 待填写 |
| tunnel-client 版本 | 待填写 |
| Tunnel ID（可只记末 6 位） | 待填写 |
| ChatGPT 应用名称 | 待填写 |
| 搜索测试 | NOT RUN |
| PDF 页码测试 | NOT RUN |
| BibTeX 测试 | NOT RUN |
| 只读权限检查 | NOT RUN |
| 最终状态 | NOT RUN |

最终状态仅允许 PASS / PARTIAL / BLOCKED。每个 PASS 必须附可复核的工具调用结果或日志证据。
