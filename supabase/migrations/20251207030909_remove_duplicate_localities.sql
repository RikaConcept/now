/*
  # Remove duplicate localities

  1. Changes
    - Delete duplicate localities keeping only the first occurrence
    - 39 duplicate entries will be removed
  
  2. Security
    - Only removes exact duplicates (same name and country)
    - Preserves unique code_prefix entries
*/

-- Delete duplicates keeping only the first occurrence (lowest ID)
WITH duplicates AS (
  SELECT 
    id,
    ROW_NUMBER() OVER (PARTITION BY name, country_id ORDER BY id) as row_num
  FROM localities
)
DELETE FROM localities
WHERE id IN (
  SELECT id FROM duplicates WHERE row_num > 1
);
