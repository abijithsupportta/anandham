import { getSupabase } from "./base";
import type { ServiceResult } from "./base";
import type { AuditLog } from "@/types/database";

// ── Types ──────────────────────────────────────────────────

export interface ContentStats {
  krithis:       { total: number; published: number; draft: number };
  dharmas:       { total: number; published: number; draft: number };
  guruPhotos:    { total: number; published: number; draft: number };
  keerthanams:   { total: number; published: number; draft: number };
  blogs:         { total: number; published: number; draft: number };
  authors:       { total: number; verified: number };
  categories:    { total: number; active: number };
}

export interface DraftItem {
  id: string;
  title: string;
  type: "krithi" | "dharma" | "blog" | "keerthanam" | "guru_photo";
  updated_at: string;
}

export interface CategoryCount {
  name: string;
  count: number;
}

export interface MonthlyGrowth {
  month: string;
  krithis: number;
  dharmas: number;
  blogs: number;
  keerthanams: number;
}

// ── Helpers ────────────────────────────────────────────────

async function countTable(
  table: string,
  filters?: { status?: string }
): Promise<number> {
  const sb = getSupabase();
  let q = sb.from(table).select("id", { count: "exact", head: true }).eq("is_deleted", false);
  if (filters?.status) q = q.eq("status", filters.status);
  const { count } = await q;
  return count ?? 0;
}

// ── Dashboard service ──────────────────────────────────────

