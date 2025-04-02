<#
.SYNOPSIS
    Crée des utilisateurs depuis un fichier CSV dans une OU cible.
.DESCRIPTION
    Crée des comptes utilisateurs standards dans Active Directory à partir d'un CSV.
    Le mode DryRun permet de simuler les actions sans créer de comptes.
.PARAMETER CsvPath
    Chemin vers le fichier CSV contenant les utilisateurs (first_name, last_name, password).
.PARAMETER TargetOU
    OU cible dans l’AD où seront créés les comptes.
.PARAMETER DryRun
    Si activé, simule les actions sans exécuter réellement.
.EXAMPLE
    .\create-users.ps1 -CsvPath "..\data\users.csv" -TargetOU "OU=USERS,OU=CEFIM Tours,DC=Loutrel,DC=eu"
#>

param (
    [string]$CsvPath,
    [string]$TargetOU,
    [switch]$DryRun = $true
)

Import-Module ActiveDirectory

$users = Import-Csv -Path $CsvPath

foreach ($user in $users) {
    $firstName = $user.first_name
    $lastName = $user.last_name
    $username = ($firstName.Substring(0,1) + $lastName).ToLower()
    $password = $user.mdp

    if ($DryRun) {
        Write-Host "[SIMULATION] Création de $username dans $TargetOU"
    } else {
        Write-Host "[+] Création de l'utilisateur $username dans $TargetOU"

        New-ADUser `
            -Name $username `
            -GivenName $firstName `
            -Surname $lastName `
            -SamAccountName $username `
            -UserPrincipalName "$username@Loutrel.eu" `
            -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
            -Enabled $true `
            -Path $TargetOU `
            -ChangePasswordAtLogon $false `
            -PasswordNeverExpires $true
    }
}

Write-Host "✅ Script terminé. Mode simulation : $DryRun"
