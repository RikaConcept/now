# Nowlover - Application de Gestion de Membres

Application complète de gestion de membres avec système d'adhésion, boutique partenaire et demandes de produits.

## 🎯 Fonctionnalités

### Pour les membres
- ✅ Inscription et authentification sécurisée
- 📱 Code membre unique par localité
- 🏆 4 niveaux d'adhésion (Bronze, Silver, Gold, Platinum)
- 🛍️ Catalogue de produits
- 🤝 Système de parrainage
- 💳 Paiements via PayPal et Paystack
- 📊 Dashboard personnel
- 🏪 Accès aux boutiques partenaires

### Pour les administrateurs
- 📈 Dashboard avec statistiques
- 👥 Gestion des membres
- 🛒 Gestion des produits
- 📦 Gestion des commandes
- 📝 Gestion des demandes de produits
- ⚙️ Paramètres du site

## 🚀 Technologies

### Frontend
- ⚛️ React 18 + TypeScript
- 🎨 Tailwind CSS
- 🔄 React Router v7
- 🗃️ Zustand (state management)
- ⚡ Vite (build tool)

### Backend
- 🐘 PHP 7.4+
- 🗄️ MySQL 8.0
- 🔐 JWT Authentication
- 💳 PayPal & Paystack Integration

### Hébergement
- 🌐 Infomaniak (hébergement mutualisé)
- 🔒 HTTPS
- 📦 Serveur Apache

## 📦 Installation

Voir [INSTALL.md](./INSTALL.md) pour les instructions d'installation complètes.

### Installation rapide

```bash
# 1. Installer les dépendances
npm install

# 2. Construire le frontend
npm run build

# 3. Importer la base de données
# Via phpMyAdmin: sql/schema.sql

# 4. Initialiser les données
php scripts/init-database.php

# 5. Déployer sur Infomaniak
./scripts/deploy.sh
```

## 🔧 Configuration

### Variables d'environnement

Créez un fichier `.env` avec:

```bash
VITE_API_URL=https://arnowconcept.com/api
```

### Base de données

Configuré dans `/backend/config/database.php`:
- Host: pz3qp7.myd.infomaniak.com
- Database: pz3qp7_arnowc1225
- User: pz3qp7_arnowcu

### Paiements

**PayPal:** Sandbox et Live configurés
**Paystack:** Sandbox et Live configurés

## 📚 Documentation

- [INSTALL.md](./INSTALL.md) - Guide d'installation
- [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md) - Guide de migration Supabase → MySQL
- [API Documentation](#api-documentation) - Documentation de l'API

## 🔐 Identifiants par défaut

**Admin:**
- Email: rikaconcept@gmail.com  
- Mot de passe: AdminNow25#

⚠️ **Important:** Changez ces identifiants après l'installation!

## 🌐 API Documentation

### Authentification

```bash
# Inscription
POST /api/auth/register
Body: { "email", "password", "phone", "locality_id" }

# Connexion
POST /api/auth/login
Body: { "email", "password" }

# Utilisateur courant
GET /api/auth/user
Header: Authorization: Bearer <token>
```

### Membres

```bash
GET /api/members              # Info membre
GET /api/members?action=all   # Tous (admin)
PUT /api/members              # Mise à jour
```

### Produits

```bash
GET /api/products             # Liste
GET /api/products?id=xxx      # Détail
POST /api/products            # Créer (admin)
PUT /api/products?id=xxx      # Modifier (admin)
DELETE /api/products?id=xxx   # Supprimer (admin)
```

### Commandes

```bash
GET /api/orders               # Liste utilisateur
POST /api/orders              # Créer
PUT /api/orders?id=xxx        # Mettre à jour
```

## 🛠️ Développement

```bash
# Développement local
npm run dev

# Build
npm run build

# Preview build
npm run preview

# Linting
npm run lint

# Type checking
npm run typecheck
```

## 📁 Structure du projet

```
/
├── backend/              # API PHP
│   ├── api/             # Endpoints
│   ├── config/          # Configuration
│   ├── middleware/      # Auth, CORS
│   ├── models/          # Modèles données
│   └── utils/           # Utilitaires
├── src/                 # Frontend React
│   ├── components/      # Composants
│   ├── contexts/        # React contexts
│   ├── lib/            # Services (API)
│   ├── pages/          # Pages
│   └── App.tsx         # App principale
├── sql/                # Scripts SQL
├── scripts/            # Scripts déploiement
├── uploads/            # Fichiers uploadés
└── dist/               # Build production
```

## 🧪 Tests

```bash
# Frontend
npm run test

# API (curl)
curl -X POST https://arnowconcept.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

## 🚀 Déploiement

```bash
# Préparer le déploiement
npm run deploy

# Ou manuellement
./scripts/deploy.sh
```

Le script créera une archive prête à l'upload sur Infomaniak.

## 📊 Base de données

### Tables principales

- **users** - Utilisateurs
- **members** - Membres avec codes
- **membership_levels** - Niveaux adhésion
- **products** - Produits
- **orders** - Commandes  
- **partner_shops** - Boutiques partenaires
- **product_requests** - Demandes produits
- **localities** - Localités/villes
- **countries** - Pays
- **referrals** - Parrainages

## 🔒 Sécurité

- ✅ Authentification JWT
- ✅ Mots de passe hashés (bcrypt)
- ✅ HTTPS obligatoire
- ✅ CORS configuré
- ✅ Protection injection SQL (PDO prepared statements)
- ✅ Validation des entrées
- ✅ Protection fichiers sensibles

## 🐛 Dépannage

### Erreur 500
- Vérifier logs PHP
- Vérifier .htaccess
- Vérifier permissions fichiers

### Erreur connexion DB
- Vérifier credentials
- Tester via phpMyAdmin
- Vérifier firewall/IP

### Frontend ne charge pas
- Vérifier build existe
- Vérifier .htaccess
- Tester dist/index.html

## 📞 Support

Pour toute question:
1. Consultez [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md)
2. Vérifiez les logs serveur
3. Contactez le support Infomaniak

## 📝 License

Propriétaire - Tous droits réservés

## 👥 Crédits

Développé pour Nowlover
Migration Supabase → MySQL/Infomaniak