/**
 * Validation utilities for admin
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
  if (password.length < 10) errors.push("Must be at least 10 characters");
  if (!/[A-Z]/.test(password)) errors.push("Must contain an uppercase letter");
  if (!/[a-z]/.test(password)) errors.push("Must contain a lowercase letter");
  if (!/[0-9]/.test(password)) errors.push("Must contain a number");
  if (!/[!@#$%^&*(),.?":{}|<>]/.test(password))
    errors.push("Must contain a special character");
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
 * Validates that a role name follows the required format
 */
export function isValidRoleName(role: string): boolean {
  const roleRegex = /^[A-Z_]{2,30}$/;
  return roleRegex.test(role);
}

/**
 * Validates an IP address (IPv4)
 */
export function isValidIPv4(ip: string): boolean {
  const ipRegex = /^(\d{1,3}\.){3}\d{1,3}$/;
  if (!ipRegex.test(ip)) return false;
  return ip.split(".").every((octet) => {
    const num = parseInt(octet, 10);
    return num >= 0 && num <= 255;
  });
}

/**
 * Validates a JSON string
 */
export function isValidJSON(jsonString: string): boolean {
  try {
    JSON.parse(jsonString);
    return true;
  } catch {
    return false;
  }
}

/**
 * Validates a cron expression (basic 5-field)
 */
export function isValidCronExpression(cron: string): boolean {
  const parts = cron.trim().split(/\s+/);
  return parts.length === 5;
}
