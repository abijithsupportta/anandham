"use client";

import { useState, useEffect } from "react";
import { useRouter, useParams } from "next/navigation";
import type { Category } from "@/types/database";
import { dharmaService, type DharmaFormInput } from "@/services/dharma.service";
import { useToast } from "@/hooks/useToast";
import { ArrowLeft, Save, Globe } from "lucide-react";
import Link from "next/link";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";

export default function DharmaFormPage() {
  const router = useRouter();
  const { id } = useParams<{ id: string }>();
  const isNew = id === "new";
  const { toast } = useToast();

  const [loading, setLoading] = useState(!isNew);
  const [saving, setSaving] = useState(false);
  const [categories, setCategories] = useState<Category[]>([]);

  const [form, setForm] = useState<DharmaFormInput>({
    title: "",
    description: "",
    category_id: "",
    youtube_url: "",
    status: "draft",
  });

  useEffect(() => {
    async function load() {
      const catResult = await dharmaService.getCategories();
      if (catResult.data) setCategories(catResult.data);

      if (!isNew) {
        const result = await dharmaService.getById(id);
        if (result.error) {
          toast(result.error, "error");
          router.push("/dharmas");
          return;
        }
        if (result.data) {
          setForm({
            title: result.data.title,
            description: result.data.description ?? "",
            category_id: result.data.category_id ?? "",
            youtube_url: result.data.youtube_url ?? "",
            status: result.data.status,
          });
        }
      }
      setLoading(false);
    }
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id, isNew]);

  function onChange(e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  }

  async function handleSave(publish = false) {
    if (!form.title.trim()) {
      toast("Title is required", "error");
      return;
    }

    setSaving(true);
    const result = isNew
      ? await dharmaService.create({ ...form, status: publish ? "published" : form.status })
      : await dharmaService.update(id, form, publish);

    setSaving(false);

    if (result.error) {
      toast(result.error, "error");
      return;
    }

    toast(isNew ? "Dharma created" : "Dharma updated", "success");
    router.push("/dharmas");
  }

  if (loading) return <LoadingState message="Loading dharma..." />;

  return (
    <div className="mx-auto max-w-3xl space-y-6">
      <PageHeader
        title={isNew ? "New Dharma" : "Edit Dharma"}
        subtitle={isNew ? "Create a new dharma teaching" : "Update dharma details"}
        action={
          <Link href="/dharmas" className="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700">
            <ArrowLeft className="h-4 w-4" />
            Back
          </Link>
        }
      />

      <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm space-y-5">
        <div>
          <label className="mb-1 block text-sm font-medium text-gray-700">Category</label>
          <select name="category_id" value={form.category_id} onChange={onChange} className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500">
            <option value="">Select a category</option>
            {categories.map((c) => (
              <option key={c.id} value={c.id}>{c.name}</option>
            ))}
          </select>
        </div>

        <div>
          <label className="mb-1 block text-sm font-medium text-gray-700">Title *</label>
          <input name="title" value={form.title} onChange={onChange} className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500" placeholder="Enter dharma title" />
        </div>

        <div>
          <label className="mb-1 block text-sm font-medium text-gray-700">Body</label>
          <textarea name="description" value={form.description} onChange={onChange} rows={10} className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500" placeholder="Enter the dharma text..." />
        </div>

        <div>
          <label className="mb-1 block text-sm font-medium text-gray-700">YouTube URL</label>
          <input name="youtube_url" value={form.youtube_url} onChange={onChange} className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500" placeholder="https://youtube.com/..." />
        </div>

        {!isNew && (
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">Status</label>
            <select name="status" value={form.status} onChange={onChange} className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500">
              <option value="draft">Draft</option>
              <option value="published">Published</option>
            </select>
          </div>
        )}

        <div className="flex items-center gap-3 pt-2">
          <button onClick={() => handleSave(false)} disabled={saving} className="inline-flex items-center gap-2 rounded-lg bg-gray-800 px-4 py-2 text-sm font-medium text-white transition hover:bg-gray-900 disabled:opacity-50">
            <Save className="h-4 w-4" />
            {saving ? "Saving..." : "Save Draft"}
          </button>
          <button onClick={() => handleSave(true)} disabled={saving} className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700 disabled:opacity-50">
            <Globe className="h-4 w-4" />
            {saving ? "Publishing..." : "Publish"}
          </button>
        </div>
      </div>
    </div>
  );
}
