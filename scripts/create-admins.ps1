<#
.SYNOPSIS
    Crée des utilisateurs depuis un CSV dans une OU cible.
.DESCRIPTION
    Permet de créer des utilisateurs dans Active Directory depuis un fichier CSV.
    Si l'option -DryRun est activée, aucune modification réelle n'est faite.
.PARAMETER CsvPath
    Chemin vers le fichier CSV contenant les utilisateurs (first_name, last_name, password).
.PARAMETER TargetOU
    OU de destination dans l'AD où les utilisateurs seront créés.
.PARAMETER DryRun
    Active le mode simulation sans créer d'utilisateurs.
.EXAMPLE
    .\create-admins.ps1 -CsvPath "..\data\admins.csv" -TargetOU "OU=ADMIN,OU=HUMANS,DC=mondomaine,DC=local"
#>

param (
    [string]$CsvPath = "..\data\admins.csv",
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

        $userObj = New-ADUser `
            -Name $username `
            -GivenName $firstName `
            -Surname $lastName `
            -SamAccountName $username `
            -UserPrincipalName "$username@Loutrel.eu" `
            -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
            -Enabled $true `
            -Path $TargetOU `
            -ChangePasswordAtLogon $false `
            -PasswordNeverExpires $true `
            -PassThru

        # Ajout au groupe "Administrateurs"
        Add-ADGroupMember -Identity "Administrateurs" -Members $userObj
    }
}

Write-Host "✅ Script terminé. Mode simulation : $DryRun"
