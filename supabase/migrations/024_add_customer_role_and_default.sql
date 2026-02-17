-- ============================================================
-- 024_add_customer_role_and_default.sql
-- Adds 'customer' role to user_role enum only.
-- NOTE: Do not use this new enum value in the same transaction.
-- The default/trigger updates are in migration 025.
-- ============================================================

-- Add new enum value for user role (idempotent)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_enum e
    JOIN pg_type t ON e.enumtypid = t.oid
    WHERE t.typname = 'user_role' AND e.enumlabel = 'customer'
  ) THEN
    ALTER TYPE public.user_role ADD VALUE 'customer';
  END IF;
END $$;

NOTIFY pgrst, 'reload schema';
