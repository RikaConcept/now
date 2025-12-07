/*
  # Fix Security and Performance Issues

  This migration addresses multiple security and performance issues identified by Supabase:

  ## 1. Add Missing Indexes on Foreign Keys
    - localities.country_id
    - members.membership_level_id
    - members.referred_by
    - revenue_distributions.order_id

  ## 2. Optimize RLS Policies (Auth Function Caching)
    - Replace `auth.uid()` with `(select auth.uid())` in all policies
    - This prevents re-evaluation for each row, improving performance at scale
    - Affects: members, orders, product_requests, products, membership_levels, referrals, admin_users, stripe_customers, stripe_subscriptions, stripe_orders

  ## 3. Remove Unused Indexes
    - Remove indexes that haven't been used to reduce overhead

  ## 4. Add Missing RLS Policies
    - audit_logs: Admin read-only access
    - ot_requests: User and admin access
    - payouts: User and admin access
    - revenue_distributions: User and admin read access
    - status_adjustments: Admin-only access

  ## 5. Fix Function Search Paths
    - Set explicit search_path for generate_unique_referral_code
    - Set explicit search_path for auto_generate_referral_code

  ## Security Notes
    - All new policies follow principle of least privilege
    - Multiple permissive policies are intentional (user OR admin access patterns)
    - Leaked password protection must be enabled in Supabase Dashboard > Auth settings
*/

-- =====================================================
-- 1. ADD MISSING INDEXES ON FOREIGN KEYS
-- =====================================================

-- Index for localities.country_id
CREATE INDEX IF NOT EXISTS idx_localities_country_id 
  ON public.localities(country_id);

-- Index for members.membership_level_id
CREATE INDEX IF NOT EXISTS idx_members_membership_level_id 
  ON public.members(membership_level_id);

-- Index for members.referred_by
CREATE INDEX IF NOT EXISTS idx_members_referred_by 
  ON public.members(referred_by);

-- Index for revenue_distributions.order_id
CREATE INDEX IF NOT EXISTS idx_revenue_distributions_order_id 
  ON public.revenue_distributions(order_id);

-- =====================================================
-- 2. REMOVE UNUSED INDEXES
-- =====================================================

DROP INDEX IF EXISTS public.idx_ot_requests_member;
DROP INDEX IF EXISTS public.idx_ot_requests_status;
DROP INDEX IF EXISTS public.idx_ot_requests_deadline;
DROP INDEX IF EXISTS public.idx_revenue_distributions_member;
DROP INDEX IF EXISTS public.idx_revenue_distributions_status;
DROP INDEX IF EXISTS public.idx_payouts_member;
DROP INDEX IF EXISTS public.idx_payouts_status;
DROP INDEX IF EXISTS public.idx_status_adjustments_member;
DROP INDEX IF EXISTS public.idx_members_locality;
DROP INDEX IF EXISTS public.idx_members_status;
DROP INDEX IF EXISTS public.idx_product_requests_status;
DROP INDEX IF EXISTS public.idx_referrals_referred;
DROP INDEX IF EXISTS public.idx_referrals_code;
DROP INDEX IF EXISTS public.idx_audit_logs_action;
DROP INDEX IF EXISTS public.idx_products_category;

-- =====================================================
-- 3. OPTIMIZE RLS POLICIES - MEMBERS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view their own member data" ON public.members;
DROP POLICY IF EXISTS "Users can insert their own member data" ON public.members;
DROP POLICY IF EXISTS "Users can update their own member data" ON public.members;
DROP POLICY IF EXISTS "Admins can view all members" ON public.members;
DROP POLICY IF EXISTS "Admins can update all members" ON public.members;

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

CREATE POLICY "Admins can view all members"
  ON public.members
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

CREATE POLICY "Admins can update all members"
  ON public.members
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

