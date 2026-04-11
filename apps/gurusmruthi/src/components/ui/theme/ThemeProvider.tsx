"use client";

import { createContext, useContext, useEffect, useState, type ReactNode } from 'react';
import type { Theme, ThemeState } from '@/types/theme';
import { themeConfig } from '@/config/theme.config';
import { applyTheme, getStoredTheme, setStoredTheme } from '@/utils/theme-helpers';

const ThemeContext = createContext<ThemeState | undefined>(undefined);

export function useThemeContext() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useThemeContext must be used within a ThemeProvider');
  }
  return context;
}

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setThemeState] = useState<Theme>(() => {
    const storedTheme = getStoredTheme();
    return storedTheme || themeConfig.defaultTheme;
  });

  // Apply theme to DOM when theme changes
  useEffect(() => {
    applyTheme(theme);
    setStoredTheme(theme);
  }, [theme]);

  const setTheme = (newTheme: Theme) => {
    setThemeState(newTheme);
  };

  const toggleTheme = () => {
    setTheme(theme === 'light' ? 'dark' : 'light');
  };

  const value: ThemeState = {
    theme,
    setTheme,
    toggleTheme,
    mounted: true,
  };

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>;
}
