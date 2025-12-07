# 🚀 Déploiement sur Infomaniak - Sans NPM

## ⚠️ Problème: npm n'est pas disponible sur hébergement mutualisé

**Solution:** Builder le frontend EN LOCAL (ou ici dans Emergent) et uploader le dossier `dist/` directement via FTP.

---

## 📦 Solution: Build avant upload

### Étape 1: Builder le frontend (déjà fait!)

Le frontend a déjà été buildé dans `/app/dist/`. Vous n'avez **PAS besoin de npm sur Infomaniak**.

```bash
# Vérifier que dist/ existe
ls -la /app/dist/

# Vous devriez voir:
# dist/
# ├── index.html
# └── assets/
#     ├── index-xxx.js
#     └── index-xxx.css
```

### Étape 2: Préparer le package de déploiement

Créons une archive avec SEULEMENT les fichiers nécessaires pour Infomaniak (sans code source):

```bash
cd /app

# Créer un dossier de déploiement
mkdir -p deploy_infomaniak

# Copier UNIQUEMENT les fichiers nécessaires
cp -r backend deploy_infomaniak/
cp -r dist deploy_infomaniak/
cp -r sql deploy_infomaniak/
cp -r scripts deploy_infomaniak/
cp .htaccess deploy_infomaniak/

# Créer le dossier uploads vide
mkdir -p deploy_infomaniak/uploads
chmod 755 deploy_infomaniak/uploads

# Créer une archive
tar -czf nowlover_infomaniak.tar.gz deploy_infomaniak/

# Ou créer un ZIP
zip -r nowlover_infomaniak.zip deploy_infomaniak/
```

Maintenant vous avez `nowlover_infomaniak.tar.gz` prêt à uploader!

---

## 📤 Déploiement sur Infomaniak (Méthode FTP)

### Option 1: Via FTP/SFTP (Recommandé)

**Outils FTP:** FileZilla, Cyberduck, WinSCP

**Credentials FTP:** (depuis panel Infomaniak → FTP)

**Fichiers à uploader vers `/public_html/`:**

```
/public_html/
├── .htaccess          ← depuis /app/.htaccess
├── backend/           ← depuis /app/backend/
├── dist/              ← depuis /app/dist/
├── uploads/           ← créer dossier vide
└── sql/               ← depuis /app/sql/ (optionnel)
```

### Option 2: Via Archive

1. **Télécharger l'archive:**
   - Téléchargez `nowlover_infomaniak.tar.gz` depuis Emergent

2. **Uploader via FTP:**
   - Uploadez l'archive dans `/public_html/`

3. **Décompresser via SSH ou File Manager:**
   ```bash
   tar -xzf nowlover_infomaniak.tar.gz
   mv deploy_infomaniak/* .
   rm -rf deploy_infomaniak
   ```

   Ou via le gestionnaire de fichiers Infomaniak → Extraire

---

## 🗄️ Configuration Base de Données

### Via phpMyAdmin (Panel Infomaniak)

1. **Accéder à phpMyAdmin:**
   - Panel Infomaniak → Bases de données → phpMyAdmin

2. **Sélectionner la base:**
   - `pz3qp7_arnowc1225`

3. **Importer le schéma:**
   - Onglet "Importer"
   - Choisir fichier: `sql/schema.sql`
   - Cliquer "Exécuter"

4. **Initialiser les données:**
   
   Via SSH (si disponible):
   ```bash
   cd /public_html
   php scripts/init-database.php
   ```
   
   Ou exécutez manuellement les requêtes SQL pour créer l'admin:
   ```sql
   -- Créer admin
   SET @admin_id = UUID();
   SET @admin_email = 'rikaconcept@gmail.com';
   SET @admin_password = '$2y$10$XqJz8ZxkYKvH5QNQZ5QZ5eZKJZxKJZxKJZxKJZxKJZxKJZxKJZxKJ';
   
   INSERT INTO users (id, email, password) VALUES (@admin_id, @admin_email, @admin_password);
   
   -- Le reste sera fait via l'interface
   ```

