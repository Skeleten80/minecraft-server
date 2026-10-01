# Creates a timestamped backup of worlds + configs into backups\.
# Safe to run while the server is stopped. If run while live, run `save-all` in console first.
# Usage: powershell -ExecutionPolicy Bypass -File backup.ps1
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$Stamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$Out = "backups\backup-$Stamp.zip"
New-Item -ItemType Directory -Force -Path "backups" | Out-Null

$Paths = @(
  "world", "world_nether", "world_the_end",
  "server.properties", "eula.txt",
  "plugins\Geyser-Spigot", "plugins\Floodgate-Spigot",
  "bukkit.yml", "spigot.yml", "paper-world.yml", "commands.yml",
  "ops.json", "whitelist.json", "usercache.json"
) | Where-Object { Test-Path $_ }

if (-not $Paths) { Write-Host "Nothing to back up yet (no world generated)."; exit 0 }

Compress-Archive -Path $Paths -DestinationPath $Out -Force
$size = "{0:N1} MB" -f ((Get-Item $Out).Length / 1MB)
Write-Host "Backup written: $Out ($size)"

# Keep only the 10 newest backups
Get-ChildItem "backups\backup-*.zip" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -Skip 10 |
    Remove-Item -Force
