#!/bin/bash

# Nowlover Deployment Script for Infomaniak
# This script helps prepare the application for deployment

echo "========================================="
echo "  Nowlover - Préparation du déploiement"
echo "========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Erreur: package.json non trouvé"
    echo "Exécutez ce script depuis la racine du projet"
    exit 1
fi

# Step 1: Install dependencies
echo "📦 Installation des dépendances..."
if command -v yarn &> /dev/null; then
    yarn install
else
    npm install
fi

# Step 2: Build frontend
echo ""
echo "🔨 Construction du frontend..."
npm run build

if [ ! -d "dist" ]; then
    echo "❌ Erreur: Le dossier dist n'a pas été créé"
    exit 1
fi

echo "✅ Build frontend créé dans /dist"

# Step 3: Create uploads directory
echo ""
echo "📁 Création du dossier uploads..."
mkdir -p uploads
chmod 755 uploads
echo "✅ Dossier uploads créé avec les permissions appropriées"

# Step 4: Prepare deployment package
echo ""
echo "📦 Préparation du package de déploiement..."

# Create a deployment directory
DEPLOY_DIR="deploy_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$DEPLOY_DIR"

# Copy necessary files
cp -r dist "$DEPLOY_DIR/"
cp -r backend "$DEPLOY_DIR/"
cp -r sql "$DEPLOY_DIR/"
cp -r uploads "$DEPLOY_DIR/"
cp .htaccess "$DEPLOY_DIR/"
cp INSTALL.md "$DEPLOY_DIR/"

echo "✅ Package de déploiement créé dans: $DEPLOY_DIR"

# Step 5: Create archive
echo ""
echo "🗜️  Création de l'archive..."
tar -czf "${DEPLOY_DIR}.tar.gz" "$DEPLOY_DIR"

echo "✅ Archive créée: ${DEPLOY_DIR}.tar.gz"

# Step 6: Display instructions
echo ""
echo "========================================="
echo "  Étapes suivantes:"
echo "========================================="
echo ""
echo "1. Uploadez l'archive ${DEPLOY_DIR}.tar.gz sur Infomaniak via FTP/SFTP"
echo ""
echo "2. Connectez-vous en SSH et décompressez:"
echo "   tar -xzf ${DEPLOY_DIR}.tar.gz"
echo "   mv ${DEPLOY_DIR}/* ."
echo ""
echo "3. Importez le schéma SQL dans phpMyAdmin:"
echo "   - Fichier: sql/schema.sql"
echo ""
echo "4. Initialisez la base de données:"
echo "   php scripts/init-database.php"
echo ""
echo "5. Configurez les permissions:"
echo "   chmod 755 uploads/"
echo "   chmod 644 .htaccess"
echo ""
echo "6. Testez l'application:"
echo "   https://arnowconcept.com/"
echo ""
echo "========================================="
echo "  Credentials Admin:"
echo "========================================="
echo "Email: rikaconcept@gmail.com"
echo "Password: AdminNow25#"
echo ""

# Optional: Display file sizes
echo "========================================="
echo "  Tailles des fichiers:"
echo "========================================="
du -sh "$DEPLOY_DIR"
du -sh "${DEPLOY_DIR}.tar.gz"
echo ""

echo "✅ Déploiement préparé avec succès!"
