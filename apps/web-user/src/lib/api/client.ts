import type { ApiResponse, ApiError, RequestConfig } from "@/types/api";

const DEFAULT_BASE_URL =
  process.env.NEXT_PUBLIC_API_URL || "http://localhost:3001/api";

class ApiClient {
  private baseUrl: string;
  private defaultHeaders: Record<string, string>;

  constructor(baseUrl: string = DEFAULT_BASE_URL) {
    this.baseUrl = baseUrl;
    this.defaultHeaders = {
      "Content-Type": "application/json",
    };
  }

  private getAuthToken(): string | null {
    if (typeof window === "undefined") return null;
    return localStorage.getItem("auth_token");
  }

  private buildHeaders(customHeaders?: Record<string, string>): HeadersInit {
    const headers: Record<string, string> = {
      ...this.defaultHeaders,
      ...customHeaders,
    };

    const token = this.getAuthToken();
    if (token) {
      headers["Authorization"] = `Bearer ${token}`;
    }

    return headers;
  }

  private buildUrl(endpoint: string, params?: Record<string, string>): string {
    const url = new URL(`${this.baseUrl}${endpoint}`);
    if (params) {
      Object.entries(params).forEach(([key, value]) => {
        url.searchParams.append(key, value);
      });
    }
    return url.toString();
  }

  private async handleResponse<T>(response: Response): Promise<ApiResponse<T>> {
    if (!response.ok) {
      const errorBody = await response.json().catch(() => null);
      const error: ApiError = {
        message:
          errorBody?.message || `HTTP Error: ${response.status} ${response.statusText}`,
        statusCode: response.status,
        errors: errorBody?.errors,
      };
      throw error;
    }

    // Handle 204 No Content
    if (response.status === 204) {
      return { data: null as T, status: response.status };
    }

    const data = await response.json();
    return {
      data: data as T,
      status: response.status,
    };
  }

  async get<T>(endpoint: string, config?: RequestConfig): Promise<ApiResponse<T>> {
    const url = this.buildUrl(endpoint, config?.params);
    const response = await fetch(url, {
      method: "GET",
      headers: this.buildHeaders(config?.headers),
      signal: config?.signal,
    });
    return this.handleResponse<T>(response);
  }

  async post<T>(
    endpoint: string,
    body?: unknown,
    config?: RequestConfig
  ): Promise<ApiResponse<T>> {
    const url = this.buildUrl(endpoint, config?.params);
    const response = await fetch(url, {
      method: "POST",
      headers: this.buildHeaders(config?.headers),
      body: body ? JSON.stringify(body) : undefined,
      signal: config?.signal,
    });
    return this.handleResponse<T>(response);
  }

  async put<T>(
    endpoint: string,
    body?: unknown,
    config?: RequestConfig
  ): Promise<ApiResponse<T>> {
    const url = this.buildUrl(endpoint, config?.params);
    const response = await fetch(url, {
      method: "PUT",
      headers: this.buildHeaders(config?.headers),
      body: body ? JSON.stringify(body) : undefined,
      signal: config?.signal,
    });
    return this.handleResponse<T>(response);
  }

  async patch<T>(
    endpoint: string,
    body?: unknown,
    config?: RequestConfig
  ): Promise<ApiResponse<T>> {
    const url = this.buildUrl(endpoint, config?.params);
    const response = await fetch(url, {
      method: "PATCH",
      headers: this.buildHeaders(config?.headers),
      body: body ? JSON.stringify(body) : undefined,
      signal: config?.signal,
    });
    return this.handleResponse<T>(response);
  }

  async delete<T>(
    endpoint: string,
    config?: RequestConfig
  ): Promise<ApiResponse<T>> {
    const url = this.buildUrl(endpoint, config?.params);
    const response = await fetch(url, {
      method: "DELETE",
      headers: this.buildHeaders(config?.headers),
      signal: config?.signal,
    });
    return this.handleResponse<T>(response);
  }

  async upload<T>(
    endpoint: string,
    formData: FormData,
    config?: RequestConfig
  ): Promise<ApiResponse<T>> {
    const url = this.buildUrl(endpoint, config?.params);
    const headers = this.buildHeaders(config?.headers);
    // Remove Content-Type for FormData — browser sets it with boundary
    delete (headers as Record<string, string>)["Content-Type"];

    const response = await fetch(url, {
      method: "POST",
      headers,
      body: formData,
      signal: config?.signal,
    });
    return this.handleResponse<T>(response);
  }
}

// Singleton instance
export const apiClient = new ApiClient();
export default ApiClient;
