/** API endpoint constants for web-admin */

export const AUTH_ENDPOINTS = {
  LOGIN: "/auth/admin/login",
  LOGOUT: "/auth/logout",
  REFRESH_TOKEN: "/auth/refresh",
  ME: "/auth/me",
} as const;

export const USER_MANAGEMENT_ENDPOINTS = {
  LIST: "/admin/users",
  DETAIL: (id: string) => `/admin/users/${id}`,
  CREATE: "/admin/users",
  UPDATE: (id: string) => `/admin/users/${id}`,
  DELETE: (id: string) => `/admin/users/${id}`,
  SUSPEND: (id: string) => `/admin/users/${id}/suspend`,
  ACTIVATE: (id: string) => `/admin/users/${id}/activate`,
} as const;

export const CONTENT_MANAGEMENT_ENDPOINTS = {
  LIST: "/admin/content",
  DETAIL: (id: string) => `/admin/content/${id}`,
  APPROVE: (id: string) => `/admin/content/${id}/approve`,
  REJECT: (id: string) => `/admin/content/${id}/reject`,
  DELETE: (id: string) => `/admin/content/${id}`,
  FLAGGED: "/admin/content/flagged",
} as const;

export const AUTHOR_MANAGEMENT_ENDPOINTS = {
  LIST: "/admin/authors",
  DETAIL: (id: string) => `/admin/authors/${id}`,
  APPROVE: (id: string) => `/admin/authors/${id}/approve`,
  REVOKE: (id: string) => `/admin/authors/${id}/revoke`,
} as const;

export const ANALYTICS_ENDPOINTS = {
  DASHBOARD: "/admin/analytics/dashboard",
  USERS: "/admin/analytics/users",
  CONTENT: "/admin/analytics/content",
  REVENUE: "/admin/analytics/revenue",
} as const;

export const SYSTEM_ENDPOINTS = {
  SETTINGS: "/admin/settings",
  ROLES: "/admin/roles",
  PERMISSIONS: "/admin/permissions",
  AUDIT_LOGS: "/admin/audit-logs",
  INTEGRATIONS: "/admin/integrations",
} as const;
