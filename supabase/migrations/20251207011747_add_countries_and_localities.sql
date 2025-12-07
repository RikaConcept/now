/*
  # Ajouter des pays et localités supplémentaires

  1. Nouveaux pays
    - USA, Côte d'Ivoire, RDC, Bénin, Burkina Faso, Togo, Ghana
    - Nigeria, Mali, Sénégal, Maroc, Gabon, Afrique du Sud
    - Mexique, Brésil, Argentine, Inde
    
  2. Nouvelles localités
    - Villes principales pour chaque pays

  3. Notes
    - Canada existe déjà, on ajoute juste des villes
    - Utilisation des codes ISO corrects et préfixes téléphoniques
*/

-- Insérer les nouveaux pays
INSERT INTO countries (name, code, phone_prefix, phone_format, currency_code, language_code) VALUES
  -- Amérique du Nord
  ('États-Unis', 'US', '+1', '+1 XXX XXX XXXX', 'USD', 'en'),
  ('Mexique', 'MX', '+52', '+52 XX XXXX XXXX', 'MXN', 'es'),
  
  -- Amérique du Sud
  ('Brésil', 'BR', '+55', '+55 XX XXXXX XXXX', 'BRL', 'pt'),
  ('Argentine', 'AR', '+54', '+54 XX XXXX XXXX', 'ARS', 'es'),
  
  -- Afrique de l'Ouest
  ('Côte d''Ivoire', 'CI', '+225', '+225 XX XX XX XX XX', 'XOF', 'fr'),
  ('Bénin', 'BJ', '+229', '+229 XX XX XX XX', 'XOF', 'fr'),
  ('Burkina Faso', 'BF', '+226', '+226 XX XX XX XX', 'XOF', 'fr'),
  ('Togo', 'TG', '+228', '+228 XX XX XX XX', 'XOF', 'fr'),
  ('Ghana', 'GH', '+233', '+233 XX XXX XXXX', 'GHS', 'en'),
  ('Nigeria', 'NG', '+234', '+234 XXX XXX XXXX', 'NGN', 'en'),
  ('Mali', 'ML', '+223', '+223 XX XX XX XX', 'XOF', 'fr'),
  ('Sénégal', 'SN', '+221', '+221 XX XXX XX XX', 'XOF', 'fr'),
  
  -- Afrique Centrale
  ('RDC', 'CD', '+243', '+243 XX XXX XXXX', 'CDF', 'fr'),
  ('Gabon', 'GA', '+241', '+241 X XX XX XX', 'XAF', 'fr'),
  
  -- Afrique du Nord
  ('Maroc', 'MA', '+212', '+212 XXX XXX XXX', 'MAD', 'ar'),
  
  -- Afrique Australe
  ('Afrique du Sud', 'ZA', '+27', '+27 XX XXX XXXX', 'ZAR', 'en'),
  
  -- Asie
  ('Inde', 'IN', '+91', '+91 XXXXX XXXXX', 'INR', 'hi')
ON CONFLICT (code) DO NOTHING;

-- Insérer les localités pour chaque pays

