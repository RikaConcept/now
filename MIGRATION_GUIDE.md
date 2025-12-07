# Migration Nowlover - Supabase vers MySQL/Infomaniak

## 📊 Vue d'ensemble de la migration

Cette migration transforme votre application Nowlover de:
- **Avant:** Supabase (PostgreSQL + Auth + Edge Functions + Storage)
- **Après:** MySQL + API REST PHP + Hébergement mutualisé Infomaniak

## 🔄 Changements majeurs

### Architecture

| Composant | Avant (Supabase) | Après (Infomaniak) |
|-----------|------------------|-------------------|
| Base de données | PostgreSQL | MySQL 8.0 |
| Authentification | Supabase Auth | JWT personnalisé |
| API | Edge Functions | PHP REST API |
| Stockage fichiers | Supabase Storage | Serveur local (/uploads) |
| Frontend | React + Supabase Client | React + Fetch API |

### Base de données

**Types de données migrés:**
- `uuid` (PostgreSQL) → `VARCHAR(36)` (MySQL)
- `jsonb` → `JSON`
- `timestamptz` → `DATETIME`
- `serial` → `AUTO_INCREMENT` (non utilisé, UUID à la place)

**Tables créées:**
- `users` - Remplace `auth.users` de Supabase
- `admin_users` - Gestion des administrateurs
- `members` - Membres avec codes uniques
- `membership_levels` - 4 niveaux (Bronze, Silver, Gold, Platinum)
- `localities` - Localités/villes
- `countries` - Pays
- `products` - Catalogue de produits
- `partner_shops` - Boutiques partenaires
- `orders` - Commandes
- `product_requests` - Demandes de produits
- `referrals` - Système de parrainage
- `site_settings` - Paramètres du site

### API Endpoints

Toutes les fonctionnalités Supabase sont maintenant accessibles via API REST:

#### Authentification
- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion
- `GET /api/auth/user` - Info utilisateur courant
- Header requis: `Authorization: Bearer <token>`

#### Membres
- `GET /api/members` - Info membre courant
- `GET /api/members?action=by-code&code=XXX` - Recherche par code
- `PUT /api/members` - Mise à jour profil
- `GET /api/members?action=all` - Tous les membres (admin)

#### Produits
- `GET /api/products` - Liste des produits
- `GET /api/products?id=xxx` - Détail produit
- `POST /api/products` - Créer produit (admin)
- `PUT /api/products?id=xxx` - Modifier produit (admin)
- `DELETE /api/products?id=xxx` - Supprimer produit (admin)

#### Commandes
- `GET /api/orders` - Commandes de l'utilisateur
- `GET /api/orders?action=single&id=xxx` - Détail commande
- `POST /api/orders` - Créer commande
- `PUT /api/orders?id=xxx` - Mettre à jour statut
- `GET /api/orders?action=all` - Toutes les commandes (admin)

#### Paiements
- `POST /api/checkout/paypal` - Initialiser paiement PayPal
- `POST /api/checkout/paystack` - Initialiser paiement Paystack
- `POST /api/webhooks/paypal` - Webhook PayPal
- `POST /api/webhooks/paystack` - Webhook Paystack

#### Données publiques
- `GET /api/localities` - Liste des localités
- `GET /api/membership-levels` - Niveaux d'adhésion
- `GET /api/partner-shops` - Boutiques partenaires
- `GET /api/countries` - Pays
- `POST /api/product-requests` - Créer demande (public/auth)

#### Administration
- `GET /api/admin?action=stats` - Statistiques dashboard
- `GET /api/admin?action=members` - Gestion membres
- `GET /api/admin?action=orders` - Gestion commandes
- `GET /api/admin?action=product-requests` - Gestion demandes

#### Upload
- `POST /api/upload` - Upload d'image (authentifié)

### Frontend - Changements

**Fichiers modifiés:**
1. `/src/lib/api.ts` - Nouveau service API (remplace Supabase client)
2. `/src/contexts/AuthContext.tsx` - Authentification JWT
3. `.env.production` - Configuration production

**Utilisation du nouveau service API:**

```typescript
import { api } from './lib/api';

// Authentification
await api.login(email, password);
await api.register(email, password);
await api.logout();

// Récupération de données
const products = await api.getProducts();
const member = await api.getMember();
const orders = await api.getOrders();

// Création
await api.createOrder(amount, 'paypal');
await api.createProductRequest(data);

// Admin
const stats = await api.getAdminStats();
const allMembers = await api.getAllMembers();
```

