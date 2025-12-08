-- Insertion complète des pays et localités
-- Basé sur les captures d'écran fournies

-- Supprimer les données existantes
DELETE FROM localities;
DELETE FROM countries;

-- Insérer tous les pays
INSERT INTO countries (id, name, code, flag_emoji) VALUES
(UUID(), 'Afrique du Sud', 'ZA', '🇿🇦'),
(UUID(), 'Allemagne', 'DE', '🇩🇪'),
(UUID(), 'Argentine', 'AR', '🇦🇷'),
(UUID(), 'Belgique', 'BE', '🇧🇪'),
(UUID(), 'Bénin', 'BJ', '🇧🇯'),
(UUID(), 'Brésil', 'BR', '🇧🇷'),
(UUID(), 'Burkina Faso', 'BF', '🇧🇫'),
(UUID(), 'Cameroun', 'CM', '🇨🇲'),
(UUID(), 'Canada', 'CA', '🇨🇦'),
(UUID(), 'Chine', 'CN', '🇨🇳'),
(UUID(), 'Côte d\'Ivoire', 'CI', '🇨🇮'),
(UUID(), 'Égypte', 'EG', '🇪🇬'),
(UUID(), 'Espagne', 'ES', '🇪🇸'),
(UUID(), 'États-Unis', 'US', '🇺🇸'),
(UUID(), 'France', 'FR', '🇫🇷'),
(UUID(), 'Gabon', 'GA', '🇬🇦'),
(UUID(), 'Ghana', 'GH', '🇬🇭'),
(UUID(), 'Israël', 'IL', '🇮🇱'),
(UUID(), 'Italie', 'IT', '🇮🇹'),
(UUID(), 'Japon', 'JP', '🇯🇵'),
(UUID(), 'Luxembourg', 'LU', '🇱🇺'),
(UUID(), 'Madagascar', 'MG', '🇲🇬'),
(UUID(), 'Mali', 'ML', '🇲🇱'),
(UUID(), 'Maroc', 'MA', '🇲🇦'),
(UUID(), 'Mexique', 'MX', '🇲🇽'),
(UUID(), 'Nigeria', 'NG', '🇳🇬'),
(UUID(), 'Pays-Bas', 'NL', '🇳🇱'),
(UUID(), 'Portugal', 'PT', '🇵🇹'),
(UUID(), 'RDC', 'CD', '🇨🇩'),
(UUID(), 'Royaume-Uni', 'GB', '🇬🇧'),
(UUID(), 'Russie', 'RU', '🇷🇺'),
(UUID(), 'Sénégal', 'SN', '🇸🇳'),
(UUID(), 'Suisse', 'CH', '🇨🇭'),
(UUID(), 'Togo', 'TG', '🇹🇬');

-- France - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id) 
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'FR' LIMIT 1)
FROM (SELECT 'Paris' as name, 'PAR' as code_prefix UNION ALL
      SELECT 'Lyon', 'LYO' UNION ALL
      SELECT 'Marseille', 'MAR' UNION ALL
      SELECT 'Toulouse', 'TOU' UNION ALL
      SELECT 'Nice', 'NIC' UNION ALL
      SELECT 'Bordeaux', 'BOR' UNION ALL
      SELECT 'Lille', 'LIL' UNION ALL
      SELECT 'Nantes', 'NAN' UNION ALL
      SELECT 'Strasbourg', 'STR' UNION ALL
      SELECT 'Rennes', 'REN' UNION ALL
      SELECT 'Montpellier', 'MON' UNION ALL
      SELECT 'Reims', 'REI' UNION ALL
      SELECT 'Le Havre', 'LEH' UNION ALL
      SELECT 'Saint-Étienne', 'STE' UNION ALL
      SELECT 'Toulon', 'TLN' UNION ALL
      SELECT 'Grenoble', 'GRE' UNION ALL
      SELECT 'Dijon', 'DIJ' UNION ALL
      SELECT 'Angers', 'ANG' UNION ALL
      SELECT 'Nîmes', 'NIM' UNION ALL
      SELECT 'Villeurbanne', 'VIL') as t;

