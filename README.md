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
| 📂 Accès aux fichiers | Le dossier partagé `User-injector-1-04` doit être monté dans un lecteur (ex : `Z:\`) |

> 🔐 **Important : Débloquer les scripts téléchargés**
>
> Avant de lancer les scripts, exécute cette commande dans PowerShell pour débloquer `deploy-lab.ps1` :
>
> ```powershell
> Unblock-File -Path "Z:\deploy-lab.ps1"
> ```

### 2. ⚙️ Exécution en 2 étapes

#### 🔁 Étape 1 : Lancement initial

Ouvre **PowerShell en tant qu’administrateur** et tape :

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
Z:
Unblock-File -Path "deploy-lab.ps1"
./deploy-lab.ps1
```

👉 Le script installe le rôle ADDS, promeut le DC et **s'arrête pour laisser le redémarrage se faire**. 
Tu devras définir un mot de passe d’administrateur de domaine manuellement à cette étape.

#### 🔄 Étape 2 : Suite du déploiement (après redémarrage)

Une fois redémarré, ouvre à nouveau PowerShell en administrateur et relance simplement :

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
Z:
./deploy-lab.ps1
```

Le script détectera que le domaine est déjà en place et enchaînera automatiquement avec :
- la création des OU,
- l'injection des utilisateurs,
- l’ajout au groupe Administrateurs,
- la vérification finale automatisée.

---

## 🧪 Mode Simulation (Dry Run)

Tous les scripts supportent un mode simulation sans effet réel dans Active Directory.
Pour tester avant déploiement :

```powershell
./deploy-lab.ps1 -DryRun:$true
```

---

## ✅ Vérification finale

Le script `check-users.ps1` confirme :
- La présence des OU
- 200 utilisateurs standards dans USERS
- 10 comptes admins dans ADMINS
- Leur appartenance au groupe "Administrateurs"

Un rapport `check-results.log` est généré à la racine.

---

## 🧪 Tests réalisés

- [x] Installation automatique ADDS
- [x] Redémarrage du contrôleur de domaine
- [x] Création sécurisée d’OU imbriquées
- [x] Injection de 200 utilisateurs standards
- [x] Injection de 10 admins + ajout groupe Administrateurs
- [x] Vérification finale automatisée
- [x] Gestion du mode DryRun pour tous les scripts
- [x] Déblocage manuel des scripts (`Unblock-File`)
- [x] Test complet sur une VM vierge Windows Server 2022

---

## 🙋 Auteur

Projet réalisé par **Lucifer / Lucie 🦦** dans le cadre d’un TP TSSR - scripting PowerShell et GitHub avec VSCode.

> Ce projet a été pensé comme un kit de déploiement rapide pour tout environnement lab AD.