## 🔐 Sécurité

### JWT (JSON Web Tokens)

L'authentification utilise JWT avec:
- Algorithm: HS256
- Expiration: 24 heures
- Secret: Configurable dans `/backend/config/jwt.php`

**⚠️ Important:** Changez le secret JWT en production!

### Mots de passe

- Hashage avec `bcrypt` (PHP `password_hash`)
- Vérification avec `password_verify`

### CORS

Configuration dans `/backend/middleware/cors.php`:
- Allow Origin: Dynamic (basé sur `HTTP_ORIGIN`)
- Allow Credentials: true
- Methods: GET, POST, PUT, DELETE, OPTIONS

### Protection des fichiers

`.htaccess` protège:
- Fichiers `.env`, `.sql`, `.log`, `.ini`
- Directory listing désactivé

## 💳 Configuration des paiements

### PayPal

**Sandbox (Test):**
```php
CLIENT_ID: AV7kpXgErYvZHnzkYNd3U4sf-xW-toyMi1u-UAHYYb9bB8HLbS2BiORDZU5H2YkK_Byz-myElL9pK7g-
SECRET: EKO_ybdAZK0FSLh2Aq3GzGsneqcVBVxU5a_bhvsXv3mgHeOsFjHJbEeUSwz8lak070k9XynIZgGdns92
```

**Live (Production):**
```php
CLIENT_ID: AXvswzslLf5AkJt5opS8QXLBit74g5blW-1Wvzbqu6jCVAjxEGIbv07-lz1a76gg5XtokHAl1nuP2B81
SECRET: [À fournir]
```

Pour activer le mode Live:
1. Modifier `PAYPAL_MODE` dans `/backend/api/checkout/paypal.php`
2. Ajouter le SECRET live
3. Configurer les webhooks dans le dashboard PayPal

### Paystack

**Sandbox & Live configurés**

Pour activer le mode Live:
1. Modifier `PAYSTACK_MODE` dans `/backend/api/checkout/paystack.php`
2. Configurer les webhooks dans le dashboard Paystack

## 📁 Structure des fichiers déployés

```
/public_html/  (racine Infomaniak)
├── .htaccess                    # Configuration Apache
├── dist/                        # Build React
│   ├── index.html
│   ├── assets/
│   └── ...
├── backend/                     # API PHP
│   ├── api/                     # Endpoints
│   │   ├── auth.php
│   │   ├── members.php
│   │   ├── products.php
│   │   ├── orders.php
│   │   ├── admin.php
│   │   ├── checkout/
│   │   │   ├── paypal.php
│   │   │   └── paystack.php
│   │   └── webhooks/
│   │       ├── paypal.php
│   │       └── paystack.php
│   ├── config/                  # Configuration
│   │   ├── database.php
│   │   └── jwt.php
│   ├── middleware/              # Middleware
│   │   ├── auth.php
│   │   └── cors.php
│   ├── models/                  # Modèles de données
│   │   ├── User.php
│   │   ├── Member.php
│   │   ├── Product.php
│   │   └── Order.php
│   └── utils/                   # Utilitaires
│       ├── JWT.php
│       ├── Response.php
│       └── UUID.php
├── uploads/                     # Fichiers uploadés (755)
├── sql/                         # Scripts SQL
│   └── schema.sql
└── scripts/                     # Scripts utilitaires
    ├── init-database.php
    └── deploy.sh
```

## 🚀 Processus de déploiement

### Option 1: Déploiement automatique

```bash
./scripts/deploy.sh
```

Ceci créera:
- Build du frontend dans `/dist`
- Archive `deploy_YYYYMMDD_HHMMSS.tar.gz`
- Package prêt à l'upload

### Option 2: Déploiement manuel

1. **Build frontend:**
   ```bash
   npm install
   npm run build
   ```

2. **Upload via FTP/SFTP:**
   - Uploadez tous les fichiers vers `/public_html`
   - Assurez les permissions appropriées

3. **Configuration base de données:**
   - Importez `sql/schema.sql` via phpMyAdmin
   - Exécutez `php scripts/init-database.php`

4. **Vérifications:**
   - Testez l'accès à https://arnowconcept.com/
   - Vérifiez les logs PHP
   - Testez la connexion admin

## 🔍 Tests et vérification

### Tests post-déploiement

