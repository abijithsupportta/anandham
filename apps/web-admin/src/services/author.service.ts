import type { Author } from "@/types/database";
import { serviceCall, now } from "./base";
import type { ServiceResult } from "./base";

// ── Input types ────────────────────────────────────────────

export interface AuthorFormInput {
  name: string;
  bio: string;
  is_verified: boolean;
  is_active: boolean;
}

// ── Author service ─────────────────────────────────────────

export const authorService = {
  async getAll(): Promise<ServiceResult<Author[]>> {
    return serviceCall((sb) =>
      sb.from("authors").select("*").order("name")
    );
  },

  async create(input: AuthorFormInput): Promise<ServiceResult<Author>> {
    const timestamp = now();
    return serviceCall((sb) =>
      sb
        .from("authors")
        .insert({
          name: input.name,
          bio: input.bio,
          is_verified: input.is_verified,
          is_active: input.is_active,
          created_at: timestamp,
          updated_at: timestamp,
        })
        .select()
        .single()
    );
  },

  async update(id: string, input: AuthorFormInput): Promise<ServiceResult<Author>> {
    return serviceCall((sb) =>
      sb
        .from("authors")
        .update({ ...input, updated_at: now() })
        .eq("id", id)
        .select()
        .single()
    );
  },

  async delete(id: string): Promise<ServiceResult<null>> {
    return serviceCall((sb) =>
      sb.from("authors").delete().eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },

  async toggleField(id: string, field: "is_active" | "is_verified", current: boolean): Promise<ServiceResult<null>> {
    return serviceCall((sb) =>
      sb
        .from("authors")
        .update({ [field]: !current, updated_at: now() })
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },
};
