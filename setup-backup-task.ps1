# Registers a Windows Scheduled Task that runs backup.ps1 daily at 4:00 AM.
# Run ONCE on the server PC as Administrator (right-click -> "Run with PowerShell"
# from an elevated prompt), or:
#   powershell -ExecutionPolicy Bypass -File setup-backup-task.ps1
# Idempotent: re-running replaces the existing task.
$ErrorActionPreference = "Stop"

$TaskName = "NeptuneCraft Daily Backup"
$Script = Join-Path $PSScriptRoot "backup.ps1"

if (-not (Test-Path $Script)) { Write-Error "backup.ps1 not found next to this script"; exit 1 }

$Action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$Script`""
$Trigger = New-ScheduledTaskTrigger -Daily -At 4am
$Settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopOnIdleEnd `
    -ExecutionTimeLimit (New-TimeSpan -Hours 1)

Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Settings $Settings `
    -Description "Daily NeptuneCraft world backup (backup.ps1, keeps 10 newest)." | Out-Null

Write-Host "OK: scheduled task '$TaskName' -> daily 4:00 AM."
Write-Host "Verify: Task Scheduler (taskschd.msc), or: Get-ScheduledTask -TaskName '$TaskName'"
