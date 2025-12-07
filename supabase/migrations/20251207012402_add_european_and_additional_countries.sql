/*
  # Ajouter pays européens et localités supplémentaires

  1. Nouveaux pays
    - Europe: Allemagne, Royaume-Uni, Pays-Bas, Espagne, Portugal, Russie, Italie
    - Moyen-Orient: Israël
    - Afrique: Égypte, Madagascar
    - Asie: Japon, Chine
    
  2. Nouvelles localités
    - Villes pour Belgique, Suisse, Luxembourg, France (déjà dans la liste)
    - Villes principales pour chaque nouveau pays

  3. Notes
    - France a déjà des villes dans une migration précédente
    - Utilisation des codes ISO corrects et préfixes téléphoniques internationaux
*/

-- Insérer les nouveaux pays
INSERT INTO countries (name, code, phone_prefix, phone_format, currency_code, language_code) VALUES
  -- Europe
  ('Allemagne', 'DE', '+49', '+49 XXX XXXXXXX', 'EUR', 'de'),
  ('Royaume-Uni', 'GB', '+44', '+44 XXXX XXXXXX', 'GBP', 'en'),
  ('Pays-Bas', 'NL', '+31', '+31 X XXXXXXXX', 'EUR', 'nl'),
  ('Espagne', 'ES', '+34', '+34 XXX XXX XXX', 'EUR', 'es'),
  ('Portugal', 'PT', '+351', '+351 XXX XXX XXX', 'EUR', 'pt'),
  ('Russie', 'RU', '+7', '+7 XXX XXX XX XX', 'RUB', 'ru'),
  ('Italie', 'IT', '+39', '+39 XXX XXX XXXX', 'EUR', 'it'),
  
  -- Moyen-Orient
  ('Israël', 'IL', '+972', '+972 XX XXX XXXX', 'ILS', 'he'),
  
  -- Afrique
  ('Égypte', 'EG', '+20', '+20 XXX XXX XXXX', 'EGP', 'ar'),
  ('Madagascar', 'MG', '+261', '+261 XX XX XXX XX', 'MGA', 'mg'),
  
  -- Asie
  ('Japon', 'JP', '+81', '+81 XX XXXX XXXX', 'JPY', 'ja'),
  ('Chine', 'CN', '+86', '+86 XXX XXXX XXXX', 'CNY', 'zh')
ON CONFLICT (code) DO NOTHING;

-- Ajouter des localités pour les pays européens existants

