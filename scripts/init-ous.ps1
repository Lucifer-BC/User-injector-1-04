# init-ous.ps1
# Crée les unités d'organisation de ton domaine Loutrel.eu si elles n'existent pas déjà

Import-Module ActiveDirectory

# Liste des OUs à créer
$ous = @(
    @{ Name = "CEFIM Tours"; Path = "DC=Loutrel,DC=eu" },
    @{ Name = "USERS"; Path = "OU=CEFIM Tours,DC=Loutrel,DC=eu" },
    @{ Name = "ADMINS"; Path = "OU=CEFIM Tours,DC=Loutrel,DC=eu" }
)

foreach ($ou in $ous) {
    $fullDN = "OU=$($ou.Name),$($ou.Path)"
    $exists = Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$fullDN'" -ErrorAction SilentlyContinue

    if (-not $exists) {
        Write-Host "🟢 Création de l'OU : $($ou.Name)"
        New-ADOrganizationalUnit -Name $ou.Name -Path $ou.Path -ProtectedFromAccidentalDeletion $false
    } else {
        Write-Host "⚠️  L'OU $($ou.Name) existe déjà, aucune action nécessaire."
    }
}

Write-Host "✅ Toutes les OUs ont été vérifiées et créées si nécessaire."
