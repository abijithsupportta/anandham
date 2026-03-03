"use client";

import { useState } from "react";
import type { Blog, ContentStatus } from "@/types/database";
import Link from "next/link";
import {
  Newspaper,
  Plus,
  Eye,
  Pencil,
  Trash2,
  Globe,
  Tag,
  ImageIcon,
  Youtube,
} from "lucide-react";
import { blogService } from "@/services/blog.service";
import { useQuery } from "@/hooks/useQuery";
import { useToast } from "@/hooks/useToast";
import SearchInput from "@/components/ui/search-input";
import StatusBadge from "@/components/ui/status-badge";
import Pagination from "@/components/ui/pagination";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import ErrorState from "@/components/ui/error-state";
import EmptyState from "@/components/ui/empty-state";

export default function BlogsPage() {
  const { toast } = useToast();
  const {
    data: blogs,
    loading,
    error,
    refetch,
  } = useQuery<Blog>(() => blogService.getAll());

  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | ContentStatus>(
    "all"
  );
  const [page, setPage] = useState(1);
  const perPage = 10;

  // ── Filtering & pagination ───────────────────────────────

  const filtered = blogs.filter((b) => {
    const matchesSearch =
      b.title.toLowerCase().includes(search.toLowerCase()) ||
      (b.excerpt ?? "").toLowerCase().includes(search.toLowerCase()) ||
      (b.tags ?? []).some((t) =>
        t.toLowerCase().includes(search.toLowerCase())
      );
    const matchesStatus = statusFilter === "all" || b.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = filtered.slice((page - 1) * perPage, page * perPage);

  // ── Handlers ─────────────────────────────────────────────

  async function handleToggleStatus(blog: Blog) {
    const result = await blogService.toggleStatus(blog.id, blog.status);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast(blog.status === "draft" ? "Published" : "Unpublished", "success");
    refetch();
  }

  async function handleDelete(id: string) {
    const result = await blogService.softDelete(id);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast("Blog deleted", "success");
    refetch();
  }

  // ── Render ───────────────────────────────────────────────

  if (loading) return <LoadingState message="Loading blog posts..." />;
  if (error) return <ErrorState message={error} onRetry={refetch} />;

  const publishedCount = blogs.filter((b) => b.status === "published").length;

  return (
    <div className="space-y-6">
      <PageHeader
        title="Blog Posts"
        subtitle={`${blogs.length} total · ${publishedCount} published`}
        action={
          <Link
            href="/blogs/new"
            className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700"
          >
            <Plus className="h-4 w-4" />
            New Blog Post
          </Link>
        }
      />

      {/* Filters */}
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput
          value={search}
          onChange={setSearch}
          placeholder="Search blogs..."
          className="sm:w-72"
        />
        <select
          value={statusFilter}
          onChange={(e) => {
            setStatusFilter(e.target.value as "all" | ContentStatus);
            setPage(1);
          }}
          className="rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
        >
          <option value="all">All Status</option>
          <option value="draft">Draft</option>
          <option value="published">Published</option>
        </select>
      </div>

      {/* Table */}
      <div className="overflow-x-auto rounded-xl border border-border-main bg-card shadow-sm">
        <table className="w-full min-w-[1120px]">
          <thead>
            <tr className="border-b border-border-main bg-surface-hover">
              <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted">
                Blog Post
              </th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted md:table-cell">
                Category
              </th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted lg:table-cell">
                Author
              </th>
              <th className="px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-muted">
                Status
              </th>
              <th className="min-w-[360px] px-6 py-3 text-right text-xs font-semibold uppercase tracking-wider text-muted">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border-light">
            {paged.map((blog) => (
              <tr key={blog.id} className="transition hover:bg-surface-hover">
                <td className="px-6 py-4">
                  <div className="flex items-center gap-3">
                    <div className="rounded-lg bg-blue-50 dark:bg-blue-500/10 p-2">
                      <Newspaper className="h-4 w-4 text-blue-600" />
                    </div>
                    <div className="min-w-0">
                      <p className="truncate text-sm font-semibold text-foreground" title={blog.title}>
                        {blog.title.length > 20
                          ? `${blog.title.slice(0, 20)}...`
                          : blog.title}
                      </p>
                      <p className="truncate text-xs text-muted">
                        {blog.excerpt
                          ? blog.excerpt.slice(0, 80) +
                            (blog.excerpt.length > 80 ? "..." : "")
                          : "No excerpt"}
                      </p>
                      {blog.tags && blog.tags.length > 0 && (
                        <div className="mt-1 flex items-center gap-1">
                          <Tag className="h-3 w-3 text-gray-300 dark:text-gray-600" />
                          {blog.tags.slice(0, 3).map((tag) => (
                            <span
                              key={tag}
                              className="rounded bg-gray-100 dark:bg-gray-800 px-1.5 py-0.5 text-[10px] text-muted"
                            >
                              {tag}
                            </span>
                          ))}
                          {blog.tags.length > 3 && (
                            <span className="text-[10px] text-muted">
                              +{blog.tags.length - 3}
                            </span>
                          )}
                        </div>
                      )}
                      {/* Media indicators */}
                      {(blog.cover_images?.length > 0 || blog.youtube_url) && (
                        <div className="mt-1 flex items-center gap-2">
                          {blog.cover_images?.length > 0 && (
                            <span className="inline-flex items-center gap-0.5 text-[10px] text-muted">
                              <ImageIcon className="h-3 w-3" />
                              {blog.cover_images.length}
                            </span>
                          )}
                          {blog.youtube_url && (
                            <span className="inline-flex items-center gap-0.5 text-[10px] text-red-500">
                              <Youtube className="h-3 w-3" />
                              Video
                            </span>
                          )}
                        </div>
                      )}
                    </div>
                  </div>
                </td>
                <td className="hidden px-6 py-4 md:table-cell">
                  <span className="rounded-full bg-gray-100 dark:bg-gray-800 px-2.5 py-1 text-xs font-medium text-foreground">
                    {blog.category?.name ?? "—"}
                  </span>
                </td>
                <td className="hidden px-6 py-4 lg:table-cell">
                  <span className="text-sm text-gray-600 dark:text-gray-400">
                    {blog.author?.name ?? "Anandham"}
                  </span>
                </td>
                <td className="px-6 py-4 text-center">
                  <StatusBadge status={blog.status} />
                </td>
                <td className="min-w-[360px] px-6 py-4 text-right">
                  <div className="flex items-center justify-end gap-2 whitespace-nowrap">
                    <Link
                      href={`/blogs/${blog.id}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="inline-flex items-center gap-1 rounded-md border border-input-border bg-card px-2.5 py-1.5 text-xs font-medium text-foreground transition hover:bg-surface-hover"
                      title="View"
                    >
                      <Eye className="h-3.5 w-3.5" />
                      View
                    </Link>
                    <Link
                      href={`/blogs/${blog.id}`}
                      className="inline-flex items-center gap-1 rounded-md border border-input-border bg-card px-2.5 py-1.5 text-xs font-medium text-foreground transition hover:bg-surface-hover"
                      title="Edit"
                    >
                      <Pencil className="h-3.5 w-3.5" />
                      Edit
                    </Link>
                    <button
                      onClick={() => handleToggleStatus(blog)}
                      className="inline-flex items-center gap-1 rounded-md border border-input-border bg-card px-2.5 py-1.5 text-xs font-medium text-foreground transition hover:bg-surface-hover"
                      title={
                        blog.status === "draft" ? "Publish" : "Unpublish"
                      }
                    >
                      {blog.status === "published" ? (
                        <Eye className="h-3.5 w-3.5" />
                      ) : (
                        <Globe className="h-3.5 w-3.5" />
                      )}
                      {blog.status === "draft" ? "Publish" : "Unpublish"}
                    </button>
                    <button
                      onClick={() => handleDelete(blog.id)}
                      className="inline-flex items-center gap-1 rounded-md border border-red-200 bg-red-50 px-2.5 py-1.5 text-xs font-medium text-red-600 transition hover:bg-red-100 dark:border-red-500/40 dark:bg-red-500/10 dark:text-red-400 dark:hover:bg-red-500/20"
                      title="Delete"
                    >
                      <Trash2 className="h-3.5 w-3.5" />
                      Delete
                    </button>
                  </div>
                </td>
              </tr>
            ))}
            {paged.length === 0 && (
              <EmptyState asTableRow message="No blog posts found" />
            )}
          </tbody>
        </table>
      </div>

      <Pagination
        currentPage={page}
        totalPages={totalPages}
        onPageChange={setPage}
      />
    </div>
  );
}
