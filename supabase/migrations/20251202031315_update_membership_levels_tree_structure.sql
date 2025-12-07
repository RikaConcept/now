/*
  # Update Membership Levels to Tree Structure

  1. Changes
    - Replace generic levels (Bronze, Silver, Gold, Platinum) with tree-themed levels
    - New structure: RACINE (Root), TRONC (Trunk), BRANCHES (Branches), FEUILLES (Leaves), POLLEN (Pollen)
    - Update minimum purchases and benefits to reflect tree growth metaphor
  
  2. Tree Level Details
    - RACINE (0€): Foundation level, starting point
    - TRONC (100€): Growing stronger, building core
    - BRANCHES (500€): Expanding reach and benefits
    - FEUILLES (1500€): Flourishing with maximum benefits
    - POLLEN (3000€): Elite level, spreading value to others
  
  3. Benefits
    - Each level builds on previous level benefits
    - Higher levels unlock referral bonuses and exclusive perks
*/

-- Clear existing membership levels
DELETE FROM membership_levels;

-- Insert tree-structured membership levels
INSERT INTO membership_levels (name, minimum_purchases, discount_percentage, benefits, "order", is_active) VALUES
  ('RACINE', 0, 5, '["Bienvenue dans la communauté NOW!Lovers", "Accès au catalogue complet", "Demandes de produits sans commission", "Code parrain personnel"]'::jsonb, 1, true),
  ('TRONC', 100, 10, '["Tous les avantages RACINE", "Réduction 10% chez nos partenaires", "Support client prioritaire", "Newsletter exclusive"]'::jsonb, 2, true),
  ('BRANCHES', 500, 15, '["Tous les avantages TRONC", "Réduction 15% chez nos partenaires", "Accès ventes privées", "Bonus parrainage +5%", "Invitations événements exclusifs"]'::jsonb, 3, true),
  ('FEUILLES', 1500, 20, '["Tous les avantages BRANCHES", "Réduction 20% chez nos partenaires", "Conseiller dédié", "Bonus parrainage +10%", "Livraison gratuite", "Cadeaux anniversaire"]'::jsonb, 4, true),
  ('POLLEN', 3000, 25, '["Tous les avantages FEUILLES", "Réduction 25% chez nos partenaires", "Accès VIP anticipé nouveautés", "Bonus parrainage +15%", "Concierge personnel", "Expériences exclusives"]'::jsonb, 5, true);
