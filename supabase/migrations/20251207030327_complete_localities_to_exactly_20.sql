/*
  # Complete localities to exactly 20 per country

  1. Changes
    - Add remaining localities to ensure each country has exactly 20 localities
    - Fills gaps for countries that didn't reach 20 in the previous migration
*/

-- Bénin (19 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Allada', 'ALL', '3dc146df-e174-4336-a875-4a50687425d4', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Côte d'Ivoire (19 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Odienné', 'ODE', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- France (19 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Grenoble', 'GNB', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Sénégal (19 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Pikine', 'PIK', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Maroc (18 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Nador', 'NDR', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Essaouira', 'ESS-MA', '992895d5-4499-4d68-a257-b84ae2c67323', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Nigeria (18 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Sokoto', 'SKO', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Warri', 'WAR', '6e89c363-2548-42f4-9e54-476a0f266a59', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- RDC (18 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Tshikapa', 'TSH', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Mbanza-Ngungu', 'MBN', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Burkina Faso (17 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Léo', 'LEO', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Boussé', 'BOU', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Sapouy', 'SAP', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Cameroun (17 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Bangangté', 'BNG', '4ceef650-26be-4c97-a88b-19987bc640f7', 0),
  ('Yabassi', 'YAB', '4ceef650-26be-4c97-a88b-19987bc640f7', 0),
  ('Tiko', 'TIK', '4ceef650-26be-4c97-a88b-19987bc640f7', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Égypte (17 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Minya', 'MNY', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Sohag', 'SOH', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Beni Suef', 'BNS', 'a656e340-8d59-4724-b8f3-501464f643f8', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Gabon (17 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Booué', 'BOO', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Ndendé', 'NDE', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Mékambo', 'MEK', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Ghana (17 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Bolgatanga', 'BOL', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Takoradi', 'TKD-GH', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Tarkwa', 'TRK', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Luxembourg (17 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Kayl', 'KYL', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Schifflange', 'SCH', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Bettembourg', 'BET', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Madagascar (17 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Ankazobe', 'AKZ', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Farafangana', 'FAR', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Ambanja', 'ABJ-MG', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Mali (17 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Yorosso', 'YOR', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Diéma', 'DIE-ML', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Koro', 'KRO', '01a97638-8563-4ae9-8ced-be0f99493d17', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Pays-Bas (17 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Maastricht', 'MST', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Leyde', 'LEY', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Dordrecht', 'DOR', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Portugal (17 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Portimão', 'PRM', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Cascais', 'CAS-PT', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Loures', 'LOU-PT', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Afrique du Sud (16 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Welkom', 'WEL', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Newcastle', 'NCS', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Benoni', 'BEN', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Boksburg', 'BOK', '689f7406-0321-4532-8785-f386ae312f2c', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Allemagne (16 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Bochum', 'BOC', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Wuppertal', 'WUP', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Bielefeld', 'BIE', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Bonn', 'BNN', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Argentine (16 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Santiago del Estero', 'SDE', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Corrientes', 'CNQ', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('San Luis', 'LUQ', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Catamarca', 'CTC', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Brésil (16 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Natal', 'NAT-BR', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('João Pessoa', 'JPA', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Teresina', 'THE', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Aracaju', 'AJU', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Chine (16 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Dalian', 'DLC', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Jinan', 'TNA', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Changsha', 'CSX', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Zhengzhou', 'CGO', 'a92746d8-a838-4768-855f-10c567268c0d', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- États-Unis (16 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Fort Worth', 'FTW', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('Charlotte', 'CLT', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('Seattle', 'SEA', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('Denver', 'DEN', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Israël (16 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Nahariya', 'NAH', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Ramla', 'RML', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Lod', 'LOD', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Acre', 'ACR', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Italie (16 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Tarente', 'TAR', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Brescia', 'BSC', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Prato', 'PRA-IT', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Modène', 'MOD-IT', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Mexique (16 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Morelia', 'MLM', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Toluca', 'TLC', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('San Luis Potosí', 'SLP', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Culiacán', 'CUL', '7737316b-e178-49d0-80ee-6f982f6a5493', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Russie (16 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Iaroslavl', 'IAR', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Vladivostok', 'VVO', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Irkoutsk', 'IKT', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Khabarovsk', 'KHV', 'b8f40142-e18f-4521-a075-aef888465663', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Belgique (15 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Ostende', 'OST', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Roulers', 'ROU', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Mouscron', 'MOU-BE', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Verviers', 'VER-BE', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Courtrai', 'COU', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Espagne (15 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Grenade', 'GRX', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Oviedo', 'OVD', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Badalona', 'BDL', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Carthagène', 'CRT', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Jerez de la Frontera', 'JER', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Inde (15 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Visakhapatnam', 'VTZ', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Patna', 'PAT', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Vadodara', 'BDQ', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Ghaziabad', 'GHA', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Ludhiana', 'LUH', '8ad813af-b53d-44db-933a-82f135849cca', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Japon (15 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Niigata', 'NII', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Hamamatsu', 'HMM', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Shizuoka', 'SHZ', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Sagamihara', 'SGM', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Okayama', 'OKJ', '4fc589f8-3b7e-4485-b276-5a196b755691', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Royaume-Uni (15 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Coventry', 'CVT', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Bradford', 'BRD-GB', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Plymouth', 'PLY', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Wolverhampton', 'WOL', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Stoke-on-Trent', 'SOT', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Suisse (15 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('La Chaux-de-Fonds', 'CDF', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Vernier', 'VER-CH', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Uster', 'UST', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Emmen', 'EMM', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Montreux', 'MTR', '8c22687a-926c-4936-84d5-93aa0423de3f', 0)
ON CONFLICT (code_prefix) DO NOTHING;
