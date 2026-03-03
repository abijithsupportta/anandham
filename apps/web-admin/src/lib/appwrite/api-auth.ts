import { cookies } from "next/headers";

export async function requireAdminCookie() {
  const cookieStore = await cookies();
  const sessionValue = cookieStore.get("ama_admin_session")?.value;
  const superAdminEmail = (process.env.SUPER_ADMIN_EMAIL || "").toLowerCase();

  if (!superAdminEmail || !sessionValue || sessionValue.toLowerCase() !== superAdminEmail) {
    return { ok: false as const, status: 401, error: "Unauthorized" };
  }

  return { ok: true as const };
}
