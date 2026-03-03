import * as dotenv from "dotenv";
import * as path from "path";
import { Client, ID, Query, Users } from "node-appwrite";

dotenv.config({ path: path.resolve(__dirname, "../.env.local") });

const endpoint =
  process.env.APPWRITE_ENDPOINT || process.env.NEXT_PUBLIC_APPWRITE_ENDPOINT;
const projectId = process.env.NEXT_PUBLIC_APPWRITE_PROJECT_ID;
const apiKey = process.env.APPWRITE_API_KEY;
const superAdminEmail = process.env.SUPER_ADMIN_EMAIL || "";
const superAdminPassword = process.env.SUPER_ADMIN_PASSWORD || "1@Abijithcb";

if (!endpoint || !projectId || !apiKey || !superAdminEmail) {
  console.error("Missing env vars: APPWRITE_ENDPOINT, NEXT_PUBLIC_APPWRITE_PROJECT_ID, APPWRITE_API_KEY, SUPER_ADMIN_EMAIL");
  process.exit(1);
}

const client = new Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
const users = new Users(client);

async function main() {
  console.log(`\n🔧 Ensuring superadmin user exists: ${superAdminEmail}\n`);

  const result = await users.list([Query.equal("email", superAdminEmail)]);
  const existing = result.users.find((user) => user.email === superAdminEmail);

  if (existing) {
    await users.updatePassword(existing.$id, superAdminPassword);
    await users.updateName(existing.$id, "Super Admin");
    await users.updateLabels(existing.$id, ["SUPERADMIN"]);
    console.log("✅ Existing superadmin updated");
    console.log(`   User ID: ${existing.$id}`);
    return;
  }

  const created = await users.create(
    ID.unique(),
    superAdminEmail,
    undefined,
    superAdminPassword,
    "Super Admin",
  );

  await users.updateEmailVerification(created.$id, true);
  await users.updateLabels(created.$id, ["SUPERADMIN"]);

  console.log("✅ Superadmin created");
  console.log(`   User ID: ${created.$id}`);
  console.log(`   Email: ${superAdminEmail}`);
}

main().catch((error) => {
  console.error("❌ Superadmin seed failed:", error);
  process.exit(1);
});
