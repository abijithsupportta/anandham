/** Shared type definitions for web-author */

export interface Author {
  id: string;
  email: string;
  name: string;
  bio?: string;
  avatar?: string;
  createdAt: string;
  updatedAt: string;
}

export interface ContentItem {
  id: string;
  title: string;
  slug: string;
  body: string;
  excerpt?: string;
  coverImage?: string;
  status: ContentStatus;
  category: string;
  tags: string[];
  wordCount: number;
  publishedAt?: string;
  createdAt: string;
  updatedAt: string;
}

export type ContentStatus =
  | "draft"
  | "in_review"
  | "published"
  | "archived"
  | "rejected";

export interface MediaItem {
  id: string;
  fileName: string;
  url: string;
  mimeType: string;
  size: number;
  createdAt: string;
}

export interface AnalyticsOverview {
  totalViews: number;
  totalReaders: number;
  totalContent: number;
  avgRating: number;
  revenueThisMonth: number;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  pageSize: number;
  totalPages: number;
}

export interface SelectOption {
  label: string;
  value: string;
}
