"use client";

import { useEffect, useState, type DragEvent } from "react";
import type { GuruKeerthanam, ContentStatus } from "@/types/database";
import Link from "next/link";
import { Music, Plus, Eye, Pencil, Trash2, Youtube, Tag, GripVertical } from "lucide-react";
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
  const [orderedKeerthanams, setOrderedKeerthanams] = useState<GuruKeerthanam[]>([]);
  const [draggingId, setDraggingId] = useState<string | null>(null);
  const [savingOrder, setSavingOrder] = useState(false);
  const [deleteConfirm, setDeleteConfirm] = useState<{ id: string; title: string } | null>(null);
  const [deleting, setDeleting] = useState(false);
  const perPage = 10;

  useEffect(() => {
    setOrderedKeerthanams(keerthanams);
  }, [keerthanams]);

  const hasOrderChanges =
    orderedKeerthanams.length === keerthanams.length &&
    orderedKeerthanams.some((item, index) => item.id !== keerthanams[index]?.id);

  const canReorder = search.trim() === "" && statusFilter === "all";

  // ── Filtering & pagination ───────────────────────────────

  const filtered = orderedKeerthanams.filter((k) => {
    const matchesSearch =
      k.title.toLowerCase().includes(search.toLowerCase()) ||
      k.description.toLowerCase().includes(search.toLowerCase()) ||
      (k.author_name ?? "").toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === "all" || k.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = canReorder ? filtered : filtered.slice((page - 1) * perPage, page * perPage);

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
    toast("Keerthanam permanently deleted", "success");
    setDeleteConfirm(null);
    refetch();
  }

  function handleDragOver(targetId: string, event: DragEvent<HTMLTableRowElement>) {
    event.preventDefault();
    if (!canReorder || !draggingId || draggingId === targetId) return;

    setOrderedKeerthanams((prev) => {
      const fromIndex = prev.findIndex((item) => item.id === draggingId);
      const toIndex = prev.findIndex((item) => item.id === targetId);
      if (fromIndex < 0 || toIndex < 0 || fromIndex === toIndex) return prev;

      const next = [...prev];
      const [moved] = next.splice(fromIndex, 1);
      next.splice(toIndex, 0, moved);
      return next;
    });
  }

  async function handleSaveOrder() {
    if (!hasOrderChanges) return;

    setSavingOrder(true);
    const result = await keerthanamService.reorder(orderedKeerthanams.map((item) => item.id));
    setSavingOrder(false);

    if (result.error) {
      toast(result.error, "error");
      return;
    }

    toast("Keerthanam priority updated", "success");
    refetch();
  }

  function handleResetOrder() {
    setOrderedKeerthanams(keerthanams);
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
        <div className="flex items-center gap-2 sm:ml-auto">
          <button
            onClick={handleResetOrder}
            disabled={!hasOrderChanges || savingOrder}
            className="rounded-lg border border-border-main px-3 py-2 text-sm font-medium text-foreground transition hover:bg-surface-hover disabled:cursor-not-allowed disabled:opacity-50"
          >
            Reset
          </button>
          <button
            onClick={handleSaveOrder}
            disabled={!hasOrderChanges || savingOrder}
            className="rounded-lg bg-indigo-600 px-3 py-2 text-sm font-medium text-white transition hover:bg-indigo-700 disabled:cursor-not-allowed disabled:opacity-50"
          >
            {savingOrder ? "Saving..." : "Save order"}
          </button>
        </div>
      </div>
      {!canReorder && (
        <p className="text-xs text-muted">Clear search and status filter to reorder by drag and drop.</p>
      )}

      {/* Table */}
      <div className="overflow-hidden rounded-xl border border-border-main bg-card shadow-sm">
        <table className="w-full">
          <thead>
            <tr className="border-b border-border-main bg-surface-hover">
              <th className="w-12 px-2 py-3" />
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
                className={`transition hover:bg-surface-hover ${draggingId === item.id ? "opacity-60" : ""}`}
                draggable={canReorder}
                onDragStart={() => setDraggingId(item.id)}
                onDragOver={(event) => handleDragOver(item.id, event)}
                onDragEnd={() => setDraggingId(null)}
                onDrop={() => setDraggingId(null)}
              >
                <td className="px-2 py-4 text-center">
                  <span className={`inline-flex rounded p-1 ${canReorder ? "cursor-grab text-muted" : "text-border-main"}`}>
                    <GripVertical className="h-4 w-4" />
                  </span>
                </td>
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
                      onClick={() => setDeleteConfirm({ id: item.id, title: item.title })}
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

      {/* Delete confirmation modal */}
      {deleteConfirm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
          <div className="max-w-md rounded-lg bg-card p-6 shadow-lg">
            <h3 className="text-lg font-semibold text-foreground">Delete Keerthanam?</h3>
            <p className="mt-2 text-sm text-muted">
              This will permanently delete <strong>{deleteConfirm.title}</strong> from the database. This action cannot be undone.
            </p>
            <div className="mt-6 flex gap-3">
              <button
                onClick={() => handleDelete(deleteConfirm.id)}
                disabled={deleting}
                className="flex-1 rounded-lg bg-red-600 px-3 py-2 text-sm font-medium text-white transition hover:bg-red-700 disabled:cursor-not-allowed disabled:opacity-50"
              >
                {deleting ? "Deleting..." : "Delete Permanently"}
              </button>
              <button
                onClick={() => setDeleteConfirm(null)}
                disabled={deleting}
                className="flex-1 rounded-lg border border-border-main px-3 py-2 text-sm font-medium text-foreground transition hover:bg-surface-hover disabled:cursor-not-allowed disabled:opacity-50"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
