/*
  # Générer les codes de parrainage pour les membres actifs

  1. Objectif
    - Générer automatiquement un code de parrainage pour tous les membres actifs qui n'en ont pas
    - Créer une fonction trigger pour générer automatiquement un code lors de l'activation d'un membre

  2. Changements
    - Mise à jour des membres actifs sans code de parrainage
    - Création d'une fonction pour générer un code unique
    - Ajout d'un trigger sur l'activation des membres
*/

-- Fonction pour générer un code de parrainage unique
CREATE OR REPLACE FUNCTION generate_unique_referral_code()
RETURNS TEXT AS $$
DECLARE
  new_code TEXT;
  code_exists BOOLEAN;
BEGIN
  LOOP
    -- Générer un code aléatoire de 8 caractères (lettres majuscules et chiffres)
    new_code := upper(substr(md5(random()::text || clock_timestamp()::text), 1, 8));
    
    -- Vérifier si le code existe déjà
    SELECT EXISTS(SELECT 1 FROM members WHERE referral_code = new_code) INTO code_exists;
    
    -- Si le code n'existe pas, on le retourne
    IF NOT code_exists THEN
      RETURN new_code;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Fonction trigger pour générer automatiquement un code de parrainage lors de l'activation
CREATE OR REPLACE FUNCTION auto_generate_referral_code()
RETURNS TRIGGER AS $$
BEGIN
  -- Si le statut passe à 'active' et qu'il n'y a pas de referral_code
  IF NEW.status = 'active' AND (OLD.status IS NULL OR OLD.status != 'active') AND NEW.referral_code IS NULL THEN
    NEW.referral_code := generate_unique_referral_code();
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger si il n'existe pas déjà
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trigger_auto_generate_referral_code'
  ) THEN
    CREATE TRIGGER trigger_auto_generate_referral_code
      BEFORE INSERT OR UPDATE ON members
      FOR EACH ROW
      EXECUTE FUNCTION auto_generate_referral_code();
  END IF;
END $$;

-- Générer les codes de parrainage pour les membres actifs existants qui n'en ont pas
UPDATE members
SET referral_code = generate_unique_referral_code()
WHERE status = 'active' AND referral_code IS NULL;
