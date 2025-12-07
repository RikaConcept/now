/*
  # Fix infinite recursion in admin_users RLS policy

  1. Problem
    - Current policy checks admin_users to verify if user is admin
    - This creates infinite recursion when querying admin_users
  
  2. Solution
    - Drop existing recursive policy
    - Create simple policy that allows users to read their own admin record
    - This breaks the recursion cycle
  
  3. Security
    - Users can only see their own admin_users record
    - Authentication is still required (authenticated role)
*/

-- Drop the problematic policy
DROP POLICY IF EXISTS "Admins only can view admin users" ON admin_users;

-- Create a non-recursive policy: users can read their own admin record
CREATE POLICY "Users can read own admin record"
  ON admin_users
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);
