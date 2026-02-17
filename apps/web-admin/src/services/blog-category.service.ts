import type { BlogCategory } from "@/types/database";
import { serviceCall, toSlug, now } from "./base";
import type { ServiceResult } from "./base";

// ── Input types ────────────────────────────────────────────

export interface BlogCategoryFormInput {
  name: string;
  description: string;
  parent_id: string; // "" for top-level
  is_active: boolean;
}

// ── Blog Category service ──────────────────────────────────

export const blogCategoryService = {
  async getAll(): Promise<ServiceResult<BlogCategory[]>> {
    return serviceCall((sb) =>
      sb
        .from("blog_categories")
        .select("*, parent:blog_categories!parent_id(id, name)")
        .order("display_order")
        .order("name")
    );
  },

  async getActive(): Promise<ServiceResult<BlogCategory[]>> {
    return serviceCall((sb) =>
      sb
        .from("blog_categories")
        .select("*")
        .eq("is_active", true)
        .order("display_order")
        .order("name")
    );
  },

  async create(input: BlogCategoryFormInput): Promise<ServiceResult<BlogCategory>> {
    const timestamp = now();
    return serviceCall((sb) =>
      sb
        .from("blog_categories")
        .insert({
          name: input.name,
          slug: toSlug(input.name),
          description: input.description,
          parent_id: input.parent_id || null,
          is_active: input.is_active,
          created_at: timestamp,
          updated_at: timestamp,
        })
        .select()
        .single()
    );
  },

  async update(id: string, input: BlogCategoryFormInput): Promise<ServiceResult<BlogCategory>> {
    return serviceCall((sb) =>
      sb
        .from("blog_categories")
        .update({
          name: input.name,
          slug: toSlug(input.name),
          description: input.description,
          parent_id: input.parent_id || null,
          is_active: input.is_active,
          updated_at: now(),
        })
        .eq("id", id)
        .select()
        .single()
    );
  },

  async delete(id: string): Promise<ServiceResult<null>> {
    return serviceCall((sb) =>
      sb.from("blog_categories").delete().eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },

  async toggleActive(id: string, current: boolean): Promise<ServiceResult<null>> {
    return serviceCall((sb) =>
      sb
        .from("blog_categories")
        .update({ is_active: !current, updated_at: now() })
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },
};
