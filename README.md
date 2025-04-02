# 🧠 User Injector - Projet AD Lab

Projet de déploiement automatique d'un environnement Active Directory complet via PowerShell, conçu pour un lab ou une démonstration technique. Il repose sur un jeu de comptes simulés générés avec Mockaroo.

---

## 📁 Arborescence du projet

```bash
User-injector-1-04/
├── README.md                 # Ce fichier
├── deploy-lab.ps1            # Script principal d'automatisation
├── data/                     # Données utilisateurs CSV
│   ├── users.csv             # 200 utilisateurs standards (Mockaroo)
│   └── admins.csv            # 10 comptes admin (Mockaroo)
└── scripts/                  # Scripts PowerShell liés au lab
    ├── install-ad.ps1        # Installation AD et création du domaine "Loutrel.eu"
    ├── init-ous.ps1          # Création des OU : CEFIM Tours / USERS / ADMINS
    ├── create-users.ps1      # Injection des utilisateurs standards
    ├── create-admins.ps1     # Injection des utilisateurs admins + ajout groupe "Administrateurs"
    └── check-users.ps1       # Script de vérification final
```

---

## 🚀 Déroulement du projet

### 1. 📋 Prérequis

| Élément | Description |
|--------|-------------|
| 🖥️ Machine | VM Windows Server 2022 (ou 2019) |
| 🔧 VMware Tools | Doit être installé et à jour |
| 🔌 IP Fixe | La machine doit avoir une IP statique (vérifiée par script) |
| 📦 Rôle ADDS | Préinstallé ou installé automatiquement |
| 📂 Accès aux fichiers | Le dossier partagé `User-injector-1-04` doit être monté dans un lecteur (ex : `Z:`) |
| 🔐 Mot de passe | Un mot de passe vous sera demandé pour le compte admin du domaine |

### 2. 📦 Lancement initial (création du domaine)

Ouvre **PowerShell en tant qu’administrateur**, puis exécute :

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
Z:
Unblock-File .\deploy-lab.ps1
.\deploy-lab.ps1
```

Ce script :
- Vérifie l'IP
- Installe le rôle ADDS
- Promeut le serveur en tant que DC (domaine `Loutrel.eu`)
- ❗ Redémarre automatiquement le serveur après cette étape

### 3. 🔁 Reprise après redémarrage

**Reconnecte-toi**, puis relance ces commandes pour exécuter la suite :

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
Z:
Unblock-File .\deploy-lab.ps1
.\deploy-lab.ps1
```

Cela va enchaîner :
- La création des OU
- L'injection des utilisateurs
- La vérification finale

### 4. 🧪 Mode Simulation (Dry Run)

Pour tester **sans créer d’utilisateurs**, tu peux ajouter le paramètre `-DryRun:$true` :

```powershell
.\deploy-lab.ps1 -DryRun:$true
```

### 5. ✅ Vérification finale

Le script `check-users.ps1` vérifie que :
- Les OU existent bien
- Il y a 200 utilisateurs dans USERS
- Il y a 10 comptes dans ADMINS
- Les comptes ADMINS sont membres du groupe "Administrateurs"

Un fichier `check-results.log` est généré automatiquement avec le statut final.

---

## 🧪 Tests réalisés

- [x] Installation automatique ADDS
- [x] Redémarrage du contrôleur de domaine
- [x] Création sécurisée d’OU imbriquées
- [x] Injection de 200 utilisateurs standards
- [x] Injection de 10 admins + ajout groupe Administrateurs
- [x] Vérification finale automatisée
- [x] Gestion du mode DryRun pour tous les scripts

---

## 🙋 Auteur

Projet réalisé par **Lucifer / Lucie 🦦** dans le cadre d’un TP TSSR - scripting PowerShell et GitHub avec VSCode.

> Ce projet a été pensé comme un kit de déploiement rapide pour tout environnement lab AD.
