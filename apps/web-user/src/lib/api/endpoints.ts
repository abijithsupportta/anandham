/** API endpoint constants for web-user */

export const AUTH_ENDPOINTS = {
  LOGIN: "/auth/login",
  REGISTER: "/auth/register",
  LOGOUT: "/auth/logout",
  REFRESH_TOKEN: "/auth/refresh",
  FORGOT_PASSWORD: "/auth/forgot-password",
  RESET_PASSWORD: "/auth/reset-password",
  ME: "/auth/me",
} as const;

export const USER_ENDPOINTS = {
  PROFILE: "/users/profile",
  UPDATE_PROFILE: "/users/profile",
  CHANGE_PASSWORD: "/users/change-password",
  PREFERENCES: "/users/preferences",
} as const;

export const CONTENT_ENDPOINTS = {
  LIST: "/content",
  DETAIL: (id: string) => `/content/${id}`,
  SEARCH: "/content/search",
  CATEGORIES: "/content/categories",
  FEATURED: "/content/featured",
  TRENDING: "/content/trending",
} as const;

export const LIBRARY_ENDPOINTS = {
  MY_LIBRARY: "/library",
  ADD_TO_LIBRARY: "/library",
  REMOVE_FROM_LIBRARY: (id: string) => `/library/${id}`,
  FAVORITES: "/library/favorites",
  HISTORY: "/library/history",
} as const;
