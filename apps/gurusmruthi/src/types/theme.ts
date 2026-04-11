import type { Theme } from '@/config/theme.config';

export type { Theme };

export interface ThemeState {
  theme: Theme;
  setTheme: (theme: Theme) => void;
  toggleTheme: () => void;
  mounted: boolean;
}

export interface ThemeConfig {
  defaultTheme: Theme;
  storageKey: string;
  themes: {
    light: {
      primary: string;
      secondary: string;
      background: string;
      text: string;
    };
    dark: {
      primary: string;
      secondary: string;
      background: string;
      text: string;
    };
  };
  enableSystem: boolean;
  disableTransitionOnChange: boolean;
}
