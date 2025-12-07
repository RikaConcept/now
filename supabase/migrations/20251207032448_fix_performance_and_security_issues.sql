/*
  # Fix Performance and Security Issues
  
  ## Performance Improvements
  
  1. **Add Missing Foreign Key Indexes**
     - Add index on `localities.country_id`
     - Add index on `members.membership_level_id`
     - Add index on `members.referred_by`
  
  2. **Remove Unused Indexes**
     - Drop `idx_products_category`
     - Drop `idx_products_active`
     - Drop `idx_referrals_referred`
     - Drop `idx_referrals_code`
     - Drop `idx_members_status`
     - Drop `idx_product_requests_status`
  
  ## Security & Query Performance
  
  3. **Optimize RLS Policies**
     - Replace all `auth.uid()` with `(select auth.uid())` to prevent re-evaluation per row
     - Consolidate multiple permissive SELECT policies into single policies with OR conditions
     - Affects tables: members, orders, product_requests, products, membership_levels, referrals, admin_users, countries, site_settings, localities
  
  ## Important Notes
  
  - Using `(select auth.uid())` evaluates the function once per query instead of once per row
  - This significantly improves query performance at scale
  - Consolidated policies reduce policy evaluation overhead
  - **Manual Action Required**: Enable "Leaked Password Protection" in Supabase Dashboard > Authentication > Settings > Security
*/

-- ============================================================================
-- 1. ADD MISSING FOREIGN KEY INDEXES
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_localities_country_id ON public.localities(country_id);
CREATE INDEX IF NOT EXISTS idx_members_membership_level_id ON public.members(membership_level_id);
CREATE INDEX IF NOT EXISTS idx_members_referred_by ON public.members(referred_by);

-- ============================================================================
-- 2. DROP UNUSED INDEXES
-- ============================================================================

DROP INDEX IF EXISTS public.idx_products_category;
DROP INDEX IF EXISTS public.idx_products_active;
DROP INDEX IF EXISTS public.idx_referrals_referred;
DROP INDEX IF EXISTS public.idx_referrals_code;
DROP INDEX IF EXISTS public.idx_members_status;
DROP INDEX IF EXISTS public.idx_product_requests_status;

-- ============================================================================
-- 3. OPTIMIZE RLS POLICIES - MEMBERS TABLE
-- ============================================================================

DROP POLICY IF EXISTS "Users can view their own member data" ON public.members;
DROP POLICY IF EXISTS "Users can insert their own member data" ON public.members;
DROP POLICY IF EXISTS "Users can update their own member data" ON public.members;

CREATE POLICY "Users can view their own member data"
  ON public.members
  FOR SELECT
  TO authenticated
  USING (id = (select auth.uid()));

CREATE POLICY "Users can insert their own member data"
  ON public.members
  FOR INSERT
  TO authenticated
  WITH CHECK (id = (select auth.uid()));

CREATE POLICY "Users can update their own member data"
  ON public.members
  FOR UPDATE
  TO authenticated
  USING (id = (select auth.uid()))
  WITH CHECK (id = (select auth.uid()));

-- ============================================================================
-- 4. OPTIMIZE RLS POLICIES - ORDERS TABLE
-- ============================================================================

DROP POLICY IF EXISTS "Users can view their own orders" ON public.orders;
DROP POLICY IF EXISTS "Users can create their own orders" ON public.orders;
DROP POLICY IF EXISTS "Users can update their own orders" ON public.orders;

CREATE POLICY "Users can view their own orders"
  ON public.orders
  FOR SELECT
  TO authenticated
  USING (member_id IN (SELECT id FROM members WHERE id = (select auth.uid())));

CREATE POLICY "Users can create their own orders"
  ON public.orders
  FOR INSERT
  TO authenticated
  WITH CHECK (member_id IN (SELECT id FROM members WHERE id = (select auth.uid())));

CREATE POLICY "Users can update their own orders"
  ON public.orders
  FOR UPDATE
  TO authenticated
  USING (member_id IN (SELECT id FROM members WHERE id = (select auth.uid())))
  WITH CHECK (member_id IN (SELECT id FROM members WHERE id = (select auth.uid())));

-- ============================================================================
-- 5. OPTIMIZE RLS POLICIES - PRODUCT_REQUESTS TABLE
-- ============================================================================

DROP POLICY IF EXISTS "Users can view their own product requests" ON public.product_requests;
DROP POLICY IF EXISTS "Users can update their own product requests" ON public.product_requests;

CREATE POLICY "Users can view their own product requests"
  ON public.product_requests
  FOR SELECT
  TO authenticated
  USING (user_id = (select auth.uid()));

CREATE POLICY "Users can update their own product requests"
  ON public.product_requests
  FOR UPDATE
  TO authenticated
  USING (user_id = (select auth.uid()))
  WITH CHECK (user_id = (select auth.uid()));

-- ============================================================================
-- 6. OPTIMIZE RLS POLICIES - PRODUCTS TABLE (CONSOLIDATE)
-- ============================================================================

DROP POLICY IF EXISTS "Admins can manage products" ON public.products;
DROP POLICY IF EXISTS "Anyone can view active products" ON public.products;

-- Consolidated SELECT policy for both regular users and admins
CREATE POLICY "Anyone can view active products"
  ON public.products
  FOR SELECT
  TO anon, authenticated
  USING (
    is_active = true 
    OR (select auth.uid()) IN (SELECT user_id FROM admin_users)
  );

