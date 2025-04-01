param (
    [string]$CsvPath = ".\users.csv",
    [string]$TargetOU "OU=ADMINS,OU=CEFIM Tours,DC=Loutrel,DC=eu"
    [bool]$DryRun = $true
)

Import-Module ActiveDirectory

Write-Host "[+] Chargement du fichier CSV : $CsvPath"
$users = Import-Csv -Path $CsvPath

foreach ($user in $users) {
    $username = "$($user.first_name).$($user.last_name)"
    $securePassword = ConvertTo-SecureString $user.mdp -AsPlainText -Force

    if ($DryRun) {
        Write-Host "[SIMULATION] Création de $username dans $TargetOU"
    }
    else {
        New-ADUser `
            -Name $username `
            -GivenName $user.first_name `
            -Surname $user.last_name `
            -SamAccountName $username `
            -UserPrincipalName "$username@Loutrel.eu" `
            -AccountPassword $securePassword `
            -Enabled $true `
            -Path $TargetOU

        Write-Host "✅ Administrateur $username créé avec succès dans $TargetOU"
    }
}
