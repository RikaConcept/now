# Guide de Push vers GitHub

## 📂 Structure du projet pour GitHub

Votre projet contient tous les fichiers nécessaires pour le déploiement sur Infomaniak.

### Dossiers à commiter dans Git

✅ **À INCLURE:**
- `backend/` - API PHP complète
- `src/` - Code source React
- `sql/` - Scripts SQL
- `scripts/` - Scripts utilitaires
- `uploads/` - Dossier vide (avec .gitkeep)
- `.htaccess` - Configuration Apache
- `package.json` - Dépendances
- Documentation (README.md, INSTALL.md, etc.)

❌ **À IGNORER (déjà dans .gitignore):**
- `dist/` - Généré par build
- `node_modules/` - Dépendances npm
- `.env` - Fichiers environnement locaux
- Fichiers de backup (*.bak, *_old.*)

### Vérifier le statut Git

```bash
# Voir les fichiers qui seront commités
git status

# Voir les fichiers ignorés
git status --ignored
```

## 📋 Checklist avant push

- [ ] Tous les fichiers backend/ sont présents
- [ ] Tous les fichiers src/ sont présents
- [ ] sql/schema.sql est présent
- [ ] scripts/ contient init-database.php et deploy.sh
- [ ] .htaccess est présent à la racine
- [ ] Documentation complète (README, INSTALL, etc.)
- [ ] .gitignore correctement configuré
- [ ] uploads/.gitkeep existe

## 🚀 Commandes Git

### Initialiser (si pas déjà fait)

```bash
git init
git add .
git commit -m "Migration complète Supabase vers MySQL/Infomaniak"
```

### Pousser vers GitHub

```bash
# Ajouter votre remote (si pas déjà fait)
git remote add origin https://github.com/RikaConcept/now.git

# Pousser
git push -u origin main
```

Ou utilisez la fonctionnalité "Save to GitHub" dans Emergent.

## 📁 Ce que vous verrez sur GitHub

```
votre-repo/
├── .gitignore
├── .htaccess
├── README.md
├── INSTALL.md
├── MIGRATION_GUIDE.md
├── DEPLOYMENT_READY.md
├── package.json
├── vite.config.ts
├── tailwind.config.js
├── backend/
│   ├── api/
│   ├── config/
│   ├── middleware/
│   ├── models/
│   └── utils/
├── src/
│   ├── components/
│   ├── contexts/
│   ├── lib/
│   └── pages/
├── sql/
│   └── schema.sql
├── scripts/
│   ├── init-database.php
│   ├── deploy.sh
│   └── test-api.sh
└── uploads/
    └── .gitkeep
```

## ⚠️ Notes importantes

### dist/ n'est PAS dans Git

Le dossier `dist/` est généré par `npm run build` et ne doit **PAS** être dans Git.

**Sur Infomaniak, vous devrez:**
1. Cloner le repo
2. Exécuter `npm install`
3. Exécuter `npm run build`
4. Le dossier `dist/` sera créé automatiquement

**Ou:** Buildez en local et uploadez `dist/` directement via FTP.

### uploads/ est vide dans Git

Le dossier `uploads/` est vide dans Git (juste `.gitkeep`).

**Sur Infomaniak:**
- Le dossier existera grâce à `.gitkeep`
- Les fichiers uploadés y seront stockés
- Ils ne seront pas versionnés (ignorés par git)

### .env.production

Le fichier `.env.production` est inclus car il contient l'URL de production (pas de secrets).

---

## 🔍 Vérifier que tout est prêt

```bash
# Depuis /app/

# 1. Vérifier que backend/ existe
ls -la backend/

# 2. Vérifier que src/ existe
ls -la src/

# 3. Vérifier que sql/schema.sql existe
ls -la sql/

# 4. Vérifier que scripts/ existe
ls -la scripts/

# 5. Vérifier que .htaccess existe
ls -la .htaccess

# 6. Vérifier que uploads/ existe avec .gitkeep
ls -la uploads/

# 7. Compter les fichiers à commiter
git add .
git status | grep "new file" | wc -l
```

Si toutes ces commandes fonctionnent, vous êtes prêt à pusher sur GitHub ! ✅

---

## 🎯 Après le push sur GitHub

Une fois sur GitHub, vous pourrez:

1. **Cloner sur Infomaniak:**
   ```bash
   git clone https://github.com/RikaConcept/now.git
   cd now
   npm install
   npm run build
   ```

2. **Ou télécharger un ZIP:**
   - GitHub → Code → Download ZIP
   - Uploader sur Infomaniak
   - Décompresser

3. **Suivre INSTALL.md** pour finaliser l'installation

---

**Votre repo GitHub sera complet et prêt pour le déploiement!** 🎉
