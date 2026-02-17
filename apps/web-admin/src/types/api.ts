/** API-related type definitions */

export interface ApiResponse<T> {
  data: T;
  status: number;
}

export interface ApiError {
  message: string;
  statusCode: number;
  errors?: Record<string, string[]>;
}

export interface RequestConfig {
  headers?: Record<string, string>;
  params?: Record<string, string>;
  signal?: AbortSignal;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  accessToken: string;
  refreshToken: string;
  user: {
    id: string;
    email: string;
    name: string;
    role: string;
    permissions: string[];
  };
}

export interface CreateUserRequest {
  email: string;
  name: string;
  role: string;
  password: string;
}

export interface UpdateUserRequest {
  id: string;
  email?: string;
  name?: string;
  role?: string;
  status?: string;
}

export interface PaginationParams {
  page?: number;
  pageSize?: number;
  sortBy?: string;
  sortOrder?: "asc" | "desc";
  search?: string;
  status?: string;
  role?: string;
  dateFrom?: string;
  dateTo?: string;
}

export interface BulkActionRequest {
  ids: string[];
  action: string;
}
