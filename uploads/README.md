# Dossier Uploads

Ce dossier stocke les fichiers uploadés par les utilisateurs (images de produits, logos, etc.).

## Configuration

Sur le serveur Infomaniak, assurez-vous que ce dossier a les permissions appropriées:

```bash
chmod 755 uploads/
chown www-data:www-data uploads/  # ou l'utilisateur Apache
```

## Structure

Les fichiers sont nommés avec des UUID pour éviter les conflits:
- `{uuid}.jpg` - Images produits
- `{uuid}.png` - Logos partenaires
- etc.

## Sécurité

- Taille max: 5 MB par fichier
- Types acceptés: images uniquement (jpg, png, gif, webp)
- Validation dans `/backend/api/upload.php`
