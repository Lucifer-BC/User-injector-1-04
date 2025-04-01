# install-ad.ps1

<#+
.SYNOPSIS
    Ce script installe et configure un Active Directory complet dans un lab.
.DESCRIPTION
    Il installe les services AD DS, promeut la machine en contrôleur de domaine,
    crée une forêt avec le domaine "Loutrel.eu" et crée des OU standard.
.PARAMETER DomainName
    Nom du domaine (par défaut "Loutrel.eu").
#>

param (
    [string]$DomainName = "Loutrel.eu"
)

Write-Host "[+] Installation des services AD DS..."
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Write-Host "[+] Promotion en contrôleur de domaine avec le domaine $DomainName..."
Import-Module ADDSDeployment
Install-ADDSForest `
    -DomainName $DomainName `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\\Windows\\NTDS" `
    -DomainMode "WinThreshold" `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\\Windows\\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\\Windows\\SYSVOL" `
    -Force:$true

# Note : le serveur redémarre automatiquement à la fin de cette opération

# --- APRÈS REBOOT : placer ce bloc dans un second script si besoin ---
<#
Start-Sleep -Seconds 60

Write-Host "[+] Création des Unites d’Organisation..."
Import-Module ActiveDirectory

$ouList = @(
    "OU=CORE,$baseDN",
    "OU=HUMANS,$baseDN",
    "OU=USERS,OU=HUMANS,$baseDN",
    "OU=ADMIN,OU=HUMANS,$baseDN"
)

$baseDN = (Get-ADDomain).DistinguishedName

foreach ($ou in $ouList) {
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ou'" -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name ($ou -split ",")[0] -Path (($ou -split ",",2)[1]) -ProtectedFromAccidentalDeletion $false
        Write-Host "[+] OU créée : $ou"
    }
    else {
        Write-Host "[-] OU déjà existante : $ou"
    }
}
#>

Write-Host "[OK] L'installation initiale de l'AD est terminée."
Write-Host "La machine va redémarrer pour appliquer les changements..."
