/*
  # Créer la table des pays et lier aux localités

  1. Nouvelle table
    - `countries`
      - `id` (uuid, primary key)
      - `name` (text) - Nom du pays
      - `code` (text, unique) - Code ISO à 2 lettres (ex: FR, BE, CA)
      - `phone_prefix` (text) - Préfixe téléphonique (ex: +33)
      - `phone_format` (text) - Format du numéro de téléphone
      - `currency_code` (text) - Code devise ISO (ex: EUR, USD)
      - `language_code` (text) - Code langue par défaut (ex: fr, en)
      - `created_at` (timestamptz)

  2. Modification
    - Ajouter `country_id` à la table `localities`

  3. Sécurité
    - Enable RLS sur `countries`
    - Politiques de lecture publique

  4. Données
    - Peupler avec les principaux pays francophones
*/

-- Créer la table countries
CREATE TABLE IF NOT EXISTS countries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  code text UNIQUE NOT NULL,
  phone_prefix text NOT NULL,
  phone_format text NOT NULL DEFAULT '+XX XXX XXX XXX',
  currency_code text NOT NULL DEFAULT 'EUR',
  language_code text NOT NULL DEFAULT 'fr',
  created_at timestamptz DEFAULT now()
);

-- Ajouter la colonne country_id à localities si elle n'existe pas
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'localities' AND column_name = 'country_id'
  ) THEN
    ALTER TABLE localities ADD COLUMN country_id uuid REFERENCES countries(id);
  END IF;
END $$;

-- Enable RLS
ALTER TABLE countries ENABLE ROW LEVEL SECURITY;

-- Politiques pour countries (lecture publique)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'countries' AND policyname = 'Countries are viewable by everyone'
  ) THEN
    CREATE POLICY "Countries are viewable by everyone"
      ON countries FOR SELECT
      TO authenticated, anon
      USING (true);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'countries' AND policyname = 'Admins can insert countries'
  ) THEN
    CREATE POLICY "Admins can insert countries"
      ON countries FOR INSERT
      TO authenticated
      WITH CHECK (
        EXISTS (
          SELECT 1 FROM admin_users
          WHERE admin_users.user_id = auth.uid()
        )
      );
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'countries' AND policyname = 'Admins can update countries'
  ) THEN
    CREATE POLICY "Admins can update countries"
      ON countries FOR UPDATE
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
  END IF;
END $$;

-- Insérer les pays principaux
INSERT INTO countries (name, code, phone_prefix, phone_format, currency_code, language_code) VALUES
  ('France', 'FR', '+33', '+33 X XX XX XX XX', 'EUR', 'fr'),
  ('Belgique', 'BE', '+32', '+32 XXX XX XX XX', 'EUR', 'fr'),
  ('Suisse', 'CH', '+41', '+41 XX XXX XX XX', 'CHF', 'fr'),
  ('Canada', 'CA', '+1', '+1 XXX XXX XXXX', 'CAD', 'fr'),
  ('Luxembourg', 'LU', '+352', '+352 XXX XXX', 'EUR', 'fr')
ON CONFLICT (code) DO NOTHING;

-- Mettre à jour les localités existantes pour les lier à la France
UPDATE localities 
SET country_id = (SELECT id FROM countries WHERE code = 'FR')
WHERE country_id IS NULL;