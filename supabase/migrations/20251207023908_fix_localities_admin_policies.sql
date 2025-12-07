/*
  # Fix localities table RLS policies for admin operations

  1. Security Changes
    - Add INSERT policy for admins to create new localities
    - Add UPDATE policy for admins to modify localities
    - Add DELETE policy for admins to remove localities
    
  2. Notes
    - All admin policies verify user is in the admin_users table
    - Public can still view all localities (existing policy)
*/

-- Add INSERT policy for admins
CREATE POLICY "Admins can insert localities"
  ON localities FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE admin_users.user_id = auth.uid()
    )
  );

-- Add UPDATE policy for admins
CREATE POLICY "Admins can update localities"
  ON localities FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE admin_users.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE admin_users.user_id = auth.uid()
    )
  );

-- Add DELETE policy for admins
CREATE POLICY "Admins can delete localities"
  ON localities FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE admin_users.user_id = auth.uid()
    )
  );
