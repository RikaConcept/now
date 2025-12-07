#!/bin/bash

# Script de vérification avant push GitHub
# Vérifie que tous les fichiers nécessaires sont présents

echo "==========================================="
echo "  Vérification du projet Nowlover"
echo "==========================================="
echo ""

ERRORS=0
WARNINGS=0

# Fonction de vérification
check_file() {
    local file=$1
    local description=$2
    
    if [ -f "$file" ]; then
        echo "✅ $description"
    else
        echo "❌ MANQUANT: $description ($file)"
        ((ERRORS++))
    fi
}

check_dir() {
    local dir=$1
    local description=$2
    
    if [ -d "$dir" ]; then
        echo "✅ $description"
    else
        echo "❌ MANQUANT: $description ($dir)"
        ((ERRORS++))
    fi
}

check_dir_not_empty() {
    local dir=$1
    local description=$2
    local min_files=${3:-1}
    
    if [ -d "$dir" ]; then
        local count=$(find "$dir" -type f | wc -l)
        if [ $count -ge $min_files ]; then
            echo "✅ $description ($count fichiers)"
        else
            echo "⚠️  VIDE: $description ($dir)"
            ((WARNINGS++))
        fi
    else
        echo "❌ MANQUANT: $description ($dir)"
        ((ERRORS++))
    fi
}

echo "1. Configuration de base"
echo "------------------------"
check_file ".htaccess" "Configuration Apache"
check_file "package.json" "Package npm"
check_file ".gitignore" "Git ignore"
check_file "README.md" "Documentation principale"
echo ""

echo "2. Backend PHP"
echo "--------------"
check_dir "backend" "Dossier backend"
check_dir "backend/api" "API endpoints"
check_dir "backend/config" "Configuration"
check_dir "backend/middleware" "Middleware"
check_dir "backend/models" "Modèles"
check_dir "backend/utils" "Utilitaires"
check_dir_not_empty "backend/api" "API endpoints" 10
echo ""

echo "3. Frontend React"
echo "-----------------"
check_dir "src" "Code source React"
check_dir "src/pages" "Pages React"
check_dir "src/components" "Composants React"
check_dir "src/contexts" "Contexts React"
check_dir "src/lib" "Bibliothèques"
check_file "src/lib/api.ts" "Service API"
check_file "src/contexts/AuthContext.tsx" "Auth Context"
check_file "src/App.tsx" "Application principale"
check_file "src/main.tsx" "Point d'entrée"
echo ""

echo "4. Base de données"
echo "------------------"
check_dir "sql" "Dossier SQL"
check_file "sql/schema.sql" "Schéma MySQL"
echo ""

echo "5. Scripts"
echo "----------"
check_dir "scripts" "Dossier scripts"
check_file "scripts/init-database.php" "Script initialisation BDD"
check_file "scripts/deploy.sh" "Script déploiement"
check_file "scripts/test-api.sh" "Script tests API"
echo ""

echo "6. Uploads"
echo "----------"
check_dir "uploads" "Dossier uploads"
check_file "uploads/.gitkeep" "GitKeep pour uploads"
echo ""

echo "7. Documentation"
echo "----------------"
check_file "README.md" "README général"
check_file "INSTALL.md" "Guide installation"
check_file "MIGRATION_GUIDE.md" "Guide migration"
check_file "DEPLOYMENT_READY.md" "Checklist déploiement"
check_file "GITHUB_GUIDE.md" "Guide GitHub"
check_file "PROJECT_STRUCTURE.md" "Structure projet"
echo ""

echo "8. Endpoints API essentiels"
echo "---------------------------"
check_file "backend/api/auth.php" "Authentification"
check_file "backend/api/members.php" "Membres"
check_file "backend/api/products.php" "Produits"
check_file "backend/api/orders.php" "Commandes"
check_file "backend/api/admin.php" "Admin"
check_file "backend/api/checkout/paypal.php" "Checkout PayPal"
check_file "backend/api/checkout/paystack.php" "Checkout Paystack"
echo ""

echo "9. Configuration et modèles"
echo "---------------------------"
check_file "backend/config/database.php" "Config database"
check_file "backend/config/jwt.php" "Config JWT"
check_file "backend/models/User.php" "Modèle User"
check_file "backend/models/Member.php" "Modèle Member"
check_file "backend/models/Product.php" "Modèle Product"
check_file "backend/models/Order.php" "Modèle Order"
echo ""

echo "10. Pages React critiques"
echo "-------------------------"
check_file "src/pages/Dashboard.tsx" "Dashboard utilisateur"
check_file "src/pages/AdminDashboard.tsx" "Dashboard admin"
check_file "src/pages/Catalog.tsx" "Catalogue produits"
check_file "src/pages/Cart.tsx" "Panier"
check_file "src/pages/ProductRequest.tsx" "Demande produit"
echo ""

echo "==========================================="
echo "  Résumé"
echo "==========================================="
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ PARFAIT! Tous les fichiers sont présents."
    echo ""
    echo "Votre projet est prêt à être poussé sur GitHub!"
    echo ""
    echo "Prochaines étapes:"
    echo "1. git add ."
    echo "2. git commit -m \"Migration Supabase vers MySQL/Infomaniak\""
    echo "3. git push origin main"
    echo ""
    echo "Ou utilisez 'Save to GitHub' dans Emergent."
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "⚠️  Vérification réussie avec $WARNINGS avertissement(s)."
    echo ""
    echo "Votre projet est prêt, mais certains dossiers sont vides."
    echo "C'est normal pour uploads/ (sera rempli en production)."
    exit 0
else
    echo "❌ $ERRORS erreur(s) détectée(s)!"
    echo ""
    echo "Veuillez corriger les fichiers manquants avant de continuer."
    exit 1
fi
