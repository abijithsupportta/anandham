/** Shared type definitions for web-user */

export interface User {
  id: string;
  email: string;
  name: string;
  avatar?: string;
  createdAt: string;
  updatedAt: string;
}

export interface ContentItem {
  id: string;
  title: string;
  description: string;
  coverImage?: string;
  authorId: string;
  authorName: string;
  category: string;
  tags: string[];
  publishedAt: string;
  readingTime: number;
}

export interface Category {
  id: string;
  name: string;
  slug: string;
  description?: string;
  count: number;
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
