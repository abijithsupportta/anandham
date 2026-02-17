/** API endpoint constants for web-author */

export const AUTH_ENDPOINTS = {
  LOGIN: "/auth/author/login",
  LOGOUT: "/auth/logout",
  REFRESH_TOKEN: "/auth/refresh",
  ME: "/auth/me",
} as const;

export const AUTHOR_ENDPOINTS = {
  PROFILE: "/authors/profile",
  UPDATE_PROFILE: "/authors/profile",
  STATS: "/authors/stats",
} as const;

export const CONTENT_ENDPOINTS = {
  LIST: "/author/content",
  CREATE: "/author/content",
  DETAIL: (id: string) => `/author/content/${id}`,
  UPDATE: (id: string) => `/author/content/${id}`,
  DELETE: (id: string) => `/author/content/${id}`,
  PUBLISH: (id: string) => `/author/content/${id}/publish`,
  UNPUBLISH: (id: string) => `/author/content/${id}/unpublish`,
  DRAFTS: "/author/content/drafts",
} as const;

export const MEDIA_ENDPOINTS = {
  UPLOAD: "/media/upload",
  LIST: "/media",
  DELETE: (id: string) => `/media/${id}`,
} as const;

export const ANALYTICS_ENDPOINTS = {
  OVERVIEW: "/author/analytics/overview",
  CONTENT: (id: string) => `/author/analytics/content/${id}`,
  READERS: "/author/analytics/readers",
  REVENUE: "/author/analytics/revenue",
} as const;
