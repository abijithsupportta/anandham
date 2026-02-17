"use client";

import { useState } from "react";
import type { GuruKeerthanam, ContentStatus } from "@/types/database";
import Link from "next/link";
import { Music, Plus, Eye, Pencil, Trash2, Youtube, Tag } from "lucide-react";
import { keerthanamService } from "@/services/keerthanam.service";
import { useQuery } from "@/hooks/useQuery";
import { useToast } from "@/hooks/useToast";
import SearchInput from "@/components/ui/search-input";
import StatusBadge from "@/components/ui/status-badge";
import Pagination from "@/components/ui/pagination";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import ErrorState from "@/components/ui/error-state";
import EmptyState from "@/components/ui/empty-state";

export default function KeerthanamsPage() {
  const { toast } = useToast();
  const {
    data: keerthanams,
    loading,
    error,
    refetch,
  } = useQuery<GuruKeerthanam>(() => keerthanamService.getAll());

  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | ContentStatus>(
    "all"
  );
  const [page, setPage] = useState(1);
  const perPage = 10;

  // ── Filtering & pagination ───────────────────────────────

  const filtered = keerthanams.filter((k) => {
    const matchesSearch =
      k.title.toLowerCase().includes(search.toLowerCase()) ||
      k.description.toLowerCase().includes(search.toLowerCase()) ||
      (k.author_name ?? "").toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === "all" || k.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = filtered.slice((page - 1) * perPage, page * perPage);

  // ── Handlers ─────────────────────────────────────────────

  async function handleToggleStatus(item: GuruKeerthanam) {
    const result = await keerthanamService.toggleStatus(item);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast(item.status === "draft" ? "Published" : "Unpublished", "success");
    refetch();
  }

  async function handleDelete(id: string) {
    const result = await keerthanamService.softDelete(id);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast("Keerthanam deleted", "success");
    refetch();
  }

  // ── Render ───────────────────────────────────────────────

  if (loading) return <LoadingState message="Loading keerthanams..." />;
  if (error) return <ErrorState message={error} onRetry={refetch} />;

  return (
    <div className="space-y-6">
      <PageHeader
        title="Guru Keerthanams"
        subtitle="Manage sacred songs"
        action={
          <Link
            href="/keerthanams/new"
            className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700"
          >
            <Plus className="h-4 w-4" />
            New Keerthanam
          </Link>
        }
      />

      {/* Filters */}
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput
          value={search}
          onChange={setSearch}
          placeholder="Search keerthanams..."
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
      <div className="overflow-hidden rounded-xl border border-border-main bg-card shadow-sm">
        <table className="w-full">
          <thead>
            <tr className="border-b border-border-main bg-surface-hover">
              <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted">
                Keerthanam
              </th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted md:table-cell">
                Author
              </th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted lg:table-cell">
                Categories
              </th>
              <th className="px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-muted">
                Status
              </th>
              <th className="px-6 py-3 text-right text-xs font-semibold uppercase tracking-wider text-muted">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border-light">
            {paged.map((item) => (
              <tr
                key={item.id}
                className="transition hover:bg-surface-hover"
              >
                <td className="px-6 py-4">
                  <div className="flex items-center gap-3">
                    <div className="rounded-lg bg-amber-50 dark:bg-amber-500/10 p-2">
                      <Music className="h-4 w-4 text-amber-600" />
                    </div>
                    <div className="min-w-0">
                      <p className="truncate text-sm font-semibold text-foreground">
                        {item.title}
                      </p>
                      <p className="truncate text-xs text-muted">
                        {item.description.slice(0, 60)}
                        {item.description.length > 60 ? "..." : ""}
                      </p>
                    </div>
                    {item.youtube_url && (
                      <Youtube className="h-4 w-4 shrink-0 text-red-500" />
                    )}
                  </div>
                </td>
                <td className="hidden px-6 py-4 md:table-cell">
                  <span className="text-sm text-gray-600 dark:text-gray-400">
                    {item.author_name || "—"}
                  </span>
                </td>
                <td className="hidden px-6 py-4 lg:table-cell">
                  <div className="flex flex-wrap gap-1">
                    {(item.categories ?? []).length === 0 && (
                      <span className="text-xs text-muted">—</span>
                    )}
                    {(item.categories ?? []).slice(0, 3).map((cat) => (
                      <span
                        key={cat.id}
                        className="inline-flex items-center gap-0.5 rounded-full bg-amber-50 dark:bg-amber-500/10 px-2 py-0.5 text-[10px] font-medium text-amber-700 dark:text-amber-400"
                      >
                        <Tag className="h-2.5 w-2.5" />
                        {cat.name}
                      </span>
                    ))}
                    {(item.categories ?? []).length > 3 && (
                      <span className="text-[10px] text-muted">
                        +{(item.categories ?? []).length - 3}
                      </span>
                    )}
                  </div>
                </td>
                <td className="px-6 py-4 text-center">
                  <StatusBadge status={item.status} />
                </td>
                <td className="px-6 py-4 text-right">
                  <div className="flex items-center justify-end gap-2">
                    <Link
                      href={`/keerthanams/${item.id}`}
                      className="rounded-md p-1.5 text-muted hover:bg-surface-hover"
                      title="Edit"
                    >
                      <Pencil className="h-4 w-4" />
                    </Link>
                    <button
                      onClick={() => handleToggleStatus(item)}
                      className="rounded-md p-1.5 text-muted hover:bg-surface-hover"
                      title={
                        item.status === "draft" ? "Publish" : "Unpublish"
                      }
                    >
                      <Eye className="h-4 w-4" />
                    </button>
                    <button
                      onClick={() => handleDelete(item.id)}
                      className="rounded-md p-1.5 text-red-500 hover:bg-red-50 dark:hover:bg-red-500/10"
                      title="Delete"
                    >
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
            {paged.length === 0 && (
              <EmptyState asTableRow message="No keerthanams found" />
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
