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
    const sb = getSupabase();

    const {
      data: { user },
      error: userError,
    } = await sb.auth.getUser();

    if (userError || !user) {
      return { data: null, error: "Please sign in again" };
    }

    const { data: profile, error: profileError } = await sb
      .from("profiles")
      .select("role")
      .eq("id", user.id)
      .single();

    if (profileError) {
      return { data: null, error: profileError.message };
    }

    const role = profile?.role;

    const baseQuery = sb
      .from("blogs")
      .select("*, category:blog_categories(id, name), author:authors(id, name)")
      .eq("is_deleted", false)
      .order("created_at", { ascending: false });

    if (role === "super_admin" || role === "admin") {
      const { data, error } = await baseQuery;
      return { data: data ?? null, error: error?.message ?? null };
    }

    const { data: author, error: authorError } = await sb
      .from("authors")
      .select("id")
      .eq("user_id", user.id)
      .eq("is_active", true)
      .maybeSingle();

    if (authorError) {
      return { data: null, error: authorError.message };
    }

    if (!author?.id) {
      return { data: [], error: null };
    }

    const { data, error } = await baseQuery.eq("author_id", author.id);
    return { data: data ?? null, error: error?.message ?? null };
  },

  async getById(id: string): Promise<ServiceResult<Blog>> {
    const context = await blogService.getCurrentUserContext();
    if (context.error || !context.data) {
      return { data: null, error: context.error ?? "Unable to resolve user" };
    }

    const isAdmin =
      context.data.role === "super_admin" || context.data.role === "admin";

    let query = getSupabase()
      .from("blogs")
      .select("*, category:blog_categories(id, name), author:authors(id, name)")
      .eq("id", id)
      .single();

    if (!isAdmin && context.data.authorId) {
      query = query.eq("author_id", context.data.authorId);
    }

    if (!isAdmin && !context.data.authorId) {
      return { data: null, error: "Author profile not found for this account" };
    }

    const { data, error } = await query;
    if (error) return { data: null, error: error.message };

    return { data, error: null };
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

  async getCurrentUserContext(): Promise<
    ServiceResult<{ userId: string; role: string; authorId: string | null }>
  > {
    const sb = getSupabase();
    const {
      data: { user },
      error: userError,
    } = await sb.auth.getUser();
    if (userError || !user) {
      return { data: null, error: "Please sign in again" };
    }

    const { data: profile, error: profileError } = await sb
      .from("profiles")
      .select("role")
      .eq("id", user.id)
      .single();

    if (profileError) {
      return { data: null, error: profileError.message };
    }

    const { data: author } = await sb
      .from("authors")
      .select("id")
      .eq("user_id", user.id)
      .eq("is_active", true)
      .maybeSingle();

    return {
      data: {
        userId: user.id,
        role: profile.role,
        authorId: author?.id ?? null,
      },
      error: null,
    };
  },

  async ensureAuthorId(): Promise<ServiceResult<string>> {
    const sb = getSupabase();
    const context = await blogService.getCurrentUserContext();
    if (context.error || !context.data) {
      return { data: null, error: context.error ?? "Unable to resolve user" };
    }

    if (context.data.authorId) {
      return { data: context.data.authorId, error: null };
    }

    const {
      data: { user },
    } = await sb.auth.getUser();

    if (!user) {
      return { data: null, error: "Please sign in again" };
    }

    const { data: profile } = await sb
      .from("profiles")
      .select("full_name")
      .eq("id", user.id)
      .maybeSingle();

    const fallbackName = user.email?.split("@")[0] || "Admin Author";
    const { data: createdAuthor, error: createError } = await sb
      .from("authors")
      .insert({
        name: (profile?.full_name || fallbackName).trim(),
        bio: "Auto-created author profile",
        email: user.email ?? null,
        user_id: user.id,
        is_verified: true,
        is_active: true,
        created_at: now(),
        updated_at: now(),
      })
      .select("id")
      .single();

    if (createError) {
      return { data: null, error: createError.message };
    }

    return { data: createdAuthor.id, error: null };
  },

  async create(input: BlogFormInput): Promise<ServiceResult<Blog>> {
    if (!input.category_id) {
      return { data: null, error: "Category is required" };
    }

    const timestamp = now();
    const isPublished = input.status === "published";
    const context = await blogService.getCurrentUserContext();
    if (context.error || !context.data) {
      return { data: null, error: context.error ?? "Unable to resolve user" };
    }

    const authorResult = await blogService.ensureAuthorId();
    if (authorResult.error || !authorResult.data) {
      return {
        data: null,
        error: authorResult.error ?? "Author profile is required",
      };
    }

    const authorId = authorResult.data;

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
          category_id: input.category_id,
          author_id: authorId,
          language: input.language || "en",
          tags: input.tags,
          status: input.status,
          published_at: isPublished ? timestamp : null,
          created_by: context.data.userId,
          updated_by: context.data.userId,
          created_at: timestamp,
          updated_at: timestamp,
        })
        .select()
        .single()
    );
  },

  async update(id: string, input: BlogFormInput, publish = false): Promise<ServiceResult<Blog>> {
    if (!input.category_id) {
      return { data: null, error: "Category is required" };
    }

    const timestamp = now();
    const status = publish ? "published" : input.status;

    const context = await blogService.getCurrentUserContext();
    if (context.error || !context.data) {
      return { data: null, error: context.error ?? "Unable to resolve user" };
    }

    const isAdmin =
      context.data.role === "super_admin" || context.data.role === "admin";
    if (!isAdmin && !context.data.authorId) {
      return { data: null, error: "Author profile not found for this account" };
    }

    const authorResult = await blogService.ensureAuthorId();
    if (authorResult.error || !authorResult.data) {
      return {
        data: null,
        error: authorResult.error ?? "Author profile is required",
      };
    }

    const authorId = authorResult.data;

    let updateQuery = getSupabase()
      .from("blogs")
      .update({
        title: input.title,
        slug: toSlug(input.title),
        excerpt: input.excerpt,
        body: input.body,
        cover_images: input.cover_images,
        youtube_url: input.youtube_url || null,
        category_id: input.category_id,
        author_id: authorId,
        language: input.language || "en",
        tags: input.tags,
        status,
        published_at: publish ? timestamp : undefined,
        updated_by: context.data.userId,
        updated_at: timestamp,
      })
      .eq("id", id);

    if (!isAdmin) {
      updateQuery = updateQuery.eq("author_id", context.data.authorId!);
    }

    const { data, error } = await updateQuery.select().single();
    if (error) {
      return { data: null, error: error.message };
    }

    return { data, error: null };
  },

  async toggleStatus(id: string, current: string): Promise<ServiceResult<null>> {
    const newStatus = current === "draft" ? "published" : "draft";
    const timestamp = now();

    const context = await blogService.getCurrentUserContext();
    if (context.error || !context.data) {
      return { data: null, error: context.error ?? "Unable to resolve user" };
    }

    const isAdmin =
      context.data.role === "super_admin" || context.data.role === "admin";
    if (!isAdmin && !context.data.authorId) {
      return { data: null, error: "Author profile not found for this account" };
    }

    let query = getSupabase()
      .from("blogs")
      .update({
        status: newStatus,
        published_at: newStatus === "published" ? timestamp : null,
        updated_by: context.data.userId,
        updated_at: timestamp,
      })
      .eq("id", id);

    if (!isAdmin) {
      query = query.eq("author_id", context.data.authorId!);
    }

    const { error } = await query;
    if (error) return { data: null, error: error.message };

    return { data: null, error: null };
  },

  async softDelete(id: string): Promise<ServiceResult<null>> {
    const context = await blogService.getCurrentUserContext();
    if (context.error || !context.data) {
      return { data: null, error: context.error ?? "Unable to resolve user" };
    }

    const isAdmin =
      context.data.role === "super_admin" || context.data.role === "admin";
    if (!isAdmin && !context.data.authorId) {
      return { data: null, error: "Author profile not found for this account" };
    }

    let query = getSupabase()
      .from("blogs")
      .update({
        is_deleted: true,
        deleted_at: now(),
        updated_by: context.data.userId,
        updated_at: now(),
      })
      .eq("id", id);

    if (!isAdmin) {
      query = query.eq("author_id", context.data.authorId!);
    }

    const { error } = await query;
    if (error) return { data: null, error: error.message };

    return { data: null, error: null };
  },
};
