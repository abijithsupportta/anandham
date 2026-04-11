"use client";

import { createContext, useContext } from 'react';
import type { ThemeState } from '@/types/theme';

const ThemeContext = createContext<ThemeState | undefined>(undefined);

export function useThemeContext() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useThemeContext must be used within a ThemeProvider');
  }
  return context;
}

export { ThemeContext };
