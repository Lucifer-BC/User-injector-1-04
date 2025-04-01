# deploy-lab.ps1
# Exécute automatiquement tous les scripts dans l'ordre pour créer un lab AD complet

param (
    [switch]$DryRun = $false
)

Write-Host "==== [1/4] Installation du domaine Active Directory ====" -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File .\scripts\install-ad.ps1" -Wait

Write-Host "`n[🔁] Veuillez redémarrer la machine maintenant, puis relancer ce script."
Write-Host "[❗] Ce script va s'arrêter ici pour permettre le redémarrage."
exit 0
