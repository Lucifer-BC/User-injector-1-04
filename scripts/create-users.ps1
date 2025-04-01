<#
.SYNOPSIS
    Injecte des utilisateurs dans Active Directory à partir d’un fichier CSV.
.PARAMETER CsvPath
    Le chemin vers le fichier CSV.
.PARAMETER TargetOU
    L’unité d’organisation cible où créer les comptes.
.PARAMETER DryRun
    Si activé, affiche les actions sans créer les comptes.
#>

param(
    [string]$CsvPath = "",
    [string]$TargetOU = "",
    [switch]$DryRun
)

Import-Module ActiveDirectory

if (-not (Test-Path $CsvPath)) {
    Write-Host "❌ Fichier CSV introuvable : $CsvPath" -ForegroundColor Red
    exit 1
}

$users = Import-Csv $CsvPath

foreach ($user in $users) {
    $firstName = $user.first_name
    $lastName  = $user.last_name
    $password  = $user.mdp
    $username  = ($firstName.Substring(0,1) + $lastName).ToLower()

    $dn = "CN=$username,$TargetOU"

    if ($DryRun) {
        Write-Host "🔎 DRY RUN : Créer $username dans $TargetOU"
        continue
    }

    if (Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue) {
        Write-Host "⚠️ Utilisateur $username existe déjà" -ForegroundColor Yellow
        continue
    }

    New-ADUser `
        -Name "$firstName $lastName" `
        -GivenName $firstName `
        -Surname $lastName `
        -SamAccountName $username `
        -UserPrincipalName "$username@loutrel.eu" `
        -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
        -Enabled $true `
        -Path $TargetOU `
        -ChangePasswordAtLogon $false `
        -PasswordNeverExpires $true

    Write-Host "✅ Utilisateur $username créé avec succès dans $TargetOU"
}