-- Belgique - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'BE' LIMIT 1)
FROM (SELECT 'Bruxelles' as name, 'BRU' as code_prefix UNION ALL
      SELECT 'Anvers', 'ANV' UNION ALL
      SELECT 'Gand', 'GAN' UNION ALL
      SELECT 'Charleroi', 'CHA' UNION ALL
      SELECT 'Liège', 'LIE' UNION ALL
      SELECT 'Bruges', 'BRG' UNION ALL
      SELECT 'Namur', 'NAM' UNION ALL
      SELECT 'Louvain', 'LOU' UNION ALL
      SELECT 'Mons', 'MON' UNION ALL
      SELECT 'Malines', 'MAL' UNION ALL
      SELECT 'Aalst', 'AAL' UNION ALL
      SELECT 'Courtrai', 'COU' UNION ALL
      SELECT 'Hasselt', 'HAS' UNION ALL
      SELECT 'Ostende', 'OST' UNION ALL
      SELECT 'Genk', 'GEN' UNION ALL
      SELECT 'Seraing', 'SER' UNION ALL
      SELECT 'Tournai', 'TRN' UNION ALL
      SELECT 'Mouscron', 'MOU' UNION ALL
      SELECT 'Verviers', 'VER' UNION ALL
      SELECT 'Dendermonde', 'DEN') as t;

-- Suisse - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'CH' LIMIT 1)
FROM (SELECT 'Zurich' as name, 'ZUR' as code_prefix UNION ALL
      SELECT 'Genève', 'GEN' UNION ALL
      SELECT 'Bâle', 'BAS' UNION ALL
      SELECT 'Lausanne', 'LAU' UNION ALL
      SELECT 'Berne', 'BER' UNION ALL
      SELECT 'Winterthur', 'WIN' UNION ALL
      SELECT 'Lucerne', 'LUC' UNION ALL
      SELECT 'Saint-Gall', 'STG' UNION ALL
      SELECT 'Lugano', 'LUG' UNION ALL
      SELECT 'Bienne', 'BIE' UNION ALL
      SELECT 'Thoune', 'THO' UNION ALL
      SELECT 'Köniz', 'KON' UNION ALL
      SELECT 'La Chaux-de-Fonds', 'CDF' UNION ALL
      SELECT 'Fribourg', 'FRI' UNION ALL
      SELECT 'Schaffhouse', 'SCH' UNION ALL
      SELECT 'Vernier', 'VRN' UNION ALL
      SELECT 'Neuchâtel', 'NEU' UNION ALL
      SELECT 'Sion', 'SIO' UNION ALL
      SELECT 'Nyon', 'NYO' UNION ALL
      SELECT 'Montreux', 'MTX') as t;

-- Canada - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'CA' LIMIT 1)
FROM (SELECT 'Montréal' as name, 'MTL' as code_prefix UNION ALL
      SELECT 'Toronto', 'TOR' UNION ALL
      SELECT 'Vancouver', 'VAN' UNION ALL
      SELECT 'Calgary', 'CAL' UNION ALL
      SELECT 'Ottawa', 'OTT' UNION ALL
      SELECT 'Edmonton', 'EDM' UNION ALL
      SELECT 'Québec', 'QUE' UNION ALL
      SELECT 'Winnipeg', 'WIN' UNION ALL
      SELECT 'Hamilton', 'HAM' UNION ALL
      SELECT 'Kitchener', 'KIT' UNION ALL
      SELECT 'London', 'LON' UNION ALL
      SELECT 'Victoria', 'VIC' UNION ALL
      SELECT 'Halifax', 'HAL' UNION ALL
      SELECT 'Oshawa', 'OSH' UNION ALL
      SELECT 'Windsor', 'WND' UNION ALL
      SELECT 'Saskatoon', 'SAS' UNION ALL
      SELECT 'Regina', 'REG' UNION ALL
      SELECT 'Sherbrooke', 'SHE' UNION ALL
      SELECT 'Gatineau', 'GAT' UNION ALL
      SELECT 'Laval', 'LAV') as t;

