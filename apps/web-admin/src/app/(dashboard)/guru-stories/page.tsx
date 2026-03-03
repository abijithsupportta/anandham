"use client";

import { useState } from "react";
import type { GuruStory, ContentStatus } from "@/types/database";
import Link from "next/link";
import { BookOpen, Plus, Eye, Pencil, Trash2, UserRound, BookText } from "lucide-react";
import { guruStoryService } from "@/services/guru-story.service";
import { useQuery } from "@/hooks/useQuery";
import { useToast } from "@/hooks/useToast";
import SearchInput from "@/components/ui/search-input";
import StatusBadge from "@/components/ui/status-badge";
import Pagination from "@/components/ui/pagination";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import ErrorState from "@/components/ui/error-state";
import EmptyState from "@/components/ui/empty-state";

export default function GuruStoriesPage() {
  const { toast } = useToast();
  const {
    data: stories,
    loading,
    error,
    refetch,
  } = useQuery<GuruStory>(() => guruStoryService.getAll());

  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"all" | ContentStatus>("all");
  const [page, setPage] = useState(1);
  const perPage = 10;

  const filtered = stories.filter((story) => {
    const matchesSearch =
      story.title.toLowerCase().includes(search.toLowerCase()) ||
      story.author_name.toLowerCase().includes(search.toLowerCase()) ||
      story.reference_book.toLowerCase().includes(search.toLowerCase()) ||
      story.body.toLowerCase().includes(search.toLowerCase());

    const matchesStatus =
      statusFilter === "all" || story.status === statusFilter;

    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filtered.length / perPage);
  const paged = filtered.slice((page - 1) * perPage, page * perPage);

  async function handleToggleStatus(story: GuruStory) {
    const result = await guruStoryService.toggleStatus(story);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast(story.status === "draft" ? "Published" : "Unpublished", "success");
    refetch();
  }

  async function handleDelete(id: string) {
    const result = await guruStoryService.softDelete(id);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast("Guru story deleted", "success");
    refetch();
  }

  if (loading) return <LoadingState message="Loading guru stories..." />;
  if (error) return <ErrorState message={error} onRetry={refetch} />;

  const publishedCount = stories.filter((s) => s.status === "published").length;

  return (
    <div className="space-y-6">
      <PageHeader
        title="Guru Stories"
        subtitle={`${stories.length} total · ${publishedCount} published`}
        action={
          <Link
            href="/guru-stories/new"
            className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700"
          >
            <Plus className="h-4 w-4" />
            New Story
          </Link>
        }
      />

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput
          value={search}
          onChange={setSearch}
          placeholder="Search stories..."
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

      <div className="overflow-hidden rounded-xl border border-border-main bg-card shadow-sm">
        <table className="w-full">
          <thead>
            <tr className="border-b border-border-main bg-surface-hover">
              <th className="px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted">
                Story
              </th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted md:table-cell">
                Author
              </th>
              <th className="hidden px-6 py-3 text-left text-xs font-semibold uppercase tracking-wider text-muted lg:table-cell">
                Reference Book
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
            {paged.map((story) => (
              <tr key={story.id} className="transition hover:bg-surface-hover">
                <td className="px-6 py-4">
                  <div className="flex items-center gap-3">
                    <div className="rounded-lg bg-sky-50 p-2 dark:bg-sky-500/10">
                      <BookOpen className="h-4 w-4 text-sky-600" />
                    </div>
                    <div className="min-w-0">
                      <p className="truncate text-sm font-semibold text-foreground">
                        {story.title}
                      </p>
                      <p className="truncate text-xs text-muted">
                        {story.body.slice(0, 100)}{story.body.length > 100 ? "..." : ""}
                      </p>
                    </div>
                  </div>
                </td>
                <td className="hidden px-6 py-4 md:table-cell">
                  <span className="inline-flex items-center gap-1 text-sm text-foreground">
                    <UserRound className="h-3.5 w-3.5 text-muted" />
                    {story.author_name || "—"}
                  </span>
                </td>
                <td className="hidden px-6 py-4 lg:table-cell">
                  <span className="inline-flex items-center gap-1 text-sm text-foreground">
                    <BookText className="h-3.5 w-3.5 text-muted" />
                    {story.reference_book || "—"}
                  </span>
                </td>
                <td className="px-6 py-4 text-center">
                  <StatusBadge status={story.status} />
                </td>
                <td className="px-6 py-4 text-right">
                  <div className="flex items-center justify-end gap-2">
                    <button
                      onClick={() => handleToggleStatus(story)}
                      className="rounded-md p-1.5 text-muted hover:bg-surface-hover"
                      title={story.status === "draft" ? "Publish" : "Unpublish"}
                    >
                      <Eye className="h-4 w-4" />
                    </button>
                    <Link
                      href={`/guru-stories/${story.id}`}
                      className="rounded-md p-1.5 text-muted hover:bg-surface-hover"
                      title="Edit"
                    >
                      <Pencil className="h-4 w-4" />
                    </Link>
                    <button
                      onClick={() => handleDelete(story.id)}
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
              <EmptyState asTableRow message="No guru stories found" />
            )}
          </tbody>
        </table>
      </div>

      <Pagination currentPage={page} totalPages={totalPages} onPageChange={setPage} />
    </div>
  );
}