---

## 🔧 Configuration finale

### Permissions (via FTP ou File Manager)

```
uploads/           → 755 (rwxr-xr-x)
.htaccess          → 644 (rw-r--r--)
backend/           → 755 (rwxr-xr-x)
dist/              → 755 (rwxr-xr-x)
```

### Test de l'installation

1. **Accéder au site:**
   - https://arnowconcept.com/

2. **Tester l'API:**
   ```bash
   curl https://arnowconcept.com/api/localities
   ```
   
   Devrait retourner un JSON avec les localités

3. **Se connecter en admin:**
   - https://arnowconcept.com/admin/login
   - Email: `rikaconcept@gmail.com`
   - Password: `AdminNow25#`

---

## 📋 Checklist de déploiement

### Pré-déploiement (sur votre machine locale ou Emergent)

- [x] Build frontend créé (`/app/dist/`)
- [x] Backend PHP complet
- [x] SQL schema prêt
- [x] .htaccess configuré

### Upload sur Infomaniak

- [ ] Uploader `backend/` via FTP
- [ ] Uploader `dist/` via FTP
- [ ] Uploader `.htaccess` via FTP
- [ ] Uploader `sql/` via FTP (optionnel)
- [ ] Créer dossier `uploads/` avec permissions 755

### Configuration base de données

- [ ] Importer `sql/schema.sql` via phpMyAdmin
- [ ] Exécuter `scripts/init-database.php` (ou créer admin manuellement)

### Tests

- [ ] Site accessible: https://arnowconcept.com/
- [ ] API répond: https://arnowconcept.com/api/localities
- [ ] Admin peut se connecter
- [ ] Pages s'affichent correctement

---

## 🎯 Structure sur Infomaniak (sans npm/node)

```
/public_html/
├── .htaccess          # Routing
├── backend/           # API PHP (fonctionne avec PHP d'Infomaniak)
├── dist/              # Frontend buildé (HTML/JS/CSS statiques)
└── uploads/           # Fichiers uploadés
```

**Aucun npm/node nécessaire!** Tout fonctionne avec PHP natif d'Infomaniak.

---

## 💡 Astuce: Automatiser le build

### Sur votre machine locale

Créez un script `build-and-package.sh`:

```bash
#!/bin/bash

# Builder le frontend
npm install
npm run build

# Créer le package pour Infomaniak
mkdir -p deploy_infomaniak
cp -r backend deploy_infomaniak/
cp -r dist deploy_infomaniak/
cp -r sql deploy_infomaniak/
cp .htaccess deploy_infomaniak/
mkdir -p deploy_infomaniak/uploads

# Créer archive
zip -r nowlover_ready.zip deploy_infomaniak/

echo "✅ nowlover_ready.zip est prêt à uploader sur Infomaniak!"
```

Ensuite:
1. Exécuter le script sur votre machine
2. Uploader `nowlover_ready.zip` sur Infomaniak
3. Extraire via File Manager

---

## 🚨 Si vous n'avez pas npm en local non plus

### Solution: Builder dans Emergent (déjà fait!)

Le dossier `/app/dist/` a déjà été créé dans Emergent.

**Téléchargez ces dossiers depuis Emergent:**

1. **Via l'interface Emergent:**
   - Téléchargez `/app/backend/`
   - Téléchargez `/app/dist/`
   - Téléchargez `/app/.htaccess`
   - Téléchargez `/app/sql/`

2. **Uploadez sur Infomaniak via FTP**

**Ou demandez-moi de créer une archive complète prête à télécharger!**

---

## 🎊 Résumé

**Le problème:** Pas de npm sur Infomaniak
**La solution:** Builder AVANT d'uploader

**Votre situation:**
- ✅ Build déjà créé dans `/app/dist/`
- ✅ Backend PHP prêt (pas besoin de npm)
- ✅ Juste uploader via FTP

**Vous n'avez PAS besoin de npm sur Infomaniak!** 🎉

---

Voulez-vous que je crée une archive ZIP complète prête à télécharger et uploader?