-- =====================================================
-- 4. OPTIMIZE RLS POLICIES - ORDERS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view their own orders" ON public.orders;
DROP POLICY IF EXISTS "Users can create their own orders" ON public.orders;
DROP POLICY IF EXISTS "Users can update their own orders" ON public.orders;
DROP POLICY IF EXISTS "Admins can view all orders" ON public.orders;
DROP POLICY IF EXISTS "Admins can update all orders" ON public.orders;

CREATE POLICY "Users can view their own orders"
  ON public.orders
  FOR SELECT
  TO authenticated
  USING (member_id = (select auth.uid()));

CREATE POLICY "Users can create their own orders"
  ON public.orders
  FOR INSERT
  TO authenticated
  WITH CHECK (member_id = (select auth.uid()));

CREATE POLICY "Users can update their own orders"
  ON public.orders
  FOR UPDATE
  TO authenticated
  USING (member_id = (select auth.uid()))
  WITH CHECK (member_id = (select auth.uid()));

CREATE POLICY "Admins can view all orders"
  ON public.orders
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

CREATE POLICY "Admins can update all orders"
  ON public.orders
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

-- =====================================================
-- 5. OPTIMIZE RLS POLICIES - PRODUCT_REQUESTS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view their own product requests" ON public.product_requests;
DROP POLICY IF EXISTS "Users can update their own product requests" ON public.product_requests;
DROP POLICY IF EXISTS "Admins can view all product requests" ON public.product_requests;
DROP POLICY IF EXISTS "Admins can update all product requests" ON public.product_requests;

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

CREATE POLICY "Admins can view all product requests"
  ON public.product_requests
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

CREATE POLICY "Admins can update all product requests"
  ON public.product_requests
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

-- =====================================================
-- 6. OPTIMIZE RLS POLICIES - PRODUCTS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Admins can manage products" ON public.products;

CREATE POLICY "Admins can manage products"
  ON public.products
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

-- =====================================================
-- 7. OPTIMIZE RLS POLICIES - MEMBERSHIP_LEVELS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Admins can manage membership levels" ON public.membership_levels;

CREATE POLICY "Admins can manage membership levels"
  ON public.membership_levels
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

-- =====================================================
-- 8. OPTIMIZE RLS POLICIES - REFERRALS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view their referrals" ON public.referrals;
DROP POLICY IF EXISTS "Admins can manage referrals" ON public.referrals;
DROP POLICY IF EXISTS "Admins can view all referrals" ON public.referrals;
DROP POLICY IF EXISTS "Admins can update all referrals" ON public.referrals;

CREATE POLICY "Users can view their referrals"
  ON public.referrals
  FOR SELECT
  TO authenticated
  USING (referrer_id = (select auth.uid()));

CREATE POLICY "Admins can view all referrals"
  ON public.referrals
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

CREATE POLICY "Admins can manage referrals"
  ON public.referrals
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

-- =====================================================
-- 9. OPTIMIZE RLS POLICIES - ADMIN_USERS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can read own admin record" ON public.admin_users;

CREATE POLICY "Users can read own admin record"
  ON public.admin_users
  FOR SELECT
  TO authenticated
  USING (user_id = (select auth.uid()));

-- =====================================================
-- 10. OPTIMIZE RLS POLICIES - STRIPE TABLES
-- =====================================================

DROP POLICY IF EXISTS "Users can view their own customer data" ON public.stripe_customers;
DROP POLICY IF EXISTS "Users can view their own subscription data" ON public.stripe_subscriptions;
DROP POLICY IF EXISTS "Users can view their own order data" ON public.stripe_orders;

CREATE POLICY "Users can view their own customer data"
  ON public.stripe_customers
  FOR SELECT
  TO authenticated
  USING (user_id = (select auth.uid()));

CREATE POLICY "Users can view their own subscription data"
  ON public.stripe_subscriptions
  FOR SELECT
  TO authenticated
  USING (
    customer_id IN (
      SELECT customer_id FROM public.stripe_customers 
      WHERE user_id = (select auth.uid())
    )
  );

