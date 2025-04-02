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

### 2. ⚙️ Lancement initial

Ouvre **PowerShell en tant qu’administrateur** sur la VM, puis exécute :

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
Z:
Unblock-File .\deploy-lab.ps1
.\deploy-lab.ps1
```

Le script va :
- Vérifier que l’IP est fixe
- Installer ADDS
- Demander un mot de passe administrateur pour le domaine
- Promouvoir automatiquement le serveur en DC (domaine `Loutrel.eu`)
- Puis redémarrer automatiquement

**ℹ️ Après le redémarrage, reconnecte-toi et relance les commandes suivantes pour continuer :**

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
Z:
Unblock-File .\deploy-lab.ps1
.\deploy-lab.ps1
```

La suite du script reprendra automatiquement les étapes 2 à 5 👇

### 3. 🧪 Mode Simulation (Dry Run)

Tous les scripts prennent en charge un mode simulation :

```powershell
.\deploy-lab.ps1 -DryRun:$true
```

Cela permet de tester sans rien créer dans l’AD. Parfait pour valider la configuration avant déploiement réel ✅

### 4. ✅ Vérification finale

Le script `check-users.ps1` vérifie que :
- Les OU existent bien
- Il y a 200 utilisateurs dans USERS
- Il y a 10 comptes dans ADMINS
- Les comptes ADMINS sont membres du groupe "Administrateurs"

Un fichier `check-results.log` est généré avec le statut final de chaque vérification.

---

## 🧪 Tests réalisés

- [x] Installation automatique ADDS
- [x] Reprise du script après redémarrage
- [x] Création sécurisée des OU
- [x] Injection de 200 utilisateurs standards
- [x] Injection de 10 admins + ajout au groupe "Administrateurs"
- [x] Vérification finale automatisée
- [x] Mode DryRun fonctionnel
- [x] Gestion d'erreurs basiques (répertoire introuvable, CSV manquant, etc.)

---

## 📦 Commandes Git pour versionner et publier

```bash
git add .
git commit -m "✅ Finalisation README et install-ad.ps1 après tests VM"
git push
```

---

## 🙋 Auteur

Projet réalisé par **Lucifer / Lucie 🦦** dans le cadre du TP scripting PowerShell et GitHub VSCode (TSSR).

> Ce projet est pensé comme un kit de déploiement rapide d'Active Directory pour environnement de test/lab.
