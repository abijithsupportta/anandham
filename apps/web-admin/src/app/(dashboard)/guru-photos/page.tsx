"use client";

import { useEffect, useState, type DragEvent } from "react";
import type { GuruPhoto, ContentStatus } from "@/types/database";
import {
  Image as ImageIcon,
  Plus,
  Pencil,
  Trash2,
  Eye,
  GripVertical,
} from "lucide-react";
import Link from "next/link";
import { guruPhotoService } from "@/services";
import { useQuery } from "@/hooks/useQuery";
import { useToast } from "@/hooks/useToast";
import SearchInput from "@/components/ui/search-input";
import StatusBadge from "@/components/ui/status-badge";
import Pagination from "@/components/ui/pagination";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import ErrorState from "@/components/ui/error-state";
import EmptyState from "@/components/ui/empty-state";

export default function GuruPhotosPage() {
  const { toast } = useToast();
  const { data: photos, loading, error, refetch } = useQuery<GuruPhoto>(
    () => guruPhotoService.getAll()
  );

  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | ContentStatus>("all");
  const [page, setPage] = useState(1);
  const [orderedPhotos, setOrderedPhotos] = useState<GuruPhoto[]>([]);
  const [draggingId, setDraggingId] = useState<string | null>(null);
  const [savingOrder, setSavingOrder] = useState(false);
  const [deleteConfirm, setDeleteConfirm] = useState<{ id: string; title: string } | null>(null);
  const [deleting, setDeleting] = useState(false);
  const perPage = 10;

  useEffect(() => {
    setOrderedPhotos(photos);
  }, [photos]);

  const hasOrderChanges =
    orderedPhotos.length === photos.length &&
    orderedPhotos.some((item, index) => item.id !== photos[index]?.id);

  const canReorder = search.trim() === "" && statusFilter === "all";

  const filtered = orderedPhotos.filter((p) => {
    const matchesSearch =
      p.title.toLowerCase().includes(search.toLowerCase()) ||
      (p.description ?? "").toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === "all" || p.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = canReorder ? filtered : filtered.slice((page - 1) * perPage, page * perPage);

  async function handleToggleStatus(id: string, current: ContentStatus) {
    const result = await guruPhotoService.toggleStatus(id, current);
    if (result.error) { toast(result.error, "error"); return; }
    toast(current === "draft" ? "Published" : "Unpublished", "success");
    refetch();
  }

  async function handleDelete(id: string) {
    const result = await guruPhotoService.softDelete(id);
    if (result.error) { toast(result.error, "error"); return; }
    toast("Photo permanently deleted", "success");
    setDeleteConfirm(null);
    refetch();
  }

  function handleDragOver(targetId: string, event: DragEvent<HTMLTableRowElement>) {
    event.preventDefault();
    if (!canReorder || !draggingId || draggingId === targetId) return;

    setOrderedPhotos((prev) => {
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
    const result = await guruPhotoService.reorder(orderedPhotos.map((item) => item.id));
    setSavingOrder(false);

    if (result.error) {
      toast(result.error, "error");
      return;
    }

    toast("Photo priority updated", "success");
    refetch();
  }

  function handleResetOrder() {
    setOrderedPhotos(photos);
  }

  if (loading) return <LoadingState message="Loading photos..." />;
  if (error) return <ErrorState message={error} onRetry={refetch} />;

  return (
    <div className="space-y-6">
      <PageHeader
        title="Guru Photos"
        subtitle="Manage sacred guru photo gallery"
        action={
          <Link href="/guru-photos/new" className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700">
            <Plus className="h-4 w-4" />
            Upload Photo
          </Link>
        }
      />

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput value={search} onChange={setSearch} placeholder="Search photos..." className="sm:w-72" />
        <select
          value={statusFilter}
          onChange={(e) => { setStatusFilter(e.target.value as "all" | ContentStatus); setPage(1); }}
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

      <div className="overflow-hidden rounded-xl border border-border-main bg-card shadow-sm">
        <table className="w-full">
          <thead>
            <tr className="border-b border-border-main bg-surface-hover">
              <th className="w-12 px-2 py-3" />
              <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted">Photo</th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted md:table-cell">Category</th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted lg:table-cell">Author</th>
              <th className="px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-muted">Status</th>
              <th className="px-6 py-3 text-right text-xs font-semibold uppercase tracking-wider text-muted">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border-light">
            {paged.map((p) => (
              <tr
                key={p.id}
                className={`transition hover:bg-surface-hover ${draggingId === p.id ? "opacity-60" : ""}`}
                draggable={canReorder}
                onDragStart={() => setDraggingId(p.id)}
                onDragOver={(event) => handleDragOver(p.id, event)}
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
                    <div className="h-12 w-20 overflow-hidden rounded bg-gray-100 dark:bg-gray-800">
                      {p.image_url ? (
                        <img src={p.image_url} alt={p.title} className="h-full w-full object-cover" />
                      ) : (
                        <ImageIcon className="h-full w-full text-gray-300 dark:text-gray-600" />
                      )}
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-foreground">{p.title}</p>
                      <p className="text-xs text-muted">{p.description?.slice(0, 50)}</p>
                    </div>
                  </div>
                </td>
                <td className="hidden px-6 py-4 md:table-cell"><span className="rounded-full bg-gray-100 dark:bg-gray-800 px-2.5 py-1 text-xs font-medium text-foreground">{p.category?.name ?? "—"}</span></td>
                <td className="hidden px-6 py-4 lg:table-cell"><span className="text-sm text-foreground">{p.author?.name ?? "—"}</span></td>
                <td className="px-6 py-4 text-center"><StatusBadge status={p.status} /></td>
                <td className="px-6 py-4 text-right">
                  <div className="flex items-center justify-end gap-2">
                    <button onClick={() => handleToggleStatus(p.id, p.status)} className="rounded-md p-1 text-muted hover:bg-surface-hover"><Eye className="h-4 w-4" /></button>
                    <Link href={`/guru-photos/${p.id}`} className="rounded-md p-1 text-muted hover:bg-surface-hover"><Pencil className="h-4 w-4" /></Link>
                    <button onClick={() => setDeleteConfirm({ id: p.id, title: p.title })} className="rounded-md p-1 text-red-500 hover:bg-red-50 dark:hover:bg-red-500/10"><Trash2 className="h-4 w-4" /></button>
                  </div>
                </td>
              </tr>
            ))}
            {paged.length === 0 && <EmptyState asTableRow colSpan={6} message="No photos found" />}
          </tbody>
        </table>
      </div>

      <Pagination currentPage={page} totalPages={totalPages} onPageChange={setPage} />

      {/* Delete confirmation modal */}
      {deleteConfirm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
          <div className="max-w-md rounded-lg bg-card p-6 shadow-lg">
            <h3 className="text-lg font-semibold text-foreground">Delete Photo?</h3>
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