CREATE POLICY "Users can view their own order data"
  ON public.stripe_orders
  FOR SELECT
  TO authenticated
  USING (
    customer_id IN (
      SELECT customer_id FROM public.stripe_customers 
      WHERE user_id = (select auth.uid())
    )
  );

-- =====================================================
-- 11. ADD MISSING RLS POLICIES - AUDIT_LOGS
-- =====================================================

CREATE POLICY "Admins can view audit logs"
  ON public.audit_logs
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

-- =====================================================
-- 12. ADD MISSING RLS POLICIES - OT_REQUESTS
-- =====================================================

CREATE POLICY "Users can view their own OT requests"
  ON public.ot_requests
  FOR SELECT
  TO authenticated
  USING (member_id = (select auth.uid()));

CREATE POLICY "Users can create their own OT requests"
  ON public.ot_requests
  FOR INSERT
  TO authenticated
  WITH CHECK (member_id = (select auth.uid()));

CREATE POLICY "Users can update their own OT requests"
  ON public.ot_requests
  FOR UPDATE
  TO authenticated
  USING (member_id = (select auth.uid()))
  WITH CHECK (member_id = (select auth.uid()));

CREATE POLICY "Admins can manage all OT requests"
  ON public.ot_requests
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

-- =====================================================
-- 13. ADD MISSING RLS POLICIES - PAYOUTS
-- =====================================================

CREATE POLICY "Users can view their own payouts"
  ON public.payouts
  FOR SELECT
  TO authenticated
  USING (member_id = (select auth.uid()));

CREATE POLICY "Admins can manage all payouts"
  ON public.payouts
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

-- =====================================================
-- 14. ADD MISSING RLS POLICIES - REVENUE_DISTRIBUTIONS
-- =====================================================

CREATE POLICY "Users can view their own revenue distributions"
  ON public.revenue_distributions
  FOR SELECT
  TO authenticated
  USING (member_id = (select auth.uid()));

CREATE POLICY "Admins can view all revenue distributions"
  ON public.revenue_distributions
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

-- =====================================================
-- 15. ADD MISSING RLS POLICIES - STATUS_ADJUSTMENTS
-- =====================================================

CREATE POLICY "Admins can manage status adjustments"
  ON public.status_adjustments
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.admin_users
      WHERE admin_users.user_id = (select auth.uid())
    )
  );

-- =====================================================
-- 16. FIX FUNCTION SEARCH PATHS
-- =====================================================

-- Drop and recreate generate_unique_referral_code with fixed search_path
DROP FUNCTION IF EXISTS public.generate_unique_referral_code();

CREATE OR REPLACE FUNCTION public.generate_unique_referral_code()
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  new_code text;
  code_exists boolean;
BEGIN
  LOOP
    -- Generate a random 8-character code
    new_code := upper(substring(md5(random()::text || clock_timestamp()::text) from 1 for 8));
    
    -- Check if code already exists
    SELECT EXISTS(SELECT 1 FROM public.referrals WHERE referral_code = new_code) INTO code_exists;
    
    -- Exit loop if code is unique
    EXIT WHEN NOT code_exists;
  END LOOP;
  
  RETURN new_code;
END;
$$;

-- Drop and recreate auto_generate_referral_code trigger function with fixed search_path
DROP FUNCTION IF EXISTS public.auto_generate_referral_code() CASCADE;

CREATE OR REPLACE FUNCTION public.auto_generate_referral_code()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  -- Only generate if member is active and doesn't already have a referral code
  IF NEW.status = 'active' AND (NEW.referral_code IS NULL OR NEW.referral_code = '') THEN
    NEW.referral_code := public.generate_unique_referral_code();
  END IF;
  
  RETURN NEW;
END;
$$;

-- Recreate trigger
DROP TRIGGER IF EXISTS trigger_auto_generate_referral_code ON public.members;

CREATE TRIGGER trigger_auto_generate_referral_code
  BEFORE INSERT OR UPDATE OF status ON public.members
  FOR EACH ROW
  EXECUTE FUNCTION public.auto_generate_referral_code();