-- USA
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('New York', 'NYC', (SELECT id FROM countries WHERE code = 'US'), 0),
  ('Los Angeles', 'LAX', (SELECT id FROM countries WHERE code = 'US'), 0),
  ('Chicago', 'CHI', (SELECT id FROM countries WHERE code = 'US'), 0),
  ('Miami', 'MIA', (SELECT id FROM countries WHERE code = 'US'), 0),
  ('Houston', 'HOU', (SELECT id FROM countries WHERE code = 'US'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Côte d'Ivoire
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Abidjan', 'ABJ', (SELECT id FROM countries WHERE code = 'CI'), 0),
  ('Bouaké', 'BKE', (SELECT id FROM countries WHERE code = 'CI'), 0),
  ('Yamoussoukro', 'YAM', (SELECT id FROM countries WHERE code = 'CI'), 0),
  ('San-Pédro', 'SPD', (SELECT id FROM countries WHERE code = 'CI'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- RDC
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Kinshasa', 'KIN', (SELECT id FROM countries WHERE code = 'CD'), 0),
  ('Lubumbashi', 'LBH', (SELECT id FROM countries WHERE code = 'CD'), 0),
  ('Mbuji-Mayi', 'MJM', (SELECT id FROM countries WHERE code = 'CD'), 0),
  ('Goma', 'GOM', (SELECT id FROM countries WHERE code = 'CD'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Bénin
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Cotonou', 'COT', (SELECT id FROM countries WHERE code = 'BJ'), 0),
  ('Porto-Novo', 'PNV', (SELECT id FROM countries WHERE code = 'BJ'), 0),
  ('Parakou', 'PAK', (SELECT id FROM countries WHERE code = 'BJ'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Burkina Faso
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Ouagadougou', 'OUA', (SELECT id FROM countries WHERE code = 'BF'), 0),
  ('Bobo-Dioulasso', 'BOB', (SELECT id FROM countries WHERE code = 'BF'), 0),
  ('Koudougou', 'KOU', (SELECT id FROM countries WHERE code = 'BF'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Togo
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Lomé', 'LOM', (SELECT id FROM countries WHERE code = 'TG'), 0),
  ('Sokodé', 'SOK', (SELECT id FROM countries WHERE code = 'TG'), 0),
  ('Kara', 'KAR', (SELECT id FROM countries WHERE code = 'TG'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Ghana
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Accra', 'ACC', (SELECT id FROM countries WHERE code = 'GH'), 0),
  ('Kumasi', 'KMS', (SELECT id FROM countries WHERE code = 'GH'), 0),
  ('Tema', 'TEM', (SELECT id FROM countries WHERE code = 'GH'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Nigeria
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Lagos', 'LAG', (SELECT id FROM countries WHERE code = 'NG'), 0),
  ('Abuja', 'ABU', (SELECT id FROM countries WHERE code = 'NG'), 0),
  ('Kano', 'KAN', (SELECT id FROM countries WHERE code = 'NG'), 0),
  ('Ibadan', 'IBD', (SELECT id FROM countries WHERE code = 'NG'), 0),
  ('Port Harcourt', 'PHC', (SELECT id FROM countries WHERE code = 'NG'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Mali
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Bamako', 'BKO', (SELECT id FROM countries WHERE code = 'ML'), 0),
  ('Sikasso', 'SIK', (SELECT id FROM countries WHERE code = 'ML'), 0),
  ('Kayes', 'KYS', (SELECT id FROM countries WHERE code = 'ML'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Sénégal
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Dakar', 'DKR', (SELECT id FROM countries WHERE code = 'SN'), 0),
  ('Thiès', 'THI', (SELECT id FROM countries WHERE code = 'SN'), 0),
  ('Saint-Louis', 'STL', (SELECT id FROM countries WHERE code = 'SN'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Maroc
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Casablanca', 'CAS', (SELECT id FROM countries WHERE code = 'MA'), 0),
  ('Rabat', 'RAB', (SELECT id FROM countries WHERE code = 'MA'), 0),
  ('Marrakech', 'MRK', (SELECT id FROM countries WHERE code = 'MA'), 0),
  ('Fès', 'FES', (SELECT id FROM countries WHERE code = 'MA'), 0),
  ('Tanger', 'TNG', (SELECT id FROM countries WHERE code = 'MA'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Gabon
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Libreville', 'LBV', (SELECT id FROM countries WHERE code = 'GA'), 0),
  ('Port-Gentil', 'POG', (SELECT id FROM countries WHERE code = 'GA'), 0),
  ('Franceville', 'FRV', (SELECT id FROM countries WHERE code = 'GA'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Afrique du Sud
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Johannesburg', 'JNB', (SELECT id FROM countries WHERE code = 'ZA'), 0),
  ('Le Cap', 'CPT', (SELECT id FROM countries WHERE code = 'ZA'), 0),
  ('Durban', 'DUR', (SELECT id FROM countries WHERE code = 'ZA'), 0),
  ('Pretoria', 'PRY', (SELECT id FROM countries WHERE code = 'ZA'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Mexique
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Mexico', 'MEX', (SELECT id FROM countries WHERE code = 'MX'), 0),
  ('Guadalajara', 'GDL', (SELECT id FROM countries WHERE code = 'MX'), 0),
  ('Monterrey', 'MTY', (SELECT id FROM countries WHERE code = 'MX'), 0),
  ('Cancún', 'CUN', (SELECT id FROM countries WHERE code = 'MX'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Brésil
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('São Paulo', 'SAO', (SELECT id FROM countries WHERE code = 'BR'), 0),
  ('Rio de Janeiro', 'RIO', (SELECT id FROM countries WHERE code = 'BR'), 0),
  ('Brasília', 'BSB', (SELECT id FROM countries WHERE code = 'BR'), 0),
  ('Salvador', 'SSA', (SELECT id FROM countries WHERE code = 'BR'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Argentine
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Buenos Aires', 'BUE', (SELECT id FROM countries WHERE code = 'AR'), 0),
  ('Córdoba', 'COR', (SELECT id FROM countries WHERE code = 'AR'), 0),
  ('Rosario', 'ROS', (SELECT id FROM countries WHERE code = 'AR'), 0),
  ('Mendoza', 'MDZ', (SELECT id FROM countries WHERE code = 'AR'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Canada (villes supplémentaires)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Montréal', 'MTL', (SELECT id FROM countries WHERE code = 'CA'), 0),
  ('Toronto', 'TOR', (SELECT id FROM countries WHERE code = 'CA'), 0),
  ('Vancouver', 'VAN', (SELECT id FROM countries WHERE code = 'CA'), 0),
  ('Québec', 'QUE', (SELECT id FROM countries WHERE code = 'CA'), 0),
  ('Ottawa', 'OTT', (SELECT id FROM countries WHERE code = 'CA'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Inde
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Mumbai', 'BOM', (SELECT id FROM countries WHERE code = 'IN'), 0),
  ('Delhi', 'DEL', (SELECT id FROM countries WHERE code = 'IN'), 0),
  ('Bangalore', 'BLR', (SELECT id FROM countries WHERE code = 'IN'), 0),
  ('Hyderabad', 'HYD', (SELECT id FROM countries WHERE code = 'IN'), 0),
  ('Chennai', 'MAA', (SELECT id FROM countries WHERE code = 'IN'), 0)
ON CONFLICT (code_prefix) DO NOTHING;