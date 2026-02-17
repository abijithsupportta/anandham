"use client";

import { useState } from "react";
import type { Author } from "@/types/database";
import {
  PenTool,
  Plus,
  Pencil,
  Trash2,
  Check,
  X,
  CheckCircle,
  Mail,
  Phone,
} from "lucide-react";
import Link from "next/link";
import { authorService } from "@/services";
import { useQuery } from "@/hooks/useQuery";
import { useToast } from "@/hooks/useToast";
import SearchInput from "@/components/ui/search-input";
import Pagination from "@/components/ui/pagination";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";
import ErrorState from "@/components/ui/error-state";

export default function AuthorsPage() {
  const { toast } = useToast();
  const { data: authors, loading, error, refetch } = useQuery<Author>(
    () => authorService.getAll()
  );

  const [search, setSearch] = useState("");
  const [activeFilter, setActiveFilter] = useState<"all" | "active" | "inactive">("all");
  const [deleteConfirm, setDeleteConfirm] = useState<string | null>(null);
  const [page, setPage] = useState(1);
  const perPage = 10;

  const filtered = authors.filter((a) => {
    const matchesSearch =
      a.name.toLowerCase().includes(search.toLowerCase()) ||
      (a.email ?? "").toLowerCase().includes(search.toLowerCase()) ||
      (a.bio ?? "").toLowerCase().includes(search.toLowerCase());
    const matchesFilter =
      activeFilter === "all" ||
      (activeFilter === "active" && a.is_active) ||
      (activeFilter === "inactive" && !a.is_active);
    return matchesSearch && matchesFilter;
  });

  const totalPages = Math.max(1, Math.ceil(filtered.length / perPage));
  const paged = filtered.slice((page - 1) * perPage, page * perPage);

  async function handleDelete(id: string) {
    const result = await authorService.delete(id);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    toast("Author deleted", "success");
    setDeleteConfirm(null);
    refetch();
  }

  async function handleToggle(id: string, field: "is_active" | "is_verified") {
    const author = authors.find((a) => a.id === id);
    if (!author) return;

    const result = await authorService.toggleField(id, field, author[field]);
    if (result.error) {
      toast(result.error, "error");
      return;
    }
    refetch();
  }

  const verifiedCount = authors.filter((a) => a.is_verified).length;
  const activeCount = authors.filter((a) => a.is_active).length;

  if (loading) return <LoadingState message="Loading authors..." />;
  if (error) return <ErrorState message={error} onRetry={refetch} />;

  return (
    <div className="space-y-6">
      <PageHeader
        title="Authors"
        subtitle={`${authors.length} total · ${activeCount} active · ${verifiedCount} verified`}
        action={
          <Link href="/authors/new" className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700">
            <Plus className="h-4 w-4" />
            Add Author
          </Link>
        }
      />

      {/* Filters */}
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <SearchInput value={search} onChange={setSearch} placeholder="Search authors..." className="sm:w-72" />
        <div className="flex gap-2">
          {([{ label: "All", value: "all" }, { label: "Active", value: "active" }, { label: "Inactive", value: "inactive" }] as const).map((f) => (
            <button
              key={f.value}
              onClick={() => { setActiveFilter(f.value); setPage(1); }}
              className={`rounded-lg px-3 py-1.5 text-sm font-medium transition ${activeFilter === f.value ? "bg-indigo-600 text-white" : "border border-border-main bg-card text-gray-600 dark:text-gray-400 hover:bg-surface-hover"}`}
            >
              {f.label}
            </button>
          ))}
        </div>
      </div>

      {/* Authors List */}
      <div className="space-y-3">
        {paged.map((author) => (
          <div key={author.id} className={`flex items-center gap-4 rounded-xl border bg-card p-4 shadow-sm transition ${author.is_active ? "border-border-main" : "border-border-light opacity-60"}`}>
            <div className="flex h-11 w-11 flex-shrink-0 items-center justify-center rounded-full bg-purple-100 dark:bg-purple-500/10">
              <PenTool className="h-5 w-5 text-purple-600" />
            </div>
            <div className="min-w-0 flex-1">
              <div className="flex items-center gap-2">
                <h3 className="text-sm font-semibold text-foreground">{author.name}</h3>
                {author.is_verified && <CheckCircle className="h-4 w-4 text-blue-500" />}
                {!author.is_active && <span className="rounded bg-gray-100 dark:bg-gray-800 px-1.5 py-0.5 text-xs text-muted">Inactive</span>}
              </div>
              <div className="mt-0.5 flex flex-wrap items-center gap-3 text-xs text-muted">
                {author.email && (
                  <span className="flex items-center gap-1">
                    <Mail className="h-3 w-3" />
                    {author.email}
                  </span>
                )}
                {author.phone && (
                  <span className="flex items-center gap-1">
                    <Phone className="h-3 w-3" />
                    {author.phone}
                  </span>
                )}
                {!author.email && !author.phone && author.bio && (
                  <span className="truncate">{author.bio}</span>
                )}
              </div>
            </div>
            <div className="flex items-center gap-1">
              <button onClick={() => handleToggle(author.id, "is_verified")} className={`rounded-lg p-2 text-sm transition ${author.is_verified ? "text-blue-600 hover:bg-blue-50 dark:hover:bg-blue-500/10" : "text-muted hover:bg-surface-hover"}`} title={author.is_verified ? "Remove verification" : "Verify"}>
                <CheckCircle className="h-4 w-4" />
              </button>
              <Link href={`/authors/${author.id}`} className="rounded-lg p-2 text-muted transition hover:bg-surface-hover hover:text-indigo-600 dark:text-indigo-400" title="Edit">
                <Pencil className="h-4 w-4" />
              </Link>
              {deleteConfirm === author.id ? (
                <div className="flex items-center gap-1">
                  <button onClick={() => handleDelete(author.id)} className="rounded-lg p-2 text-red-600 transition hover:bg-red-50 dark:hover:bg-red-500/10" title="Confirm delete">
                    <Check className="h-4 w-4" />
                  </button>
                  <button onClick={() => setDeleteConfirm(null)} className="rounded-lg p-2 text-muted transition hover:bg-surface-hover" title="Cancel">
                    <X className="h-4 w-4" />
                  </button>
                </div>
              ) : (
                <button onClick={() => setDeleteConfirm(author.id)} className="rounded-lg p-2 text-muted transition hover:bg-surface-hover hover:text-red-600" title="Delete">
                  <Trash2 className="h-4 w-4" />
                </button>
              )}
            </div>
          </div>
        ))}

        {filtered.length === 0 && (
          <div className="py-12 text-center text-sm text-muted">No authors found</div>
        )}
      </div>

      <Pagination currentPage={page} totalPages={totalPages} onPageChange={setPage} />
    </div>
  );
}