-- Côte d'Ivoire - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'CI' LIMIT 1)
FROM (SELECT 'Abidjan' as name, 'ABI' as code_prefix UNION ALL
      SELECT 'Bouaké', 'BOU' UNION ALL
      SELECT 'Daloa', 'DAL' UNION ALL
      SELECT 'San-Pédro', 'SAN' UNION ALL
      SELECT 'Yamoussoukro', 'YAM' UNION ALL
      SELECT 'Korhogo', 'KOR' UNION ALL
      SELECT 'Man', 'MAN' UNION ALL
      SELECT 'Divo', 'DIV' UNION ALL
      SELECT 'Gagnoa', 'GAG' UNION ALL
      SELECT 'Soubré', 'SOU' UNION ALL
      SELECT 'Abengourou', 'ABE' UNION ALL
      SELECT 'Agboville', 'AGB' UNION ALL
      SELECT 'Grand-Bassam', 'GBA' UNION ALL
      SELECT 'Bondoukou', 'BON' UNION ALL
      SELECT 'Odienné', 'ODI' UNION ALL
      SELECT 'Séguéla', 'SEG' UNION ALL
      SELECT 'Dabou', 'DAB' UNION ALL
      SELECT 'Issia', 'ISS' UNION ALL
      SELECT 'Adzopé', 'ADZ' UNION ALL
      SELECT 'Sassandra', 'SAS') as t;

-- Cameroun - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'CM' LIMIT 1)
FROM (SELECT 'Yaoundé' as name, 'YAO' as code_prefix UNION ALL
      SELECT 'Douala', 'DLA' UNION ALL
      SELECT 'Garoua', 'GAR' UNION ALL
      SELECT 'Bafoussam', 'BAF' UNION ALL
      SELECT 'Bamenda', 'BAM' UNION ALL
      SELECT 'Maroua', 'MAR' UNION ALL
      SELECT 'Nkongsamba', 'NKO' UNION ALL
      SELECT 'Ngaoundéré', 'NGA' UNION ALL
      SELECT 'Bertoua', 'BER' UNION ALL
      SELECT 'Limbé', 'LIM' UNION ALL
      SELECT 'Edéa', 'EDE' UNION ALL
      SELECT 'Kumba', 'KUM' UNION ALL
      SELECT 'Kribi', 'KRI' UNION ALL
      SELECT 'Buea', 'BUE' UNION ALL
      SELECT 'Dschang', 'DSC' UNION ALL
      SELECT 'Ebolowa', 'EBO' UNION ALL
      SELECT 'Foumban', 'FOU' UNION ALL
      SELECT 'Mbouda', 'MBO' UNION ALL
      SELECT 'Sangmélima', 'SAN' UNION ALL
      SELECT 'Bafia', 'BAI') as t;

-- Sénégal - 20 localités  
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'SN' LIMIT 1)
FROM (SELECT 'Dakar' as name, 'DAK' as code_prefix UNION ALL
      SELECT 'Thiès', 'THI' UNION ALL
      SELECT 'Saint-Louis', 'STL' UNION ALL
      SELECT 'Kaolack', 'KAO' UNION ALL
      SELECT 'Ziguinchor', 'ZIG' UNION ALL
      SELECT 'Diourbel', 'DIO' UNION ALL
      SELECT 'Louga', 'LOU' UNION ALL
      SELECT 'Tambacounda', 'TAM' UNION ALL
      SELECT 'Mbour', 'MBO' UNION ALL
      SELECT 'Rufisque', 'RUF' UNION ALL
      SELECT 'Kolda', 'KOL' UNION ALL
      SELECT 'Sédhiou', 'SED' UNION ALL
      SELECT 'Matam', 'MAT' UNION ALL
      SELECT 'Kédougou', 'KED' UNION ALL
      SELECT 'Richard Toll', 'RIC' UNION ALL
      SELECT 'Touba', 'TOU' UNION ALL
      SELECT 'Pikine', 'PIK' UNION ALL
      SELECT 'Guédiawaye', 'GUE' UNION ALL
      SELECT 'Fatick', 'FAT' UNION ALL
      SELECT 'Kaffrine', 'KAF') as t;

