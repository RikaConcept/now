# Scripts SQL

Ce dossier contient les scripts SQL pour initialiser la base de données MySQL.

## Fichiers

### `schema.sql`

Schéma complet de la base de données Nowlover:

- **11 tables** migrées de PostgreSQL vers MySQL
- **Données initiales:**
  - 4 niveaux d'adhésion (Bronze, Silver, Gold, Platinum)
  - 8 localités françaises
  - 5 boutiques partenaires
  - 3 produits de démarrage

## Installation

### Méthode 1: Via phpMyAdmin

1. Connectez-vous à phpMyAdmin (panel Infomaniak)
2. Sélectionnez votre base de données
3. Onglet "Importer"
4. Choisir `schema.sql`
5. Exécuter

### Méthode 2: Via MySQL CLI

```bash
mysql -h pz3qp7.myd.infomaniak.com \
      -u pz3qp7_arnowcu \
      -p \
      pz3qp7_arnowc1225 < schema.sql
```

## Après l'import

Exécutez le script d'initialisation:

```bash
php scripts/init-database.php
```

Ceci créera l'utilisateur admin avec les credentials:
- Email: `rikaconcept@gmail.com`
- Password: `AdminNow25#`
