"use client";

import { useState, useEffect, useRef, useCallback } from "react";
import { useRouter, useParams } from "next/navigation";
import { guruStoryService, type GuruStoryFormInput } from "@/services/guru-story.service";
import { useToast } from "@/hooks/useToast";
import {
  ArrowLeft,
  Save,
  Globe,
  Maximize2,
  Minimize2,
  Type,
  AlignLeft,
  UserRound,
  BookText,
} from "lucide-react";
import Link from "next/link";
import PageHeader from "@/components/ui/page-header";
import { FormPageSkeleton } from "@/components/ui/page-skeleton";

function countStats(text: string) {
  const chars = text.length;
  const words = text.trim() ? text.trim().split(/\s+/).length : 0;
  const lines = text ? text.split("\n").length : 0;
  return { chars, words, lines };
}

export default function GuruStoryFormPage() {
  const router = useRouter();
  const { id } = useParams<{ id: string }>();
  const isNew = id === "new";
  const { toast } = useToast();

  const [loading, setLoading] = useState(!isNew);
  const [saving, setSaving] = useState(false);
  const [expanded, setExpanded] = useState(false);
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  const [form, setForm] = useState<GuruStoryFormInput>({
    title: "",
    body: "",
    author_name: "",
    reference_book: "",
    status: "draft",
  });

  useEffect(() => {
    async function load() {
      if (!isNew) {
        const result = await guruStoryService.getById(id);
        if (result.error) {
          toast(result.error, "error");
          router.push("/guru-stories");
          return;
        }
        if (result.data) {
          setForm({
            title: result.data.title,
            body: result.data.body,
            author_name: result.data.author_name ?? "",
            reference_book: result.data.reference_book ?? "",
            status: result.data.status,
          });
        }
      }
      setLoading(false);
    }
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id, isNew]);

  function onChange(
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>
  ) {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  }

  async function handleSave(publish = false) {
    if (!form.title.trim()) {
      toast("Title is required", "error");
      return;
    }

    if (!form.body.trim()) {
      toast("Body is required", "error");
      return;
    }

    if (!form.author_name.trim()) {
      toast("Author name is required", "error");
      return;
    }

    if (!form.reference_book.trim()) {
      toast("Reference book is required", "error");
      return;
    }

    setSaving(true);
    const result = isNew
      ? await guruStoryService.create({
          ...form,
          status: publish ? "published" : form.status,
        })
      : await guruStoryService.update(id, form, publish);

    setSaving(false);

    if (result.error) {
      toast(result.error, "error");
      return;
    }

    toast(isNew ? "Guru story created" : "Guru story updated", "success");
    router.push("/guru-stories");
  }

  const handleKeyDown = useCallback(
    (e: React.KeyboardEvent) => {
      if ((e.ctrlKey || e.metaKey) && e.key === "s") {
        e.preventDefault();
        handleSave(e.shiftKey);
      }
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [form, isNew, saving]
  );

  function handleTabKey(e: React.KeyboardEvent<HTMLTextAreaElement>) {
    if (e.key === "Tab") {
      e.preventDefault();
      const ta = e.currentTarget;
      const start = ta.selectionStart;
      const end = ta.selectionEnd;
      const newValue =
        form.body.substring(0, start) + "  " + form.body.substring(end);
      setForm((prev) => ({ ...prev, body: newValue }));
      requestAnimationFrame(() => {
        ta.selectionStart = ta.selectionEnd = start + 2;
      });
    }
  }

  const stats = countStats(form.body);

  if (loading) return <FormPageSkeleton />;

  return (
    <div
      className={`space-y-6 ${expanded ? "fixed inset-0 z-50 overflow-y-auto bg-surface-hover p-6" : "mx-auto max-w-4xl"}`}
      onKeyDown={handleKeyDown}
    >
      <PageHeader
        title={isNew ? "New Guru Story" : "Edit Guru Story"}
        subtitle={isNew ? "Create a new spiritual story" : "Update story details"}
        action={
          <Link
            href="/guru-stories"
            className="inline-flex items-center gap-2 text-sm text-muted hover:text-foreground"
          >
            <ArrowLeft className="h-4 w-4" />
            Back
          </Link>
        }
      />

      <div className="rounded-xl border border-border-main bg-card p-5 shadow-sm">
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <div className="sm:col-span-2">
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">
              Title *
            </label>
            <input
              name="title"
              value={form.title}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Enter story title"
            />
          </div>

          <div>
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">
              <UserRound className="mr-1 inline h-3.5 w-3.5" />
              Author Name *
            </label>
            <input
              name="author_name"
              value={form.author_name}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Enter author name"
            />
          </div>

          <div>
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">
              <BookText className="mr-1 inline h-3.5 w-3.5" />
              Reference Book *
            </label>
            <input
              name="reference_book"
              value={form.reference_book}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Enter reference book"
            />
          </div>
        </div>
      </div>

      <div className="rounded-xl border border-border-main bg-card shadow-sm">
        <div className="flex items-center justify-between border-b border-border-light px-4 py-2.5">
          <div className="flex items-center gap-3">
            <div className="flex items-center gap-1.5 text-sm font-medium text-foreground">
              <Type className="h-4 w-4 text-muted" />
              Body
            </div>
            <div className="hidden items-center gap-3 text-xs text-muted sm:flex">
              <span>{stats.lines} {stats.lines === 1 ? "line" : "lines"}</span>
              <span className="text-gray-200 dark:text-gray-700">|</span>
              <span>{stats.words} {stats.words === 1 ? "word" : "words"}</span>
              <span className="text-gray-200 dark:text-gray-700">|</span>
              <span>{stats.chars} chars</span>
            </div>
          </div>
          <button
            type="button"
            onClick={() => {
              setExpanded(!expanded);
              setTimeout(() => textareaRef.current?.focus(), 100);
            }}
            className="rounded-md p-1.5 text-muted transition hover:bg-surface-hover hover:text-gray-600 dark:text-gray-400"
            title={expanded ? "Exit fullscreen (Esc)" : "Fullscreen editor"}
          >
            {expanded ? (
              <Minimize2 className="h-4 w-4" />
            ) : (
              <Maximize2 className="h-4 w-4" />
            )}
          </button>
        </div>

        <div className="relative">
          <textarea
            ref={textareaRef}
            name="body"
            value={form.body}
            onChange={onChange}
            onKeyDown={(e) => {
              handleTabKey(e);
              if (e.key === "Escape" && expanded) setExpanded(false);
            }}
            className={`w-full resize-none border-0 bg-transparent px-5 py-4 font-mono text-sm leading-relaxed text-foreground placeholder-muted focus:outline-none focus:ring-0 ${
              expanded ? "min-h-[calc(100vh-320px)]" : "min-h-[480px]"
            }`}
            placeholder={"Write the guru story body here...\n\nTip: Use Ctrl+S to save, Ctrl+Shift+S to publish."}
            spellCheck={false}
          />
        </div>

        <div className="flex items-center justify-between border-t border-border-light px-4 py-2">
          <div className="flex items-center gap-1.5 text-xs text-muted">
            <AlignLeft className="h-3.5 w-3.5" />
            <span>Plain text</span>
            <span className="text-gray-200 dark:text-gray-700">·</span>
            <span>Tab inserts spaces</span>
            <span className="text-gray-200 dark:text-gray-700">·</span>
            <span>Ctrl+S save</span>
          </div>
          {!isNew && (
            <div className="flex items-center gap-2">
              <span className="text-xs text-muted">Status:</span>
              <select
                name="status"
                value={form.status}
                onChange={onChange}
                className="rounded-md border border-border-main bg-surface-hover px-2 py-1 text-xs font-medium text-gray-600 dark:text-gray-400 focus:border-indigo-400 dark:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-400"
              >
                <option value="draft">Draft</option>
                <option value="published">Published</option>
              </select>
            </div>
          )}
        </div>
      </div>

      <div className="sticky bottom-0 -mx-6 border-t border-border-main bg-card/90 px-6 py-3 backdrop-blur-sm">
        <div className="mx-auto flex max-w-4xl items-center justify-between">
          <Link href="/guru-stories" className="text-sm text-muted hover:text-foreground">
            Cancel
          </Link>
          <div className="flex items-center gap-3">
            <button
              onClick={() => handleSave(false)}
              disabled={saving}
              className="inline-flex items-center gap-2 rounded-lg border border-input-border bg-card px-4 py-2 text-sm font-medium text-foreground transition hover:bg-surface-hover disabled:opacity-50"
            >
              <Save className="h-4 w-4" />
              {saving ? "Saving..." : "Save Draft"}
            </button>
            <button
              onClick={() => handleSave(true)}
              disabled={saving}
              className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700 disabled:opacity-50"
            >
              <Globe className="h-4 w-4" />
              {saving ? "Publishing..." : "Publish"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
