# deploy-lab.ps1
# Exécute automatiquement tous les scripts dans l'ordre pour créer un lab AD complet
# Domaine : Loutrel.eu

param (
    [switch]$DryRun = $false
)

# Étape 0 - Aller dans le bon répertoire si lancé depuis un raccourci
Set-Location $PSScriptRoot

# Étape 1 - Vérifier si la machine est déjà un contrôleur de domaine
$alreadyPromoted = (Get-WmiObject Win32_ComputerSystem).PartOfDomain

if (-not $alreadyPromoted) {
    Write-Host "==== [1/5] Installation du domaine Active Directory ====" -ForegroundColor Cyan
    & .\scripts\install-ad.ps1
    
    Write-Host "[🔁] Redémarrage automatique imminent..."
    exit
}

# Étape 2 - Création des OUs
Write-Host "`n==== [2/5] Création des Unités d'Organisation ====" -ForegroundColor Cyan
& .\scripts\init-ous.ps1

# Étape 3 - Création des utilisateurs standards
Write-Host "`n==== [3/5] Création des utilisateurs standards ====" -ForegroundColor Cyan
& .\scripts\create-users.ps1 `
    -CsvPath ".\data\users.csv" `
    -TargetOU "OU=USERS,OU=CEFIM Tours,DC=Loutrel,DC=eu" `
    -DryRun:$DryRun

# Étape 4 - Création des utilisateurs admins
Write-Host "`n==== [4/5] Création des utilisateurs admins ====" -ForegroundColor Cyan
& .\scripts\create-admins.ps1 `
    -CsvPath ".\data\admins.csv" `
    -TargetOU "OU=ADMINS,OU=CEFIM Tours,DC=Loutrel,DC=eu" `
    -DryRun:$DryRun

# Étape 5 - Vérification
Write-Host "`n==== [5/5] Vérification finale de l'annuaire ====" -ForegroundColor Cyan
& .\scripts\check-users.ps1
