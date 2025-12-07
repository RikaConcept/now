/*
  # Complete localities to 20 per country

  1. Changes
    - Add localities to reach 20 localities per country
    - Covers major cities and urban centers for each country
    - Uses unique code prefixes for each locality
  
  2. Countries covered
    - All existing countries in the database
    - Major cities, regional capitals, and important urban centers
*/

-- Cameroun (12 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Maroua', 'MAR', '4ceef650-26be-4c97-a88b-19987bc640f7', 0),
  ('Bertoua', 'BER', '4ceef650-26be-4c97-a88b-19987bc640f7', 0),
  ('Buea', 'BUE', '4ceef650-26be-4c97-a88b-19987bc640f7', 0),
  ('Nkongsamba', 'NKO', '4ceef650-26be-4c97-a88b-19987bc640f7', 0),
  ('Loum', 'LOU', '4ceef650-26be-4c97-a88b-19987bc640f7', 0),
  ('Foumban', 'FOU', '4ceef650-26be-4c97-a88b-19987bc640f7', 0),
  ('Mbouda', 'MBO', '4ceef650-26be-4c97-a88b-19987bc640f7', 0),
  ('Sangmélima', 'SAN', '4ceef650-26be-4c97-a88b-19987bc640f7', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Afrique du Sud (4 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Johannesburg', 'JNB', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Le Cap', 'CPT', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Durban', 'DUR', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Pretoria', 'PRY', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Port Elizabeth', 'PLZ', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Bloemfontein', 'BFN', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('East London', 'ELS', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Pietermaritzburg', 'PZB', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Nelspruit', 'NLP', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Polokwane', 'PTG', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Kimberley', 'KIM', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Rustenburg', 'RUS', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('George', 'GRJ', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Middelburg', 'MDB', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Upington', 'UTN', '689f7406-0321-4532-8785-f386ae312f2c', 0),
  ('Vereeniging', 'VER', '689f7406-0321-4532-8785-f386ae312f2c', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Allemagne (5 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Berlin', 'BER-DE', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Munich', 'MUC', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Francfort', 'FRA', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Hambourg', 'HAM', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Cologne', 'CGN', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Stuttgart', 'STR', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Düsseldorf', 'DUS', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Dortmund', 'DTM', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Essen', 'ESS', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Leipzig', 'LEJ', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Brême', 'BRE', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Dresde', 'DRS', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Hanovre', 'HAJ', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Nuremberg', 'NUE', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0),
  ('Duisbourg', 'DUI', '8402fe55-b901-49f5-834f-e2bf06787bdb', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Argentine (4 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Buenos Aires', 'BUE-AR', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Córdoba', 'COR', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Rosario', 'ROS', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Mendoza', 'MDZ', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('La Plata', 'LPL', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('San Miguel de Tucumán', 'TUC', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Mar del Plata', 'MDP', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Salta', 'SLA', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Santa Fe', 'SFN', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('San Juan', 'UAQ', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Resistencia', 'RES', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Neuquén', 'NQN', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Posadas', 'PSS', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Bahía Blanca', 'BHI', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Paraná', 'PRA', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0),
  ('Formosa', 'FMA', 'a8c4975d-6f0c-4adc-ad7b-f0ea896c31fc', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Belgique (5 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Bruxelles', 'BRU', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Anvers', 'ANR', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Gand', 'GNT', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Charleroi', 'CRL', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Liège', 'LGG', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Bruges', 'BRG', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Namur', 'NAM', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Louvain', 'LVN', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Mons', 'MNS', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Malines', 'MLN', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Alost', 'ALS', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Hasselt', 'HSL', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Tournai', 'TRN', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Genk', 'GNK', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0),
  ('Seraing', 'SRG', 'b2e1588a-18a2-4f34-8bf2-b318ad3d83db', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Bénin (3 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Cotonou', 'COO', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Porto-Novo', 'PNV', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Parakou', 'PKO', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Djougou', 'DJO', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Bohicon', 'BOH', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Kandi', 'KND', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Lokossa', 'LOK', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Ouidah', 'OUI', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Abomey', 'ABO', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Natitingou', 'NAT', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Savé', 'SAV', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Pobé', 'POB', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Kétou', 'KET', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Malanville', 'MAL', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Tchaourou', 'TCH', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Bembèrèkè', 'BEM', '3dc146df-e174-4336-a875-4a50687425d4', 0),
  ('Nikki', 'NIK', '3dc146df-e174-4336-a875-4a50687425d4', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Brésil (4 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('São Paulo', 'SAO', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Rio de Janeiro', 'RIO', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Brasília', 'BSB', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Salvador', 'SSA', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Fortaleza', 'FOR', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Belo Horizonte', 'BHZ', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Manaus', 'MAO', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Curitiba', 'CWB', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Recife', 'REC', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Porto Alegre', 'POA', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Belém', 'BEL', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Goiânia', 'GYN', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Guarulhos', 'GRU', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Campinas', 'CPQ', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('São Luís', 'SLZ', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0),
  ('Maceió', 'MCZ', 'aa4f1656-e7c4-4ee7-8522-43769de6bb52', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Burkina Faso (3 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Ouagadougou', 'OUA', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Bobo-Dioulasso', 'BOB', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Koudougou', 'KOU', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Ouahigouya', 'OHG', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Banfora', 'BNF', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Dédougou', 'DED', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Kaya', 'KYA', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Fada Ngourma', 'FAD', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Tenkodogo', 'TNK', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Gaoua', 'GAO', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Dori', 'DOR', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Manga', 'MNG', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Réo', 'REO', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Houndé', 'HND', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Nouna', 'NOU', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Ziniaré', 'ZIN', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0),
  ('Diébougou', 'DIE', '77c35ba4-3417-40d2-8cb3-4b10b7aa7dff', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Canada (5 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Toronto', 'YYZ', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('Montréal', 'YUL', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('Vancouver', 'YVR', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('Calgary', 'YYC', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('Ottawa', 'YOW', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('Edmonton', 'YEG', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('Québec', 'YQB', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('Winnipeg', 'YWG', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('Hamilton', 'YHM', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('Kitchener', 'YKF', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('London', 'YXU', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('Victoria', 'YYJ', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('Halifax', 'YHZ', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('Oshawa', 'YOO', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0),
  ('Windsor', 'YQG', 'b6e137d8-2637-4b26-ad51-0948a9e1a440', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Chine (6 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Pékin', 'PEK', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Shanghai', 'SHA', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Guangzhou', 'CAN', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Shenzhen', 'SZX', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Chengdu', 'CTU', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Chongqing', 'CKG', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Tianjin', 'TSN', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Wuhan', 'WUH', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Xian', 'XIY', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Hangzhou', 'HGH', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Nanjing', 'NKG', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Shenyang', 'SHE', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Harbin', 'HRB', 'a92746d8-a838-4768-855f-10c567268c0d', 0),
  ('Qingdao', 'TAO', 'a92746d8-a838-4768-855f-10c567268c0d', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Côte d'Ivoire (4 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Abidjan', 'ABJ', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Bouaké', 'BYK', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Yamoussoukro', 'ASK', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Daloa', 'DJO-CI', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('San-Pédro', 'SPY', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Korhogo', 'HGO', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Man', 'MJC', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Divo', 'DIV', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Gagnoa', 'GGN', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Abengourou', 'AEH', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Soubré', 'SBQ', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Agboville', 'AGV', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Grand-Bassam', 'GBS', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Séguéla', 'SEG', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Bondoukou', 'BDK', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0),
  ('Ferkessédougou', 'FEK', '0193bfb8-2de5-4e29-8040-92dc15e8cd0c', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Égypte (4 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Le Caire', 'CAI', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Alexandrie', 'ALY', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Gizeh', 'GZH', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Charm el-Cheikh', 'SSH', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Port-Saïd', 'PSD', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Suez', 'SUZ', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Louxor', 'LXR', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Assouan', 'ASW', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Mansoura', 'MNF', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Tanta', 'TNT', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Asyut', 'ATZ', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Ismaïlia', 'ISM', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Faiyoum', 'FYM', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Zagazig', 'ZAG', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Damiette', 'DMT', 'a656e340-8d59-4724-b8f3-501464f643f8', 0),
  ('Hurghada', 'HRG', 'a656e340-8d59-4724-b8f3-501464f643f8', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Espagne (5 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Madrid', 'MAD', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Barcelone', 'BCN', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Valence', 'VLC', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Séville', 'SVQ', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Saragosse', 'ZAZ', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Malaga', 'AGP', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Murcie', 'MJV', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Palma de Majorque', 'PMI', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Las Palmas', 'LPA', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Bilbao', 'BIO', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Alicante', 'ALC', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Cordoue', 'ODB', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Valladolid', 'VLL', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Vigo', 'VGO', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0),
  ('Gijón', 'GIJ', '14dd083d-eff5-47b8-9d03-11b8da147a70', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- États-Unis (6 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('New York', 'NYC', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('Los Angeles', 'LAX', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('Chicago', 'ORD', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('Houston', 'HOU', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('Phoenix', 'PHX', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('Philadelphie', 'PHL', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('San Antonio', 'SAT', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('San Diego', 'SAN', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('Dallas', 'DFW', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('San José', 'SJC', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('Austin', 'AUS', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('Jacksonville', 'JAX', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('San Francisco', 'SFO', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0),
  ('Columbus', 'CMH', '8a8b5008-bdf5-4dd3-8426-74c046acfeb6', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- France (5 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Paris', 'PAR', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Marseille', 'MRS', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Lyon', 'LYS', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Toulouse', 'TLS', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Nice', 'NCE', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Nantes', 'NTE', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Strasbourg', 'SXB', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Montpellier', 'MPL', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Bordeaux', 'BOD', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Lille', 'LIL', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Rennes', 'RNS', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Reims', 'RHE', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Le Havre', 'LEH', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Saint-Étienne', 'EBU', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0),
  ('Toulon', 'TLN', '7d12c2b2-bcd3-4e82-9410-839c33e0cfce', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Gabon (3 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Libreville', 'LBV', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Port-Gentil', 'POG', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Franceville', 'FRV', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Oyem', 'OYE', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Moanda', 'MOD', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Mouila', 'MOU', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Lambaréné', 'LMB', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Tchibanga', 'TCH-GA', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Koulamoutou', 'KOU-GA', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Makokou', 'MKB', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Bitam', 'BMM', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Gamba', 'GAX', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Ntoum', 'NTM', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Lastoursville', 'LAS', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Mounana', 'MNN', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Mayumba', 'MYB', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0),
  ('Omboué', 'OMB', 'b14f09eb-3fc0-42c9-9485-462b98ca24d5', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Ghana (3 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Accra', 'ACC', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Kumasi', 'KMS', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Tamale', 'TML', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Sekondi-Takoradi', 'TKD', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Cape Coast', 'CCC', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Obuasi', 'OBS', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Teshie', 'TSH', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Tema', 'TEM', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Madina', 'MDI', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Koforidua', 'KFD', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Wa', 'WAA', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Techiman', 'TCM', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Sunyani', 'SNY', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Ho', 'HOE', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Nungua', 'NUN', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Aflao', 'AFL', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0),
  ('Berekum', 'BER-GH', '063e004f-c02a-4eea-8c49-eb34bd60acb8', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Inde (5 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Mumbai', 'BOM', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Delhi', 'DEL', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Bangalore', 'BLR', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Hyderabad', 'HYD', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Ahmedabad', 'AMD', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Chennai', 'MAA', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Kolkata', 'CCU', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Surat', 'STV', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Pune', 'PNQ', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Jaipur', 'JAI', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Lucknow', 'LKO', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Kanpur', 'KNU', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Nagpur', 'NAG', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Indore', 'IDR', '8ad813af-b53d-44db-933a-82f135849cca', 0),
  ('Bhopal', 'BHO', '8ad813af-b53d-44db-933a-82f135849cca', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Israël (4 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Jérusalem', 'JRS', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Tel Aviv', 'TLV', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Haïfa', 'HFA', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Rishon LeZion', 'RSH', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Petah Tikva', 'PTK', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Ashdod', 'ASD', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Netanya', 'NTY', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Beer-Sheva', 'BEV', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Holon', 'HLN', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Ramat Gan', 'RMG', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Bat Yam', 'BTY', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Rehovot', 'RHV', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Herzliya', 'HRZ', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Kfar Saba', 'KFS', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Hadera', 'HDR', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0),
  ('Modiin', 'MOD-IL', '7264b810-b396-4ec7-be19-6f51a5224a5d', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Italie (5 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Rome', 'ROM', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Milan', 'MIL', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Naples', 'NAP', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Turin', 'TRN-IT', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Palerme', 'PMO', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Gênes', 'GOA', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Bologne', 'BLQ', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Florence', 'FLR', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Bari', 'BRI', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Catane', 'CTA', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Venise', 'VCE', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Vérone', 'VRN', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Messine', 'MSS', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Padoue', 'PAD', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0),
  ('Trieste', 'TRS', '3f8d1788-88b3-4b9f-ac8c-7f35f6c97fe5', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Japon (5 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Tokyo', 'TYO', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Yokohama', 'YOK', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Osaka', 'OSA', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Nagoya', 'NGO', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Sapporo', 'SPK', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Kobe', 'UKB', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Kyoto', 'KYT', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Fukuoka', 'FUK', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Kawasaki', 'KWS', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Saitama', 'SIT', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Hiroshima', 'HIJ', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Sendai', 'SDJ', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Kitakyushu', 'KKJ', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Chiba', 'CHB', '4fc589f8-3b7e-4485-b276-5a196b755691', 0),
  ('Sakai', 'SKI', '4fc589f8-3b7e-4485-b276-5a196b755691', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Luxembourg (3 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Luxembourg', 'LUX', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Esch-sur-Alzette', 'ESH', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Differdange', 'DIF', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Dudelange', 'DUD', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Ettelbruck', 'ETT', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Diekirch', 'DIK', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Wiltz', 'WLZ', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Echternach', 'ECH', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Rumelange', 'RUM', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Grevenmacher', 'GRV', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Pétange', 'PET', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Bertrange', 'BTR', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Strassen', 'STR-LU', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Niederkorn', 'NDK', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Oberkorn', 'OBK', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Sanem', 'SNM', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0),
  ('Mersch', 'MER', 'dd9f23d3-58ad-41d8-9ff8-ebb76623dbb8', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Madagascar (4 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Antananarivo', 'TNR', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Toamasina', 'TMM', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Antsirabe', 'ATS', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Fianarantsoa', 'FIA', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Mahajanga', 'MJN', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Toliara', 'TLE', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Antsiranana', 'DIE-MG', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Ambovombe', 'AMB', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Morondava', 'MOQ', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Nosy Be', 'NOS', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Sambava', 'SVB', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Manakara', 'MNK', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Ambatondrazaka', 'AMZ', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Mananjary', 'MNJ', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Antalaha', 'ANL', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0),
  ('Maroantsetra', 'WMN', 'f8d2be9f-3cc2-416e-b44d-97ae0e995941', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Mali (3 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Bamako', 'BKO', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Sikasso', 'SKS', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Mopti', 'MZI', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Koutiala', 'KTL', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Ségou', 'SGU', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Kayes', 'KYS', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Gao', 'GAQ', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Tombouctou', 'TOM', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Kati', 'KTI', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('San', 'SAN-ML', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Kolokani', 'KLK', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Niono', 'NIO', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Bougouni', 'BGN', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Markala', 'MRK', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Kidal', 'KID', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Banamba', 'BNB', '01a97638-8563-4ae9-8ced-be0f99493d17', 0),
  ('Koulikoro', 'KLR', '01a97638-8563-4ae9-8ced-be0f99493d17', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Maroc (5 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Casablanca', 'CAS', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Rabat', 'RBA', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Fès', 'FEZ', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Marrakech', 'RAK', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Tanger', 'TNG', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Agadir', 'AGA', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Meknès', 'MEK', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Oujda', 'OUD', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Kénitra', 'NNA', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Tétouan', 'TTU', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Salé', 'SLE', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Mohammedia', 'MOH', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('El Jadida', 'ELJ', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Safi', 'SAF', '992895d5-4499-4d68-a257-b84ae2c67323', 0),
  ('Beni Mellal', 'BNM', '992895d5-4499-4d68-a257-b84ae2c67323', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Mexique (4 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Mexico', 'MEX', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Guadalajara', 'GDL', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Monterrey', 'MTY', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Puebla', 'PBC', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Tijuana', 'TIJ', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('León', 'BJX', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Juárez', 'CJS', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Zapopan', 'ZPN', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Mérida', 'MID', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Chihuahua', 'CUU', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Querétaro', 'QRO', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Cancún', 'CUN', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Acapulco', 'ACA', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Aguascalientes', 'AGU', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Hermosillo', 'HMO', '7737316b-e178-49d0-80ee-6f982f6a5493', 0),
  ('Saltillo', 'SLW', '7737316b-e178-49d0-80ee-6f982f6a5493', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Nigeria (5 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Lagos', 'LOS', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Kano', 'KAN', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Ibadan', 'IBA', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Abuja', 'ABV', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Port Harcourt', 'PHC', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Benin City', 'BNI', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Kaduna', 'KAD', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Maiduguri', 'MIU', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Zaria', 'ZAR', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Aba', 'ABA', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Jos', 'JOS', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Ilorin', 'ILR', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Oyo', 'OYO', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Enugu', 'ENU', '6e89c363-2548-42f4-9e54-476a0f266a59', 0),
  ('Abeokuta', 'ABE', '6e89c363-2548-42f4-9e54-476a0f266a59', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Pays-Bas (4 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Amsterdam', 'AMS', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Rotterdam', 'RTM', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('La Haye', 'HAG', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Utrecht', 'UTC', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Eindhoven', 'EIN', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Tilburg', 'TIL', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Groningue', 'GRQ', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Almere', 'ALM', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Breda', 'BRD', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Nimègue', 'NMG', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Enschede', 'ENS', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Apeldoorn', 'APL', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Haarlem', 'HAA', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Arnhem', 'ARN', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Zaanstad', 'ZAA', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0),
  ('Amersfoort', 'AMF', '6159c6e3-ddfa-4ae6-aa29-44e1fd3c08c8', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Portugal (4 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Lisbonne', 'LIS', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Porto', 'OPO', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Braga', 'BGZ', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Coimbra', 'CBP', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Funchal', 'FNC', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Setúbal', 'STB', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Almada', 'ALM-PT', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Amadora', 'AMD-PT', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Guimarães', 'GUI', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Évora', 'EVO', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Aveiro', 'AVR', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Faro', 'FAO', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Leiria', 'LEI', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Viseu', 'VIS', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Santarém', 'SNT', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0),
  ('Vila Nova de Gaia', 'VNG', '5094e867-5a3a-489d-901c-26a66e1f68d7', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- RDC (4 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Kinshasa', 'FIH', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Lubumbashi', 'FBM', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Mbuji-Mayi', 'MJM', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Kananga', 'KGA', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Kisangani', 'FKI', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Bukavu', 'BKY', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Goma', 'GOM', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Kolwezi', 'KWZ', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Likasi', 'LIQ', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Matadi', 'MAT', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Mbandaka', 'MDK', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Bandundu', 'FDU', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Butembo', 'BUX', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Uvira', 'UVR', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Beni', 'BNC', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0),
  ('Kikwit', 'KKW', '915ca6e9-ce50-497b-aa46-3e53c002c369', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Royaume-Uni (5 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Londres', 'LON', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Birmingham', 'BHX', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Manchester', 'MAN', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Glasgow', 'GLA', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Liverpool', 'LPL', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Leeds', 'LDS', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Sheffield', 'SHF', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Édimbourg', 'EDI', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Bristol', 'BRS', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Leicester', 'LCT', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Newcastle', 'NCL', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Nottingham', 'NTM', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Cardiff', 'CWL', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Belfast', 'BFS', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0),
  ('Southampton', 'SOU', 'fb308813-b290-4de1-a80f-0badf1cd8189', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Russie (4 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Moscou', 'MOW', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Saint-Pétersbourg', 'LED', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Novossibirsk', 'OVB', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Ekaterinbourg', 'SVX', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Kazan', 'KZN', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Nijni Novgorod', 'GOJ', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Tchéliabinsk', 'CEK', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Samara', 'KUF', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Omsk', 'OMS', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Rostov-sur-le-Don', 'ROV', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Oufa', 'UFA', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Krasnoïarsk', 'KJA', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Perm', 'PEE', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Voronej', 'VOZ', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Volgograd', 'VOG', 'b8f40142-e18f-4521-a075-aef888465663', 0),
  ('Krasnodar', 'KRR', 'b8f40142-e18f-4521-a075-aef888465663', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Sénégal (3 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Dakar', 'DKR', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Thiès', 'THS', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Saint-Louis', 'XLS', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Kaolack', 'KLC', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Ziguinchor', 'ZIG', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Mbour', 'MBR', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Touba', 'TBA', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Louga', 'LGA', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Tambacounda', 'TUD', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Diourbel', 'DRB', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Rufisque', 'RUF', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Kolda', 'KDA', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Matam', 'MTM', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Kédougou', 'KDG', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Richard-Toll', 'RTL', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Sédhiou', 'SDH', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0),
  ('Fatick', 'FTK', '1844e1c6-bb68-4af4-9a8a-58e29de3ace0', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Suisse (5 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Zurich', 'ZRH', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Genève', 'GVA', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Bâle', 'BSL', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Lausanne', 'LSN', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Berne', 'BRN', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Winterthour', 'WNT', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Lucerne', 'LUC', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Saint-Gall', 'ACH', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Lugano', 'LUG', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Bienne', 'BIL', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Thoune', 'THN', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Neuchâtel', 'NCH', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Fribourg', 'FRB', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Sion', 'SIO', '8c22687a-926c-4936-84d5-93aa0423de3f', 0),
  ('Schaffhouse', 'SHF-CH', '8c22687a-926c-4936-84d5-93aa0423de3f', 0)
ON CONFLICT (code_prefix) DO NOTHING;

-- Togo (3 -> 20)
INSERT INTO localities (name, code_prefix, country_id, member_count) VALUES
  ('Lomé', 'LFW', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Sokodé', 'SKD', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Kara', 'KRR-TG', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Kpalimé', 'KPL', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Atakpamé', 'ATP', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Bassar', 'BSR', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Tsévié', 'TSV', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Aného', 'ANH', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Dapaong', 'DPG', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Notsé', 'NOT', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Mango', 'MNG-TG', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Niamtougou', 'NIA', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Tabligbo', 'TAB', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Vogan', 'VOG-TG', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Badou', 'BDU', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Tchamba', 'TCB', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0),
  ('Kévé', 'KEV', '8ee3fc20-af0e-49b7-9534-fa63f0efc25c', 0)
ON CONFLICT (code_prefix) DO NOTHING;
