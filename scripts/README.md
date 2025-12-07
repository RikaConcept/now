# Scripts Utilitaires

## Fichiers disponibles

### `init-database.php`

Script d'initialisation de la base de données.

**Usage:**
```bash
php scripts/init-database.php
```

**Ce qu'il fait:**
- Teste la connexion MySQL
- Crée l'utilisateur admin
- Crée le membre admin
- Assigne les privilèges admin
- Affiche les statistiques

### `deploy.sh`

Script de déploiement automatique.

**Usage:**
```bash
./scripts/deploy.sh
```

**Ce qu'il fait:**
- Installe les dépendances npm
- Build le frontend
- Crée le dossier uploads
- Prépare un package de déploiement
- Crée une archive `.tar.gz`
- Affiche les instructions

### `test-api.sh`

Script de tests automatisés de l'API.

**Usage:**
```bash
./scripts/test-api.sh
```

**Ce qu'il fait:**
- Teste tous les endpoints publics
- Teste l'authentification
- Teste les endpoints authentifiés
- Teste les endpoints admin
- Affiche un rapport complet

## Permissions

Assurez-vous que les scripts sont exécutables:

```bash
chmod +x scripts/*.sh
chmod +x scripts/*.php
```
