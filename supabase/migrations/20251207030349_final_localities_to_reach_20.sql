/*
  # Final localities to reach exactly 20 per country

  1. Changes
    - Add the last missing locality for Gabon, Pays-Bas, and RDC
    - Ensures all countries have exactly 20 localities
*/

-- Gabon (19 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Port-Gentil Zone', 'PGZ', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Pays-Bas (19 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Leiden', 'LDN', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- RDC (19 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Ilebo', 'ILE', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0)
ON CONFLICT (code_prefix) DO NOTHING;
