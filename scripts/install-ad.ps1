# install-ad.ps1

<#+
.SYNOPSIS
    Ce script installe et configure un Active Directory complet dans un lab.
.DESCRIPTION
    Il installe les services AD DS, promeut la machine en contrôleur de domaine,
    crée une forêt avec le domaine "Loutrel.eu" et redémarre proprement.
.PARAMETER DomainName
    Nom du domaine (par défaut "Loutrel.eu").
#>

param (
    [string]$DomainName = "Loutrel.eu"
)

Write-Host "[+] Installation des services AD DS..." -ForegroundColor Cyan
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Write-Host "[+] Promotion en contrôleur de domaine avec le domaine $DomainName..." -ForegroundColor Cyan
Import-Module ADDSDeployment

Install-ADDSForest `
    -DomainName $DomainName `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\\Windows\\NTDS" `
    -DomainMode "WinThreshold" `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\\Windows\\NTDS" `
    -NoRebootOnCompletion:$true `
    -SysvolPath "C:\\Windows\\SYSVOL" `
    -Force:$true

Write-Host "[OK] Domaine $DomainName installé. Redémarrage dans 5 secondes..." -ForegroundColor Yellow
Start-Sleep -Seconds 5
Restart-Computer -Force
