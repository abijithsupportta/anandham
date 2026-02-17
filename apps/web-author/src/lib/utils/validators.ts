/**
 * Validation utilities
 */

export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

export function isValidPassword(password: string): {
  valid: boolean;
  errors: string[];
} {
  const errors: string[] = [];
  if (password.length < 8) errors.push("Must be at least 8 characters");
  if (!/[A-Z]/.test(password)) errors.push("Must contain an uppercase letter");
  if (!/[a-z]/.test(password)) errors.push("Must contain a lowercase letter");
  if (!/[0-9]/.test(password)) errors.push("Must contain a number");
  return { valid: errors.length === 0, errors };
}

export function isValidUrl(url: string): boolean {
  try {
    new URL(url);
    return true;
  } catch {
    return false;
  }
}

export function isNotEmpty(value: string): boolean {
  return value.trim().length > 0;
}

export function isWithinLength(
  value: string,
  min: number,
  max: number
): boolean {
  const len = value.trim().length;
  return len >= min && len <= max;
}

/**
 * Validates content title length and format
 */
export function isValidTitle(title: string): boolean {
  return title.trim().length >= 3 && title.trim().length <= 200;
}

/**
 * Validates that content body has minimum required length
 */
export function isValidContentBody(body: string, minWords: number = 50): boolean {
  const wordCount = body.trim().split(/\s+/).filter(Boolean).length;
  return wordCount >= minWords;
}

/**
 * Validates allowed file types for upload
 */
export function isValidFileType(
  fileName: string,
  allowedTypes: string[] = [".jpg", ".jpeg", ".png", ".gif", ".webp"]
): boolean {
  const extension = fileName.toLowerCase().slice(fileName.lastIndexOf("."));
  return allowedTypes.includes(extension);
}

/**
 * Validates file size (default max 10MB)
 */
export function isValidFileSize(
  sizeInBytes: number,
  maxSizeMB: number = 10
): boolean {
  return sizeInBytes <= maxSizeMB * 1024 * 1024;
}
