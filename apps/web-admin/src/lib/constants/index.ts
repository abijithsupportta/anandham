/** Application-wide constants for web-admin */

export const APP_NAME = "Anandham Admin";
export const APP_DESCRIPTION = "System Administration Panel";

export const ROUTES = {
  DASHBOARD: "/",
  LOGIN: "/login",
  ANALYTICS: "/analytics",
  REPORTS: "/reports",
  USERS: "/users",
  CONTENT: "/content",
  AUTHORS: "/authors",
  CATEGORIES: "/categories",
  SETTINGS: "/settings",
  ROLES: "/roles",
  AUDIT_LOGS: "/logs",
  INTEGRATIONS: "/integrations",
} as const;

export const USER_STATUS = {
  ACTIVE: "active",
  SUSPENDED: "suspended",
  PENDING: "pending",
  DEACTIVATED: "deactivated",
} as const;

export const ADMIN_ROLES = {
  SUPER_ADMIN: "SUPER_ADMIN",
  ADMIN: "ADMIN",
  MODERATOR: "MODERATOR",
  VIEWER: "VIEWER",
} as const;

export const PAGINATION = {
  DEFAULT_PAGE: 1,
  DEFAULT_PAGE_SIZE: 25,
  MAX_PAGE_SIZE: 200,
} as const;

export const STORAGE_KEYS = {
  AUTH_TOKEN: "auth_token",
  REFRESH_TOKEN: "refresh_token",
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
