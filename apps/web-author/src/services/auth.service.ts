import { apiClient } from "@/lib/api/client";
import { AUTH_ENDPOINTS } from "@/lib/api/endpoints";
import type { LoginRequest, LoginResponse } from "@/types/api";
import { STORAGE_KEYS } from "@/lib/constants";

class AuthService {
  async login(credentials: LoginRequest): Promise<LoginResponse> {
    const response = await apiClient.post<LoginResponse>(
      AUTH_ENDPOINTS.LOGIN,
      credentials
    );

    if (typeof window !== "undefined") {
      localStorage.setItem(STORAGE_KEYS.AUTH_TOKEN, response.data.accessToken);
      localStorage.setItem(
        STORAGE_KEYS.REFRESH_TOKEN,
        response.data.refreshToken
      );
    }

    return response.data;
  }

  async logout(): Promise<void> {
    try {
      await apiClient.post(AUTH_ENDPOINTS.LOGOUT);
    } finally {
      if (typeof window !== "undefined") {
        localStorage.removeItem(STORAGE_KEYS.AUTH_TOKEN);
        localStorage.removeItem(STORAGE_KEYS.REFRESH_TOKEN);
      }
    }
  }

  async refreshToken(): Promise<string> {
    const refreshToken =
      typeof window !== "undefined"
        ? localStorage.getItem(STORAGE_KEYS.REFRESH_TOKEN)
        : null;

    if (!refreshToken) {
      throw new Error("No refresh token available");
    }

    const response = await apiClient.post<{ accessToken: string }>(
      AUTH_ENDPOINTS.REFRESH_TOKEN,
      { refreshToken }
    );

    if (typeof window !== "undefined") {
      localStorage.setItem(STORAGE_KEYS.AUTH_TOKEN, response.data.accessToken);
    }

    return response.data.accessToken;
  }

  async getCurrentUser() {
    return apiClient.get(AUTH_ENDPOINTS.ME);
  }

  getToken(): string | null {
    if (typeof window === "undefined") return null;
    return localStorage.getItem(STORAGE_KEYS.AUTH_TOKEN);
  }

  isAuthenticated(): boolean {
    return !!this.getToken();
  }
}

export const authService = new AuthService();
export default AuthService;
