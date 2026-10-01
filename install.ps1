# Downloads the pinned server + plugin jars. Idempotent: skips files already present.
# Run once after copying this folder to the machine that will host the server.
# Usage: right-click -> "Run with PowerShell", or: powershell -ExecutionPolicy Bypass -File install.ps1
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

# Pinned versions (verified working together on 2026-09-30):
#   Paper 26.2 build 129 (STABLE) = Minecraft Java 26.2, requires Java 25+
#   Geyser 2.11.3 build 1247      = Bedrock bridge, emulates Java 26.2
#   Floodgate 2.2.5 build 141     = lets Bedrock players join without a Java account
$FillApi = "https://fill.papermc.io/v3/projects/paper/versions/26.2/builds/129"
$PaperUrl = (Invoke-RestMethod -Uri $FillApi).downloads.'server:default'.url
$GeyserUrl = "https://download.geysermc.org/v2/projects/geyser/versions/2.11.3/builds/1247/downloads/spigot"
$FloodgateUrl = "https://download.geysermc.org/v2/projects/floodgate/versions/2.2.5/builds/141/downloads/spigot"

function Fetch($Url, $Dest) {
    if ((Test-Path $Dest) -and ((Get-Item $Dest).Length -gt 0)) {
        Write-Host "OK   $Dest (already present)"
        return
    }
    Write-Host "GET  $Url"
    $dir = Split-Path $Dest -Parent
    if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    Invoke-WebRequest -Uri $Url -OutFile $Dest
    $size = "{0:N1} MB" -f ((Get-Item $Dest).Length / 1MB)
    Write-Host "OK   $Dest ($size)"
}

Fetch $PaperUrl    "paper.jar"
Fetch $GeyserUrl   "plugins\Geyser-Spigot.jar"
Fetch $FloodgateUrl "plugins\Floodgate-Spigot.jar"

Write-Host ""
Write-Host "All jars ready. Next: start.bat"
