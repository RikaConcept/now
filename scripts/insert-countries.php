#!/usr/bin/env php
<?php

/**
 * Script d'insertion des pays et localités
 * À exécuter après l'import du schema.sql
 */

require_once __DIR__ . '/../backend/config/database.php';
require_once __DIR__ . '/../backend/utils/UUID.php';

echo "=== Insertion des pays et localités ===\n\n";

try {
    $db = Database::getInstance();
    
    // Supprimer anciennes données
    echo "Nettoyage des anciennes données...\n";
    $db->query("DELETE FROM localities");
    $db->query("DELETE FROM countries");
    
    // Définition des pays avec leurs localités
    $countries = [
        'France' => ['FR', '🇫🇷', ['Paris', 'Lyon', 'Marseille', 'Toulouse', 'Nice', 'Bordeaux', 'Lille', 'Nantes', 'Strasbourg', 'Rennes', 'Montpellier', 'Reims', 'Le Havre', 'Saint-Étienne', 'Toulon', 'Grenoble', 'Dijon', 'Angers', 'Nîmes', 'Villeurbanne']],
        'Belgique' => ['BE', '🇧🇪', ['Bruxelles', 'Anvers', 'Gand', 'Charleroi', 'Liège', 'Bruges', 'Namur', 'Louvain', 'Mons', 'Malines', 'Aalst', 'Courtrai', 'Hasselt', 'Ostende', 'Genk', 'Seraing', 'Tournai', 'Mouscron', 'Verviers', 'Dendermonde']],
        'Suisse' => ['CH', '🇨🇭', ['Zurich', 'Genève', 'Bâle', 'Lausanne', 'Berne', 'Winterthur', 'Lucerne', 'Saint-Gall', 'Lugano', 'Bienne', 'Thoune', 'Köniz', 'La Chaux-de-Fonds', 'Fribourg', 'Schaffhouse', 'Vernier', 'Neuchâtel', 'Sion', 'Nyon', 'Montreux']],
        'Canada' => ['CA', '🇨🇦', ['Montréal', 'Toronto', 'Vancouver', 'Calgary', 'Ottawa', 'Edmonton', 'Québec', 'Winnipeg', 'Hamilton', 'Kitchener', 'London', 'Victoria', 'Halifax', 'Oshawa', 'Windsor', 'Saskatoon', 'Regina', 'Sherbrooke', 'Gatineau', 'Laval']],
        'Côte d\'Ivoire' => ['CI', '🇨🇮', ['Abidjan', 'Bouaké', 'Daloa', 'San-Pédro', 'Yamoussoukro', 'Korhogo', 'Man', 'Divo', 'Gagnoa', 'Soubré', 'Abengourou', 'Agboville', 'Grand-Bassam', 'Bondoukou', 'Odienné', 'Séguéla', 'Dabou', 'Issia', 'Adzopé', 'Sassandra']],
        'Cameroun' => ['CM', '🇨🇲', ['Yaoundé', 'Douala', 'Garoua', 'Bafoussam', 'Bamenda', 'Maroua', 'Nkongsamba', 'Ngaoundéré', 'Bertoua', 'Limbé', 'Edéa', 'Kumba', 'Kribi', 'Buea', 'Dschang', 'Ebolowa', 'Foumban', 'Mbouda', 'Sangmélima', 'Bafia']],
        'Sénégal' => ['SN', '🇸🇳', ['Dakar', 'Thiès', 'Saint-Louis', 'Kaolack', 'Ziguinchor', 'Diourbel', 'Louga', 'Tambacounda', 'Mbour', 'Rufisque', 'Kolda', 'Sédhiou', 'Matam', 'Kédougou', 'Richard Toll', 'Touba', 'Pikine', 'Guédiawaye', 'Fatick', 'Kaffrine']],
        'Bénin' => ['BJ', '🇧🇯', ['Cotonou', 'Porto-Novo', 'Parakou', 'Abomey-Calavi', 'Djougou', 'Bohicon', 'Kandi', 'Lokossa', 'Ouidah', 'Abomey', 'Natitingou', 'Malanville', 'Savé', 'Pobé', 'Kétou', 'Sakété', 'Comé', 'Nikki', 'Savalou', 'Bembèrèkè']],
        'Togo' => ['TG', '🇹🇬', ['Lomé', 'Sokodé', 'Kara', 'Atakpamé', 'Kpalimé', 'Dapaong', 'Tsévié', 'Notsé', 'Aného', 'Mango', 'Bassar', 'Vogan', 'Tabligbo', 'Tchamba', 'Sotouboua', 'Bafilo', 'Niamtougou', 'Kandé', 'Badou', 'Amlamé']],
        'Burkina Faso' => ['BF', '🇧🇫', ['Ouagadougou', 'Bobo-Dioulasso', 'Koudougou', 'Ouahigouya', 'Banfora', 'Dédougou', 'Kaya', 'Tenkodogo', 'Fada N\'Gourma', 'Houndé', 'Réo', 'Manga', 'Dori', 'Gaoua', 'Ziniaré', 'Po', 'Djibo', 'Nouna', 'Bogandé', 'Kongoussi']],
        'Mali' => ['ML', '🇲🇱', ['Bamako', 'Sikasso', 'Mopti', 'Koutiala', 'Ségou', 'Kayes', 'Gao', 'Tombouctou', 'Kati', 'Koulikoro', 'San', 'Markala', 'Kolokani', 'Djenné', 'Bandiagara', 'Kidal', 'Nioro', 'Bougouni', 'Yorosso', 'Kangaba']],
        'Gabon' => ['GA', '🇬🇦', ['Libreville', 'Port-Gentil', 'Franceville', 'Oyem', 'Moanda', 'Mouila', 'Lambaréné', 'Tchibanga', 'Koulamoutou', 'Makokou', 'Bitam', 'Gamba', 'Ntoum', 'Omboué', 'Mounana', 'Akieni', 'Lastoursville', 'Fougamou', 'Mimongo', 'Mayumba']],
        'RDC' => ['CD', '🇨🇩', ['Kinshasa', 'Lubumbashi', 'Mbuji-Mayi', 'Kananga', 'Kisangani', 'Bukavu', 'Goma', 'Kolwezi', 'Likasi', 'Matadi', 'Boma', 'Mbandaka', 'Butembo', 'Uvira', 'Beni', 'Kikwit', 'Tshikapa', 'Bandundu', 'Gbadolite', 'Gemena']],
        'Maroc' => ['MA', '🇲🇦', ['Casablanca', 'Rabat', 'Fès', 'Marrakech', 'Tanger', 'Agadir', 'Meknès', 'Oujda', 'Kénitra', 'Tétouan', 'Salé', 'Safi', 'Mohammedia', 'El Jadida', 'Khouribga', 'Béni Mellal', 'Nador', 'Taza', 'Settat', 'Errachidia']],
        'Nigeria' => ['NG', '🇳🇬', ['Lagos', 'Abuja', 'Kano', 'Ibadan', 'Port Harcourt', 'Benin City', 'Kaduna', 'Enugu', 'Zaria', 'Warri', 'Ilorin', 'Jos', 'Aba', 'Calabar', 'Akure', 'Abeokuta', 'Onitsha', 'Sokoto', 'Osogbo', 'Maiduguri']],
        'Ghana' => ['GH', '🇬🇭', ['Accra', 'Kumasi', 'Tamale', 'Takoradi', 'Ashaiman', 'Tema', 'Cape Coast', 'Obuasi', 'Teshie', 'Madina', 'Koforidua', 'Wa', 'Techiman', 'Ho', 'Sunyani', 'Bolgatanga', 'Nungua', 'Lashibi', 'Dome', 'Winneba']],
        'Allemagne' => ['DE', '🇩🇪', ['Berlin', 'Munich', 'Hambourg', 'Francfort', 'Cologne', 'Stuttgart', 'Düsseldorf', 'Dortmund', 'Essen', 'Leipzig', 'Brême', 'Dresde', 'Hanovre', 'Nuremberg', 'Duisbourg', 'Bochum', 'Wuppertal', 'Bielefeld', 'Bonn', 'Münster']],
        'Luxembourg' => ['LU', '🇱🇺', ['Luxembourg', 'Esch-sur-Alzette', 'Differdange', 'Dudelange', 'Ettelbruck', 'Diekirch', 'Wiltz', 'Echternach', 'Rumelange', 'Grevenmacher', 'Pétange', 'Mersch', 'Clervaux', 'Remich', 'Vianden', 'Redange', 'Mondorf', 'Steinfort', 'Bascharage', 'Bertrange']],
        'Espagne' => ['ES', '🇪🇸', ['Madrid', 'Barcelone', 'Valence', 'Séville', 'Saragosse', 'Málaga', 'Murcie', 'Palma', 'Las Palmas', 'Bilbao', 'Alicante', 'Cordoue', 'Valladolid', 'Vigo', 'Gijón', 'Hospitalet', 'Vitoria', 'La Coruña', 'Grenade', 'Elche']],
        'Italie' => ['IT', '🇮🇹', ['Rome', 'Milan', 'Naples', 'Turin', 'Palerme', 'Gênes', 'Bologne', 'Florence', 'Bari', 'Catane', 'Venise', 'Vérone', 'Messine', 'Padoue', 'Trieste', 'Brescia', 'Parme', 'Modène', 'Reggio Calabria', 'Pérouse']],
        'Portugal' => ['PT', '🇵🇹', ['Lisbonne', 'Porto', 'Braga', 'Amadora', 'Setúbal', 'Coimbra', 'Funchal', 'Almada', 'Queluz', 'Évora', 'Rio Tinto', 'Faro', 'Aveiro', 'Viseu', 'Guimarães', 'Leiria', 'Vila Nova', 'Portimão', 'Santarém', 'Beja']],
        'Royaume-Uni' => ['GB', '🇬🇧', ['Londres', 'Birmingham', 'Manchester', 'Glasgow', 'Liverpool', 'Leeds', 'Sheffield', 'Édimbourg', 'Bristol', 'Cardiff', 'Leicester', 'Coventry', 'Bradford', 'Belfast', 'Nottingham', 'Newcastle', 'Plymouth', 'Southampton', 'Reading', 'Derby']],
        'Afrique du Sud' => ['ZA', '🇿🇦', ['Johannesburg', 'Le Cap', 'Durban', 'Pretoria', 'Port Elizabeth', 'Bloemfontein', 'East London', 'Pietermaritzburg', 'Kimberley', 'Nelspruit', 'Polokwane', 'Rustenburg', 'George', 'Middelburg', 'Witbank', 'Vereeniging', 'Benoni', 'Boksburg', 'Soweto', 'Centurion']],
        'Égypte' => ['EG', '🇪🇬', ['Le Caire', 'Alexandrie', 'Gizeh', 'Charm el-Cheikh', 'Louxor', 'Assouan', 'Hurghada', 'Port-Saïd', 'Suez', 'Ismaïlia', 'Tanta', 'Mansoura', 'Assiout', 'Zagazig', 'Fayoum', 'Damanhour', 'Minya', 'Beni Suef', 'Qena', 'Sohag']],
        'Maroc' => ['MA', '🇲🇦', ['Casablanca', 'Rabat', 'Fès', 'Marrakech', 'Tanger', 'Agadir', 'Meknès', 'Oujda', 'Kénitra', 'Tétouan', 'Salé', 'Safi', 'Mohammedia', 'El Jadida', 'Khouribga', 'Béni Mellal', 'Nador', 'Taza', 'Settat', 'Errachidia']],
    ];
    
    $totalCountries = 0;
    $totalLocalities = 0;
    $usedCodes = [];
    
    foreach ($countries as $countryName => [$code, $flag, $cities]) {
        // Insérer le pays
        $countryId = UUID::v4();
        $db->query(
            "INSERT INTO countries (id, name, code, flag_emoji, created_at) VALUES (?, ?, ?, ?, NOW())",
            [$countryId, $countryName, $code, $flag]
        );
        $totalCountries++;
        echo "✓ Pays ajouté: $countryName ($code)\n";
        
        // Insérer les localités avec codes uniques
        $cityCount = 0;
        foreach ($cities as $city) {
            $localityId = UUID::v4();
            
            // Générer un code unique en utilisant pays + ville
            $baseCode = $code . '-' . strtoupper(substr(preg_replace('/[^A-Za-z]/', '', $city), 0, 3));
            $codePrefix = $baseCode;
            $counter = 1;
            
            // Si le code existe déjà, ajouter un numéro
            while (in_array($codePrefix, $usedCodes)) {
                $codePrefix = $baseCode . $counter;
                $counter++;
            }
            
            $usedCodes[] = $codePrefix;
            
            $db->query(
                "INSERT INTO localities (id, name, code_prefix, member_count, country_id, created_at) VALUES (?, ?, ?, 0, ?, NOW())",
                [$localityId, $city, $codePrefix, $countryId]
            );
            $cityCount++;
            $totalLocalities++;
        }
        echo "  → $cityCount villes ajoutées\n";
    }
    
    echo "\n=== Résumé ===\n";
    echo "Pays insérés: $totalCountries\n";
    echo "Localités insérées: $totalLocalities\n\n";
    echo "✓ Insertion terminée avec succès!\n";
    
} catch (Exception $e) {
    echo "✗ Erreur: " . $e->getMessage() . "\n";
    exit(1);
}
