# deploy-lab.ps1
# Exécute automatiquement tous les scripts dans l'ordre pour créer un lab AD complet
# Domaine : Loutrel.eu

param (
    [switch]$DryRun = $false
)

Write-Host "==== [1/4] Installation du domaine Active Directory ====" -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File .\scripts\install-ad.ps1" -Wait

Write-Host "`n[🔁] Veuillez redémarrer la machine maintenant, puis relancer ce script."
Write-Host "[❗] Ce script va s'arrêter ici pour permettre le redémarrage."
exit 0

<# --- APRÈS REDÉMARRAGE --- #>

Write-Host "==== [2/4] Création des Unités d'Organisation ====" -ForegroundColor Cyan
& .\scripts\init-ous.ps1

Write-Host "==== [3/4] Création des utilisateurs standards ====" -ForegroundColor Cyan
& .\scripts\create-users.ps1 `
    -CsvPath ".\users.csv" `
    -TargetOU "OU=USERS,OU=CEFIM Tours,DC=Loutrel,DC=eu" `
    -DryRun:$DryRun

Write-Host "==== [4/4] Création des utilisateurs admins ====" -ForegroundColor Cyan
& .\scripts\create-admins.ps1 `
    -CsvPath ".\admins.csv" `
    -TargetOU "OU=ADMINS,OU=CEFIM Tours,DC=Loutrel,DC=eu" `
    -DryRun:$DryRun
