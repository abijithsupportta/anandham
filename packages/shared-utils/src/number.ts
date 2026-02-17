/**
 * Format a number as currency
 */
export function formatCurrency(
  amount: number,
  currency = 'INR',
  locale = 'en-IN',
): string {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency,
  }).format(amount);
}

/**
 * Format a number with locale-specific separators
 */
export function formatNumber(num: number, locale = 'en-IN'): string {
  return new Intl.NumberFormat(locale).format(num);
}

/**
 * Clamp a number between min and max
 */
export function clamp(value: number, min: number, max: number): number {
  return Math.min(Math.max(value, min), max);
}

/**
 * Calculate percentage
 */
export function percentage(value: number, total: number, decimals = 1): number {
  if (total === 0) return 0;
  return Number(((value / total) * 100).toFixed(decimals));
}
