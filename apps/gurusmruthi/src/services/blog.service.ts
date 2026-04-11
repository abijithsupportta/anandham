import type { Blog, BlogCategory } from "@/types/database";
import { serviceCall } from "./base";
import type { ServiceResult } from "./base";

// ── Blog service ─────────────────────────────────────

export const blogService = {
  async getAll(): Promise<ServiceResult<Blog[]>> {
    return serviceCall((sb) =>
      sb
        .from("blogs")
        .select("*, category:blog_categories(*), author:authors(*)")
        .eq("is_deleted", false)
        .eq("status", "published")
        .order("published_at", { ascending: false })
    );
  },

  async getById(id: string): Promise<ServiceResult<Blog>> {
    return serviceCall((sb) =>
      sb
        .from("blogs")
        .select("*, category:blog_categories(*), author:authors(*)")
        .eq("id", id)
        .eq("status", "published")
        .eq("is_deleted", false)
        .single()
    );
  },

  async getBySlug(slug: string): Promise<ServiceResult<Blog>> {
    return serviceCall((sb) =>
      sb
        .from("blogs")
        .select("*, category:blog_categories(*), author:authors(*)")
        .eq("slug", slug)
        .eq("status", "published")
        .eq("is_deleted", false)
        .single()
    );
  },

  async getByCategory(categoryId: string): Promise<ServiceResult<Blog[]>> {
    return serviceCall((sb) =>
      sb
        .from("blogs")
        .select("*, category:blog_categories(*), author:authors(*)")
        .eq("category_id", categoryId)
        .eq("status", "published")
        .eq("is_deleted", false)
        .order("published_at", { ascending: false })
    );
  },

  async getCategories(): Promise<ServiceResult<BlogCategory[]>> {
    return serviceCall((sb) =>
      sb
        .from("blog_categories")
        .select("*")
        .eq("is_active", true)
        .order("name")
    );
  },
};
