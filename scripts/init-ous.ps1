# init-ous.ps1
# Crée les unités d'organisation de ton domaine Loutrel.eu

Import-Module ActiveDirectory

Write-Host "Création de l'OU principale : CEFIM Tours"
New-ADOrganizationalUnit -Name "CEFIM Tours" -Path "DC=Loutrel,DC=eu"

Write-Host "Création de l'OU USERS"
New-ADOrganizationalUnit -Name "USERS" -Path "OU=CEFIM Tours,DC=Loutrel,DC=eu"

Write-Host "Création de l'OU ADMINS"
New-ADOrganizationalUnit -Name "ADMINS" -Path "OU=CEFIM Tours,DC=Loutrel,DC=eu"

Write-Host "✅ Toutes les OUs ont été créées avec succès."
