-- Nowlover MySQL Database Schema
-- Migration from Supabase PostgreSQL to MySQL for Infomaniak

-- Set charset and collation
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Drop tables if they exist (for clean installation)
DROP TABLE IF EXISTS product_requests;
DROP TABLE IF EXISTS referrals;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS admin_users;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS membership_levels;
DROP TABLE IF EXISTS partner_shops;
DROP TABLE IF EXISTS localities;
DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS site_settings;
DROP TABLE IF EXISTS users;

-- Users table (replaces auth.users from Supabase)
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Countries table
CREATE TABLE countries (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE,
    flag_emoji VARCHAR(10),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Localities table
CREATE TABLE localities (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    code_prefix VARCHAR(10) NOT NULL UNIQUE,
    member_count INT DEFAULT 0,
    country_id VARCHAR(36),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE SET NULL,
    INDEX idx_code_prefix (code_prefix),
    INDEX idx_country (country_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Membership levels table
CREATE TABLE membership_levels (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    minimum_purchases DECIMAL(10,2) DEFAULT 0,
    discount_percentage DECIMAL(5,2) DEFAULT 0,
    benefits JSON,
    `order` INT NOT NULL,
    is_active TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_order (`order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Members table
CREATE TABLE members (
    id VARCHAR(36) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    locality_id VARCHAR(36),
    code VARCHAR(50) NOT NULL UNIQUE,
    status ENUM('pending', 'active', 'inactive') DEFAULT 'pending',
    membership_level_id VARCHAR(36),
    total_spent DECIMAL(10,2) DEFAULT 0,
    referral_code VARCHAR(50) UNIQUE,
    referred_by VARCHAR(36),
    activated_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (locality_id) REFERENCES localities(id) ON DELETE SET NULL,
    FOREIGN KEY (membership_level_id) REFERENCES membership_levels(id) ON DELETE SET NULL,
    FOREIGN KEY (referred_by) REFERENCES members(id) ON DELETE SET NULL,
    INDEX idx_locality (locality_id),
    INDEX idx_status (status),
    INDEX idx_code (code),
    INDEX idx_referral_code (referral_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Partner shops table
CREATE TABLE partner_shops (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT,
    discount_percentage DECIMAL(5,2) DEFAULT 0,
    address TEXT,
    is_active TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Products table
CREATE TABLE products (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image_url TEXT,
    category VARCHAR(100) NOT NULL,
    stock INT DEFAULT 0,
    is_active TINYINT(1) DEFAULT 1,
    purchase_link TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Orders table
CREATE TABLE orders (
    id VARCHAR(36) PRIMARY KEY,
    member_id VARCHAR(36) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'paid', 'cancelled') DEFAULT 'pending',
    payment_method VARCHAR(50),
    payment_provider VARCHAR(50),
    payment_id VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    paid_at DATETIME,
    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE,
    INDEX idx_member (member_id),
    INDEX idx_status (status),
    INDEX idx_payment_id (payment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Referrals table
CREATE TABLE referrals (
    id VARCHAR(36) PRIMARY KEY,
    referrer_id VARCHAR(36) NOT NULL,
    referred_id VARCHAR(36) NOT NULL,
    referral_code VARCHAR(50) NOT NULL,
    bonus_amount DECIMAL(10,2) DEFAULT 0,
    status ENUM('pending', 'completed') DEFAULT 'pending',
    referred_member_level VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    completed_at DATETIME,
    FOREIGN KEY (referrer_id) REFERENCES members(id) ON DELETE CASCADE,
    FOREIGN KEY (referred_id) REFERENCES members(id) ON DELETE CASCADE,
    INDEX idx_referrer (referrer_id),
    INDEX idx_referred (referred_id),
    INDEX idx_code (referral_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Admin users table
CREATE TABLE admin_users (
    user_id VARCHAR(36) PRIMARY KEY,
    role ENUM('admin', 'moderator') DEFAULT 'moderator',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Product requests table
CREATE TABLE product_requests (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36),
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    product_name VARCHAR(255) NOT NULL,
    best_price_found DECIMAL(10,2) NOT NULL,
    price_source TEXT NOT NULL,
    user_budget DECIMAL(10,2) NOT NULL,
    is_member TINYINT(1) DEFAULT 0,
    status ENUM('pending', 'processing', 'completed', 'cancelled') DEFAULT 'pending',
    margin_donation DECIMAL(10,2),
    image_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Site settings table
CREATE TABLE site_settings (
    id VARCHAR(36) PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT,
    setting_type VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_key (setting_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default membership levels
INSERT INTO membership_levels (id, name, minimum_purchases, discount_percentage, benefits, `order`, is_active) VALUES
(UUID(), 'Bronze', 0, 5, '["Bienvenue dans la communauté", "Accès au catalogue", "Demandes de produits sans commission"]', 1, 1),
(UUID(), 'Silver', 100, 10, '["Tous les avantages Bronze", "Réductions 10% sur les boutiques", "Priorité support client"]', 2, 1),
(UUID(), 'Gold', 500, 15, '["Tous les avantages Silver", "Réductions 15% sur les boutiques", "Accès aux ventes privées", "Bonus de parrainage +5%"]', 3, 1),
(UUID(), 'Platinum', 2000, 20, '["Tous les avantages Gold", "Réductions 20% sur les boutiques", "Conseiller personnel", "Bonus de parrainage +10%", "Livraison gratuite"]', 4, 1);

-- Insert default localities
INSERT INTO localities (id, name, code_prefix, member_count) VALUES
(UUID(), 'Paris', 'PAR', 0),
(UUID(), 'Lyon', 'LYO', 0),
(UUID(), 'Marseille', 'MAR', 0),
(UUID(), 'Toulouse', 'TOU', 0),
(UUID(), 'Nice', 'NIC', 0),
(UUID(), 'Bordeaux', 'BOR', 0),
(UUID(), 'Lille', 'LIL', 0),
(UUID(), 'Nantes', 'NAN', 0);

-- Insert default partner shops
INSERT INTO partner_shops (id, name, category, description, discount_percentage, address, is_active) VALUES
(UUID(), 'Mode Express', 'Mode', 'Vêtements et accessoires tendance', 15.00, '123 Rue de la Mode, Paris', 1),
(UUID(), 'TechStore', 'Électronique', 'Appareils électroniques et gadgets', 10.00, '45 Avenue Tech, Lyon', 1),
(UUID(), 'Bio Market', 'Alimentation', 'Produits bio et naturels', 12.00, '78 Bd Santé, Marseille', 1),
(UUID(), 'Sport Plus', 'Sport', 'Équipements sportifs', 20.00, '32 Rue Athlète, Toulouse', 1),
(UUID(), 'Maison Déco', 'Décoration', 'Décoration intérieure', 18.00, '56 Avenue Style, Nice', 1);

-- Insert default products
INSERT INTO products (id, name, description, price, category, stock, is_active) VALUES
(UUID(), 'Pack Découverte Premium', 'Sélection de produits premium pour débuter', 50.00, 'Packs', 100, 1),
(UUID(), 'Pack Expérience', 'Collection exclusive de marques partenaires', 100.00, 'Packs', 50, 1),
(UUID(), 'Pack VIP Platinum', 'Expérience complète avec tous les avantages', 200.00, 'Packs', 25, 1);

-- Create initial admin user (email: rikaconcept@gmail.com, password: AdminNow25#)
-- Password hash for AdminNow25#
SET @admin_id = UUID();
SET @admin_email = 'rikaconcept@gmail.com';
SET @admin_password = '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'; -- This will be replaced by actual hash

INSERT INTO users (id, email, password) VALUES (@admin_id, @admin_email, @admin_password);

-- Create member record for admin
INSERT INTO members (id, email, code, status, activated_at) 
VALUES (@admin_id, @admin_email, 'ADMIN001', 'active', NOW());

-- Set as admin
INSERT INTO admin_users (user_id, role) VALUES (@admin_id, 'admin');
