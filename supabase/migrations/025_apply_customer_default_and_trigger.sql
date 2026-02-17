-- ============================================================
-- 025_apply_customer_default_and_trigger.sql
-- Applies default role and trigger updates that use 'customer'.
-- Must run after 024 has committed.
-- ============================================================

-- New rows in profiles should default to customer
ALTER TABLE public.profiles
  ALTER COLUMN role SET DEFAULT 'customer';

-- Update trigger to default to customer for new user-app signups
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
    COALESCE((NEW.raw_user_meta_data->>'role')::public.user_role, 'customer'),
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

NOTIFY pgrst, 'reload schema';