export const dashboardService = {
  /** Fetch all content stats in parallel */
  async getStats(): Promise<ServiceResult<ContentStats>> {
    try {
      const [
        krithisTotal, krithisPublished, krithisDraft,
        dharmasTotal, dharmasPublished, dharmasDraft,
        photosTotal, photosPublished, photosDraft,
        keerthanamsTotal, keerthanamsPublished, keerthanamsDraft,
        blogsTotal, blogsPublished, blogsDraft,
      ] = await Promise.all([
        countTable("guru_krithis"),
        countTable("guru_krithis", { status: "published" }),
        countTable("guru_krithis", { status: "draft" }),
        countTable("guru_dharmas"),
        countTable("guru_dharmas", { status: "published" }),
        countTable("guru_dharmas", { status: "draft" }),
        countTable("guru_photos"),
        countTable("guru_photos", { status: "published" }),
        countTable("guru_photos", { status: "draft" }),
        countTable("guru_keerthanams"),
        countTable("guru_keerthanams", { status: "published" }),
        countTable("guru_keerthanams", { status: "draft" }),
        countTable("blogs"),
        countTable("blogs", { status: "published" }),
        countTable("blogs", { status: "draft" }),
      ]);

      // Authors & categories don't have is_deleted/status
      const sb = getSupabase();
      const { count: authorsTotal } = await sb
        .from("authors")
        .select("id", { count: "exact", head: true })
        .eq("is_active", true);
      const { count: authorsVerified } = await sb
        .from("authors")
        .select("id", { count: "exact", head: true })
        .eq("is_active", true)
        .eq("is_verified", true);
      const { count: catsTotal } = await sb
        .from("content_categories")
        .select("id", { count: "exact", head: true });
      const { count: catsActive } = await sb
        .from("content_categories")
        .select("id", { count: "exact", head: true })
        .eq("is_active", true);

      return {
        data: {
          krithis:     { total: krithisTotal, published: krithisPublished, draft: krithisDraft },
          dharmas:     { total: dharmasTotal, published: dharmasPublished, draft: dharmasDraft },
          guruPhotos:  { total: photosTotal, published: photosPublished, draft: photosDraft },
          keerthanams: { total: keerthanamsTotal, published: keerthanamsPublished, draft: keerthanamsDraft },
          blogs:       { total: blogsTotal, published: blogsPublished, draft: blogsDraft },
          authors:     { total: authorsTotal ?? 0, verified: authorsVerified ?? 0 },
          categories:  { total: catsTotal ?? 0, active: catsActive ?? 0 },
        },
        error: null,
      };
    } catch (err) {
      return { data: null, error: err instanceof Error ? err.message : "Failed to load stats" };
    }
  },

  /** Recent audit log entries */
  async getRecentActivity(limit = 10): Promise<ServiceResult<AuditLog[]>> {
    try {
      const sb = getSupabase();
      const { data, error } = await sb
        .from("audit_logs")
        .select("*, user:profiles!changed_by(full_name)")
        .order("changed_at", { ascending: false })
        .limit(limit);

      if (error) return { data: null, error: error.message };
      return { data: data as AuditLog[], error: null };
    } catch (err) {
      return { data: null, error: err instanceof Error ? err.message : "Failed to load activity" };
    }
  },

  /** Draft content across all content types */
  async getDrafts(limit = 10): Promise<ServiceResult<DraftItem[]>> {
    try {
      const sb = getSupabase();

      const [krithis, dharmas, blogs, keerthanams, photos] = await Promise.all([
        sb.from("guru_krithis")
          .select("id, title, updated_at")
          .eq("status", "draft").eq("is_deleted", false)
          .order("updated_at", { ascending: false }).limit(limit),
        sb.from("guru_dharmas")
          .select("id, title, updated_at")
          .eq("status", "draft").eq("is_deleted", false)
          .order("updated_at", { ascending: false }).limit(limit),
        sb.from("blogs")
          .select("id, title, updated_at")
          .eq("status", "draft").eq("is_deleted", false)
          .order("updated_at", { ascending: false }).limit(limit),
        sb.from("guru_keerthanams")
          .select("id, title, updated_at")
          .eq("status", "draft").eq("is_deleted", false)
          .order("updated_at", { ascending: false }).limit(limit),
        sb.from("guru_photos")
          .select("id, title, updated_at")
          .eq("status", "draft").eq("is_deleted", false)
          .order("updated_at", { ascending: false }).limit(limit),
      ]);

      const items: DraftItem[] = [
        ...(krithis.data ?? []).map((r) => ({ ...r, type: "krithi" as const })),
        ...(dharmas.data ?? []).map((r) => ({ ...r, type: "dharma" as const })),
        ...(blogs.data ?? []).map((r) => ({ ...r, type: "blog" as const })),
        ...(keerthanams.data ?? []).map((r) => ({ ...r, type: "keerthanam" as const })),
        ...(photos.data ?? []).map((r) => ({ ...r, type: "guru_photo" as const })),
      ];

      // Sort by most recently updated and take top N
      items.sort((a, b) => new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime());

      return { data: items.slice(0, limit), error: null };
    } catch (err) {
      return { data: null, error: err instanceof Error ? err.message : "Failed to load drafts" };
    }
  },

  /** Category item counts (top N by content count) */
  async getTopCategories(limit = 6): Promise<ServiceResult<CategoryCount[]>> {
    try {
      const sb = getSupabase();

      // Count items per category across content tables
      const { data: cats } = await sb
        .from("content_categories")
        .select("id, name")
        .eq("is_active", true);

      if (!cats || cats.length === 0) return { data: [], error: null };

      // Count from each join table / FK
      const counts = new Map<string, number>();
      for (const cat of cats) counts.set(cat.id, 0);

      // guru_krithis.category_id
      const { data: krithiCats } = await sb
        .from("guru_krithis")
        .select("category_id")
        .eq("is_deleted", false)
        .not("category_id", "is", null);
      for (const r of krithiCats ?? []) {
        if (r.category_id && counts.has(r.category_id))
          counts.set(r.category_id, (counts.get(r.category_id) ?? 0) + 1);
      }

      // guru_dharmas.category_id
      const { data: dharmaCats } = await sb
        .from("guru_dharmas")
        .select("category_id")
        .eq("is_deleted", false)
        .not("category_id", "is", null);
      for (const r of dharmaCats ?? []) {
        if (r.category_id && counts.has(r.category_id))
          counts.set(r.category_id, (counts.get(r.category_id) ?? 0) + 1);
      }

      // guru_keerthanam_categories (junction)
      const { data: keerthanamCats } = await sb
        .from("guru_keerthanam_categories")
        .select("category_id");
      for (const r of keerthanamCats ?? []) {
        if (counts.has(r.category_id))
          counts.set(r.category_id, (counts.get(r.category_id) ?? 0) + 1);
      }

      const catMap = new Map<string, string>();
      for (const cat of cats) catMap.set(cat.id, cat.name);

      const result: CategoryCount[] = [];
      for (const [id, count] of counts) {
        if (count > 0) result.push({ name: catMap.get(id) ?? "", count });
      }
      result.sort((a, b) => b.count - a.count);

      return { data: result.slice(0, limit), error: null };
    } catch (err) {
      return { data: null, error: err instanceof Error ? err.message : "Failed to load categories" };
    }
  },

  /** Monthly content creation over the last 6 months */
  async getMonthlyGrowth(): Promise<ServiceResult<MonthlyGrowth[]>> {
    try {
      const sb = getSupabase();
      const months: MonthlyGrowth[] = [];
      const now = new Date();

      for (let i = 5; i >= 0; i--) {
        const d = new Date(now.getFullYear(), now.getMonth() - i, 1);
        const start = d.toISOString();
        const end = new Date(d.getFullYear(), d.getMonth() + 1, 1).toISOString();
        const label = d.toLocaleString("en-US", { month: "short" });

        const [k, dh, b, ke] = await Promise.all([
          sb.from("guru_krithis").select("id", { count: "exact", head: true })
            .eq("is_deleted", false).gte("created_at", start).lt("created_at", end),
          sb.from("guru_dharmas").select("id", { count: "exact", head: true })
            .eq("is_deleted", false).gte("created_at", start).lt("created_at", end),
          sb.from("blogs").select("id", { count: "exact", head: true })
            .eq("is_deleted", false).gte("created_at", start).lt("created_at", end),
          sb.from("guru_keerthanams").select("id", { count: "exact", head: true })
            .eq("is_deleted", false).gte("created_at", start).lt("created_at", end),
        ]);

        months.push({
          month: label,
          krithis: k.count ?? 0,
          dharmas: dh.count ?? 0,
          blogs: b.count ?? 0,
          keerthanams: ke.count ?? 0,
        });
      }

      return { data: months, error: null };
    } catch (err) {
      return { data: null, error: err instanceof Error ? err.message : "Failed to load growth data" };
    }
  },
};