-- Belgique
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Bruxelles', 'BRU', (SELECT id FROM countries WHERE code = 'BE'), 0),
  ('Anvers', 'ANR', (SELECT id FROM countries WHERE code = 'BE'), 0),
  ('Gand', 'GNT', (SELECT id FROM countries WHERE code = 'BE'), 0),
  ('Liège', 'LIE', (SELECT id FROM countries WHERE code = 'BE'), 0),
  ('Charleroi', 'CRL', (SELECT id FROM countries WHERE code = 'BE'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Suisse
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Zurich', 'ZRH', (SELECT id FROM countries WHERE code = 'CH'), 0),
  ('Genève', 'GVA', (SELECT id FROM countries WHERE code = 'CH'), 0),
  ('Bâle', 'BSL', (SELECT id FROM countries WHERE code = 'CH'), 0),
  ('Berne', 'BRN', (SELECT id FROM countries WHERE code = 'CH'), 0),
  ('Lausanne', 'LSN', (SELECT id FROM countries WHERE code = 'CH'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Luxembourg
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Luxembourg-Ville', 'LUX', (SELECT id FROM countries WHERE code = 'LU'), 0),
  ('Esch-sur-Alzette', 'ESH', (SELECT id FROM countries WHERE code = 'LU'), 0),
  ('Differdange', 'DIF', (SELECT id FROM countries WHERE code = 'LU'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Ajouter des localités pour les nouveaux pays

-- Allemagne
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Berlin', 'BER', (SELECT id FROM countries WHERE code = 'DE'), 0),
  ('Munich', 'MUC', (SELECT id FROM countries WHERE code = 'DE'), 0),
  ('Hambourg', 'HAM', (SELECT id FROM countries WHERE code = 'DE'), 0),
  ('Francfort', 'FRA', (SELECT id FROM countries WHERE code = 'DE'), 0),
  ('Cologne', 'CGN', (SELECT id FROM countries WHERE code = 'DE'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Royaume-Uni
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Londres', 'LON', (SELECT id FROM countries WHERE code = 'GB'), 0),
  ('Manchester', 'MAN', (SELECT id FROM countries WHERE code = 'GB'), 0),
  ('Birmingham', 'BHM', (SELECT id FROM countries WHERE code = 'GB'), 0),
  ('Liverpool', 'LPL', (SELECT id FROM countries WHERE code = 'GB'), 0),
  ('Édimbourg', 'EDI', (SELECT id FROM countries WHERE code = 'GB'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Pays-Bas
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Amsterdam', 'AMS', (SELECT id FROM countries WHERE code = 'NL'), 0),
  ('Rotterdam', 'RTM', (SELECT id FROM countries WHERE code = 'NL'), 0),
  ('La Haye', 'HAG', (SELECT id FROM countries WHERE code = 'NL'), 0),
  ('Utrecht', 'UTR', (SELECT id FROM countries WHERE code = 'NL'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Espagne
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Madrid', 'MAD', (SELECT id FROM countries WHERE code = 'ES'), 0),
  ('Barcelone', 'BCN', (SELECT id FROM countries WHERE code = 'ES'), 0),
  ('Valence', 'VLC', (SELECT id FROM countries WHERE code = 'ES'), 0),
  ('Séville', 'SVQ', (SELECT id FROM countries WHERE code = 'ES'), 0),
  ('Bilbao', 'BIO', (SELECT id FROM countries WHERE code = 'ES'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Portugal
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Lisbonne', 'LIS', (SELECT id FROM countries WHERE code = 'PT'), 0),
  ('Porto', 'OPO', (SELECT id FROM countries WHERE code = 'PT'), 0),
  ('Braga', 'BGZ', (SELECT id FROM countries WHERE code = 'PT'), 0),
  ('Coimbra', 'CBR', (SELECT id FROM countries WHERE code = 'PT'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Russie
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Moscou', 'MOW', (SELECT id FROM countries WHERE code = 'RU'), 0),
  ('Saint-Pétersbourg', 'LED', (SELECT id FROM countries WHERE code = 'RU'), 0),
  ('Novosibirsk', 'OVB', (SELECT id FROM countries WHERE code = 'RU'), 0),
  ('Iekaterinbourg', 'SVX', (SELECT id FROM countries WHERE code = 'RU'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Italie
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Rome', 'ROM', (SELECT id FROM countries WHERE code = 'IT'), 0),
  ('Milan', 'MIL', (SELECT id FROM countries WHERE code = 'IT'), 0),
  ('Naples', 'NAP', (SELECT id FROM countries WHERE code = 'IT'), 0),
  ('Turin', 'TRN', (SELECT id FROM countries WHERE code = 'IT'), 0),
  ('Florence', 'FLR', (SELECT id FROM countries WHERE code = 'IT'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Israël
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Tel Aviv', 'TLV', (SELECT id FROM countries WHERE code = 'IL'), 0),
  ('Jérusalem', 'JRS', (SELECT id FROM countries WHERE code = 'IL'), 0),
  ('Haïfa', 'HFA', (SELECT id FROM countries WHERE code = 'IL'), 0),
  ('Beer-Sheva', 'BEV', (SELECT id FROM countries WHERE code = 'IL'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Égypte
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Le Caire', 'CAI', (SELECT id FROM countries WHERE code = 'EG'), 0),
  ('Alexandrie', 'ALY', (SELECT id FROM countries WHERE code = 'EG'), 0),
  ('Gizeh', 'GIZ', (SELECT id FROM countries WHERE code = 'EG'), 0),
  ('Louxor', 'LXR', (SELECT id FROM countries WHERE code = 'EG'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Madagascar
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Antananarivo', 'TNR', (SELECT id FROM countries WHERE code = 'MG'), 0),
  ('Toamasina', 'TMM', (SELECT id FROM countries WHERE code = 'MG'), 0),
  ('Antsirabe', 'ATJ', (SELECT id FROM countries WHERE code = 'MG'), 0),
  ('Mahajanga', 'MJN', (SELECT id FROM countries WHERE code = 'MG'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Japon
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Tokyo', 'TYO', (SELECT id FROM countries WHERE code = 'JP'), 0),
  ('Osaka', 'OSA', (SELECT id FROM countries WHERE code = 'JP'), 0),
  ('Kyoto', 'KYT', (SELECT id FROM countries WHERE code = 'JP'), 0),
  ('Yokohama', 'YOK', (SELECT id FROM countries WHERE code = 'JP'), 0),
  ('Nagoya', 'NGO', (SELECT id FROM countries WHERE code = 'JP'), 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Chine
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Pékin', 'BJS', (SELECT id FROM countries WHERE code = 'CN'), 0),
  ('Shanghai', 'SHA', (SELECT id FROM countries WHERE code = 'CN'), 0),
  ('Guangzhou', 'CAN', (SELECT id FROM countries WHERE code = 'CN'), 0),
  ('Shenzhen', 'SZX', (SELECT id FROM countries WHERE code = 'CN'), 0),
  ('Chengdu', 'CTU', (SELECT id FROM countries WHERE code = 'CN'), 0),
  ('Hong Kong', 'HKG', (SELECT id FROM countries WHERE code = 'CN'), 0)
ON CONFLICT (code_prefix) DO NOTHING;