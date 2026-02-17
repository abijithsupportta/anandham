import type { Blog, BlogCategory } from "@/types/database";
import { serviceCall, getSupabase, toSlug, now } from "./base";
import type { ServiceResult } from "./base";

// ── Input types ────────────────────────────────────────────

export interface BlogFormInput {
  title: string;
  excerpt: string;
  body: string;
  cover_images: string[];
  youtube_url: string;
  category_id: string;
  language: string;
  tags: string[];
  status: string;
}

// ── Blog service ───────────────────────────────────────────

export const blogService = {
  async getAll(): Promise<ServiceResult<Blog[]>> {
    return serviceCall((sb) =>
      sb
        .from("blogs")
        .select("*, category:blog_categories(id, name), author:authors(id, name)")
        .eq("is_deleted", false)
        .order("created_at", { ascending: false })
    );
  },

  async getById(id: string): Promise<ServiceResult<Blog>> {
    return serviceCall((sb) =>
      sb
        .from("blogs")
        .select("*, category:blog_categories(id, name), author:authors(id, name)")
        .eq("id", id)
        .single()
    );
  },

  async getCategories(): Promise<ServiceResult<BlogCategory[]>> {
    return serviceCall((sb) =>
      sb
        .from("blog_categories")
        .select("*")
        .eq("is_active", true)
        .order("display_order")
        .order("name")
    );
  },

  /** Resolve the author_id for the currently logged-in user.
   *  - If the user is an author with a linked authors row → return that author id
   *  - Otherwise (admin / super_admin) → return null (shown as "Anandham")
   */
  async resolveAuthorId(): Promise<string | null> {
    const sb = getSupabase();
    const { data: { user } } = await sb.auth.getUser();
    if (!user) return null;

    // Check if this user has a linked author record
    const { data: author } = await sb
      .from("authors")
      .select("id")
      .eq("user_id", user.id)
      .eq("is_active", true)
      .maybeSingle();

    return author?.id ?? null;
  },

  async create(input: BlogFormInput): Promise<ServiceResult<Blog>> {
    const timestamp = now();
    const isPublished = input.status === "published";
    const authorId = await blogService.resolveAuthorId();
    return serviceCall((sb) =>
      sb
        .from("blogs")
        .insert({
          title: input.title,
          slug: toSlug(input.title),
          excerpt: input.excerpt,
          body: input.body,
          cover_images: input.cover_images,
          youtube_url: input.youtube_url || null,
          category_id: input.category_id || null,
          author_id: authorId,
          language: input.language || "en",
          tags: input.tags,
          status: input.status,
          published_at: isPublished ? timestamp : null,
          created_at: timestamp,
          updated_at: timestamp,
        })
        .select()
        .single()
    );
  },

  async update(id: string, input: BlogFormInput, publish = false): Promise<ServiceResult<Blog>> {
    const timestamp = now();
    const status = publish ? "published" : input.status;
    return serviceCall((sb) =>
      sb
        .from("blogs")
        .update({
          title: input.title,
          slug: toSlug(input.title),
          excerpt: input.excerpt,
          body: input.body,
          cover_images: input.cover_images,
          youtube_url: input.youtube_url || null,
          category_id: input.category_id || null,
          language: input.language || "en",
          tags: input.tags,
          status,
          published_at: publish ? timestamp : undefined,
          updated_at: timestamp,
        })
        .eq("id", id)
        .select()
        .single()
    );
  },

  async toggleStatus(id: string, current: string): Promise<ServiceResult<null>> {
    const newStatus = current === "draft" ? "published" : "draft";
    const timestamp = now();
    return serviceCall((sb) =>
      sb
        .from("blogs")
        .update({
          status: newStatus,
          published_at: newStatus === "published" ? timestamp : null,
          updated_at: timestamp,
        })
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },

  async softDelete(id: string): Promise<ServiceResult<null>> {
    return serviceCall((sb) =>
      sb
        .from("blogs")
        .update({ is_deleted: true, deleted_at: now(), updated_at: now() })
        .eq("id", id)
    ) as Promise<ServiceResult<null>>;
  },
};
