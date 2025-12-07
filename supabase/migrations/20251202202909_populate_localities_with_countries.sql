/*
  # Populate localities with countries

  1. Changes
    - Link existing localities to France
    - Add new localities for other supported countries
    - Create comprehensive list covering major cities in each country
  
  2. New Localities
    - Multiple cities per country (France, USA, Ivory Coast, Italy, Germany, etc.)
    - Each locality gets appropriate code prefix based on city abbreviation
  
  3. Notes
    - Existing French cities (Paris, Lyon, Marseille, Nice, Toulouse) will be linked to France
    - New cities added for geographic coverage
*/

-- Link existing French localities to France country
UPDATE localities SET country_id = (SELECT id FROM countries WHERE code = 'FR') WHERE code_prefix IN ('PAR', 'LYO', 'MAR', 'NIC', 'TOU');

-- Add more French localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Bordeaux', 'BOR', (SELECT id FROM countries WHERE code = 'FR'), 0),
  ('Nantes', 'NAN', (SELECT id FROM countries WHERE code = 'FR'), 0),
  ('Strasbourg', 'STR', (SELECT id FROM countries WHERE code = 'FR'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Add USA localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('New York', 'NYC', (SELECT id FROM countries WHERE code = 'US'), 0),
  ('Los Angeles', 'LAX', (SELECT id FROM countries WHERE code = 'US'), 0),
  ('Chicago', 'CHI', (SELECT id FROM countries WHERE code = 'US'), 0),
  ('Miami', 'MIA', (SELECT id FROM countries WHERE code = 'US'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Add Ivory Coast localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Abidjan', 'ABJ', (SELECT id FROM countries WHERE code = 'CI'), 0),
  ('Yamoussoukro', 'YAM', (SELECT id FROM countries WHERE code = 'CI'), 0),
  ('Bouaké', 'BOU', (SELECT id FROM countries WHERE code = 'CI'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Add Italy localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Rome', 'ROM', (SELECT id FROM countries WHERE code = 'IT'), 0),
  ('Milan', 'MIL', (SELECT id FROM countries WHERE code = 'IT'), 0),
  ('Naples', 'NAP', (SELECT id FROM countries WHERE code = 'IT'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Add Germany localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Berlin', 'BER', (SELECT id FROM countries WHERE code = 'DE'), 0),
  ('Munich', 'MUN', (SELECT id FROM countries WHERE code = 'DE'), 0),
  ('Hamburg', 'HAM', (SELECT id FROM countries WHERE code = 'DE'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Add Canada localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Toronto', 'TOR', (SELECT id FROM countries WHERE code = 'CA'), 0),
  ('Montreal', 'MTL', (SELECT id FROM countries WHERE code = 'CA'), 0),
  ('Vancouver', 'VAN', (SELECT id FROM countries WHERE code = 'CA'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Add Benin localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Cotonou', 'COT', (SELECT id FROM countries WHERE code = 'BJ'), 0),
  ('Porto-Novo', 'PNO', (SELECT id FROM countries WHERE code = 'BJ'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Add Senegal localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Dakar', 'DKR', (SELECT id FROM countries WHERE code = 'SN'), 0),
  ('Thiès', 'THS', (SELECT id FROM countries WHERE code = 'SN'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Add Nigeria localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Lagos', 'LOS', (SELECT id FROM countries WHERE code = 'NG'), 0),
  ('Abuja', 'ABU', (SELECT id FROM countries WHERE code = 'NG'), 0),
  ('Kano', 'KAN', (SELECT id FROM countries WHERE code = 'NG'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Add Cameroon localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Douala', 'DLA', (SELECT id FROM countries WHERE code = 'CM'), 0),
  ('Yaoundé', 'YAO', (SELECT id FROM countries WHERE code = 'CM'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Add DRC localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Kinshasa', 'KIN', (SELECT id FROM countries WHERE code = 'CD'), 0),
  ('Lubumbashi', 'LUB', (SELECT id FROM countries WHERE code = 'CD'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Add South Africa localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Johannesburg', 'JNB', (SELECT id FROM countries WHERE code = 'ZA'), 0),
  ('Cape Town', 'CPT', (SELECT id FROM countries WHERE code = 'ZA'), 0),
  ('Durban', 'DUR', (SELECT id FROM countries WHERE code = 'ZA'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Add Spain localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Madrid', 'MAD', (SELECT id FROM countries WHERE code = 'ES'), 0),
  ('Barcelona', 'BCN', (SELECT id FROM countries WHERE code = 'ES'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Add Brazil localities
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('São Paulo', 'SAO', (SELECT id FROM countries WHERE code = 'BR'), 0),
  ('Rio de Janeiro', 'RIO', (SELECT id FROM countries WHERE code = 'BR'), 0),
  ('Brasília', 'BSB', (SELECT id FROM countries WHERE code = 'BR'), 0)
ON CONFLICT (code_prefix) DO NOTHING;
