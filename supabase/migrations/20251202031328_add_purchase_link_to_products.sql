/*
  # Add purchase_link to products table

  1. Changes
    - Add `purchase_link` column to products table (optional external purchase link)
    - Make `image_url` NOT NULL since images are mandatory for products
  
  2. Notes
    - image_url is required for all products
    - purchase_link is optional - users can buy through external sites
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'products' AND column_name = 'purchase_link'
  ) THEN
    ALTER TABLE products ADD COLUMN purchase_link text;
  END IF;
END $$;

-- Make image_url required (set a default for existing records first)
UPDATE products SET image_url = 'https://images.pexels.com/photos/264547/pexels-photo-264547.jpeg' WHERE image_url IS NULL;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'products' AND column_name = 'image_url' AND is_nullable = 'YES'
  ) THEN
    ALTER TABLE products ALTER COLUMN image_url SET NOT NULL;
  END IF;
END $$;
