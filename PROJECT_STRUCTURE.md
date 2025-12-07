# Structure du Projet Nowlover

## 📂 Vue d'ensemble

```
nowlover/
├── backend/              # API REST PHP
├── src/                  # Code source React
├── dist/                 # Build production (généré, pas dans Git)
├── sql/                  # Scripts SQL
├── scripts/              # Scripts utilitaires
├── uploads/              # Fichiers uploadés (vide dans Git)
├── supabase/             # Ancien (ignoré, plus nécessaire)
├── .htaccess             # Configuration Apache
├── package.json          # Dépendances npm
└── [Documentation]       # Guides et README
```

## 📁 Détail des dossiers

### `/backend/` - API REST PHP

```
backend/
├── api/                  # Endpoints API
│   ├── auth.php         # Authentification
│   ├── members.php      # Gestion membres
│   ├── products.php     # Gestion produits
│   ├── orders.php       # Gestion commandes
│   ├── admin.php        # Dashboard admin
│   ├── localities.php   # Localités
│   ├── membership-levels.php # Niveaux
│   ├── partner-shops.php # Boutiques
│   ├── product-requests.php # Demandes
│   ├── countries.php    # Pays
│   ├── site-settings.php # Paramètres
│   ├── upload.php       # Upload fichiers
│   ├── checkout/        # Paiements
│   │   ├── paypal.php
│   │   └── paystack.php
│   └── webhooks/        # Webhooks paiements
│       ├── paypal.php
│       └── paystack.php
├── config/              # Configuration
│   ├── database.php     # Connexion MySQL
│   └── jwt.php          # Config JWT
├── middleware/          # Middleware
│   ├── auth.php         # Authentification
│   └── cors.php         # CORS
├── models/              # Modèles de données
│   ├── User.php
│   ├── Member.php
│   ├── Product.php
│   └── Order.php
└── utils/               # Utilitaires
    ├── JWT.php          # JWT encode/decode
    ├── Response.php     # Réponses standardisées
    └── UUID.php         # Génération UUID
```

**Rôle:** API REST qui remplace Supabase Edge Functions et Auth.

### `/src/` - Code source React

```
src/
├── components/          # Composants réutilisables
│   ├── Header.tsx
│   ├── Navigation.tsx
│   ├── ImageUpload.tsx
│   ├── SubscriptionStatus.tsx
│   └── CurrencySelector.tsx
├── contexts/            # React Contexts
│   ├── AuthContext.tsx  # Authentification JWT
│   └── CurrencyContext.tsx # Gestion devises
├── lib/                 # Services et utilitaires
│   ├── api.ts          # Service API (remplace Supabase)
│   ├── currency.ts     # Gestion devises
│   └── cartStore.ts    # Store panier (Zustand)
├── pages/              # Pages de l'application
│   ├── Home.tsx
│   ├── Login.tsx
│   ├── Signup.tsx
│   ├── Dashboard.tsx
│   ├── AdminDashboard.tsx
│   ├── GenerateCode.tsx
│   ├── Catalog.tsx
│   ├── Cart.tsx
│   ├── ProductRequest.tsx
│   ├── Partners.tsx
│   ├── Shop.tsx
│   ├── SiteSettings.tsx
│   └── CheckoutSuccess.tsx
├── App.tsx             # Application principale
├── main.tsx            # Point d'entrée
├── index.css           # Styles globaux
└── vite-env.d.ts       # Types TypeScript
```

**Rôle:** Interface utilisateur React avec routing et state management.

### `/dist/` - Build production

⚠️ **Généré automatiquement, PAS dans Git**

```bash
# Pour générer dist/
npm run build
```

Contient:
- `index.html` - Page HTML
- `assets/` - JS/CSS minifiés et optimisés

### `/sql/` - Scripts SQL

```
sql/
├── schema.sql          # Schéma complet MySQL
└── README.md           # Documentation
```

**Rôle:** Création de la base de données MySQL avec toutes les tables et données initiales.

### `/scripts/` - Scripts utilitaires