1. **Frontend:**
   - [ ] Page d'accueil s'affiche
   - [ ] Navigation fonctionne
   - [ ] Pas d'erreurs console

2. **Authentification:**
   - [ ] Inscription fonctionne
   - [ ] Connexion fonctionne
   - [ ] Token JWT généré et stocké
   - [ ] Déconnexion fonctionne

3. **API:**
   - [ ] Tous les endpoints répondent
   - [ ] Données correctement récupérées
   - [ ] CORS configuré correctement

4. **Admin:**
   - [ ] Connexion admin réussie
   - [ ] Dashboard affiche les stats
   - [ ] Gestion membres/produits/commandes

5. **Paiements:**
   - [ ] Checkout PayPal fonctionne
   - [ ] Checkout Paystack fonctionne
   - [ ] Webhooks configurés

### Commandes de test

```bash
# Test connexion base de données
php scripts/init-database.php

# Test endpoint API
curl https://arnowconcept.com/api/localities

# Test authentification
curl -X POST https://arnowconcept.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"rikaconcept@gmail.com","password":"AdminNow25#"}'
```

## 🐛 Dépannage

### Erreur 500 sur les routes API

**Cause:** Configuration .htaccess ou permissions
**Solution:**
1. Vérifiez que mod_rewrite est activé
2. Vérifiez les logs PHP: `/var/log/apache2/error.log`
3. Testez l'accès direct: `https://arnowconcept.com/backend/api/auth.php`

### Erreur de connexion base de données

**Cause:** Credentials incorrects
**Solution:**
1. Vérifiez `/backend/config/database.php`
2. Testez via phpMyAdmin avec les mêmes credentials
3. Vérifiez que l'IP est autorisée (si restriction)

### Frontend ne se charge pas

**Cause:** Build manquant ou .htaccess mal configuré
**Solution:**
1. Vérifiez que `/dist` existe et contient les fichiers
2. Vérifiez la règle de réécriture finale dans `.htaccess`
3. Testez en accédant directement à `/dist/index.html`

### CORS errors

**Cause:** Headers CORS mal configurés
**Solution:**
1. Vérifiez `/backend/middleware/cors.php`
2. Vérifiez que le middleware est inclus dans chaque endpoint
3. Testez avec `curl -v` pour voir les headers

### Upload d'images échoue

**Cause:** Permissions du dossier `uploads`
**Solution:**
```bash
chmod 755 uploads/
chown www-data:www-data uploads/  # ou l'utilisateur Apache
```

## 📞 Support et maintenance

### Logs à surveiller

1. **Logs PHP:** Panneau Infomaniak → Logs → PHP
2. **Logs Apache:** Erreurs 500, 404
3. **Logs application:** Erreurs custom logged via `error_log()`

### Maintenance régulière

1. **Backups:**
   - Base de données: Panneau Infomaniak → Backups
   - Fichiers: Backup FTP régulier

2. **Mises à jour:**
   - Dépendances npm: `npm update`
   - Rebuild frontend après updates
   - Redéployer sur serveur

3. **Sécurité:**
   - Changer le secret JWT régulièrement
   - Surveiller les tentatives de connexion
   - Maintenir PHP à jour

### Points de contact

- **Hébergement:** Support Infomaniak
- **Base de données:** phpMyAdmin Infomaniak
- **Paiements:** Dashboard PayPal & Paystack

## ✅ Checklist complète

### Pré-déploiement
- [ ] Code testé localement
- [ ] Build frontend créé
- [ ] Credentials configurés
- [ ] SQL schema préparé

### Déploiement
- [ ] Fichiers uploadés sur Infomaniak
- [ ] Base de données importée
- [ ] Script d'init exécuté
- [ ] Permissions configurées

### Post-déploiement
- [ ] Site accessible
- [ ] Admin peut se connecter
- [ ] Toutes les pages fonctionnent
- [ ] API endpoints testés
- [ ] Paiements configurés
- [ ] Webhooks testés
- [ ] Monitoring activé

### Production
- [ ] Secret JWT changé
- [ ] Mode production activé
- [ ] HTTPS vérifié
- [ ] Backups planifiés
- [ ] Documentation mise à jour

---

## 🎉 Félicitations!

Votre application Nowlover est maintenant entièrement migrée sur votre infrastructure Infomaniak!

**URL de production:** https://arnowconcept.com/
**Email admin:** rikaconcept@gmail.com
**Password:** AdminNow25# (à changer!)

Pour toute question ou problème, consultez les logs et la documentation.