-- Bénin - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'BJ' LIMIT 1)
FROM (SELECT 'Cotonou' as name, 'COT' as code_prefix UNION ALL
      SELECT 'Porto-Novo', 'POR' UNION ALL
      SELECT 'Parakou', 'PAR' UNION ALL
      SELECT 'Abomey-Calavi', 'ABO' UNION ALL
      SELECT 'Djougou', 'DJO' UNION ALL
      SELECT 'Bohicon', 'BOH' UNION ALL
      SELECT 'Kandi', 'KAN' UNION ALL
      SELECT 'Lokossa', 'LOK' UNION ALL
      SELECT 'Ouidah', 'OUI' UNION ALL
      SELECT 'Abomey', 'ABM' UNION ALL
      SELECT 'Natitingou', 'NAT' UNION ALL
      SELECT 'Malanville', 'MAL' UNION ALL
      SELECT 'Savé', 'SAV' UNION ALL
      SELECT 'Pobé', 'POB' UNION ALL
      SELECT 'Kétou', 'KET' UNION ALL
      SELECT 'Sakété', 'SAK' UNION ALL
      SELECT 'Come', 'COM' UNION ALL
      SELECT 'Nikki', 'NIK' UNION ALL
      SELECT 'Savalou', 'SAL' UNION ALL
      SELECT 'Bembèrèkè', 'BEM') as t;

-- Togo - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'TG' LIMIT 1)
FROM (SELECT 'Lomé' as name, 'LOM' as code_prefix UNION ALL
      SELECT 'Sokodé', 'SOK' UNION ALL
      SELECT 'Kara', 'KAR' UNION ALL
      SELECT 'Atakpamé', 'ATA' UNION ALL
      SELECT 'Kpalimé', 'KPA' UNION ALL
      SELECT 'Dapaong', 'DAP' UNION ALL
      SELECT 'Tsévié', 'TSE' UNION ALL
      SELECT 'Notsé', 'NOT' UNION ALL
      SELECT 'Aného', 'ANE' UNION ALL
      SELECT 'Mango', 'MAN' UNION ALL
      SELECT 'Bassar', 'BAS' UNION ALL
      SELECT 'Vogan', 'VOG' UNION ALL
      SELECT 'Tabligbo', 'TAB' UNION ALL
      SELECT 'Tchamba', 'TCH' UNION ALL
      SELECT 'Sotouboua', 'SOT' UNION ALL
      SELECT 'Bafilo', 'BAF' UNION ALL
      SELECT 'Niamtougou', 'NIA' UNION ALL
      SELECT 'Kandé', 'KND' UNION ALL
      SELECT 'Badou', 'BAD' UNION ALL
      SELECT 'Amlamé', 'AML') as t;

-- Burkina Faso - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'BF' LIMIT 1)
FROM (SELECT 'Ouagadougou' as name, 'OUA' as code_prefix UNION ALL
      SELECT 'Bobo-Dioulasso', 'BOB' UNION ALL
      SELECT 'Koudougou', 'KOU' UNION ALL
      SELECT 'Ouahigouya', 'OHI' UNION ALL
      SELECT 'Banfora', 'BAN' UNION ALL
      SELECT 'Dédougou', 'DED' UNION ALL
      SELECT 'Kaya', 'KAY' UNION ALL
      SELECT 'Tenkodogo', 'TEN' UNION ALL
      SELECT 'Fada N\'Gourma', 'FAD' UNION ALL
      SELECT 'Houndé', 'HOU' UNION ALL
      SELECT 'Réo', 'REO' UNION ALL
      SELECT 'Manga', 'MAN' UNION ALL
      SELECT 'Dori', 'DOR' UNION ALL
      SELECT 'Gaoua', 'GAO' UNION ALL
      SELECT 'Ziniaré', 'ZIN' UNION ALL
      SELECT 'Po', 'POO' UNION ALL
      SELECT 'Djibo', 'DJI' UNION ALL
      SELECT 'Nouna', 'NOU' UNION ALL
      SELECT 'Bogandé', 'BOG' UNION ALL
      SELECT 'Kongoussi', 'KON') as t;

