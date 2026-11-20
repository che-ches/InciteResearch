$ErrorActionPreference = "Stop"

Write-Host "=== Zotero MCP Phase 1 / Windows bootstrap ===" -ForegroundColor Cyan

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    throw "Python 3.10+ was not found. Install Python from https://www.python.org/downloads/ and reopen PowerShell."
}

$pythonVersion = & python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')"
$parts = $pythonVersion.Split(".")
if ([int]$parts[0] -lt 3 -or ([int]$parts[0] -eq 3 -and [int]$parts[1] -lt 10)) {
    throw "Python 3.10+ is required. Detected: $pythonVersion"
}
Write-Host "Python: $pythonVersion"

$uv = Get-Command uv -ErrorAction SilentlyContinue
if (-not $uv) {
    Write-Host "uv is missing. Install it from https://docs.astral.sh/uv/getting-started/installation/ and rerun this script."
    exit 2
}

Write-Host "Installing/updating zotero-mcp-server..."
& uv tool install --upgrade zotero-mcp-server
if ($LASTEXITCODE -ne 0) { throw "uv tool install failed with exit code $LASTEXITCODE" }

$zoteroMcp = Get-Command zotero-mcp -ErrorAction SilentlyContinue
if (-not $zoteroMcp) {
    throw "zotero-mcp command is not on PATH. Restart PowerShell and run: uv tool update-shell"
}

Write-Host "`n=== CLI help ===" -ForegroundColor Cyan
& zotero-mcp --help
if ($LASTEXITCODE -ne 0) { throw "zotero-mcp --help failed" }

Write-Host "`n=== Setup information ===" -ForegroundColor Cyan
& zotero-mcp setup-info
if ($LASTEXITCODE -ne 0) { throw "zotero-mcp setup-info failed" }

Write-Host "`nBootstrap complete. Next:"
Write-Host "1. Start Zotero Desktop."
Write-Host "2. Enable Settings > Advanced > Miscellaneous > Allow other applications..."
Write-Host "3. Follow research_lab/zotero/README.md to configure Secure MCP Tunnel."
Write-Host "No Zotero or OpenAI credentials were requested or stored by this script."
