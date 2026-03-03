"use client";

import { useState, useEffect, useRef, useCallback } from "react";
import { useRouter, useParams } from "next/navigation";
import type { ContentCategory } from "@/types/database";
import {
  dharmaService,
  type DharmaFormInput,
  type DharmaItemInput,
  type DharmaWordInput,
} from "@/services/dharma.service";
import { useToast } from "@/hooks/useToast";
import {
  ArrowLeft,
  Save,
  Globe,
  Maximize2,
  Minimize2,
  AlignLeft,
  Youtube,
  Plus,
  Trash2,
  BookOpen,
  Languages,
  GripVertical,
  ScrollText,
} from "lucide-react";
import Link from "next/link";
import PageHeader from "@/components/ui/page-header";
import { FormPageSkeleton } from "@/components/ui/page-skeleton";

// ── Helpers ────────────────────────────────────────────────

function countStats(text: string) {
  const chars = text.length;
  const words = text.trim() ? text.trim().split(/\s+/).length : 0;
  const lines = text ? text.split("\n").length : 0;
  return { chars, words, lines };
}

type ExpandedPanel = null | "meaning";

export default function DharmaFormPage() {
  const router = useRouter();
  const { id } = useParams<{ id: string }>();
  const isNew = id === "new";
  const { toast } = useToast();

  const [loading, setLoading] = useState(!isNew);
  const [saving, setSaving] = useState(false);
  const [categories, setCategories] = useState<ContentCategory[]>([]);
  const [expanded, setExpanded] = useState<ExpandedPanel>(null);
  const translationRef = useRef<HTMLTextAreaElement>(null);

  const [form, setForm] = useState<DharmaFormInput>({
    title: "",
    description: "",
    translation: "",
    category_id: "",
    youtube_url: "",
    status: "draft",
  });

  const [words, setWords] = useState<DharmaWordInput[]>([]);
  const [slokaLines, setSlokaLines] = useState<DharmaItemInput[]>([
    { text: "", explanation: "", item_number: 1 },
  ]);

  // ── Load data ────────────────────────────────────────────

  useEffect(() => {
    async function load() {
      const catResult = await dharmaService.getCategories();
      if (catResult.data) setCategories(catResult.data);

      if (!isNew) {
        const [result, itemsResult, wordsResult] = await Promise.all([
          dharmaService.getById(id),
          dharmaService.getItems(id),
          dharmaService.getWords(id),
        ]);

        if (result.error) {
          toast(result.error, "error");
          router.push("/dharmas");
          return;
        }
        if (result.data) {
          setForm({
            title: result.data.title,
            description: result.data.description ?? "",
            translation: result.data.translation ?? "",
            category_id: result.data.category_id ?? "",
            youtube_url: result.data.youtube_url ?? "",
            status: result.data.status,
          });

          if (itemsResult.data && itemsResult.data.length > 0) {
            setSlokaLines(
              itemsResult.data.map((item) => ({
                id: item.id,
                text: item.text,
                explanation: item.explanation ?? "",
                item_number: item.item_number,
              }))
            );
          } else if ((result.data.description ?? "").trim()) {
            const legacyLines = (result.data.description ?? "")
              .split("\n")
              .map((line) => line.trim())
              .filter(Boolean);

            if (legacyLines.length > 0) {
              setSlokaLines(
                legacyLines.map((line, index) => ({
                  text: line,
                  explanation: "",
                  item_number: index + 1,
                }))
              );
            }
          }
        }
        if (wordsResult.data && wordsResult.data.length > 0) {
          setWords(
            wordsResult.data.map((w) => ({
              id: w.id,
              word: w.word,
              meaning: w.meaning,
              display_order: w.display_order,
            }))
          );
        }
      }
      setLoading(false);
    }
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id, isNew]);

  // ── Handlers ─────────────────────────────────────────────

  function onChange(e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  }

  // ── Sloka line handlers ────────────────────────────────

  function addSlokaLine() {
    setSlokaLines((prev) => [
      ...prev,
      { text: "", explanation: "", item_number: prev.length + 1 },
    ]);
  }

  function updateSlokaLine(index: number, value: string) {
    setSlokaLines((prev) =>
      prev.map((line, i) =>
        i === index ? { ...line, text: value, item_number: i + 1 } : line
      )
    );
  }

  function removeSlokaLine(index: number) {
    setSlokaLines((prev) => {
      const filtered = prev.filter((_, i) => i !== index);
      if (filtered.length === 0) {
        return [{ text: "", explanation: "", item_number: 1 }];
      }
      return filtered.map((line, i) => ({ ...line, item_number: i + 1 }));
    });
  }

  // ── Word handlers ────────────────────────────────────────

  function addWord() {
    setWords((prev) => [
      ...prev,
      { word: "", meaning: "", display_order: prev.length },
    ]);
  }

  function updateWord(index: number, field: "word" | "meaning", value: string) {
    setWords((prev) =>
      prev.map((w, i) => (i === index ? { ...w, [field]: value } : w))
    );
  }

  function removeWord(index: number) {
    setWords((prev) => prev.filter((_, i) => i !== index));
  }

  // ── Save ─────────────────────────────────────────────────

  async function handleSave(publish = false) {
    const normalizedLines = slokaLines
      .map((line, index) => ({
        ...line,
        text: line.text.trim(),
        item_number: index + 1,
      }))
      .filter((line) => line.text.length > 0);

    if (normalizedLines.length === 0) {
      toast("Add at least one sloka line", "error");
      return;
    }

    if (!form.translation.trim()) {
      toast("Detailed meaning is required", "error");
      return;
    }

    setSaving(true);

    const firstSlokaLine = normalizedLines[0]?.text ?? "";
    const generatedTitleBase = firstSlokaLine.slice(0, 80) || "Dharma";
    const internalTitle = form.title.trim() || (isNew
      ? `${generatedTitleBase} ${Date.now()}`
      : generatedTitleBase);

    const payload: DharmaFormInput = {
      ...form,
      title: internalTitle,
      description: normalizedLines.map((line) => line.text).join("\n"),
      status: publish ? "published" : form.status,
    };

    // 1. Save the dharma itself
    const result = isNew
      ? await dharmaService.create(payload)
      : await dharmaService.update(id, payload, publish);

    if (result.error) {
      setSaving(false);
      toast(result.error, "error");
      return;
    }

    // 2. Save words (only if dharma saved successfully)
    const dharmaId = isNew ? result.data?.id : id;
    if (dharmaId) {
      const itemResult = await dharmaService.saveItems(dharmaId, normalizedLines);
      if (itemResult.error) {
        setSaving(false);
        toast(`Dharma saved but sloka lines failed: ${itemResult.error}`, "error");
        return;
      }

      // Filter out completely empty word rows
      const validWords = words.filter((w) => w.word.trim() || w.meaning.trim());
      if (validWords.length > 0 || !isNew) {
        const wordsResult = await dharmaService.saveWords(dharmaId, validWords);
        if (wordsResult.error) {
          setSaving(false);
          toast(`Dharma saved but words failed: ${wordsResult.error}`, "error");
          return;
        }
      }
    }

    setSaving(false);
    toast(isNew ? "Dharma created" : "Dharma updated", "success");
    router.push("/dharmas");
  }

  // Keyboard shortcut: Ctrl+S to save, Ctrl+Shift+S to publish
  const handleKeyDown = useCallback(
    (e: React.KeyboardEvent) => {
      if ((e.ctrlKey || e.metaKey) && e.key === "s") {
        e.preventDefault();
        handleSave(e.shiftKey);
      }
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [form, words, slokaLines, isNew, saving]
  );

  // Tab key inserts spaces
  function handleTabKey(e: React.KeyboardEvent<HTMLTextAreaElement>) {
    if (e.key === "Tab") {
      e.preventDefault();
      const ta = e.currentTarget;
      const start = ta.selectionStart;
      const end = ta.selectionEnd;
      const val = form.translation;
      const newValue = val.substring(0, start) + "  " + val.substring(end);
      setForm((prev) => ({ ...prev, translation: newValue }));
      requestAnimationFrame(() => {
        ta.selectionStart = ta.selectionEnd = start + 2;
      });
    }
  }

  const translationStats = countStats(form.translation);

  // ── Render ───────────────────────────────────────────────

  if (loading) return <FormPageSkeleton />;

  return (
    <div
      className={`space-y-6 ${expanded ? "fixed inset-0 z-50 overflow-y-auto bg-surface-hover p-6" : "mx-auto max-w-4xl"}`}
      onKeyDown={handleKeyDown}
    >
      <PageHeader
        title={isNew ? "New Dharma" : "Edit Dharma"}
        subtitle={isNew ? "Create a new dharma teaching" : "Update dharma details"}
        action={
          <Link href="/dharmas" className="inline-flex items-center gap-2 text-sm text-muted hover:text-foreground">
            <ArrowLeft className="h-4 w-4" />
            Back
          </Link>
        }
      />

      {/* ── 1. Metadata Panel ────────────────────────────── */}
      {expanded === null && (
        <div className="rounded-xl border border-border-main bg-card p-5 shadow-sm">
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <div>
              <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">Category</label>
              <select
                name="category_id"
                value={form.category_id}
                onChange={onChange}
                className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              >
                <option value="">Select a category</option>
                {categories.map((c) => (
                  <option key={c.id} value={c.id}>{c.name}</option>
                ))}
              </select>
            </div>

            <div>
              <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">
                <Youtube className="mr-1 inline h-3.5 w-3.5" />
                YouTube URL
              </label>
              <input
                name="youtube_url"
                value={form.youtube_url}
                onChange={onChange}
                className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                placeholder="https://youtube.com/..."
              />
            </div>
          </div>
        </div>
      )}

      {/* ── 2. Sloka Lines ──────────────────────────────── */}
      {expanded === null && (
        <div className="rounded-xl border border-border-main bg-card shadow-sm">
          <div className="flex items-center justify-between border-b border-border-light px-4 py-3">
            <div className="flex items-center gap-2 text-sm font-medium text-foreground">
              <ScrollText className="h-4 w-4 text-muted" />
              Sloka Lines
              {slokaLines.length > 0 && (
                <span className="rounded-full bg-indigo-50 dark:bg-indigo-500/10 px-2 py-0.5 text-xs font-semibold text-indigo-600 dark:text-indigo-400">
                  {slokaLines.length}
                </span>
              )}
            </div>
            <button
              type="button"
              onClick={addSlokaLine}
              className="inline-flex items-center gap-1.5 rounded-lg bg-indigo-50 dark:bg-indigo-500/10 px-3 py-1.5 text-xs font-medium text-indigo-600 dark:text-indigo-400 transition hover:bg-indigo-100 dark:hover:bg-indigo-500/20"
            >
              <Plus className="h-3.5 w-3.5" />
              Add Line
            </button>
          </div>

          <div className="space-y-2 p-4">
            {slokaLines.map((line, index) => (
              <div
                key={line.id ?? index}
                className="group grid grid-cols-[auto_1fr_auto] items-start gap-3 rounded-lg border border-border-light bg-surface-hover/50 px-2 py-2 transition hover:border-border-main hover:bg-surface-hover"
              >
                <GripVertical className="mt-2 h-4 w-4 cursor-grab text-gray-300 dark:text-gray-600" />
                <textarea
                  value={line.text}
                  onChange={(e) => updateSlokaLine(index, e.target.value)}
                  className="min-h-[46px] w-full resize-y rounded-md border border-border-main bg-card px-3 py-2 text-sm focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  placeholder={`Sloka line ${index + 1}`}
                />
                <button
                  type="button"
                  onClick={() => removeSlokaLine(index)}
                  className="rounded-md p-1.5 text-gray-300 dark:text-gray-600 transition hover:bg-red-50 dark:hover:bg-red-500/10 hover:text-red-500"
                  title="Remove line"
                >
                  <Trash2 className="h-4 w-4" />
                </button>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* ── 3. Words & Meanings ──────────────────────────── */}
      {expanded === null && (
        <div className="rounded-xl border border-border-main bg-card shadow-sm">
          <div className="flex items-center justify-between border-b border-border-light px-4 py-3">
            <div className="flex items-center gap-2 text-sm font-medium text-foreground">
              <BookOpen className="h-4 w-4 text-muted" />
              Words &amp; Meanings
              {words.length > 0 && (
                <span className="rounded-full bg-indigo-50 dark:bg-indigo-500/10 px-2 py-0.5 text-xs font-semibold text-indigo-600 dark:text-indigo-400">
                  {words.length}
                </span>
              )}
            </div>
            <button
              type="button"
              onClick={addWord}
              className="inline-flex items-center gap-1.5 rounded-lg bg-indigo-50 dark:bg-indigo-500/10 px-3 py-1.5 text-xs font-medium text-indigo-600 dark:text-indigo-400 transition hover:bg-indigo-100 dark:hover:bg-indigo-500/20 dark:bg-indigo-500/15"
            >
              <Plus className="h-3.5 w-3.5" />
              Add Word
            </button>
          </div>

          <div className="p-4">
            {words.length === 0 ? (
              <div className="rounded-lg border-2 border-dashed border-border-main px-6 py-8 text-center">
                <BookOpen className="mx-auto h-8 w-8 text-gray-300 dark:text-gray-600" />
                <p className="mt-2 text-sm text-muted">No words added yet</p>
                <p className="mt-1 text-xs text-gray-300 dark:text-gray-600">
                  Add words and their meanings to help readers understand the dharma
                </p>
                <button
                  type="button"
                  onClick={addWord}
                  className="mt-3 inline-flex items-center gap-1.5 rounded-lg border border-input-border px-3 py-1.5 text-xs font-medium text-gray-600 dark:text-gray-400 transition hover:bg-surface-hover"
                >
                  <Plus className="h-3.5 w-3.5" />
                  Add First Word
                </button>
              </div>
            ) : (
              <div className="space-y-2">
                {/* Header */}
                <div className="grid grid-cols-[auto_1fr_1fr_auto] items-center gap-3 px-2 pb-1">
                  <div className="w-5" />
                  <span className="text-xs font-semibold uppercase tracking-wider text-muted">Word</span>
                  <span className="text-xs font-semibold uppercase tracking-wider text-muted">Meaning</span>
                  <div className="w-8" />
                </div>

                {words.map((w, i) => (
                  <div
                    key={i}
                    className="group grid grid-cols-[auto_1fr_1fr_auto] items-center gap-3 rounded-lg border border-border-light bg-surface-hover/50 px-2 py-2 transition hover:border-border-main hover:bg-surface-hover"
                  >
                    <GripVertical className="h-4 w-4 cursor-grab text-gray-300 dark:text-gray-600" />
                    <input
                      value={w.word}
                      onChange={(e) => updateWord(i, "word", e.target.value)}
                      className="rounded-md border border-border-main bg-card px-3 py-1.5 text-sm focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                      placeholder="Enter word..."
                    />
                    <input
                      value={w.meaning}
                      onChange={(e) => updateWord(i, "meaning", e.target.value)}
                      className="rounded-md border border-border-main bg-card px-3 py-1.5 text-sm focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                      placeholder="Enter meaning..."
                    />
                    <button
                      type="button"
                      onClick={() => removeWord(i)}
                      className="rounded-md p-1.5 text-gray-300 dark:text-gray-600 transition hover:bg-red-50 dark:hover:bg-red-500/10 hover:text-red-500"
                      title="Remove word"
                    >
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </div>
                ))}

                <button
                  type="button"
                  onClick={addWord}
                  className="mt-1 inline-flex w-full items-center justify-center gap-1.5 rounded-lg border border-dashed border-input-border py-2 text-xs font-medium text-muted transition hover:border-gray-400 dark:hover:border-gray-600 hover:text-gray-600 dark:text-gray-400"
                >
                  <Plus className="h-3.5 w-3.5" />
                  Add Another Word
                </button>
              </div>
            )}
          </div>
        </div>
      )}

      {/* ── 4. Detailed Meaning ──────────────────────────── */}
      {(expanded === null || expanded === "meaning") && (
        <EditorPanel
          label="Detailed Meaning"
          icon={<Languages className="h-4 w-4 text-muted" />}
          fieldName="translation"
          value={form.translation}
          stats={translationStats}
          textareaRef={translationRef}
          expanded={expanded === "meaning"}
          onToggleExpand={() => {
            setExpanded(expanded === "meaning" ? null : "meaning");
            setTimeout(() => translationRef.current?.focus(), 100);
          }}
          onChange={onChange}
          onTabKey={handleTabKey}
          placeholder={"Write the full detailed meaning here...\n\nThis section should explain the complete meaning in detail after slokas and word meanings."}
          statusSelect={
            !isNew && expanded === null ? (
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
            ) : null
          }
        />
      )}

      {/* ── Sticky Action Bar ────────────────────────────── */}
      <div className="sticky bottom-0 -mx-6 border-t border-border-main bg-card/90 px-6 py-3 backdrop-blur-sm">
        <div className="mx-auto flex max-w-4xl items-center justify-between">
          <Link href="/dharmas" className="text-sm text-muted hover:text-foreground">
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

// ── Reusable Editor Panel Component ────────────────────────

interface EditorPanelProps {
  label: string;
  icon: React.ReactNode;
  fieldName: string;
  value: string;
  stats: { lines: number; words: number; chars: number };
  textareaRef: React.RefObject<HTMLTextAreaElement | null>;
  expanded: boolean;
  onToggleExpand: () => void;
  onChange: (e: React.ChangeEvent<HTMLTextAreaElement>) => void;
  onTabKey: (e: React.KeyboardEvent<HTMLTextAreaElement>) => void;
  placeholder: string;
  statusSelect?: React.ReactNode;
}

function EditorPanel({
  label,
  icon,
  fieldName,
  value,
  stats,
  textareaRef,
  expanded,
  onToggleExpand,
  onChange,
  onTabKey,
  placeholder,
  statusSelect,
}: EditorPanelProps) {
  return (
    <div className="rounded-xl border border-border-main bg-card shadow-sm">
      {/* Toolbar */}
      <div className="flex items-center justify-between border-b border-border-light px-4 py-2.5">
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-1.5 text-sm font-medium text-foreground">
            {icon}
            {label}
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
          onClick={onToggleExpand}
          className="rounded-md p-1.5 text-muted transition hover:bg-surface-hover hover:text-gray-600 dark:text-gray-400"
          title={expanded ? "Exit fullscreen (Esc)" : "Fullscreen editor"}
        >
          {expanded ? <Minimize2 className="h-4 w-4" /> : <Maximize2 className="h-4 w-4" />}
        </button>
      </div>

      {/* Textarea */}
      <div className="relative">
        <textarea
          ref={textareaRef}
          name={fieldName}
          value={value}
          onChange={onChange}
          onKeyDown={(e) => {
            onTabKey(e);
            if (e.key === "Escape" && expanded) onToggleExpand();
          }}
          className={`w-full resize-none border-0 bg-transparent px-5 py-4 font-mono text-sm leading-relaxed text-foreground placeholder-muted focus:outline-none focus:ring-0 ${
            expanded ? "min-h-[calc(100vh-320px)]" : "min-h-[320px]"
          }`}
          placeholder={placeholder}
          spellCheck={false}
        />
      </div>

      {/* Footer */}
      <div className="flex items-center justify-between border-t border-border-light px-4 py-2">
        <div className="flex items-center gap-1.5 text-xs text-muted">
          <AlignLeft className="h-3.5 w-3.5" />
          <span>Plain text</span>
          <span className="text-gray-200 dark:text-gray-700">·</span>
          <span>Tab inserts spaces</span>
          <span className="text-gray-200 dark:text-gray-700">·</span>
          <span>Ctrl+S save</span>
        </div>
        {statusSelect}
      </div>
    </div>
  );
}