-- Mali - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'ML' LIMIT 1)
FROM (SELECT 'Bamako' as name, 'BAM' as code_prefix UNION ALL
      SELECT 'Sikasso', 'SIK' UNION ALL
      SELECT 'Mopti', 'MOP' UNION ALL
      SELECT 'Koutiala', 'KOU' UNION ALL
      SELECT 'Ségou', 'SEG' UNION ALL
      SELECT 'Kayes', 'KAY' UNION ALL
      SELECT 'Gao', 'GAO' UNION ALL
      SELECT 'Tombouctou', 'TOM' UNION ALL
      SELECT 'Kati', 'KAT' UNION ALL
      SELECT 'Koulikoro', 'KLI' UNION ALL
      SELECT 'San', 'SAN' UNION ALL
      SELECT 'Markala', 'MAR' UNION ALL
      SELECT 'Kolokani', 'KOL' UNION ALL
      SELECT 'Djenné', 'DJE' UNION ALL
      SELECT 'Bandiagara', 'BAN' UNION ALL
      SELECT 'Kidal', 'KID' UNION ALL
      SELECT 'Nioro', 'NIO' UNION ALL
      SELECT 'Bougouni', 'BOU' UNION ALL
      SELECT 'Yorosso', 'YOR' UNION ALL
      SELECT 'Kangaba', 'KAN') as t;

-- Gabon - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'GA' LIMIT 1)
FROM (SELECT 'Libreville' as name, 'LIB' as code_prefix UNION ALL
      SELECT 'Port-Gentil', 'PGE' UNION ALL
      SELECT 'Franceville', 'FRA' UNION ALL
      SELECT 'Oyem', 'OYE' UNION ALL
      SELECT 'Moanda', 'MOA' UNION ALL
      SELECT 'Mouila', 'MOU' UNION ALL
      SELECT 'Lambaréné', 'LAM' UNION ALL
      SELECT 'Tchibanga', 'TCH' UNION ALL
      SELECT 'Koulamoutou', 'KOU' UNION ALL
      SELECT 'Makokou', 'MAK' UNION ALL
      SELECT 'Bitam', 'BIT' UNION ALL
      SELECT 'Gamba', 'GAM' UNION ALL
      SELECT 'Ntoum', 'NTO' UNION ALL
      SELECT 'Omboué', 'OMB' UNION ALL
      SELECT 'Mounana', 'MNA' UNION ALL
      SELECT 'Akieni', 'AKI' UNION ALL
      SELECT 'Lastoursville', 'LAS' UNION ALL
      SELECT 'Fougamou', 'FOU' UNION ALL
      SELECT 'Mimongo', 'MIM' UNION ALL
      SELECT 'Mayumba', 'MAY') as t;

-- RDC (République Démocratique du Congo) - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'CD' LIMIT 1)
FROM (SELECT 'Kinshasa' as name, 'KIN' as code_prefix UNION ALL
      SELECT 'Lubumbashi', 'LUB' UNION ALL
      SELECT 'Mbuji-Mayi', 'MBU' UNION ALL
      SELECT 'Kananga', 'KAN' UNION ALL
      SELECT 'Kisangani', 'KIS' UNION ALL
      SELECT 'Bukavu', 'BUK' UNION ALL
      SELECT 'Goma', 'GOM' UNION ALL
      SELECT 'Kolwezi', 'KOL' UNION ALL
      SELECT 'Likasi', 'LIK' UNION ALL
      SELECT 'Matadi', 'MAT' UNION ALL
      SELECT 'Boma', 'BOM' UNION ALL
      SELECT 'Mbandaka', 'MBA' UNION ALL
      SELECT 'Butembo', 'BUT' UNION ALL
      SELECT 'Uvira', 'UVI' UNION ALL
      SELECT 'Beni', 'BEN' UNION ALL
      SELECT 'Kikwit', 'KIK' UNION ALL
      SELECT 'Tshikapa', 'TSH' UNION ALL
      SELECT 'Bandundu', 'BAN' UNION ALL
      SELECT 'Gbadolite', 'GBA' UNION ALL
      SELECT 'Gemena', 'GEM') as t;

