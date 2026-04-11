// Central theme configuration
export const themeConfig = {
  defaultTheme: 'light' as const,
  storageKey: 'gurusmruthi-theme',
  themes: {
    light: {
      primary: 'blue',
      secondary: 'slate',
      background: 'white',
      text: 'gray-900'
    },
    dark: {
      primary: 'amber',
      secondary: 'gray',
      background: 'black',
      text: 'gray-100'
    }
  },
  enableSystem: false,
  disableTransitionOnChange: false
} as const;

export type Theme = 'light' | 'dark';
