/*
  # Ajouter les politiques admin pour toutes les tables

  1. Objectif
    - Permettre aux administrateurs de voir et gérer toutes les données (membres, commandes, demandes de produits)
    - Maintenir la sécurité pour les utilisateurs normaux

  2. Changements
    - Ajout de politiques SELECT pour les admins sur members
    - Ajout de politiques SELECT et UPDATE pour les admins sur orders
    - Ajout de politiques SELECT et UPDATE pour les admins sur product_requests
    - Utilisation de admin_users.user_id pour la vérification
*/

-- Politiques admin pour la table members
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'members' AND policyname = 'Admins can view all members'
  ) THEN
    CREATE POLICY "Admins can view all members"
      ON members FOR SELECT
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM admin_users
          WHERE admin_users.user_id = auth.uid()
        )
      );
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'members' AND policyname = 'Admins can update all members'
  ) THEN
    CREATE POLICY "Admins can update all members"
      ON members FOR UPDATE
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM admin_users
          WHERE admin_users.user_id = auth.uid()
        )
      );
  END IF;
END $$;

-- Politiques admin pour la table orders
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'orders' AND policyname = 'Admins can view all orders'
  ) THEN
    CREATE POLICY "Admins can view all orders"
      ON orders FOR SELECT
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM admin_users
          WHERE admin_users.user_id = auth.uid()
        )
      );
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'orders' AND policyname = 'Admins can update all orders'
  ) THEN
    CREATE POLICY "Admins can update all orders"
      ON orders FOR UPDATE
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM admin_users
          WHERE admin_users.user_id = auth.uid()
        )
      );
  END IF;
END $$;

-- Politiques admin pour la table product_requests
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'product_requests' AND policyname = 'Admins can view all product requests'
  ) THEN
    CREATE POLICY "Admins can view all product requests"
      ON product_requests FOR SELECT
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM admin_users
          WHERE admin_users.user_id = auth.uid()
        )
      );
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'product_requests' AND policyname = 'Admins can update all product requests'
  ) THEN
    CREATE POLICY "Admins can update all product requests"
      ON product_requests FOR UPDATE
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM admin_users
          WHERE admin_users.user_id = auth.uid()
        )
      );
  END IF;
END $$;

-- Politiques admin pour la table referrals
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'referrals' AND policyname = 'Admins can view all referrals'
  ) THEN
    CREATE POLICY "Admins can view all referrals"
      ON referrals FOR SELECT
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM admin_users
          WHERE admin_users.user_id = auth.uid()
        )
      );
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'referrals' AND policyname = 'Admins can update all referrals'
  ) THEN
    CREATE POLICY "Admins can update all referrals"
      ON referrals FOR UPDATE
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM admin_users
          WHERE admin_users.user_id = auth.uid()
        )
      );
  END IF;
END $$;
