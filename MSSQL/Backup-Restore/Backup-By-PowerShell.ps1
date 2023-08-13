# PowerShell Backup
$credential = Get-Credential

Backup-SqlDatabase -ServerInstance Computer\Instance -Database PlayGround -BackupAction Database -Credential $credential
