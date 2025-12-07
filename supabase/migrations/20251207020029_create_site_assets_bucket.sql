/*
  # Create site assets storage bucket

  1. Storage
    - Create public bucket for site assets (logos, images)
    - Enable public access for reading
    - Restrict uploads to admins only

  2. Security
    - Anyone can view files
    - Only admins can upload, update, or delete files
*/

-- Create the bucket for site assets
INSERT INTO storage.buckets (id, name, public)
VALUES ('site-assets', 'site-assets', true)
ON CONFLICT (id) DO NOTHING;

-- Drop existing policies if they exist
DO $$
BEGIN
  DROP POLICY IF EXISTS "Public can view site assets" ON storage.objects;
  DROP POLICY IF EXISTS "Admins can upload site assets" ON storage.objects;
  DROP POLICY IF EXISTS "Admins can update site assets" ON storage.objects;
  DROP POLICY IF EXISTS "Admins can delete site assets" ON storage.objects;
END $$;

-- Allow public read access
CREATE POLICY "Public can view site assets"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'site-assets');

-- Allow admins to upload files
CREATE POLICY "Admins can upload site assets"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'site-assets' AND
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE admin_users.user_id = auth.uid()
  )
);

-- Allow admins to update files
CREATE POLICY "Admins can update site assets"
ON storage.objects
FOR UPDATE
TO authenticated
USING (
  bucket_id = 'site-assets' AND
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE admin_users.user_id = auth.uid()
  )
)
WITH CHECK (
  bucket_id = 'site-assets' AND
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE admin_users.user_id = auth.uid()
  )
);

-- Allow admins to delete files
CREATE POLICY "Admins can delete site assets"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'site-assets' AND
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE admin_users.user_id = auth.uid()
  )
);