/*
  # Create site settings table

  1. New Tables
    - `site_settings`
      - `id` (text, primary key) - Always a single row with id 'default'
      - `app_name` (text) - Application name
      - `logo_url` (text) - URL to logo image
      - `primary_color` (text) - Primary brand color (hex)
      - `secondary_color` (text) - Secondary brand color (hex)
      - `accent_color` (text) - Accent color (hex)
      - `hero_title` (text) - Hero section title
      - `hero_description` (text) - Hero section description
      - `why_choose_title` (text) - Why choose section title
      - `why_choose_description` (text) - Why choose section description
      - `feature_1_title` (text)
      - `feature_1_description` (text)
      - `feature_1_icon` (text) - Icon name from lucide-react
      - `feature_2_title` (text)
      - `feature_2_description` (text)
      - `feature_2_icon` (text)
      - `feature_3_title` (text)
      - `feature_3_description` (text)
      - `feature_3_icon` (text)
      - `stats_members` (text) - Display value for members
      - `stats_partners` (text) - Display value for partners
      - `stats_satisfaction` (text) - Display value for satisfaction
      - `contact_title` (text)
      - `contact_description` (text)
      - `contact_address` (text)
      - `contact_phone` (text)
      - `contact_hours` (text)
      - `contact_email` (text)
      - `contact_support_email` (text)
      - `footer_description` (text)
      - `footer_copyright` (text)
      - `social_facebook` (text)
      - `social_twitter` (text)
      - `social_instagram` (text)
      - `social_linkedin` (text)
      - `updated_at` (timestamptz)

  2. Security
    - Enable RLS on `site_settings` table
    - Add policy for public read access
    - Add policy for admin write access
*/

-- Create site_settings table
CREATE TABLE IF NOT EXISTS site_settings (
  id text PRIMARY KEY DEFAULT 'default',
  app_name text DEFAULT 'NOW!',
  logo_url text DEFAULT '',
  primary_color text DEFAULT '#2563eb',
  secondary_color text DEFAULT '#9333ea',
  accent_color text DEFAULT '#fbbf24',
  hero_title text DEFAULT 'Bienvenue chez NOW!',
  hero_description text DEFAULT 'Découvrez des produits exceptionnels et bénéficiez d''avantages exclusifs chez nos partenaires de confiance',
  why_choose_title text DEFAULT 'Pourquoi choisir NOW!Concept ?',
  why_choose_description text DEFAULT 'Une plateforme unique qui vous connecte aux meilleurs produits et services',
  feature_1_title text DEFAULT 'Accès instantané',
  feature_1_description text DEFAULT 'Découvrez immédiatement tous nos produits et services partenaires',
  feature_1_icon text DEFAULT 'Zap',
  feature_2_title text DEFAULT 'Qualité garantie',
  feature_2_description text DEFAULT 'Tous nos partenaires sont soigneusement sélectionnés pour leur excellence',
  feature_2_icon text DEFAULT 'Shield',
  feature_3_title text DEFAULT 'Avantages exclusifs',
  feature_3_description text DEFAULT 'Bénéficiez de réductions et d''offres spéciales réservées aux membres',
  feature_3_icon text DEFAULT 'Award',
  stats_members text DEFAULT '10,000+',
  stats_partners text DEFAULT '500+',
  stats_satisfaction text DEFAULT '4.9/5',
  contact_title text DEFAULT 'Contactez-nous',
  contact_description text DEFAULT 'Une question ? Notre équipe est là pour vous aider',
  contact_address text DEFAULT '123 Rue de l''Innovation, 75001 Paris, France',
  contact_phone text DEFAULT '+33 1 23 45 67 89',
  contact_hours text DEFAULT 'Lun-Ven 9h-18h',
  contact_email text DEFAULT 'contact@nowlovers.com',
  contact_support_email text DEFAULT 'support@nowlovers.com',
  footer_description text DEFAULT 'La plateforme qui connecte les amoureux des beaux produits aux meilleures boutiques.',
  footer_copyright text DEFAULT '© 2024 NOW!. Tous droits réservés.',
  social_facebook text DEFAULT '',
  social_twitter text DEFAULT '',
  social_instagram text DEFAULT '',
  social_linkedin text DEFAULT '',
  updated_at timestamptz DEFAULT now()
);

-- Insert default settings if not exists
INSERT INTO site_settings (id)
VALUES ('default')
ON CONFLICT (id) DO NOTHING;

-- Enable RLS
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;

-- Public can read site settings
CREATE POLICY "Anyone can read site settings"
  ON site_settings
  FOR SELECT
  TO public
  USING (true);

-- Only admins can update site settings
CREATE POLICY "Admins can update site settings"
  ON site_settings
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE admin_users.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE admin_users.user_id = auth.uid()
    )
  );