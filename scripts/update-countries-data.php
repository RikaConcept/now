#!/usr/bin/env php
<?php
/**
 * Script 2: Mettre à jour les données des pays existants
 * Exécutez après add-country-columns.php
 */

require_once __DIR__ . '/../backend/config/database.php';

echo "<h1>Mise à jour des données pays</h1><pre>\n";

try {
    $db = Database::getInstance();
    
    echo "=== Mise à jour des indicatifs et formats téléphoniques ===\n\n";
    
    $countriesData = [
        'FR' => ['+33', '+33 6 XX XX XX XX', 'EUR'],
        'BE' => ['+32', '+32 4XX XX XX XX', 'EUR'],
        'CH' => ['+41', '+41 XX XXX XX XX', 'CHF'],
        'CA' => ['+1', '+1 XXX XXX XXXX', 'CAD'],
        'CI' => ['+225', '+225 XX XX XX XX XX', 'XOF'],
        'CM' => ['+237', '+237 6 XX XX XX XX', 'XAF'],
        'SN' => ['+221', '+221 XX XXX XX XX', 'XOF'],
        'BJ' => ['+229', '+229 XX XX XX XX', 'XOF'],
        'TG' => ['+228', '+228 XX XX XX XX', 'XOF'],
        'BF' => ['+226', '+226 XX XX XX XX', 'XOF'],
        'ML' => ['+223', '+223 XX XX XX XX', 'XOF'],
        'GA' => ['+241', '+241 X XX XX XX', 'XAF'],
        'CD' => ['+243', '+243 XX XXX XXXX', 'CDF'],
        'MA' => ['+212', '+212 6XX XX XX XX', 'MAD'],
        'NG' => ['+234', '+234 XXX XXX XXXX', 'NGN'],
        'GH' => ['+233', '+233 XX XXX XXXX', 'GHS'],
        'DE' => ['+49', '+49 XXX XXXXXXX', 'EUR'],
        'LU' => ['+352', '+352 XXX XXX', 'EUR'],
        'ES' => ['+34', '+34 XXX XX XX XX', 'EUR'],
        'IT' => ['+39', '+39 XXX XXX XXXX', 'EUR'],
        'PT' => ['+351', '+351 XXX XXX XXX', 'EUR'],
        'GB' => ['+44', '+44 XXXX XXXXXX', 'GBP'],
        'ZA' => ['+27', '+27 XX XXX XXXX', 'ZAR'],
        'EG' => ['+20', '+20 XXX XXX XXXX', 'EGP'],
    ];
    
    foreach ($countriesData as $code => [$prefix, $format, $currency]) {
        $db->query(
            "UPDATE countries SET phone_prefix = ?, phone_format = ?, currency_code = ? WHERE code = ?",
            [$prefix, $format, $currency, $code]
        );
        echo "✓ Mis à jour: $code → $prefix / $currency\n";
    }
    
    echo "\n✅ Tous les pays ont été mis à jour!\n";
    echo "\nProchaine étape: Exécutez insert-countries.php pour ajouter toutes les localités\n";
    
} catch (Exception $e) {
    echo "✗ Erreur: " . $e->getMessage() . "\n";
    exit(1);
}

echo "</pre>";
