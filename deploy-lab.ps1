# deploy-lab.ps1
# Exécute automatiquement tous les scripts dans l'ordre pour créer un lab AD complet
# Domaine : Loutrel.eu

param (
    [switch]$DryRun = $false
)

Write-Host "==== [1/5] Installation du domaine Active Directory ====" -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File .\scripts\install-ad.ps1" -Wait

Write-Host ""
Write-Host "[🔁] Veuillez redemarrer la machine maintenant, puis relancer ce script." -ForegroundColor Yellow
Write-Host "[❗] Ce script va s'arreter ici pour permettre le redemarrage." -ForegroundColor Red
exit 0

<# --- APRÈS REDÉMARRAGE --- #>

Write-Host ""
Write-Host "==== [2/5] Creation des Unités d'Organisation ====" -ForegroundColor Cyan
& .\scripts\init-ous.ps1

Write-Host ""
Write-Host "==== [3/5] Creation des utilisateurs standards ====" -ForegroundColor Cyan
& .\scripts\create-users.ps1 `
    -CsvPath ".\data\users.csv" `
    -TargetOU "OU=USERS,OU=CEFIM Tours,DC=Loutrel,DC=eu" `
    -DryRun:$DryRun

Write-Host ""
Write-Host "==== [4/5] Creation des utilisateurs admins ====" -ForegroundColor Cyan
& .\scripts\create-admins.ps1 `
    -CsvPath ".\data\admins.csv" `
    -TargetOU "OU=ADMINS,OU=CEFIM Tours,DC=Loutrel,DC=eu" `
    -DryRun:$DryRun

Write-Host ""
Write-Host "==== [5/5] Verification finale de l annuaire ====" -ForegroundColor Cyan
& .\scripts\check-users.ps1
