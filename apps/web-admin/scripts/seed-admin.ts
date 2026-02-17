/**
 * Seed script to create the super admin user in Supabase Auth.
 *
 * Run once:  npx tsx scripts/seed-admin.ts
 *
 * Prerequisites:
 *   - Set SUPABASE_SERVICE_ROLE_KEY in your .env.local
 *     (find it in Supabase Dashboard → Settings → API → service_role key)
 */

import { createClient } from "@supabase/supabase-js";
import * as dotenv from "dotenv";
import * as path from "path";

dotenv.config({ path: path.resolve(__dirname, "../.env.local") });

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!;

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  console.error(
    "Missing NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in .env.local"
  );
  console.error(
    "Add SUPABASE_SERVICE_ROLE_KEY from Supabase Dashboard → Settings → API"
  );
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false },
});

const ADMIN_EMAIL = "info@abijithcb.com";
const ADMIN_PASSWORD = "1@Abijithcb";

async function seedAdmin() {
  console.log(`\n🔧 Creating super admin: ${ADMIN_EMAIL}\n`);

  // Check if user already exists
  const { data: existingUsers } = await supabase.auth.admin.listUsers();
  const exists = existingUsers?.users?.find((u) => u.email === ADMIN_EMAIL);

  if (exists) {
    console.log("✅ Super admin already exists (id:", exists.id, ")");
    console.log("   Updating password...");
    const { error } = await supabase.auth.admin.updateUserById(exists.id, {
      password: ADMIN_PASSWORD,
      email_confirm: true,
    });
    if (error) {
      console.error("❌ Failed to update password:", error.message);
      process.exit(1);
    }
    console.log("✅ Password updated successfully.");
    return;
  }

  // Create the admin user
  const { data, error } = await supabase.auth.admin.createUser({
    email: ADMIN_EMAIL,
    password: ADMIN_PASSWORD,
    email_confirm: true, // Skip email verification
    user_metadata: {
      full_name: "Super Admin",
      role: "SUPER_ADMIN",
    },
  });

  if (error) {
    console.error("❌ Failed to create admin:", error.message);
    process.exit(1);
  }

  console.log("✅ Super admin created successfully!");
  console.log("   ID:", data.user.id);
  console.log("   Email:", ADMIN_EMAIL);
  console.log("   Role: SUPER_ADMIN");
  console.log("\n   You can now log in at /login");
}

seedAdmin().catch((err) => {
  console.error("Unexpected error:", err);
  process.exit(1);
});
