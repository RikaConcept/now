# Backend API PHP

API REST complète pour l'application Nowlover.

## Structure

```
backend/
├── api/              # Endpoints API
├── config/           # Configuration (DB, JWT)
├── middleware/       # Auth, CORS
├── models/           # Modèles de données
└── utils/            # Utilitaires (JWT, Response, UUID)
```

## Configuration

Les credentials de la base de données sont dans `/config/database.php`.

**⚠️ Important:** Changez le secret JWT dans `/config/jwt.php` en production!

## Endpoints

Voir la documentation complète dans `/MIGRATION_GUIDE.md`

### Authentification
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/user`

### Membres
- `GET /api/members`
- `PUT /api/members`

### Produits
- `GET /api/products`
- `POST /api/products` (admin)
- `PUT /api/products` (admin)
- `DELETE /api/products` (admin)

### Et bien plus...

## Sécurité

- JWT pour l'authentification
- PDO prepared statements (protection SQL injection)
- CORS configuré
- Validation des entrées
