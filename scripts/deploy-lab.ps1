# check-users.ps1
# Vérifie que les OUs existent, que les utilisateurs ont été créés et que les admins sont bien dans le groupe Administrateurs

Import-Module ActiveDirectory

$baseDN = "DC=Loutrel,DC=eu"
$ouList = @("OU=CEFIM Tours,$baseDN", "OU=USERS,OU=CEFIM Tours,$baseDN", "OU=ADMINS,OU=CEFIM Tours,$baseDN")

Write-Host "\n==== Vérification des OUs ====" -ForegroundColor Cyan
foreach ($ou in $ouList) {
    if (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ou'" -ErrorAction SilentlyContinue) {
        Write-Host "✅ OU présente : $ou"
    } else {
        Write-Host "❌ OU manquante : $ou" -ForegroundColor Red
    }
}

Write-Host "\n==== Vérification des utilisateurs USERS ====" -ForegroundColor Cyan
$users = Import-Csv -Path ".\users.csv"
foreach ($u in $users) {
    $login = ($u.first_name.Substring(0,1) + $u.last_name).ToLower()
    $exists = Get-ADUser -Filter "SamAccountName -eq '$login'" -ErrorAction SilentlyContinue
    if ($exists) {
        Write-Host "✅ User trouvé : $login"
    } else {
        Write-Host "❌ Manquant : $login" -ForegroundColor Red
    }
}

Write-Host "\n==== Vérification des administrateurs ====" -ForegroundColor Cyan
$admins = Import-Csv -Path ".\admins.csv"
foreach ($a in $admins) {
    $login = ($a.first_name.Substring(0,1) + $a.last_name).ToLower()
    $inGroup = Get-ADGroupMember -Identity "Administrateurs" -Recursive | Where-Object { $_.SamAccountName -eq $login }
    if ($inGroup) {
        Write-Host "✅ Admin OK : $login"
    } else {
        Write-Host "❌ Admin NON trouvé dans le groupe : $login" -ForegroundColor Red
    }
}

Write-Host "\n🔍 Vérification terminée." -ForegroundColor Cyan
