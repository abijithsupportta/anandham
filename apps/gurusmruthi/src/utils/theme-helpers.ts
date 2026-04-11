import type { Theme } from '@/config/theme.config';
import { themeConfig } from '@/config/theme.config';

/**
 * Get the theme from localStorage
 */
export function getStoredTheme(): Theme | null {
  if (typeof window === 'undefined') return null;
  try {
    const stored = localStorage.getItem(themeConfig.storageKey);
    return stored as Theme;
  } catch {
    return null;
  }
}

/**
 * Set the theme in localStorage
 */
export function setStoredTheme(theme: Theme): void {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(themeConfig.storageKey, theme);
  } catch {
    // Ignore errors
  }
}

/**
 * Apply theme to document
 */
export function applyTheme(theme: Theme): void {
  if (typeof document === 'undefined') return;

  const root = document.documentElement;

  root.classList.remove('light', 'dark');
  root.classList.add(theme);

  if (themeConfig.disableTransitionOnChange) {
    root.style.setProperty('--transition-duration', '0s');
  } else {
    root.style.removeProperty('--transition-duration');
  }
}

/**
 * Validate if a theme is valid
 */
export function isValidTheme(theme: string): theme is Theme {
  return theme === 'light' || theme === 'dark';
}
