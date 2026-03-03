"use client";

import { useEffect, useState, type DragEvent } from "react";
import type { Dharma, ContentStatus } from "@/types/database";
import Link from "next/link";
import { ScrollText, Plus, Eye, Pencil, Trash2, Youtube, GripVertical } from "lucide-react";
import { dharmaService } from "@/services";
import { useQuery } from "@/hooks/useQuery";
import { useToast } from "@/hooks/useToast";
import SearchInput from "@/components/ui/search-input";
import StatusBadge from "@/components/ui/status-badge";
import Pagination from "@/components/ui/pagination";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import ErrorState from "@/components/ui/error-state";
import EmptyState from "@/components/ui/empty-state";

export default function DharmasPage() {
  const { toast } = useToast();
  const { data: dharmas, loading, error, refetch } = useQuery<Dharma>(
    () => dharmaService.getAll()
  );

  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | ContentStatus>("all");
  const [page, setPage] = useState(1);
  const [orderedDharmas, setOrderedDharmas] = useState<Dharma[]>([]);
  const [lineCounts, setLineCounts] = useState<Record<string, number>>({});
  const [draggingId, setDraggingId] = useState<string | null>(null);
  const [savingOrder, setSavingOrder] = useState(false);
  const perPage = 10;

  useEffect(() => {
    setOrderedDharmas(dharmas);
  }, [dharmas]);

  useEffect(() => {
    let isMounted = true;

    async function loadLineCounts() {
      if (dharmas.length === 0) {
        if (isMounted) setLineCounts({});
        return;
      }

      const result = await dharmaService.getLineCounts(dharmas.map((item) => item.id));
      if (isMounted && !result.error) {
        setLineCounts(result.data ?? {});
      }
    }

    loadLineCounts();

    return () => {
      isMounted = false;
    };
  }, [dharmas]);

  const hasOrderChanges =
    orderedDharmas.length === dharmas.length &&
    orderedDharmas.some((item, index) => item.id !== dharmas[index]?.id);

  const canReorder = search.trim() === "" && statusFilter === "all";

  const filtered = orderedDharmas.filter((d) => {
    const matchesSearch =
      d.title.toLowerCase().includes(search.toLowerCase()) ||
      (d.description ?? "").toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === "all" || d.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = canReorder ? filtered : filtered.slice((page - 1) * perPage, page * perPage);

  async function handleToggleStatus(dharma: Dharma) {
    const result = await dharmaService.toggleStatus(dharma);
    if (result.error) { toast(result.error, "error"); return; }
    toast(dharma.status === "draft" ? "Published" : "Unpublished", "success");
    refetch();
  }

  async function handleDelete(id: string) {
    const result = await dharmaService.softDelete(id);
    if (result.error) { toast(result.error, "error"); return; }
    toast("Dharma deleted", "success");
    refetch();
  }

  function handleDragOver(targetId: string, event: DragEvent<HTMLTableRowElement>) {
    event.preventDefault();
    if (!canReorder || !draggingId || draggingId === targetId) return;

    setOrderedDharmas((prev) => {
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
    const result = await dharmaService.reorder(orderedDharmas.map((item) => item.id));
    setSavingOrder(false);

    if (result.error) {
      toast(result.error, "error");
      return;
    }

    toast("Dharma priority updated", "success");
    refetch();
  }

  function handleResetOrder() {
    setOrderedDharmas(dharmas);
  }

  if (loading) return <LoadingState message="Loading dharmas..." />;
  if (error) return <ErrorState message={error} onRetry={refetch} />;

  return (
    <div className="space-y-6">
      <PageHeader
        title="Guru Dharmas"
        subtitle="Manage dharma teachings"
        action={
          <Link href="/dharmas/new" className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700">
            <Plus className="h-4 w-4" />
            New Dharma
          </Link>
        }
      />

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput value={search} onChange={setSearch} placeholder="Search dharmas..." className="sm:w-72" />
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
              <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted">Dharma</th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted md:table-cell">Category</th>
              <th className="px-6 py-3 text-center text-xs font-semibold uppercase tracking-wider text-muted">Status</th>
              <th className="px-6 py-3 text-right text-xs font-semibold uppercase tracking-wider text-muted">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border-light">
            {paged.map((dharma) => (
              <tr
                key={dharma.id}
                className={`transition hover:bg-surface-hover ${draggingId === dharma.id ? "opacity-60" : ""}`}
                draggable={canReorder}
                onDragStart={() => setDraggingId(dharma.id)}
                onDragOver={(event) => handleDragOver(dharma.id, event)}
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
                      <ScrollText className="h-4 w-4 text-amber-600" />
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-foreground">
                        {(dharma.description ?? "")
                          .split("\n")
                          .map((line) => line.trim())
                          .find(Boolean) ?? "Dharma"}
                      </p>
                      <p className="text-xs text-muted">
                        {(dharma.description ?? "").slice(0, 60)}{(dharma.description ?? "").length > 60 ? "..." : ""}
                      </p>
                      <p className="text-xs text-muted">
                        {lineCounts[dharma.id] ?? 0} sloka {((lineCounts[dharma.id] ?? 0) === 1 ? "line" : "lines")}
                      </p>
                    </div>
                    {dharma.youtube_url && <Youtube className="h-4 w-4 text-red-500" />}
                  </div>
                </td>
                <td className="hidden px-6 py-4 md:table-cell">
                  <span className="rounded-full bg-gray-100 dark:bg-gray-800 px-2.5 py-1 text-xs font-medium text-foreground">
                    {dharma.category?.name ?? "—"}
                  </span>
                </td>
                <td className="px-6 py-4 text-center">
                  <StatusBadge status={dharma.status} />
                </td>
                <td className="px-6 py-4 text-right">
                  <div className="flex items-center justify-end gap-2">
                    <Link href={`/dharmas/${dharma.id}`} className="rounded-md p-1.5 text-muted hover:bg-surface-hover">
                      <Pencil className="h-4 w-4" />
                    </Link>
                    <button onClick={() => handleToggleStatus(dharma)} className="rounded-md p-1.5 text-muted hover:bg-surface-hover" title={dharma.status === "draft" ? "Publish" : "Unpublish"}>
                      <Eye className="h-4 w-4" />
                    </button>
                    <button onClick={() => handleDelete(dharma.id)} className="rounded-md p-1.5 text-red-500 hover:bg-red-50 dark:hover:bg-red-500/10">
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
            {paged.length === 0 && <EmptyState asTableRow message="No dharmas found" />}
          </tbody>
        </table>
      </div>

      <Pagination currentPage={page} totalPages={totalPages} onPageChange={setPage} />
    </div>
  );
}
