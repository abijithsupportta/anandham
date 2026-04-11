import type { Author } from "@/types/database";
import { serviceCall } from "./base";
import type { ServiceResult } from "./base";

// ── Author service ─────────────────────────────────────

export const authorService = {
  async getAll(): Promise<ServiceResult<Author[]>> {
    return serviceCall((sb) =>
      sb
        .from("authors")
        .select("*")
        .eq("is_active", true)
        .order("name")
    );
  },

  async getById(id: string): Promise<ServiceResult<Author>> {
    return serviceCall((sb) =>
      sb
        .from("authors")
        .select("*")
        .eq("id", id)
        .eq("is_active", true)
        .single()
    );
  },

  async getVerified(): Promise<ServiceResult<Author[]>> {
    return serviceCall((sb) =>
      sb
        .from("authors")
        .select("*")
        .eq("is_active", true)
        .eq("is_verified", true)
        .order("name")
    );
  },
};
