# 🧠 User Injector - Projet AD Lab

Projet de déploiement automatique d'un environnement Active Directory complet via PowerShell, pour un lab de tests ou un POC en entreprise.

---

## 📦 Contenu du projet

Ce dépôt contient :

```
User-injector-1-04/
├── users.csv                # 200 utilisateurs standards (Mockaroo)
├── admins.csv               # 10 utilisateurs admins (Mockaroo)
├── deploy-lab.ps1           # Script principal de déploiement
└── scripts/
    ├── install-ad.ps1       # Installation d'AD et création du domaine Loutrel.eu
    ├── init-ous.ps1         # Création des OU CEFIM Tours / USERS / ADMINS
    ├── create-users.ps1     # Injection des utilisateurs standards
    ├── create-admins.ps1    # Injection des utilisateurs admins + ajout au groupe Administrateurs
    └── check-users.ps1      # Script de vérification finale
```

---

## 🚀 Comment utiliser ce projet ?

### 1. Prérequis
- Une machine virtuelle **Windows Server 2022** (ou 2019)
- PowerShell lancé **en administrateur**
- Accès Internet pour installer les services AD DS si besoin
- Le rôle **AD DS** installé via :

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

- Dossier `User-injector-1-04` présent dans un **lecteur partagé** (ex: `Z:\`) via VMware ou VirtualBox

---

### 2. Lancer le déploiement automatique

Dans PowerShell **en tant qu'administrateur** sur la VM :

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
cd Z:\User-injector-1-04
.\deploy-lab.ps1
```

✅ Le script va :
1. Installer AD et promouvoir la machine en contrôleur de domaine (DC)
2. Te demander de redémarrer
3. Puis, à la relance, créer les OU et injecter les utilisateurs

> 💡 Tu peux activer le mode simulation avec :
```powershell
.\deploy-lab.ps1 -DryRun:$true
```

---

### 3. Vérification automatique

Le script `check-users.ps1` vérifie que :
- Les OU sont bien créées
- 200 utilisateurs sont bien dans USERS
- 10 admins sont bien dans ADMINS
- Tous les admins sont dans le groupe **Administrateurs**

📁 Il génère un fichier `check-results.log` avec un récapitulatif.

---

## 🧪 Tests réalisés
- [x] Installation d’Active Directory (AD DS)
- [x] Redémarrage automatique intégré dans le processus
- [x] Création automatique des OUs (y compris imbriquées)
- [x] Injection de 200 utilisateurs standards
- [x] Injection de 10 comptes admins
- [x] Ajout automatique des admins au groupe local "Administrateurs"
- [x] Rapport de validation final automatisé

---

## 🙋 Créateur
Lucie / Lucifer : loutre de l'enfer 🦦🔥

> Projet réalisé dans le cadre d'un TP de scripting PowerShell débutant à avancé, avec Git et VSCode. Ce projet vise à démontrer l'automatisation d'une infrastructure AD minimaliste dans un environnement de test local.
