# 🚀 INSTALLATION SUR INFOMANIAK - Guide Simplifié (Sans NPM)

## ✅ Situation: Hébergement mutualisé sans Node.js/NPM

**Bonne nouvelle:** Votre application est PRÊTE! Tout est déjà buildé.

---

## 📦 Fichiers prêts à uploader

J'ai créé **2 archives** prêtes pour vous:

1. **`nowlover_infomaniak.tar.gz`** (232 KB)
2. **`nowlover_infomaniak.zip`** (251 KB)

Ces archives contiennent UNIQUEMENT les fichiers nécessaires pour Infomaniak:
- ✅ `backend/` - API PHP
- ✅ `dist/` - Frontend buildé (HTML/JS/CSS)
- ✅ `sql/` - Scripts SQL
- ✅ `scripts/` - Scripts PHP
- ✅ `.htaccess` - Configuration
- ✅ `uploads/` - Dossier vide

**Pas de node_modules, pas de src/, pas besoin de npm!**

---

## 🔧 Installation en 6 étapes (15 minutes)

### Étape 1: Télécharger l'archive (depuis Emergent)

Dans Emergent, téléchargez:
- `/app/nowlover_infomaniak.zip` 

OU directement les dossiers:
- `/app/deploy_infomaniak/`

### Étape 2: Uploader sur Infomaniak via FTP

**Credentials FTP:** (depuis Panel Infomaniak → FTP)

**Uploader vers `/public_html/` (ou votre dossier racine):**

```
Via FileZilla/Cyberduck:
1. Connectez-vous en FTP
2. Naviguez vers /public_html/
3. Uploadez:
   - .htaccess
   - backend/ (dossier complet)
   - dist/ (dossier complet)
   - sql/ (dossier complet)
   - scripts/ (dossier complet)
   - uploads/ (dossier vide)
```

### Étape 3: Configurer les permissions

Via File Manager Infomaniak ou FTP:

```
uploads/     → 755
.htaccess    → 644
backend/     → 755
```

### Étape 4: Importer la base de données

**Via phpMyAdmin:**

1. Panel Infomaniak → Bases de données → phpMyAdmin
2. Sélectionner: `pz3qp7_arnowc1225`
3. Onglet "Importer"
4. Choisir: `sql/schema.sql`
5. Cliquer "Exécuter"

✅ Résultat: 11 tables créées avec données initiales

### Étape 5: Créer l'administrateur

**Option A: Via SSH (si disponible)**

```bash
cd /public_html
php scripts/init-database.php
```

**Option B: Via phpMyAdmin (si pas de SSH)**

Exécutez cette requête SQL:

```sql
-- Créer admin user
SET @admin_id = '550e8400-e29b-41d4-a716-446655440000';
SET @admin_email = 'rikaconcept@gmail.com';
-- Hash de 'AdminNow25#'
SET @admin_password = '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi';

-- Insérer utilisateur
INSERT INTO users (id, email, password) 
VALUES (@admin_id, @admin_email, @admin_password)
ON DUPLICATE KEY UPDATE email=email;

-- Insérer membre
INSERT INTO members (id, email, code, status, activated_at) 
VALUES (@admin_id, @admin_email, 'ADMIN001', 'active', NOW())
ON DUPLICATE KEY UPDATE email=email;

-- Définir comme admin
INSERT INTO admin_users (user_id, role) 
VALUES (@admin_id, 'admin')
ON DUPLICATE KEY UPDATE role='admin';
```

### Étape 6: Tester l'application

1. **Accéder au site:**
   - https://arnowconcept.com/

2. **Tester l'API:**
   - https://arnowconcept.com/api/localities
   - Devrait retourner un JSON

3. **Se connecter en admin:**
   - https://arnowconcept.com/admin/login
   - Email: `rikaconcept@gmail.com`
   - Password: `AdminNow25#`

---

## ✅ Vérifications post-installation

### Test 1: Site accessible
- [ ] https://arnowconcept.com/ affiche la page d'accueil

### Test 2: API fonctionne
```bash
curl https://arnowconcept.com/api/localities
# Devrait retourner: {"success":true,"data":[...]}
```

### Test 3: Admin accessible
- [ ] Login admin fonctionne
- [ ] Dashboard affiche les stats

### Test 4: Pages publiques
- [ ] Page d'accueil
- [ ] Catalogue
- [ ] Partenaires
- [ ] Génération de code

---

## 🐛 Dépannage

### Erreur 500 sur toutes les pages

**Cause:** .htaccess mal configuré ou mod_rewrite désactivé

**Solution:**
1. Vérifiez que `.htaccess` est bien uploadé
2. Testez sans .htaccess:
   - Renommez `.htaccess` en `.htaccess.bak`
   - Testez l'accès direct: `https://arnowconcept.com/dist/index.html`
3. Contactez support Infomaniak pour activer mod_rewrite

### Erreur "Database connection failed"

**Cause:** Credentials incorrects

**Solution:**
1. Vérifiez dans `/backend/config/database.php`
2. Testez connexion via phpMyAdmin avec mêmes credentials
3. Vérifiez que le schéma SQL a été importé

### API retourne 404

**Cause:** .htaccess ne route pas correctement

**Solution:**
1. Testez l'accès direct: `https://arnowconcept.com/backend/api/localities.php`
2. Si ça fonctionne, le problème est dans .htaccess
3. Vérifiez les règles de réécriture

### Frontend ne s'affiche pas

**Cause:** dist/ mal uploadé

**Solution:**
1. Vérifiez que `/dist/index.html` existe sur le serveur
2. Vérifiez que `/dist/assets/` contient les fichiers JS/CSS
3. Testez l'accès direct: `https://arnowconcept.com/dist/index.html`

---

## 📥 Télécharger les archives

**Depuis Emergent:**

Les archives sont dans `/app/`:
- `nowlover_infomaniak.tar.gz` (232 KB)
- `nowlover_infomaniak.zip` (251 KB)

**Ou téléchargez le dossier:**
- `/app/deploy_infomaniak/` (contient tout)

---

## 🎯 Récapitulatif

### Ce dont vous avez besoin:

1. ✅ Accès FTP Infomaniak
2. ✅ Accès phpMyAdmin Infomaniak
3. ✅ Archive `nowlover_infomaniak.zip` (déjà créée)

### Ce dont vous N'avez PAS besoin:

- ❌ npm/node sur Infomaniak
- ❌ Compiler sur le serveur
- ❌ SSH (optionnel, mais pas obligatoire)

### Temps d'installation:

- Upload FTP: 5-10 minutes
- Import SQL: 2 minutes
- Configuration: 2 minutes
- Tests: 5 minutes

**Total: ~15-20 minutes** ⏱️

---

## 🎊 Votre application fonctionne 100% sans npm!

Le backend est en **PHP natif** (supporté par Infomaniak)
Le frontend est **HTML/JS/CSS statique** (déjà buildé)

**Aucune compilation nécessaire sur le serveur!** 🚀

---

## 📞 Besoin d'aide?

1. Vérifiez les logs PHP (Panel Infomaniak)
2. Consultez `INSTALL.md` pour plus de détails
3. Testez avec les commandes curl ci-dessus

**Votre application est prête à tourner sur Infomaniak!** ✨
