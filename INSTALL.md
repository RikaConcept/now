# Nowlover - Guide d'installation sur Infomaniak

## 📋 Prérequis

- Hébergement mutualisé Infomaniak avec PHP 7.4+ et MySQL
- Accès FTP ou SSH
- Base de données MySQL configurée

## 🚀 Installation

### Étape 1: Configuration de la base de données

1. Connectez-vous à phpMyAdmin depuis votre panel Infomaniak
2. Sélectionnez votre base de données: `pz3qp7_arnowc1225`
3. Importez le fichier `/sql/schema.sql`
4. Vérifiez que toutes les tables ont été créées

### Étape 2: Initialisation des données

Exécutez le script d'initialisation pour créer l'utilisateur admin:

```bash
php scripts/init-database.php
```

Ceci créera:
- Utilisateur admin: rikaconcept@gmail.com / AdminNow25#
- Niveaux d'adhésion (Bronze, Silver, Gold, Platinum)
- Localités par défaut
- Boutiques partenaires
- Produits de démarrage

### Étape 3: Construction du frontend

```bash
cd frontend
npm install  # ou yarn install
npm run build  # ou yarn build
```

Le build sera créé dans `/dist`

### Étape 4: Déploiement sur Infomaniak

Structure des fichiers sur le serveur:

```
/public_html/  (ou votre dossier racine)
├── .htaccess
├── backend/
│   ├── api/
│   ├── config/
│   ├── middleware/
│   ├── models/
│   └── utils/
├── dist/  (build React)
├── uploads/  (créer ce dossier, chmod 755)
└── sql/
```

**Important:** 
- Assurez-vous que le dossier `uploads/` existe et a les permissions d'écriture (755 ou 775)
- Le fichier `.htaccess` doit être à la racine

### Étape 5: Configuration des permissions

```bash
chmod 755 uploads/
chmod 644 .htaccess
chmod 644 backend/config/*.php
```

## 🔐 Identifiants par défaut

**Admin:**
- Email: rikaconcept@gmail.com
- Mot de passe: AdminNow25#

**Base de données:**
- Host: pz3qp7.myd.infomaniak.com
- Database: pz3qp7_arnowc1225
- User: pz3qp7_arnowcu
- Port: 3306

## 🌐 URLs de l'API

Une fois déployé sur https://arnowconcept.com/, les endpoints seront:

- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion
- `GET /api/auth/user` - Info utilisateur
- `GET /api/members` - Info membre
- `GET /api/products` - Liste produits
- `GET /api/orders` - Commandes
- `GET /api/localities` - Localités
- `GET /api/membership-levels` - Niveaux d'adhésion
- `GET /api/partner-shops` - Boutiques partenaires
- `POST /api/product-requests` - Demandes de produits
- `GET /api/admin/stats` - Statistiques admin (authentifié)

## 💳 Configuration des paiements

### PayPal

Les credentials sont déjà configurés dans le code:
- Sandbox: Mode test activé
- Live: Sera activé après fourniture du SECRET

### Paystack

Les credentials sont configurés:
- Sandbox & Live disponibles

## 🔧 Dépannage

### Erreur de connexion à la base de données

Vérifiez les credentials dans `/backend/config/database.php`

### Erreur 500 sur les routes API

1. Vérifiez les logs PHP d'Infomaniak
2. Assurez-vous que `.htaccess` est bien configuré
3. Vérifiez les permissions des fichiers

### Frontend ne charge pas

1. Vérifiez que le build existe dans `/dist`
2. Vérifiez les règles de réécriture dans `.htaccess`
3. Assurez-vous que l'URL de l'API est correcte dans le build

## 📱 Test de l'installation

1. Accédez à https://arnowconcept.com/
2. Créez un compte ou connectez-vous avec les identifiants admin
3. Testez la création d'une demande de produit
4. Vérifiez le dashboard admin

## 🔄 Mises à jour

Pour mettre à jour l'application:

1. Sauvegardez la base de données
2. Uploadez les nouveaux fichiers backend
3. Rebuilder et déployer le frontend
4. Testez toutes les fonctionnalités

## 📞 Support

En cas de problème, vérifiez:
- Les logs PHP dans le panel Infomaniak
- Les erreurs dans la console du navigateur
- La connexion à la base de données

## 🔒 Sécurité

**Important après installation:**

1. Changez le secret JWT dans `/backend/config/jwt.php`
2. Changez le mot de passe admin
3. Activez HTTPS (normalement déjà fait par Infomaniak)
4. Limitez les permissions des dossiers sensibles

## ✅ Checklist post-installation

- [ ] Base de données importée et initialisée
- [ ] Admin peut se connecter
- [ ] Frontend s'affiche correctement
- [ ] API répond sur tous les endpoints
- [ ] Upload de fichiers fonctionne
- [ ] Paiements configurés
- [ ] HTTPS activé
- [ ] Logs d'erreur consultés

Votre application Nowlover est maintenant prête à l'emploi ! 🎉
