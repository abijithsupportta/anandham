/**
 * Get an item from localStorage with JSON parsing
 */
export function getStorageItem<T>(key: string, defaultValue?: T): T | null {
  if (typeof window === 'undefined') return defaultValue ?? null;
  try {
    const item = localStorage.getItem(key);
    return item ? (JSON.parse(item) as T) : (defaultValue ?? null);
  } catch {
    return defaultValue ?? null;
  }
}

/**
 * Set an item in localStorage with JSON serialization
 */
export function setStorageItem<T>(key: string, value: T): void {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(key, JSON.stringify(value));
  } catch (error) {
    console.error(`Failed to set storage item "${key}":`, error);
  }
}

/**
 * Remove an item from localStorage
 */
export function removeStorageItem(key: string): void {
  if (typeof window === 'undefined') return;
  localStorage.removeItem(key);
}

/**
 * Clear all items from localStorage
 */
export function clearStorage(): void {
  if (typeof window === 'undefined') return;
  localStorage.clear();
}
