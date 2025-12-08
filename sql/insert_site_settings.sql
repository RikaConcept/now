-- Insertion des paramètres du site par défaut
-- À exécuter après l'import du schema.sql

-- Supprimer les anciennes données si elles existent
DELETE FROM site_settings;

-- Insérer les paramètres par défaut
INSERT INTO site_settings (id, setting_key, setting_value, setting_type, created_at, updated_at) VALUES
(UUID(), 'app_name', 'NOW!Lovers', 'text', NOW(), NOW()),
(UUID(), 'logo_url', '', 'text', NOW(), NOW()),
(UUID(), 'primary_color', '#2563eb', 'color', NOW(), NOW()),
(UUID(), 'secondary_color', '#4f46e5', 'color', NOW(), NOW()),
(UUID(), 'accent_color', '#fbbf24', 'color', NOW(), NOW()),
(UUID(), 'hero_title', 'Rejoignez NOW!Lovers et profitez d\'avantages exclusifs', 'text', NOW(), NOW()),
(UUID(), 'hero_description', 'Découvrez une communauté de membres bénéficiant de réductions exceptionnelles chez nos partenaires de confiance', 'text', NOW(), NOW()),
(UUID(), 'why_choose_title', 'Pourquoi rejoindre NOW!Lovers ?', 'text', NOW(), NOW()),
(UUID(), 'why_choose_description', 'Des avantages exclusifs, une communauté engagée et des partenaires de qualité', 'text', NOW(), NOW()),
(UUID(), 'feature_1_title', 'Réductions Exclusives', 'text', NOW(), NOW()),
(UUID(), 'feature_1_description', 'Bénéficiez de réductions allant jusqu\'à 20% chez tous nos partenaires', 'text', NOW(), NOW()),
(UUID(), 'feature_1_icon', 'Tag', 'text', NOW(), NOW()),
(UUID(), 'feature_2_title', 'Communauté Active', 'text', NOW(), NOW()),
(UUID(), 'feature_2_description', 'Rejoignez une communauté de membres actifs et partagez vos expériences', 'text', NOW(), NOW()),
(UUID(), 'feature_2_icon', 'Users', 'text', NOW(), NOW()),
(UUID(), 'feature_3_title', 'Service Personnalisé', 'text', NOW(), NOW()),
(UUID(), 'feature_3_description', 'Bénéficiez d\'un service client dédié et de demandes de produits sans commission', 'text', NOW(), NOW()),
(UUID(), 'feature_3_icon', 'Award', 'text', NOW(), NOW()),
(UUID(), 'stats_members', '1,000+', 'text', NOW(), NOW()),
(UUID(), 'stats_partners', '50+', 'text', NOW(), NOW()),
(UUID(), 'stats_satisfaction', '4.8/5', 'text', NOW(), NOW()),
(UUID(), 'contact_title', 'Contactez-nous', 'text', NOW(), NOW()),
(UUID(), 'contact_description', 'Notre équipe est à votre écoute pour répondre à toutes vos questions', 'text', NOW(), NOW()),
(UUID(), 'contact_address', '123 Rue de la République\n75001 Paris, France', 'text', NOW(), NOW()),
(UUID(), 'contact_phone', '+33 1 23 45 67 89', 'text', NOW(), NOW()),
(UUID(), 'contact_hours', 'Lun-Ven: 9h-18h', 'text', NOW(), NOW()),
(UUID(), 'contact_email', 'contact@nowlovers.com', 'text', NOW(), NOW()),
(UUID(), 'contact_support_email', 'support@nowlovers.com', 'text', NOW(), NOW()),
(UUID(), 'footer_description', 'NOW!Lovers - La communauté qui partage les bonnes affaires et les avantages exclusifs.', 'text', NOW(), NOW()),
(UUID(), 'footer_copyright', '© 2025 NOW!Lovers. Tous droits réservés.', 'text', NOW(), NOW()),
(UUID(), 'social_facebook', '', 'text', NOW(), NOW()),
(UUID(), 'social_twitter', '', 'text', NOW(), NOW()),
(UUID(), 'social_instagram', '', 'text', NOW(), NOW()),
(UUID(), 'social_linkedin', '', 'text', NOW(), NOW());
