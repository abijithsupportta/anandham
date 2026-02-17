import type { Author, ContentType, AuthorAssignment } from "@/types/database";
import { serviceCall, now } from "./base";
import type { ServiceResult } from "./base";

// ── Input types ────────────────────────────────────────────

export interface AuthorFormInput {
  name: string;
  email: string;
  password: string;
  phone: string;
  address: string;
  bio: string;
  photo_url: string;
  is_verified: boolean;
  is_active: boolean;
  content_type_ids: string[];
}

// ── Author service ─────────────────────────────────────────

export const authorService = {
  async getAll(): Promise<ServiceResult<Author[]>> {
    return serviceCall((sb) =>
      sb.from("authors").select("*").order("name")
    );
  },

  async getById(id: string): Promise<ServiceResult<Author>> {
    return serviceCall((sb) =>
      sb
        .from("authors")
        .select("*")
        .eq("id", id)
        .single()
    );
  },

  async getContentTypes(): Promise<ServiceResult<ContentType[]>> {
    return serviceCall((sb) =>
      sb
        .from("content_types")
        .select("*")
        .eq("is_active", true)
        .order("display_order")
    );
  },

  async getAssignments(userId: string): Promise<ServiceResult<AuthorAssignment[]>> {
    return serviceCall((sb) =>
      sb
        .from("author_assignments")
        .select("*, content_type:content_types(*)")
        .eq("user_id", userId)
    );
  },

  /** Create author via server API (needs service_role for auth user creation) */
  async create(input: AuthorFormInput): Promise<ServiceResult<Author>> {
    try {
      const res = await fetch("/api/authors", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name: input.name,
          email: input.email,
          password: input.password,
          phone: input.phone,
          address: input.address,
          bio: input.bio,
          photo_url: input.photo_url,
          content_type_ids: input.content_type_ids,
        }),
      });
      const json = await res.json();
      if (!res.ok) return { data: null, error: json.error || "Create failed" };
      return { data: json.data, error: null };
    } catch {
      return { data: null, error: "Network error" };
    }
  },

  /** Update author via server API */
  async update(id: string, input: Partial<AuthorFormInput>): Promise<ServiceResult<Author>> {
    try {
      const res = await fetch("/api/authors", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ id, ...input }),
      });
      const json = await res.json();
      if (!res.ok) return { data: null, error: json.error || "Update failed" };
      return { data: json.data, error: null };
    } catch {
      return { data: null, error: "Network error" };
    }
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