CREATE POLICY "Admins can insert products"
  ON public.products
  FOR INSERT
  TO authenticated
  WITH CHECK ((select auth.uid()) IN (SELECT user_id FROM admin_users));

CREATE POLICY "Admins can update products"
  ON public.products
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) IN (SELECT user_id FROM admin_users))
  WITH CHECK ((select auth.uid()) IN (SELECT user_id FROM admin_users));

CREATE POLICY "Admins can delete products"
  ON public.products
  FOR DELETE
  TO authenticated
  USING ((select auth.uid()) IN (SELECT user_id FROM admin_users));

-- ============================================================================
-- 7. OPTIMIZE RLS POLICIES - MEMBERSHIP_LEVELS TABLE (CONSOLIDATE)
-- ============================================================================

DROP POLICY IF EXISTS "Admins can manage membership levels" ON public.membership_levels;
DROP POLICY IF EXISTS "Anyone can view membership levels" ON public.membership_levels;

-- Keep single SELECT policy for all users (already public)
CREATE POLICY "Anyone can view membership levels"
  ON public.membership_levels
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Admins can insert membership levels"
  ON public.membership_levels
  FOR INSERT
  TO authenticated
  WITH CHECK ((select auth.uid()) IN (SELECT user_id FROM admin_users));

CREATE POLICY "Admins can update membership levels"
  ON public.membership_levels
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) IN (SELECT user_id FROM admin_users))
  WITH CHECK ((select auth.uid()) IN (SELECT user_id FROM admin_users));

CREATE POLICY "Admins can delete membership levels"
  ON public.membership_levels
  FOR DELETE
  TO authenticated
  USING ((select auth.uid()) IN (SELECT user_id FROM admin_users));

-- ============================================================================
-- 8. OPTIMIZE RLS POLICIES - REFERRALS TABLE (CONSOLIDATE)
-- ============================================================================

DROP POLICY IF EXISTS "Users can view their referrals" ON public.referrals;
DROP POLICY IF EXISTS "Admins can manage referrals" ON public.referrals;

-- Consolidated SELECT policy
CREATE POLICY "Users can view their referrals"
  ON public.referrals
  FOR SELECT
  TO authenticated
  USING (
    referrer_id = (select auth.uid())
    OR (select auth.uid()) IN (SELECT user_id FROM admin_users)
  );

CREATE POLICY "Admins can insert referrals"
  ON public.referrals
  FOR INSERT
  TO authenticated
  WITH CHECK ((select auth.uid()) IN (SELECT user_id FROM admin_users));

CREATE POLICY "Admins can update referrals"
  ON public.referrals
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) IN (SELECT user_id FROM admin_users))
  WITH CHECK ((select auth.uid()) IN (SELECT user_id FROM admin_users));

CREATE POLICY "Admins can delete referrals"
  ON public.referrals
  FOR DELETE
  TO authenticated
  USING ((select auth.uid()) IN (SELECT user_id FROM admin_users));

-- ============================================================================
-- 9. OPTIMIZE RLS POLICIES - ADMIN_USERS TABLE
-- ============================================================================

DROP POLICY IF EXISTS "Users can read own admin record" ON public.admin_users;

CREATE POLICY "Users can read own admin record"
  ON public.admin_users
  FOR SELECT
  TO authenticated
  USING (user_id = (select auth.uid()));

-- ============================================================================
-- 10. OPTIMIZE RLS POLICIES - COUNTRIES TABLE
-- ============================================================================

DROP POLICY IF EXISTS "Admins can insert countries" ON public.countries;
DROP POLICY IF EXISTS "Admins can update countries" ON public.countries;

CREATE POLICY "Admins can insert countries"
  ON public.countries
  FOR INSERT
  TO authenticated
  WITH CHECK ((select auth.uid()) IN (SELECT user_id FROM admin_users));

CREATE POLICY "Admins can update countries"
  ON public.countries
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) IN (SELECT user_id FROM admin_users))
  WITH CHECK ((select auth.uid()) IN (SELECT user_id FROM admin_users));

-- ============================================================================
-- 11. OPTIMIZE RLS POLICIES - SITE_SETTINGS TABLE
-- ============================================================================

DROP POLICY IF EXISTS "Admins can update site settings" ON public.site_settings;

CREATE POLICY "Admins can update site settings"
  ON public.site_settings
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) IN (SELECT user_id FROM admin_users))
  WITH CHECK ((select auth.uid()) IN (SELECT user_id FROM admin_users));

-- ============================================================================
-- 12. OPTIMIZE RLS POLICIES - LOCALITIES TABLE
-- ============================================================================

DROP POLICY IF EXISTS "Admins can insert localities" ON public.localities;
DROP POLICY IF EXISTS "Admins can update localities" ON public.localities;
DROP POLICY IF EXISTS "Admins can delete localities" ON public.localities;

CREATE POLICY "Admins can insert localities"
  ON public.localities
  FOR INSERT
  TO authenticated
  WITH CHECK ((select auth.uid()) IN (SELECT user_id FROM admin_users));

CREATE POLICY "Admins can update localities"
  ON public.localities
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) IN (SELECT user_id FROM admin_users))
  WITH CHECK ((select auth.uid()) IN (SELECT user_id FROM admin_users));

CREATE POLICY "Admins can delete localities"
  ON public.localities
  FOR DELETE
  TO authenticated
  USING ((select auth.uid()) IN (SELECT user_id FROM admin_users));