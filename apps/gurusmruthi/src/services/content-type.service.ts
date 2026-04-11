import type { ContentType } from "@/types/database";
import { serviceCall } from "./base";
import type { ServiceResult } from "./base";

// ── Content Type service ─────────────────────────────

export const contentTypeService = {
  async getAll(): Promise<ServiceResult<ContentType[]>> {
    return serviceCall((sb) =>
      sb
        .from("content_types")
        .select("*")
        .eq("is_active", true)
        .order("display_order")
    );
  },
};
