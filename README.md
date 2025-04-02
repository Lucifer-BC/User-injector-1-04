# 🧠 User Injector - Projet AD Lab

Projet de déploiement automatique d'un environnement Active Directory complet via PowerShell, avec mode simulation intégré.

---

## 📁 Arborescence du projet

```
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

| Élément           | Description                                                             |
|-------------------|-------------------------------------------------------------------------|
| 🖥️ Machine        | VM Windows Server 2022 (ou 2019)                                        |
| 🔧 VMware Tools   | Doivent être installés et à jour                                        |
| 🔌 IP Fixe         | L'adresse IP doit être définie manuellement                            |
| 📦 Rôle ADDS       | Sera installé automatiquement par le script                            |
| 📂 Dossier partagé | Le dossier `User-injector-1-04` doit être partagé avec la VM           |
| 💽 Lecteur Z:\     | Le dossier partagé doit apparaître dans la VM comme `Z:\`              |

> 🧠 Vérifie les **VMware Shared Folders** : Settings > Options > Shared folders > Always enabled

---

### 2. 🛠️ Lancement de l'installation automatique

Dans PowerShell (en **mode administrateur**) dans la VM :

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
Z:
.\deploy-lab.ps1
```

Le script va automatiquement :

1. Vérifier que l’IP est fixe  
2. Installer le rôle ADDS si nécessaire  
3. Promouvoir le serveur en contrôleur de domaine (domaine `Loutrel.eu`)  
4. Demander un redémarrage  
5. Créer les OU nécessaires  
6. Injecter les utilisateurs standards  
7. Injecter les admins et les ajouter au groupe "Administrateurs"  
8. Lancer la vérification finale

---

### 3. 🧪 Mode Simulation (`-DryRun`)

Tous les scripts prennent en charge un **mode simulation** :

```powershell
Z:
.\deploy-lab.ps1 -DryRun:$true
```

Ce mode :

- Affiche les actions prévues  
- Ne modifie **rien** dans Active Directory

✅ Idéal pour valider que tout est prêt avant déploiement réel.

---

### 4. ✅ Vérification finale automatique

Le script `check-users.ps1` vérifie que :

- Les OU ont bien été créées  
- 200 utilisateurs sont présents dans `USERS`  
- 10 comptes admins dans `ADMINS`  
- Les comptes admins sont bien membres du groupe "Administrateurs"

📄 Un rapport est généré : `check-results.log`

---

## 🧪 Tests réalisés

- [x] Installation automatique du rôle ADDS  
- [x] Redémarrage du serveur DC intégré  
- [x] Création d’OU imbriquées : CEFIM Tours > USERS / ADMINS  
- [x] Injection de 200 utilisateurs standards  
- [x] Injection de 10 admins + ajout dans "Administrateurs"  
- [x] Vérification automatisée de la structure  
- [x] Mode `DryRun` fonctionnel sur tous les scripts

---

## 🙋 Auteur

Projet réalisé par **Lucifer 🦦** dans le cadre d’un TP TSSR – scripting PowerShell et GitHub avec VSCode.

> 🧰 Ce projet a été pensé comme un kit de déploiement rapide pour tout environnement lab AD.
