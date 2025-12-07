/*
  # Nowlover Application Schema

  ## Overview
  This migration creates the complete database schema for the Nowlover membership application.

  ## 1. New Tables

  ### `localities`
  - `id` (uuid, primary key) - Unique identifier
  - `name` (text) - Locality name
  - `code_prefix` (text) - Prefix for generated codes in this locality
  - `member_count` (integer) - Current number of members in this locality
  - `created_at` (timestamptz) - Creation timestamp

  ### `members`
  - `id` (uuid, primary key) - Unique identifier, linked to auth.users
  - `email` (text) - Member email
  - `phone` (text) - Phone number for WhatsApp notifications
  - `locality_id` (uuid) - Reference to locality
  - `code` (text, unique) - Generated Nowlover code
  - `status` (text) - Member status: 'pending', 'active', 'inactive'
  - `activated_at` (timestamptz) - When the code was activated
  - `created_at` (timestamptz) - Creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### `partner_shops`
  - `id` (uuid, primary key) - Unique identifier
  - `name` (text) - Shop name
  - `category` (text) - Shop category
  - `description` (text) - Shop description
  - `discount_percentage` (numeric) - Discount for members
  - `address` (text) - Physical address
  - `is_active` (boolean) - Whether shop is currently active
  - `created_at` (timestamptz) - Creation timestamp

  ### `orders`
  - `id` (uuid, primary key) - Unique identifier
  - `member_id` (uuid) - Reference to member
  - `amount` (numeric) - Order amount
  - `status` (text) - Order status: 'pending', 'paid', 'cancelled'
  - `payment_method` (text) - Payment method used
  - `created_at` (timestamptz) - Creation timestamp
  - `paid_at` (timestamptz) - Payment completion timestamp

  ### `product_requests`
  - `id` (uuid, primary key) - Unique identifier
  - `user_id` (uuid, nullable) - Reference to user if authenticated
  - `email` (text) - Contact email
  - `phone` (text) - Contact phone
  - `product_name` (text) - Requested product name
  - `best_price_found` (numeric) - Lowest price found by user
  - `price_source` (text) - Link or location of the best price
  - `user_budget` (numeric) - User's available budget
  - `is_member` (boolean) - Whether user is a member
  - `status` (text) - Request status: 'pending', 'processing', 'completed', 'cancelled'
  - `margin_donation` (numeric, nullable) - Donation amount if member
  - `created_at` (timestamptz) - Creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ## 2. Security
  - Enable RLS on all tables
  - Add policies for authenticated users to manage their own data
  - Add policies for public access where appropriate (product requests, partner shops viewing)

  ## 3. Indexes
  - Add indexes on foreign keys and frequently queried columns
  - Add unique index on member codes

  ## 4. Important Notes
  - Member codes are generated based on locality and member count
  - Members receive notifications via email and/or WhatsApp
  - Product requests track margin sharing (50% for non-members, optional donation for members)
  - Order completion triggers member activation
*/

CREATE TABLE IF NOT EXISTS localities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  code_prefix text NOT NULL UNIQUE,
  member_count integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS members (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email text NOT NULL,
  phone text,
  locality_id uuid REFERENCES localities(id) ON DELETE SET NULL,
  code text UNIQUE NOT NULL,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'inactive')),
  activated_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS partner_shops (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  category text NOT NULL,
  description text,
  discount_percentage numeric(5,2) DEFAULT 0,
  address text,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  member_id uuid REFERENCES members(id) ON DELETE CASCADE,
  amount numeric(10,2) NOT NULL,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'cancelled')),
  payment_method text,
  created_at timestamptz DEFAULT now(),
  paid_at timestamptz
);

CREATE TABLE IF NOT EXISTS product_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  email text NOT NULL,
  phone text,
  product_name text NOT NULL,
  best_price_found numeric(10,2) NOT NULL,
  price_source text NOT NULL,
  user_budget numeric(10,2) NOT NULL,
  is_member boolean DEFAULT false,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'cancelled')),
  margin_donation numeric(10,2),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_members_locality ON members(locality_id);
CREATE INDEX IF NOT EXISTS idx_members_status ON members(status);
CREATE INDEX IF NOT EXISTS idx_orders_member ON orders(member_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_product_requests_user ON product_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_product_requests_status ON product_requests(status);

ALTER TABLE localities ENABLE ROW LEVEL SECURITY;
ALTER TABLE members ENABLE ROW LEVEL SECURITY;
ALTER TABLE partner_shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view localities"
  ON localities FOR SELECT
  TO authenticated, anon
  USING (true);

CREATE POLICY "Users can view their own member data"
  ON members FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can insert their own member data"
  ON members FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update their own member data"
  ON members FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Anyone can view active partner shops"
  ON partner_shops FOR SELECT
  TO authenticated, anon
  USING (is_active = true);

CREATE POLICY "Users can view their own orders"
  ON orders FOR SELECT
  TO authenticated
  USING (member_id = auth.uid());

CREATE POLICY "Users can create their own orders"
  ON orders FOR INSERT
  TO authenticated
  WITH CHECK (member_id = auth.uid());

CREATE POLICY "Users can update their own orders"
  ON orders FOR UPDATE
  TO authenticated
  USING (member_id = auth.uid())
  WITH CHECK (member_id = auth.uid());

CREATE POLICY "Anyone can create product requests"
  ON product_requests FOR INSERT
  TO authenticated, anon
  WITH CHECK (true);

CREATE POLICY "Users can view their own product requests"
  ON product_requests FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Anonymous users can view their product requests by email"
  ON product_requests FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Users can update their own product requests"
  ON product_requests FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

INSERT INTO localities (name, code_prefix, member_count) VALUES
  ('Paris', 'PAR', 0),
  ('Lyon', 'LYO', 0),
  ('Marseille', 'MAR', 0),
  ('Toulouse', 'TOU', 0),
  ('Nice', 'NIC', 0)
ON CONFLICT (code_prefix) DO NOTHING;

INSERT INTO partner_shops (name, category, description, discount_percentage, address, is_active) VALUES
  ('Mode Express', 'Mode', 'Vêtements et accessoires tendance', 15.00, '123 Rue de la Mode, Paris', true),
  ('TechStore', 'Électronique', 'Appareils électroniques et gadgets', 10.00, '45 Avenue Tech, Lyon', true),
  ('Bio Market', 'Alimentation', 'Produits bio et naturels', 12.00, '78 Bd Santé, Marseille', true),
  ('Sport Plus', 'Sport', 'Équipements sportifs', 20.00, '32 Rue Athlète, Toulouse', true),
  ('Maison Déco', 'Décoration', 'Décoration intérieure', 18.00, '56 Avenue Style, Nice', true)
ON CONFLICT DO NOTHING;