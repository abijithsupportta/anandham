// ============================================================
// Database types matching supabase/migrations/ schema
// ============================================================

// ── Enums ──────────────────────────────────────────────────────────────

export type UserRole = "super_admin" | "admin" | "author";
export type ContentStatus = "draft" | "published";
export type ContentLanguage = "ta" | "en" | "sa" | "ml" | "hi";
export type AuditAction = "INSERT" | "UPDATE" | "DELETE";

// ── Profiles (extends auth.users) ──────────────────────────────────────

export interface Profile {
  id: string;
  full_name: string;
  avatar_url?: string | null;
  role: UserRole;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  // Joined from auth.users
  email?: string;
}

// ── Content Types ──────────────────────────────────────────────────────

export interface ContentType {
  id: string;
  name: string;            // 'guru_krithis', 'guru_dharmas', 'guru_photos'
  display_name: string;    // 'Guru Krithis'
  description: string;
  icon: string;
  color: string;
  table_name: string;
  display_order: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

// ── Categories ─────────────────────────────────────────────────────────

export interface Category {
  id: string;
  content_type_id: string;
  name: string;
  slug: string;
  description: string;
  icon: string;
  color: string;
  display_order: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  // Joined
  content_type?: ContentType;
}

// ── Authors ────────────────────────────────────────────────────────────

export interface Author {
  id: string;
  name: string;
  bio: string;
  photo_url?: string | null;
  is_verified: boolean;
  is_active: boolean;
  created_by?: string | null;
  created_at: string;
  updated_at: string;
}

// ── Krithis ────────────────────────────────────────────────────────────

export interface Krithi {
  id: string;
  title: string;
  slug: string;
  description: string;
  category_id?: string | null;
  author_id?: string | null;
  language: ContentLanguage;
  youtube_url?: string | null;
  status: ContentStatus;
  published_at?: string | null;
  is_deleted: boolean;
  deleted_at?: string | null;
  created_by?: string | null;
  updated_by?: string | null;
  created_at: string;
  updated_at: string;
  // Joined
  category?: Category;
  author?: Author;
  slokas?: Sloka[];
  sloka_count?: number;
}

// ── Slokas ─────────────────────────────────────────────────────────────

export interface Sloka {
  id: string;
  krithi_id: string;
  sloka_number: number;
  original_text: string;
  transliteration: string;
  translation: string;
  explanation: string;
  is_deleted: boolean;
  deleted_at?: string | null;
  created_by?: string | null;
  updated_by?: string | null;
  created_at: string;
  updated_at: string;
}

// ── Dharmas ────────────────────────────────────────────────────────────

export interface Dharma {
  id: string;
  title: string;
  slug: string;
  description: string;
  category_id?: string | null;
  author_id?: string | null;
  language: ContentLanguage;
  youtube_url?: string | null;
  status: ContentStatus;
  published_at?: string | null;
  is_deleted: boolean;
  deleted_at?: string | null;
  created_by?: string | null;
  updated_by?: string | null;
  created_at: string;
  updated_at: string;
  // Joined
  category?: Category;
  author?: Author;
  items?: DharmaItem[];
  item_count?: number;
}

// ── Dharma Items ───────────────────────────────────────────────────────

export interface DharmaItem {
  id: string;
  dharma_id: string;
  item_number: number;
  text: string;
  explanation: string;
  is_deleted: boolean;
  deleted_at?: string | null;
  created_by?: string | null;
  updated_by?: string | null;
  created_at: string;
  updated_at: string;
}

// ── Guru Photos ────────────────────────────────────────────────────────

export interface GuruPhoto {
  id: string;
  title: string;
  slug: string;
  description: string;
  image_url: string;
  category_id?: string | null;
  author_id?: string | null;
  display_order: number;
  status: ContentStatus;
  published_at?: string | null;
  is_deleted: boolean;
  deleted_at?: string | null;
  created_by?: string | null;
  updated_by?: string | null;
  created_at: string;
  updated_at: string;
  // Joined
  category?: Category;
  author?: Author;
}

// ── Author Assignments ─────────────────────────────────────────────────

export interface AuthorAssignment {
  id: string;
  user_id: string;
  content_type_id: string;
  record_id?: string | null;
  can_create: boolean;
  can_edit: boolean;
  can_delete: boolean;
  assigned_by?: string | null;
  created_at: string;
  // Joined
  user?: Profile;
  content_type?: ContentType;
}

// ── Audit Logs ─────────────────────────────────────────────────────────

export interface AuditLog {
  id: string;
  table_name: string;
  record_id: string;
  action: AuditAction;
  changed_by?: string | null;
  old_data?: Record<string, unknown> | null;
  new_data?: Record<string, unknown> | null;
  changed_at: string;
  // Joined
  user?: Profile;
}

// ── Dashboard Stats ────────────────────────────────────────────────────

export interface DashboardStats {
  total_krithis: number;
  total_dharmas: number;
  total_guru_photos: number;
  total_authors: number;
  total_categories: number;
  published_krithis: number;
  draft_krithis: number;
  published_dharmas: number;
  draft_dharmas: number;
  recent_changes: number;
}

// ── Pagination ─────────────────────────────────────────────────────────

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  per_page: number;
  total_pages: number;
}

export interface PaginationParams {
  page?: number;
  per_page?: number;
  search?: string;
  sort_by?: string;
  sort_order?: "asc" | "desc";
}

// ── Settings ───────────────────────────────────────────────────────────

export interface AppSettings {
  site_name: string;
  site_description: string;
  maintenance_mode: boolean;
  allow_registration: boolean;
  auto_approve_authors: boolean;
  default_language: ContentLanguage;
  supported_languages: ContentLanguage[];
}
