#!/usr/bin/env php
<?php

/**
 * Database initialization script
 * This script will:
 * 1. Test database connection
 * 2. Create the admin user with the provided credentials
 */

require_once __DIR__ . '/../backend/config/database.php';
require_once __DIR__ . '/../backend/utils/UUID.php';

echo "=== Nowlover Database Initialization ===\n\n";

try {
    // Test database connection
    echo "Testing database connection...\n";
    $db = Database::getInstance();
    echo "✓ Database connection successful!\n\n";
    
    // Create admin user
    echo "Creating admin user...\n";
    
    $adminEmail = 'rikaconcept@gmail.com';
    $adminPassword = 'AdminNow25#';
    $hashedPassword = password_hash($adminPassword, PASSWORD_BCRYPT);
    $adminId = UUID::v4();
    
    // Check if admin already exists
    $stmt = $db->query("SELECT id FROM users WHERE email = ?", [$adminEmail]);
    $existingUser = $stmt->fetch();
    
    if ($existingUser) {
        echo "Admin user already exists with ID: {$existingUser['id']}\n";
        $adminId = $existingUser['id'];
        
        // Update password in case it changed
        $db->query(
            "UPDATE users SET password = ? WHERE id = ?",
            [$hashedPassword, $adminId]
        );
        echo "✓ Admin password updated\n";
    } else {
        // Create user
        $db->query(
            "INSERT INTO users (id, email, password, created_at) VALUES (?, ?, ?, NOW())",
            [$adminId, $adminEmail, $hashedPassword]
        );
        echo "✓ Admin user created: $adminEmail\n";
        
        // Get Bronze level ID
        $stmt = $db->query("SELECT id FROM membership_levels WHERE name = 'Bronze' LIMIT 1");
        $bronzeLevel = $stmt->fetch();
        $levelId = $bronzeLevel ? $bronzeLevel['id'] : null;
        
        // Create member record
        $referralCode = strtoupper(substr(md5($adminId . time()), 0, 8));
        $db->query(
            "INSERT INTO members (id, email, code, status, membership_level_id, referral_code, activated_at, created_at, updated_at) 
             VALUES (?, ?, ?, 'active', ?, ?, NOW(), NOW(), NOW())",
            [$adminId, $adminEmail, 'ADMIN001', $levelId, $referralCode]
        );
        echo "✓ Admin member record created with code: ADMIN001\n";
        
        // Set as admin
        $db->query(
            "INSERT INTO admin_users (user_id, role, created_at) VALUES (?, 'admin', NOW())",
            [$adminId]
        );
        echo "✓ Admin privileges granted\n\n";
    }
    
    // Display statistics
    echo "=== Database Statistics ===\n";
    
    $stmt = $db->query("SELECT COUNT(*) as count FROM users");
    echo "Users: " . $stmt->fetch()['count'] . "\n";
    
    $stmt = $db->query("SELECT COUNT(*) as count FROM members");
    echo "Members: " . $stmt->fetch()['count'] . "\n";
    
    $stmt = $db->query("SELECT COUNT(*) as count FROM products");
    echo "Products: " . $stmt->fetch()['count'] . "\n";
    
    $stmt = $db->query("SELECT COUNT(*) as count FROM partner_shops");
    echo "Partner Shops: " . $stmt->fetch()['count'] . "\n";
    
    $stmt = $db->query("SELECT COUNT(*) as count FROM localities");
    echo "Localities: " . $stmt->fetch()['count'] . "\n";
    
    $stmt = $db->query("SELECT COUNT(*) as count FROM membership_levels");
    echo "Membership Levels: " . $stmt->fetch()['count'] . "\n\n";
    
    echo "=== Admin Credentials ===\n";
    echo "Email: $adminEmail\n";
    echo "Password: $adminPassword\n\n";
    
    echo "✓ Database initialization complete!\n";
    
} catch (Exception $e) {
    echo "✗ Error: " . $e->getMessage() . "\n";
    exit(1);
}