-- Maroc - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'MA' LIMIT 1)
FROM (SELECT 'Casablanca' as name, 'CAS' as code_prefix UNION ALL
      SELECT 'Rabat', 'RAB' UNION ALL
      SELECT 'Fès', 'FES' UNION ALL
      SELECT 'Marrakech', 'MAR' UNION ALL
      SELECT 'Tanger', 'TAN' UNION ALL
      SELECT 'Agadir', 'AGA' UNION ALL
      SELECT 'Meknès', 'MEK' UNION ALL
      SELECT 'Oujda', 'OUJ' UNION ALL
      SELECT 'Kénitra', 'KEN' UNION ALL
      SELECT 'Tétouan', 'TET' UNION ALL
      SELECT 'Salé', 'SAL' UNION ALL
      SELECT 'Safi', 'SAF' UNION ALL
      SELECT 'Mohammedia', 'MOH' UNION ALL
      SELECT 'El Jadida', 'ELJ' UNION ALL
      SELECT 'Khouribga', 'KHO' UNION ALL
      SELECT 'Béni Mellal', 'BEN' UNION ALL
      SELECT 'Nador', 'NAD' UNION ALL
      SELECT 'Taza', 'TAZ' UNION ALL
      SELECT 'Settat', 'SET' UNION ALL
      SELECT 'Errachidia', 'ERR') as t;

-- Nigeria - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'NG' LIMIT 1)
FROM (SELECT 'Lagos' as name, 'LAG' as code_prefix UNION ALL
      SELECT 'Abuja', 'ABU' UNION ALL
      SELECT 'Kano', 'KAN' UNION ALL
      SELECT 'Ibadan', 'IBA' UNION ALL
      SELECT 'Port Harcourt', 'PHC' UNION ALL
      SELECT 'Benin City', 'BEN' UNION ALL
      SELECT 'Kaduna', 'KAD' UNION ALL
      SELECT 'Enugu', 'ENU' UNION ALL
      SELECT 'Zaria', 'ZAR' UNION ALL
      SELECT 'Warri', 'WAR' UNION ALL
      SELECT 'Ilorin', 'ILO' UNION ALL
      SELECT 'Jos', 'JOS' UNION ALL
      SELECT 'Aba', 'ABA' UNION ALL
      SELECT 'Calabar', 'CAL' UNION ALL
      SELECT 'Akure', 'AKU' UNION ALL
      SELECT 'Abeokuta', 'ABE' UNION ALL
      SELECT 'Onitsha', 'ONI' UNION ALL
      SELECT 'Sokoto', 'SOK' UNION ALL
      SELECT 'Osogbo', 'OSO' UNION ALL
      SELECT 'Maiduguri', 'MAI') as t;

-- Ghana - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'GH' LIMIT 1)
FROM (SELECT 'Accra' as name, 'ACC' as code_prefix UNION ALL
      SELECT 'Kumasi', 'KUM' UNION ALL
      SELECT 'Tamale', 'TAM' UNION ALL
      SELECT 'Takoradi', 'TAK' UNION ALL
      SELECT 'Ashaiman', 'ASH' UNION ALL
      SELECT 'Tema', 'TEM' UNION ALL
      SELECT 'Cape Coast', 'CAP' UNION ALL
      SELECT 'Obuasi', 'OBU' UNION ALL
      SELECT 'Teshie', 'TES' UNION ALL
      SELECT 'Madina', 'MAD' UNION ALL
      SELECT 'Koforidua', 'KOF' UNION ALL
      SELECT 'Wa', 'WAA' UNION ALL
      SELECT 'Techiman', 'TEC' UNION ALL
      SELECT 'Ho', 'HOO' UNION ALL
      SELECT 'Sunyani', 'SUN' UNION ALL
      SELECT 'Bolgatanga', 'BOL' UNION ALL
      SELECT 'Nungua', 'NUN' UNION ALL
      SELECT 'Lashibi', 'LAS' UNION ALL
      SELECT 'Dome', 'DOM' UNION ALL
      SELECT 'Winneba', 'WIN') as t;

