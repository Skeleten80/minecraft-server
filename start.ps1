# Starts the Minecraft server in the foreground. Ctrl+C stops it (saves world first).
# Usage: double-click start.bat, or: powershell -ExecutionPolicy Bypass -File start.ps1
# RAM override:  $env:MC_RAM = "8G"  (default 4G)
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

if (-not (Test-Path "paper.jar")) { Write-Error "paper.jar missing - run install.bat first"; exit 1 }
if (-not (Get-Command java -ErrorAction SilentlyContinue)) { Write-Error "Java not found - install Java 25+ first (see README)"; exit 1 }

$Ram = if ($env:MC_RAM) { $env:MC_RAM } else { "4G" }
Write-Host "Starting Paper 26.2 with $Ram RAM (override: `$env:MC_RAM='8G')"

& java "-Xms$Ram" "-Xmx$Ram" `
  --add-modules=jdk.incubator.vector `
  -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 `
  -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch `
  -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M `
  -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 `
  -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 `
  -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 `
  -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 `
  -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true `
  -jar paper.jar --nogui
