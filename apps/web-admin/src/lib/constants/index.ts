/** Application-wide constants for web-admin */

export const APP_NAME = "Anandham Admin";
export const APP_DESCRIPTION = "System Administration Panel";

export const ROUTES = {
  DASHBOARD: "/",
  LOGIN: "/login",
  USERS: "/users",
  AUTHORS: "/authors",
  CONTENT_CATEGORIES: "/content-categories",
  KRITHIS: "/krithis",
  DHARMAS: "/dharmas",
  GURU_STORIES: "/guru-stories",
  GURU_PHOTOS: "/guru-photos",
  SETTINGS: "/settings",
  AUDIT_LOG: "/audit-log",
} as const;

export const ADMIN_ROLES = {
  SUPER_ADMIN: "super_admin",
  ADMIN: "admin",
  AUTHOR: "author",
} as const;

export const PAGINATION = {
  DEFAULT_PAGE: 1,
  DEFAULT_PAGE_SIZE: 25,
  MAX_PAGE_SIZE: 200,
} as const;

export const STORAGE_KEYS = {
  SIDEBAR_COLLAPSED: "sidebar_collapsed",
  TABLE_PREFERENCES: "table_preferences",
} as const;

export const BREAKPOINTS = {
  SM: 640,
  MD: 768,
  LG: 1024,
  XL: 1280,
  "2XL": 1536,
} as const;
