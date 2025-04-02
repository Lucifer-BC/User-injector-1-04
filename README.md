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

| Élément            | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| 🖥️ Machine         | VM Windows Server 2022 (ou 2019)                                             |
| 🔧 VMware Tools     | Doit être installé et à jour                                                 |
| 🔌 IP Fixe          | La machine doit avoir une IP statique (sinon le script refusera de s'exécuter) |
| 📦 Rôle ADDS        | Non installé (le script le fera automatiquement)                             |
| 📂 Dossier partagé  | Le dossier `User-injector-1-04` doit être partagé dans VMware Workstation    |

### 2. 🧭 Monter le dossier partagé en lecteur réseau

Dans VMware Workstation :
- Va dans **Settings** de ta VM (Ctrl+D)
- Onglet **Options > Shared Folders**
- Active **Always enabled**
- Ajoute le dossier contenant `User-injector-1-04`

Dans la VM, PowerShell :
```powershell
net use Z: "\\vmware-host\Shared Folders\User-injector-1-04"
```

Vérifie que le lecteur `Z:` apparaît bien avec `Get-PSDrive`

---

### 3. 🛠️ Lancer le déploiement automatique

Dans PowerShell (administrateur) :

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
Z:
Unblock-File .\deploy-lab.ps1
.\deploy-lab.ps1
```

📌 À la première exécution, le script :
- Vérifie l’IP fixe (sinon il s'arrête)
- Installe le rôle ADDS
- Te demande un mot de passe SafeMode
- Crée et configure le domaine `Loutrel.eu`
- **Redémarre automatiquement la machine**

🔁 **Après redémarrage**, reconnecte-toi sur la session `Administrateur`, puis :

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
Z:
Unblock-File .\deploy-lab.ps1
.\deploy-lab.ps1
```

✅ Cette fois, les étapes suivantes se déclencheront :
- Création des OU `USERS` et `ADMINS`
- Injection des utilisateurs depuis `data/users.csv` et `data/admins.csv`
- Vérification finale de l'annuaire

---

### 4. 🧪 Mode Simulation (Dry Run)

Pour tester sans rien créer dans l’AD :
```powershell
.\deploy-lab.ps1 -DryRun:$true
```
Tous les scripts de création sont compatibles DryRun.

---

### 5. ✅ Vérification finale

Le script `check-users.ps1` (exécuté automatiquement) vérifie que :
- Les OU existent
- 200 utilisateurs standards sont présents
- 10 comptes admins sont créés
- Les comptes admins sont membres du groupe "Administrateurs"

Un fichier `check-results.log` est généré dans le dossier principal.

---

## 🧪 Tests réalisés

- [x] Détection IP non statique
- [x] Installation automatique ADDS
- [x] Redémarrage forcé après promotion
- [x] Création sécurisée d’OU imbriquées
- [x] Injection de 200 utilisateurs standards
- [x] Injection de 10 admins + ajout groupe Administrateurs
- [x] Vérification finale automatisée
- [x] Gestion du mode DryRun pour tous les scripts
- [x] Test depuis lecteur réseau Z: (VMware Shared Folders)

---

## 🙋 Auteur

Projet réalisé par **Lucifer / Lucie 🦦** dans le cadre d’un TP TSSR - scripting PowerShell et GitHub avec VSCode.

> Ce projet est un kit complet de déploiement AD pour environnements de test ou formations. 🤓
