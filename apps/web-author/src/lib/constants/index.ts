/** Application-wide constants for web-author */

export const APP_NAME = "Anandham Author";
export const APP_DESCRIPTION = "Content Management Portal";

export const ROUTES = {
  DASHBOARD: "/",
  LOGIN: "/login",
  CONTENT: "/content",
  CONTENT_NEW: "/content/new",
  DRAFTS: "/drafts",
  PUBLISHED: "/published",
  EDITOR: "/editor",
  MEDIA: "/media",
  ANALYTICS: "/analytics",
  PROFILE: "/profile",
  SETTINGS: "/settings",
} as const;

export const CONTENT_STATUS = {
  DRAFT: "draft",
  IN_REVIEW: "in_review",
  PUBLISHED: "published",
  ARCHIVED: "archived",
  REJECTED: "rejected",
} as const;

export const PAGINATION = {
  DEFAULT_PAGE: 1,
  DEFAULT_PAGE_SIZE: 20,
  MAX_PAGE_SIZE: 100,
} as const;

export const STORAGE_KEYS = {
  AUTH_TOKEN: "auth_token",
  REFRESH_TOKEN: "refresh_token",
  EDITOR_DRAFT: "editor_draft",
  THEME: "theme",
} as const;

export const MAX_FILE_SIZES = {
  IMAGE: 5 * 1024 * 1024, // 5MB
  VIDEO: 100 * 1024 * 1024, // 100MB
  DOCUMENT: 20 * 1024 * 1024, // 20MB
} as const;

export const BREAKPOINTS = {
  SM: 640,
  MD: 768,
  LG: 1024,
  XL: 1280,
  "2XL": 1536,
} as const;
