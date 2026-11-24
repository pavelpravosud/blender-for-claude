# Stravenford Academy - Blender for Claude (Windows). Official sources only.
$log = Join-Path $PSScriptRoot "install_log.txt"
Start-Transcript -Path $log -Force | Out-Null
$env:DISABLE_TELEMETRY = "1"
Write-Host "1/5 Installing Blender (blender.org, via winget)..."
winget install --id BlenderFoundation.Blender -e --accept-source-agreements --accept-package-agreements
Write-Host "2/5 Installing uv (Astral, via winget)..."
winget install --id astral-sh.uv -e --accept-source-agreements --accept-package-agreements
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User') + ';' + "$env:USERPROFILE\.local\bin;$env:LOCALAPPDATA\Microsoft\WinGet\Links"
$venv = Join-Path $env:USERPROFILE ".blender-mcp-py311"
Write-Host "3/5 Creating a private Python 3.11 just for Blender in $venv"
uv venv $venv --python 3.11 --python-preference only-managed --clear
uv pip install --python (Join-Path $venv "Scripts\python.exe") mcp-for-blender
$exe = Join-Path $venv "Scripts\mcp-for-blender.exe"
if (-not (Test-Path $exe)) { Write-Host "ERROR: connector not installed. Post install_log.txt in the Stravenford community (Help)."; Stop-Transcript | Out-Null; Read-Host "Press Enter"; exit 1 }
Write-Host "4/5 Installing the Blender add-on"
& $exe install-addon
Write-Host "5/5 Building the Claude extension"
$src = Join-Path $PSScriptRoot "extension"
$out = Join-Path $PSScriptRoot "2_Blender (Python 3.11).mcpb"
if (Test-Path $src) {
  if (Test-Path $out) { Remove-Item $out -Force }
  Add-Type -AssemblyName System.IO.Compression
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $zip = [System.IO.Compression.ZipFile]::Open($out, 'Create')
  [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, (Join-Path $src "manifest.json"), "manifest.json")
  [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, (Join-Path $src "server\index.js"), "server/index.js")
  $zip.Dispose()
}
Write-Host ""
Write-Host "DONE. Next: double-click '2_Blender (Python 3.11).mcpb' in this folder and press Install in Claude."
Stop-Transcript | Out-Null
Read-Host "Press Enter to close"
