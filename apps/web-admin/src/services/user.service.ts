import type { Profile } from "@/types/database";
import { serviceCall } from "./base";
import type { ServiceResult } from "./base";

// ── User service ───────────────────────────────────────────

export const userService = {
  async getAll(): Promise<ServiceResult<Profile[]>> {
    return serviceCall((sb) =>
      sb
        .from("profiles")
        .select("*")
        .order("created_at", { ascending: false })
    );
  },

  async toggleActive(id: string, currentActive: boolean): Promise<ServiceResult<null>> {
    return serviceCall((sb) =>
      sb
        .from("profiles")
        .update({ is_active: !currentActive })
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },

  async deleteUser(userId: string, userRole: string): Promise<ServiceResult<null>> {
    try {
      const res = await fetch("/api/users", {
        method: "DELETE",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ userId, userRole }),
      });
      const json = await res.json();
      if (!res.ok) return { data: null, error: json.error || "Delete failed" };
      return { data: null, error: null };
    } catch {
      return { data: null, error: "Network error" };
    }
  },
};