-- Autres pays avec localités principales (10-20 par pays pour ne pas alourdir)

-- Allemagne - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'DE' LIMIT 1)
FROM (SELECT 'Berlin' as name, 'BER' as code_prefix UNION ALL
      SELECT 'Munich', 'MUN' UNION ALL
      SELECT 'Hambourg', 'HAM' UNION ALL
      SELECT 'Francfort', 'FRA' UNION ALL
      SELECT 'Cologne', 'COL' UNION ALL
      SELECT 'Stuttgart', 'STU' UNION ALL
      SELECT 'Düsseldorf', 'DUS' UNION ALL
      SELECT 'Dortmund', 'DOR' UNION ALL
      SELECT 'Essen', 'ESS' UNION ALL
      SELECT 'Leipzig', 'LEI' UNION ALL
      SELECT 'Brême', 'BRE' UNION ALL
      SELECT 'Dresde', 'DRE' UNION ALL
      SELECT 'Hanovre', 'HAN' UNION ALL
      SELECT 'Nuremberg', 'NUR' UNION ALL
      SELECT 'Duisbourg', 'DUI' UNION ALL
      SELECT 'Bochum', 'BOC' UNION ALL
      SELECT 'Wuppertal', 'WUP' UNION ALL
      SELECT 'Bielefeld', 'BIE' UNION ALL
      SELECT 'Bonn', 'BON' UNION ALL
      SELECT 'Münster', 'MUN') as t;

-- Luxembourg - 12 localités (pays plus petit)
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'LU' LIMIT 1)
FROM (SELECT 'Luxembourg' as name, 'LUX' as code_prefix UNION ALL
      SELECT 'Esch-sur-Alzette', 'ESC' UNION ALL
      SELECT 'Differdange', 'DIF' UNION ALL
      SELECT 'Dudelange', 'DUD' UNION ALL
      SELECT 'Ettelbruck', 'ETT' UNION ALL
      SELECT 'Diekirch', 'DIE' UNION ALL
      SELECT 'Wiltz', 'WIL' UNION ALL
      SELECT 'Echternach', 'ECH' UNION ALL
      SELECT 'Rumelange', 'RUM' UNION ALL
      SELECT 'Grevenmacher', 'GRE' UNION ALL
      SELECT 'Pétange', 'PET' UNION ALL
      SELECT 'Mersch', 'MER') as t;

-- Espagne - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'ES' LIMIT 1)
FROM (SELECT 'Madrid' as name, 'MAD' as code_prefix UNION ALL
      SELECT 'Barcelone', 'BAR' UNION ALL
      SELECT 'Valence', 'VAL' UNION ALL
      SELECT 'Séville', 'SEV' UNION ALL
      SELECT 'Saragosse', 'ZAR' UNION ALL
      SELECT 'Málaga', 'MAL' UNION ALL
      SELECT 'Murcie', 'MUR' UNION ALL
      SELECT 'Palma', 'PAL' UNION ALL
      SELECT 'Las Palmas', 'LPA' UNION ALL
      SELECT 'Bilbao', 'BIL' UNION ALL
      SELECT 'Alicante', 'ALI' UNION ALL
      SELECT 'Cordoue', 'COR' UNION ALL
      SELECT 'Valladolid', 'VLL' UNION ALL
      SELECT 'Vigo', 'VIG' UNION ALL
      SELECT 'Gijón', 'GIJ' UNION ALL
      SELECT 'Hospitalet', 'HOS' UNION ALL
      SELECT 'Vitoria', 'VIT' UNION ALL
      SELECT 'La Coruña', 'COR' UNION ALL
      SELECT 'Grenade', 'GRE' UNION ALL
      SELECT 'Elche', 'ELC') as t;

