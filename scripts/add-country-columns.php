#!/usr/bin/env php
<?php
/**
 * Script 1: Ajouter les colonnes manquantes à la table countries
 * Exécutez ce script avant insert-countries.php
 */

require_once __DIR__ . '/../backend/config/database.php';

echo "<h1>Mise à jour de la table countries</h1><pre>\n";

try {
    $db = Database::getInstance();
    
    echo "=== Ajout des colonnes manquantes ===\n\n";
    
    // Vérifier si les colonnes existent déjà
    $stmt = $db->query("SHOW COLUMNS FROM countries LIKE 'phone_prefix'");
    $exists = $stmt->fetch();
    
    if (!$exists) {
        echo "Ajout de la colonne phone_prefix...\n";
        $db->query("ALTER TABLE countries ADD COLUMN phone_prefix VARCHAR(10) AFTER flag_emoji");
        echo "✓ Colonne phone_prefix ajoutée\n";
    } else {
        echo "✓ Colonne phone_prefix existe déjà\n";
    }
    
    $stmt = $db->query("SHOW COLUMNS FROM countries LIKE 'phone_format'");
    $exists = $stmt->fetch();
    
    if (!$exists) {
        echo "Ajout de la colonne phone_format...\n";
        $db->query("ALTER TABLE countries ADD COLUMN phone_format VARCHAR(50) AFTER phone_prefix");
        echo "✓ Colonne phone_format ajoutée\n";
    } else {
        echo "✓ Colonne phone_format existe déjà\n";
    }
    
    $stmt = $db->query("SHOW COLUMNS FROM countries LIKE 'currency_code'");
    $exists = $stmt->fetch();
    
    if (!$exists) {
        echo "Ajout de la colonne currency_code...\n";
        $db->query("ALTER TABLE countries ADD COLUMN currency_code VARCHAR(10) AFTER phone_format");
        echo "✓ Colonne currency_code ajoutée\n";
    } else {
        echo "✓ Colonne currency_code existe déjà\n";
    }
    
    echo "\n✅ Mise à jour terminée!\n";
    echo "\nProchaine étape: Exécutez update-countries-data.php\n";
    
} catch (Exception $e) {
    echo "✗ Erreur: " . $e->getMessage() . "\n";
    exit(1);
}

echo "</pre>";
