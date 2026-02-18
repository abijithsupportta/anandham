-- ============================================================
-- 028_relax_profile_constraints_for_initial_signup.sql
-- Allows user-app signup with email/password only.
-- Profile details remain optional at creation and can be completed later.
-- ============================================================

ALTER TABLE public.profiles
  DROP CONSTRAINT IF EXISTS chk_profiles_full_name_required,
  DROP CONSTRAINT IF EXISTS chk_profiles_address_required,
  DROP CONSTRAINT IF EXISTS chk_profiles_house_name_required,
  DROP CONSTRAINT IF EXISTS chk_profiles_city_required,
  DROP CONSTRAINT IF EXISTS chk_profiles_state_required,
  DROP CONSTRAINT IF EXISTS chk_profiles_pincode_required,
  DROP CONSTRAINT IF EXISTS chk_profiles_phone_number_format,
  DROP CONSTRAINT IF EXISTS chk_profiles_india_pincode;

ALTER TABLE public.profiles
  ADD CONSTRAINT chk_profiles_phone_number_format
    CHECK (
      phone_number = ''
      OR phone_number ~ '^[0-9]{7,12}$'
    ) NOT VALID,
  ADD CONSTRAINT chk_profiles_india_pincode
    CHECK (
      pincode = ''
      OR phone_country_code <> '+91'
      OR pincode ~ '^[0-9]{6}$'
    ) NOT VALID;

NOTIFY pgrst, 'reload schema';