import { useThemeContext } from '@/components/ui/theme/ThemeProvider';
import type { ThemeState } from '@/types/theme';

export function useTheme(): ThemeState {
  return useThemeContext();
}
