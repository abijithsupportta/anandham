export * from "./database";

export interface ApiResponse<T = unknown> {
  data?: T;
  error?: string;
  message?: string;
  success: boolean;
}

export type SortDirection = "asc" | "desc";

export interface SelectOption {
  label: string;
  value: string;
}
