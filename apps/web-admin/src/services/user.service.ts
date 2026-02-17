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
};