-- Italie - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'IT' LIMIT 1)
FROM (SELECT 'Rome' as name, 'ROM' as code_prefix UNION ALL
      SELECT 'Milan', 'MIL' UNION ALL
      SELECT 'Naples', 'NAP' UNION ALL
      SELECT 'Turin', 'TUR' UNION ALL
      SELECT 'Palerme', 'PAL' UNION ALL
      SELECT 'Gênes', 'GEN' UNION ALL
      SELECT 'Bologne', 'BOL' UNION ALL
      SELECT 'Florence', 'FLO' UNION ALL
      SELECT 'Bari', 'BAR' UNION ALL
      SELECT 'Catane', 'CAT' UNION ALL
      SELECT 'Venise', 'VEN' UNION ALL
      SELECT 'Vérone', 'VER' UNION ALL
      SELECT 'Messine', 'MES' UNION ALL
      SELECT 'Padoue', 'PAD' UNION ALL
      SELECT 'Trieste', 'TRI' UNION ALL
      SELECT 'Brescia', 'BRE' UNION ALL
      SELECT 'Parme', 'PAR' UNION ALL
      SELECT 'Modène', 'MOD' UNION ALL
      SELECT 'Reggio Calabria', 'REG' UNION ALL
      SELECT 'Pérouse', 'PER') as t;

-- Portugal - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'PT' LIMIT 1)
FROM (SELECT 'Lisbonne' as name, 'LIS' as code_prefix UNION ALL
      SELECT 'Porto', 'POR' UNION ALL
      SELECT 'Braga', 'BRA' UNION ALL
      SELECT 'Amadora', 'AMA' UNION ALL
      SELECT 'Setúbal', 'SET' UNION ALL
      SELECT 'Coimbra', 'COI' UNION ALL
      SELECT 'Funchal', 'FUN' UNION ALL
      SELECT 'Almada', 'ALM' UNION ALL
      SELECT 'Queluz', 'QUE' UNION ALL
      SELECT 'Évora', 'EVO' UNION ALL
      SELECT 'Rio Tinto', 'RIO' UNION ALL
      SELECT 'Faro', 'FAR' UNION ALL
      SELECT 'Aveiro', 'AVE' UNION ALL
      SELECT 'Viseu', 'VIS' UNION ALL
      SELECT 'Guimarães', 'GUI' UNION ALL
      SELECT 'Leiria', 'LEI' UNION ALL
      SELECT 'Vila Nova', 'VNO' UNION ALL
      SELECT 'Portimão', 'PTM' UNION ALL
      SELECT 'Santarém', 'SAN' UNION ALL
      SELECT 'Beja', 'BEJ') as t;

-- Royaume-Uni - 20 localités
INSERT INTO localities (id, name, code_prefix, member_count, country_id)
SELECT UUID(), name, code_prefix, 0, (SELECT id FROM countries WHERE code = 'GB' LIMIT 1)
FROM (SELECT 'Londres' as name, 'LON' as code_prefix UNION ALL
      SELECT 'Birmingham', 'BIR' UNION ALL
      SELECT 'Manchester', 'MAN' UNION ALL
      SELECT 'Glasgow', 'GLA' UNION ALL
      SELECT 'Liverpool', 'LIV' UNION ALL
      SELECT 'Leeds', 'LEE' UNION ALL
      SELECT 'Sheffield', 'SHE' UNION ALL
      SELECT 'Édimbourg', 'EDI' UNION ALL
      SELECT 'Bristol', 'BRI' UNION ALL
      SELECT 'Cardiff', 'CAR' UNION ALL
      SELECT 'Leicester', 'LEI' UNION ALL
      SELECT 'Coventry', 'COV' UNION ALL
      SELECT 'Bradford', 'BRA' UNION ALL
      SELECT 'Belfast', 'BEL' UNION ALL
      SELECT 'Nottingham', 'NOT' UNION ALL
      SELECT 'Newcastle', 'NEW' UNION ALL
      SELECT 'Plymouth', 'PLY' UNION ALL
      SELECT 'Southampton', 'SOU' UNION ALL
      SELECT 'Reading', 'REA' UNION ALL
      SELECT 'Derby', 'DER') as t;
