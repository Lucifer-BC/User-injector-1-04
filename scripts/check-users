# check-users.ps1
# Ce script vérifie que les OUs, utilisateurs et groupes AD ont bien été créés

Import-Module ActiveDirectory

$results = @()

# --- Vérification des OUs ---
$ousToCheck = @(
    "OU=CEFIM Tours,DC=Loutrel,DC=eu",
    "OU=USERS,OU=CEFIM Tours,DC=Loutrel,DC=eu",
    "OU=ADMINS,OU=CEFIM Tours,DC=Loutrel,DC=eu"
)

foreach ($ou in $ousToCheck) {
    if (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ou'" -ErrorAction SilentlyContinue) {
        Write-Host "✅ OU trouvée : $ou" -ForegroundColor Green
        $results += "OU OK : $ou"
    } else {
        Write-Host "❌ OU manquante : $ou" -ForegroundColor Red
        $results += "OU MISSING : $ou"
    }
}

# --- Vérification utilisateurs ---
function Test-UserPresence {
    param($OUPath, $ExpectedCount, $Label)
    $found = Get-ADUser -SearchBase $OUPath -Filter *
    $count = $found.Count
    if ($count -ge $ExpectedCount) {
        Write-Host "✅ $count $Label trouvé(s) dans $OUPath" -ForegroundColor Green
        $results += "$Label OK ($count)"
    } else {
        Write-Host "❌ Seulement $count $Label trouvé(s) dans $OUPath (attendu : $ExpectedCount)" -ForegroundColor Red
        $results += "$Label INCOMPLET ($count/$ExpectedCount)"
    }
}

Test-UserPresence -OUPath "OU=USERS,OU=CEFIM Tours,DC=Loutrel,DC=eu" -ExpectedCount 200 -Label "Utilisateurs"
Test-UserPresence -OUPath "OU=ADMINS,OU=CEFIM Tours,DC=Loutrel,DC=eu" -ExpectedCount 10 -Label "Admins"

# --- Vérification groupe ---
$admins = Get-ADGroupMember -Identity "Administrateurs" -ErrorAction SilentlyContinue
if ($admins.Count -ge 10) {
    Write-Host "✅ $($admins.Count) membres trouvés dans le groupe Administrateurs" -ForegroundColor Green
    $results += "Groupe Administrateurs OK ($($admins.Count))"
} else {
    Write-Host "❌ Moins de 10 membres dans le groupe Administrateurs" -ForegroundColor Red
    $results += "Groupe Administrateurs INCOMPLET ($($admins.Count))"
}

# --- Export optionnel du résumé ---
$results | Out-File -FilePath "check-results.log" -Encoding UTF8
Write-Host "\n📁 Rapport généré dans check-results.log"
