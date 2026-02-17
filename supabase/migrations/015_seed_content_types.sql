-- ============================================================
-- 015_seed_content_types.sql
-- Seed initial content types for the home screen
-- Run in: Supabase SQL Editor (after 014)
-- ============================================================

INSERT INTO public.content_types (name, display_name, description, icon, color, table_name, display_order)
VALUES
  ('guru_krithis', 'Guru Krithis', 'Sacred poems and songs with slokas', '📿', '#8b5cf6', 'krithis', 1),
  ('guru_dharmas', 'Guru Dharmas', 'Spiritual teachings and principles', '🙏', '#f59e0b', 'dharmas', 2),
  ('guru_photos', 'Guru Photos', 'Sacred and devotional photographs', '📸', '#3b82f6', 'guru_photos', 3)
ON CONFLICT (name) DO NOTHING;


-- ── Create storage buckets ─────────────────────────────────

-- Run these via Supabase Dashboard → Storage → New Bucket
-- or via the API. SQL cannot create storage buckets directly.
-- Bucket names:
--   author-photos    (public)
--   guru-photos      (public)
--   content-images   (public)


-- ── Set the super admin profile role ───────────────────────
-- (The seed-admin.ts script already created the auth user.
--  This ensures the profile row has the correct role.)

UPDATE public.profiles
SET role = 'super_admin', full_name = 'Super Admin'
WHERE id = (SELECT id FROM auth.users WHERE email = 'info@abijithcb.com')
AND role != 'super_admin';
