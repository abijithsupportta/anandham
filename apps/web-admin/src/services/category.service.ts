import type { ContentCategory, ContentType } from "@/types/database";
import { serviceCall, toSlug, now } from "./base";
import type { ServiceResult } from "./base";

// ── Input types ────────────────────────────────────────────

export interface CreateContentCategoryInput {
  content_type_id: string;
  name: string;
  description: string;
  is_active: boolean;
}

export type UpdateContentCategoryInput = CreateContentCategoryInput;

// ── Content Category service ───────────────────────────────

export const contentCategoryService = {
  async getAll(): Promise<ServiceResult<ContentCategory[]>> {
    return serviceCall((sb) =>
      sb
        .from("content_categories")
        .select("*, content_type:content_types(*)")
        .order("display_order")
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

  async create(input: CreateContentCategoryInput): Promise<ServiceResult<ContentCategory>> {
    const slug = toSlug(input.name);
    const timestamp = now();

    return serviceCall((sb) =>
      sb
        .from("content_categories")
        .insert({
          content_type_id: input.content_type_id,
          name: input.name,
          slug,
          description: input.description,
          is_active: input.is_active,
          created_at: timestamp,
          updated_at: timestamp,
        })
        .select()
        .single()
    );
  },

  async update(id: string, input: UpdateContentCategoryInput): Promise<ServiceResult<ContentCategory>> {
    const slug = toSlug(input.name);

    return serviceCall((sb) =>
      sb
        .from("content_categories")
        .update({
          content_type_id: input.content_type_id,
          name: input.name,
          slug,
          description: input.description,
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
      sb.from("content_categories").delete().eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },

  async toggleActive(id: string, currentActive: boolean): Promise<ServiceResult<null>> {
    return serviceCall((sb) =>
      sb
        .from("content_categories")
        .update({ is_active: !currentActive, updated_at: now() })
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },
};
