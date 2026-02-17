-- ============================================================
-- 023_add_user_profile_registration_fields.sql
-- Adds mandatory registration fields to public.profiles
-- and updates auth trigger to capture metadata on signup.
-- Run in: Supabase SQL Editor (after 022)
-- ============================================================

-- ── Step 1: Add profile columns ─────────────────────────────

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS phone_country_code TEXT NOT NULL DEFAULT '+91',
  ADD COLUMN IF NOT EXISTS phone_number       TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS address            TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS house_name         TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS city               TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS state              TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS pincode            TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS is_sndp_member     BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS sndp_union_name    TEXT,
  ADD COLUMN IF NOT EXISTS sndp_branch_number TEXT,
  ADD COLUMN IF NOT EXISTS sndp_temple_name   TEXT;

CREATE INDEX IF NOT EXISTS idx_profiles_phone_number ON public.profiles(phone_number);
CREATE INDEX IF NOT EXISTS idx_profiles_city_state ON public.profiles(city, state);

-- ── Step 2: Enforce mandatory data (for new/updated rows) ──

ALTER TABLE public.profiles
  DROP CONSTRAINT IF EXISTS chk_profiles_full_name_required,
  DROP CONSTRAINT IF EXISTS chk_profiles_phone_country_code_allowed,
  DROP CONSTRAINT IF EXISTS chk_profiles_phone_number_format,
  DROP CONSTRAINT IF EXISTS chk_profiles_address_required,
  DROP CONSTRAINT IF EXISTS chk_profiles_house_name_required,
  DROP CONSTRAINT IF EXISTS chk_profiles_city_required,
  DROP CONSTRAINT IF EXISTS chk_profiles_state_required,
  DROP CONSTRAINT IF EXISTS chk_profiles_pincode_required,
  DROP CONSTRAINT IF EXISTS chk_profiles_india_pincode,
  DROP CONSTRAINT IF EXISTS chk_profiles_sndp_fields_when_member;

ALTER TABLE public.profiles
  ADD CONSTRAINT chk_profiles_full_name_required
    CHECK (length(trim(full_name)) > 0) NOT VALID,
  ADD CONSTRAINT chk_profiles_phone_country_code_allowed
    CHECK (phone_country_code IN ('+91', '+971', '+1', '+966', '+44', '+968')) NOT VALID,
  ADD CONSTRAINT chk_profiles_phone_number_format
    CHECK (phone_number ~ '^[0-9]{7,12}$') NOT VALID,
  ADD CONSTRAINT chk_profiles_address_required
    CHECK (length(trim(address)) > 0) NOT VALID,
  ADD CONSTRAINT chk_profiles_house_name_required
    CHECK (length(trim(house_name)) > 0) NOT VALID,
  ADD CONSTRAINT chk_profiles_city_required
    CHECK (length(trim(city)) > 0) NOT VALID,
  ADD CONSTRAINT chk_profiles_state_required
    CHECK (length(trim(state)) > 0) NOT VALID,
  ADD CONSTRAINT chk_profiles_pincode_required
    CHECK (length(trim(pincode)) > 0) NOT VALID,
  ADD CONSTRAINT chk_profiles_india_pincode
    CHECK (phone_country_code <> '+91' OR pincode ~ '^[0-9]{6}$') NOT VALID,
  ADD CONSTRAINT chk_profiles_sndp_fields_when_member
    CHECK (
      NOT is_sndp_member
      OR (
        length(trim(COALESCE(sndp_union_name, ''))) > 0
        AND length(trim(COALESCE(sndp_branch_number, ''))) > 0
        AND length(trim(COALESCE(sndp_temple_name, ''))) > 0
      )
    ) NOT VALID;

-- ── Step 3: Update new-user trigger for richer metadata ────

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (
    id,
    full_name,
    role,
    phone_country_code,
    phone_number,
    address,
    house_name,
    city,
    state,
    pincode,
    is_sndp_member,
    sndp_union_name,
    sndp_branch_number,
    sndp_temple_name
  )
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE((NEW.raw_user_meta_data->>'role')::public.user_role, 'author'),
    COALESCE(NEW.raw_user_meta_data->>'phone_country_code', '+91'),
    COALESCE(NEW.raw_user_meta_data->>'phone_number', ''),
    COALESCE(NEW.raw_user_meta_data->>'address', ''),
    COALESCE(NEW.raw_user_meta_data->>'house_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'city', ''),
    COALESCE(NEW.raw_user_meta_data->>'state', ''),
    COALESCE(NEW.raw_user_meta_data->>'pincode', ''),
    COALESCE((NEW.raw_user_meta_data->>'is_sndp_member')::BOOLEAN, FALSE),
    NULLIF(NEW.raw_user_meta_data->>'sndp_union_name', ''),
    NULLIF(NEW.raw_user_meta_data->>'sndp_branch_number', ''),
    NULLIF(NEW.raw_user_meta_data->>'sndp_temple_name', '')
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ── Step 4: Reload schema cache ────────────────────────────

NOTIFY pgrst, 'reload schema';
