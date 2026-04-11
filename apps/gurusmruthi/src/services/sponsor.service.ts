import type { Sponsor } from "@/types/database";
import { serviceCall } from "./base";
import type { ServiceResult } from "./base";

// ── Sponsor service ─────────────────────────────────────

export const sponsorService = {
  async getAll(): Promise<ServiceResult<Sponsor[]>> {
    return serviceCall((sb) =>
      sb
        .from("sponsors")
        .select("*")
        .eq("is_deleted", false)
        .eq("status", "published")
        .order("donated_amount", { ascending: false })
    );
  },

  async getById(id: string): Promise<ServiceResult<Sponsor>> {
    return serviceCall((sb) =>
      sb
        .from("sponsors")
        .select("*")
        .eq("id", id)
        .eq("status", "published")
        .eq("is_deleted", false)
        .single()
    );
  },
};
