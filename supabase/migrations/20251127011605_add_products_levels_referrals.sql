/*
  # Add Products, Membership Levels, Referrals, and Admin Features

  ## 1. New Tables

  ### `products`
  - `id` (uuid, primary key) - Unique identifier
  - `name` (text) - Product name
  - `description` (text) - Product description
  - `price` (numeric) - Product price
  - `image_url` (text) - Product image URL
  - `category` (text) - Product category
  - `stock` (integer) - Available stock
  - `is_active` (boolean) - Whether product is available
  - `created_at` (timestamptz) - Creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### `membership_levels`
  - `id` (uuid, primary key) - Unique identifier
  - `name` (text) - Level name (e.g., Silver, Gold, Platinum)
  - `minimum_purchases` (numeric) - Minimum amount spent to reach level
  - `discount_percentage` (numeric) - Base discount percentage for this level
  - `benefits` (jsonb) - Array of benefit descriptions
  - `order` (integer) - Display order
  - `is_active` (boolean) - Whether level is active
  - `created_at` (timestamptz) - Creation timestamp

  ### `referrals`
  - `id` (uuid, primary key) - Unique identifier
  - `referrer_id` (uuid) - Member who referred
  - `referred_id` (uuid) - Member who was referred
  - `referral_code` (text, unique) - Unique referral code
  - `bonus_amount` (numeric) - Bonus for referrer
  - `status` (text) - 'pending', 'completed'
  - `referred_member_level` (text) - Level of referred member when activated
  - `created_at` (timestamptz) - Creation timestamp
  - `completed_at` (timestamptz) - When referral was completed

  ### `admin_users`
  - `user_id` (uuid) - Reference to auth user
  - `role` (text) - Admin role: 'admin', 'moderator'
  - `created_at` (timestamptz) - Creation timestamp

  ### `product_requests_v2` (new version with image support)
  - Inherits all from product_requests
  - `image_url` (text) - Optional product image URL

  ## 2. Updates to Existing Tables

  ### `members`
  - Add `membership_level_id` (uuid) - Current membership level
  - Add `total_spent` (numeric) - Total amount spent
  - Add `referral_code` (text, unique) - Personal referral code
  - Add `referred_by` (uuid) - Who referred this member

  ## 3. Security
  - Enable RLS on all new tables
  - Add admin-only policies
  - Add member-specific access policies

  ## 4. Important Notes
  - Membership levels are ordered and determine benefits
  - Referral system tracks who referred each member
  - Admin users have special access to manage platform
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_name = 'products'
  ) THEN
    CREATE TABLE products (
      id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      name text NOT NULL,
      description text,
      price numeric(10,2) NOT NULL,
      image_url text,
      category text NOT NULL,
      stock integer DEFAULT 0,
      is_active boolean DEFAULT true,
      created_at timestamptz DEFAULT now(),
      updated_at timestamptz DEFAULT now()
    );
    CREATE INDEX idx_products_category ON products(category);
    CREATE INDEX idx_products_active ON products(is_active);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_name = 'membership_levels'
  ) THEN
    CREATE TABLE membership_levels (
      id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      name text UNIQUE NOT NULL,
      minimum_purchases numeric(10,2) DEFAULT 0,
      discount_percentage numeric(5,2) DEFAULT 0,
      benefits jsonb DEFAULT '[]'::jsonb,
      "order" integer NOT NULL,
      is_active boolean DEFAULT true,
      created_at timestamptz DEFAULT now()
    );
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_name = 'referrals'
  ) THEN
    CREATE TABLE referrals (
      id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      referrer_id uuid REFERENCES members(id) ON DELETE CASCADE,
      referred_id uuid REFERENCES members(id) ON DELETE CASCADE,
      referral_code text UNIQUE NOT NULL,
      bonus_amount numeric(10,2) DEFAULT 0,
      status text DEFAULT 'pending' CHECK (status IN ('pending', 'completed')),
      referred_member_level text,
      created_at timestamptz DEFAULT now(),
      completed_at timestamptz
    );
    CREATE INDEX idx_referrals_referrer ON referrals(referrer_id);
    CREATE INDEX idx_referrals_referred ON referrals(referred_id);
    CREATE INDEX idx_referrals_code ON referrals(referral_code);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_name = 'admin_users'
  ) THEN
    CREATE TABLE admin_users (
      user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
      role text CHECK (role IN ('admin', 'moderator')) DEFAULT 'moderator',
      created_at timestamptz DEFAULT now()
    );
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'members' AND column_name = 'membership_level_id'
  ) THEN
    ALTER TABLE members ADD COLUMN membership_level_id uuid REFERENCES membership_levels(id) ON DELETE SET NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'members' AND column_name = 'total_spent'
  ) THEN
    ALTER TABLE members ADD COLUMN total_spent numeric(10,2) DEFAULT 0;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'members' AND column_name = 'referral_code'
  ) THEN
    ALTER TABLE members ADD COLUMN referral_code text UNIQUE;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'members' AND column_name = 'referred_by'
  ) THEN
    ALTER TABLE members ADD COLUMN referred_by uuid REFERENCES members(id) ON DELETE SET NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'product_requests' AND column_name = 'image_url'
  ) THEN
    ALTER TABLE product_requests ADD COLUMN image_url text;
  END IF;
END $$;

ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE membership_levels ENABLE ROW LEVEL SECURITY;
ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view active products"
  ON products FOR SELECT
  TO authenticated, anon
  USING (is_active = true);

CREATE POLICY "Admins can manage products"
  ON products FOR ALL
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

CREATE POLICY "Anyone can view membership levels"
  ON membership_levels FOR SELECT
  TO authenticated, anon
  USING (is_active = true);

CREATE POLICY "Admins can manage membership levels"
  ON membership_levels FOR ALL
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

CREATE POLICY "Users can view their referrals"
  ON referrals FOR SELECT
  TO authenticated
  USING (
    referrer_id = auth.uid() OR
    referred_id = auth.uid()
  );

CREATE POLICY "Admins can manage referrals"
  ON referrals FOR ALL
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

CREATE POLICY "Admins only can view admin users"
  ON admin_users FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.user_id = auth.uid() AND au.role = 'admin'
    )
  );

INSERT INTO membership_levels (name, minimum_purchases, discount_percentage, benefits, "order", is_active) VALUES
  ('Bronze', 0, 5, '["Bienvenue dans la communauté", "Accès au catalogue", "Demandes de produits sans commission"]'::jsonb, 1, true),
  ('Silver', 100, 10, '["Tous les avantages Bronze", "Réductions 10% sur les boutiques", "Priorité support client"]'::jsonb, 2, true),
  ('Gold', 500, 15, '["Tous les avantages Silver", "Réductions 15% sur les boutiques", "Accès aux ventes privées", "Bonus de parrainage +5%"]'::jsonb, 3, true),
  ('Platinum', 2000, 20, '["Tous les avantages Gold", "Réductions 20% sur les boutiques", "Conseiller personnel", "Bonus de parrainage +10%", "Livraison gratuite"]'::jsonb, 4, true)
ON CONFLICT (name) DO NOTHING;

INSERT INTO products (name, description, price, category, stock, is_active) VALUES
  ('Pack Découverte Premium', 'Sélection de produits premium pour débuter', 50.00, 'Packs', 100, true),
  ('Pack Expérience', 'Collection exclusive de marques partenaires', 100.00, 'Packs', 50, true),
  ('Pack VIP Platinum', 'Expérience complète avec tous les avantages', 200.00, 'Packs', 25, true)
ON CONFLICT DO NOTHING;
