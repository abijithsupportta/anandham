import { createClient } from "@supabase/supabase-js";

/**
 * Server-side Supabase admin client using service_role key.
 * ONLY use in API routes / server actions — never expose to client.
 */
export function createAdminClient() {
  return createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,
    { auth: { autoRefreshToken: false, persistSession: false } }
  );
}
