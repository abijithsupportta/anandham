import { createClient } from "@/lib/supabase/client";

// ── Service result type ────────────────────────────────────

export interface ServiceResult<T> {
  data: T | null;
  error: string | null;
}

// ── Helper to get a Supabase client ────────────────────────

export function getSupabase() {
  return createClient();
}

// ── Wrap Supabase calls with consistent error handling ─────

export async function serviceCall<T>(
  fn: (supabase: ReturnType<typeof createClient>) => PromiseLike<{
    data: T | null;
    error: { message: string } | null;
  }>
): Promise<ServiceResult<T>> {
  try {
    const supabase = getSupabase();
    const { data, error } = await fn(supabase);
    if (error) return { data: null, error: error.message };
    return { data, error: null };
  } catch (err) {
    const message = err instanceof Error ? err.message : "An unexpected error occurred";
    return { data: null, error: message };
  }
}

// ── Slug helper ────────────────────────────────────────────

export function toSlug(text: string, maxLen = 80): string {
  return text
    .toLowerCase()
    .replace(/[^a-z0-9\s-]/g, "")
    .replace(/\s+/g, "-")
    .slice(0, maxLen);
}

// ── Timestamp helper ───────────────────────────────────────

export function now(): string {
  return new Date().toISOString();
}
