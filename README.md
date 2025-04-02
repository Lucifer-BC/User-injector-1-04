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
| 🔧 VMware Tools | Doit être installé et à jour (sinon, pas de dossier partagé possible) |
| 🔌 IP Fixe | La machine doit avoir une IP statique (le script vérifiera) |
| 📦 Rôle ADDS | Sera installé automatiquement si manquant |
| 📂 Dossier partagé | Le dossier contenant ce projet doit être partagé dans VMware (ex : Z:) |

#### ⚙️ Configuration du partage VMware (obligatoire !) :
1. Éteindre la VM.
2. Dans VMware Workstation > `Settings` > `Options` > `Shared Folders`
3. Activer le partage > Ajouter le dossier `User-injector-1-04`
4. Le dossier sera visible dans la VM sous une lettre (`Z:` en général).

---

### 2. 🚀 Installation complète

Ouvre **PowerShell en tant qu'administrateur** dans la VM, et exécute **exactement ces commandes** :

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
Z:
Unblock-File .\deploy-lab.ps1
.\deploy-lab.ps1
```

#### 🛑 Ce que fait ce script automatiquement :
- Vérifie que l’adresse IP est fixe
- Installe le rôle ADDS si besoin
- Promeut le serveur en tant que contrôleur de domaine (domaine `Loutrel.eu`)
- Redémarre automatiquement la machine 🌀

---

### 3. 🔁 Après le redémarrage automatique

➡️ Une fois reconnecté à la session **administrateur du domaine**, **rouvre PowerShell en administrateur** et relance les commandes :

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
Z:
.\deploy-lab.ps1
```

🟢 Cette fois, il va automatiquement :
- Créer les OU : `CEFIM Tours`, `USERS`, `ADMINS`
- Injecter les utilisateurs depuis les fichiers CSV (`users.csv`, `admins.csv`)
- Ajouter les comptes admins dans le groupe "Administrateurs"
- Lancer la vérification finale ✅

---

### 4. 🧪 Mode Simulation (Dry Run)

Tu peux tester tout le processus sans rien créer avec :

```powershell
.\deploy-lab.ps1 -DryRun:$true
```

Le mode simulation affichera toutes les actions **sans les exécuter réellement** dans l’annuaire.

---

### 5. ✅ Vérification finale

Le script `check-users.ps1` est lancé automatiquement. Il vérifie :
- Que les OU existent bien
- Que 200 utilisateurs sont présents dans USERS
- Que 10 comptes sont présents dans ADMINS
- Que tous les ADMINS sont membres du groupe local "Administrateurs"

Il génère un fichier `check-results.log` avec les résultats.

---

## 🧪 Tests réalisés

- [x] Vérification IP Fixe (fail en DHCP)
- [x] Installation automatique ADDS
- [x] Redémarrage du serveur après promotion
- [x] Création sécurisée des OU
- [x] Injection de 200 utilisateurs standards (Mockaroo)
- [x] Injection de 10 comptes admins
- [x] Ajout au groupe Administrateurs
- [x] Vérification complète via `check-users.ps1`
- [x] Mode simulation (DryRun)

---

## 🙋 Auteur

Projet réalisé par **Lucifer / Lucie 🦦** dans le cadre du TP PowerShell & GitHub du TSSR.

> Ce dépôt Git peut être utilisé pour tester, auditer ou enseigner un déploiement automatisé Active Directory dans un environnement local Windows Server.