```
scripts/
├── init-database.php   # Initialise BDD + crée admin
├── deploy.sh           # Script de déploiement
├── test-api.sh         # Tests automatisés API
└── README.md           # Documentation
```

**Rôle:** Automatisation de l'installation et des tests.

### `/uploads/` - Fichiers uploadés

⚠️ **Vide dans Git, rempli en production**

Contient les fichiers uploadés par les utilisateurs:
- Images de produits
- Logos boutiques partenaires
- Photos de demandes de produits

Dans Git: Juste `.gitkeep` et `README.md`
En production: Fichiers réels

### `/supabase/` - Ancien backend

⚠️ **Ignoré, plus nécessaire**

Ce dossier contient l'ancienne configuration Supabase:
- Edge Functions (remplacées par API PHP)
- Migrations PostgreSQL (remplacées par schema.sql MySQL)

**Action:** Peut être supprimé ou ignoré (déjà dans .gitignore)

## 📄 Fichiers racine importants

### Configuration

- `.htaccess` - Routing Apache pour Infomaniak
- `.gitignore` - Fichiers à ignorer
- `.env.production` - URL API production
- `.env.example` - Template variables env

### Package Management

- `package.json` - Dépendances npm (Supabase retiré)
- `yarn.lock` - Lock file Yarn

### Build Configuration

- `vite.config.ts` - Configuration Vite
- `tailwind.config.js` - Configuration Tailwind
- `postcss.config.js` - Configuration PostCSS
- `tsconfig.json` - Configuration TypeScript

### Documentation

- `README.md` - Documentation générale
- `INSTALL.md` - Guide installation
- `MIGRATION_GUIDE.md` - Guide migration technique
- `DEPLOYMENT_READY.md` - Checklist déploiement
- `FRONTEND_MIGRATION.md` - Patterns migration
- `ADMIN_DASHBOARD_MIGRATION.md` - Guide admin
- `GITHUB_GUIDE.md` - Ce fichier

## 🔄 Workflow de déploiement

### Développement local

1. `git clone` votre repo
2. `npm install` - Installer dépendances
3. `npm run dev` - Lancer dev server
4. Développer et tester
5. `git commit` et `git push`

### Déploiement Infomaniak

1. **Via Git:**
   ```bash
   git clone votre-repo
   npm install
   npm run build
   php scripts/init-database.php
   ```

2. **Via FTP:**
   - Build local: `npm run build`
   - Upload: `backend/`, `dist/`, `.htaccess`, `sql/`
   - SSH: `php scripts/init-database.php`

## 📊 Tailles des dossiers

| Dossier | Taille | Dans Git? |
|---------|--------|-----------|
| `backend/` | ~150 KB | ✅ Oui |
| `src/` | ~200 KB | ✅ Oui |
| `node_modules/` | ~150 MB | ❌ Non (.gitignore) |
| `dist/` | ~400 KB | ❌ Non (.gitignore) |
| `sql/` | ~15 KB | ✅ Oui |
| `scripts/` | ~10 KB | ✅ Oui |
| `uploads/` | Variable | ⚠️ Vide dans Git |
| `supabase/` | ~100 KB | ❌ Non (.gitignore) |

**Total dans Git:** ~500 KB (sans node_modules, dist, supabase)

## ✅ Vérification finale

Assurez-vous que ces dossiers/fichiers sont présents:

```bash
# Backend complet
ls -la backend/api/*.php
ls -la backend/config/*.php
ls -la backend/middleware/*.php
ls -la backend/models/*.php
ls -la backend/utils/*.php

# SQL
ls -la sql/schema.sql

# Scripts
ls -la scripts/*.php
ls -la scripts/*.sh

# Configuration
ls -la .htaccess

# Source React
ls -la src/pages/*.tsx
ls -la src/lib/api.ts

# Documentation
ls -la *.md
```

Si tous ces fichiers existent, **votre projet est complet!** ✅

---

**Votre structure est maintenant optimale pour GitHub et Infomaniak!** 🎉
