/** Application-wide constants for web-user */

export const APP_NAME = "Anandham";
export const APP_DESCRIPTION =
  "Discover joy through stories, knowledge, and community";

export const ROUTES = {
  HOME: "/",
  LOGIN: "/login",
  REGISTER: "/register",
  EXPLORE: "/explore",
  LIBRARY: "/library",
  FAVORITES: "/favorites",
  HISTORY: "/history",
  SETTINGS: "/settings",
  PROFILE: "/profile",
} as const;

export const PAGINATION = {
  DEFAULT_PAGE: 1,
  DEFAULT_PAGE_SIZE: 20,
  MAX_PAGE_SIZE: 100,
} as const;

export const STORAGE_KEYS = {
  AUTH_TOKEN: "auth_token",
  REFRESH_TOKEN: "refresh_token",
  USER_PREFERENCES: "user_preferences",
  THEME: "theme",
} as const;

export const BREAKPOINTS = {
  SM: 640,
  MD: 768,
  LG: 1024,
  XL: 1280,
  "2XL": 1536,
} as const;
