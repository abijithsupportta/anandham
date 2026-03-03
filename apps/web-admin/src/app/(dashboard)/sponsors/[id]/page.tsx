"use client";

import { useState, useEffect, useRef, useCallback } from "react";
import { useRouter, useParams } from "next/navigation";
import { sponsorService, type SponsorFormInput } from "@/services/sponsor.service";
import { useToast } from "@/hooks/useToast";
import { ArrowLeft, Save, Globe, Upload, X, HandCoins, House, IndianRupee } from "lucide-react";
import Link from "next/link";
import PageHeader from "@/components/ui/page-header";
import { FormPageSkeleton } from "@/components/ui/page-skeleton";

async function uploadSponsorPhoto(file: File): Promise<string> {
  const formData = new FormData();
  formData.append("files", file);
  formData.append("folder", "sponsors");

  const res = await fetch("/api/upload", { method: "POST", body: formData });
  const json = await res.json();
  if (!res.ok) throw new Error(json.error || "Upload failed");
  return json.urls?.[0] || "";
}

export default function SponsorFormPage() {
  const router = useRouter();
  const { id } = useParams<{ id: string }>();
  const isNew = id === "new";
  const { toast } = useToast();

  const [loading, setLoading] = useState(!isNew);
  const [saving, setSaving] = useState(false);
  const [uploading, setUploading] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [form, setForm] = useState<SponsorFormInput>({
    sponsor_name: "",
    house_name: "",
    photo_url: "",
    donated_amount: 0,
    amount_visible: true,
    status: "draft",
  });

  useEffect(() => {
    async function load() {
      if (!isNew) {
        const result = await sponsorService.getById(id);
        if (result.error) {
          toast(result.error, "error");
          router.push("/sponsors");
          return;
        }
        if (result.data) {
          setForm({
            sponsor_name: result.data.sponsor_name,
            house_name: result.data.house_name,
            photo_url: result.data.photo_url,
            donated_amount: Number(result.data.donated_amount ?? 0),
            amount_visible: result.data.amount_visible ?? true,
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
    const { name, value } = e.target;
    if (name === "amount_visible") {
      const checked = (e.target as HTMLInputElement).checked;
      setForm((prev) => ({ ...prev, amount_visible: checked }));
      return;
    }
    if (name === "donated_amount") {
      setForm((prev) => ({ ...prev, donated_amount: Number(value || 0) }));
      return;
    }
    setForm((prev) => ({ ...prev, [name]: value }));
  }

  const handleUpload = useCallback(async (files: FileList | null) => {
    if (!files || files.length === 0) return;
    const file = files[0];

    if (!["image/jpeg", "image/png", "image/webp", "image/gif", "image/avif"].includes(file.type)) {
      toast("Please select a valid image file (JPEG, PNG, WebP, GIF, AVIF)", "error");
      return;
    }
    if (file.size > 10 * 1024 * 1024) {
      toast("Image exceeds 10MB limit", "error");
      return;
    }

    setUploading(true);
    try {
      const url = await uploadSponsorPhoto(file);
      setForm((prev) => ({ ...prev, photo_url: url }));
      toast("Sponsor photo uploaded", "success");
    } catch (err) {
      toast(err instanceof Error ? err.message : "Upload failed", "error");
    } finally {
      setUploading(false);
    }
  }, [toast]);

  async function handleSave(publish = false) {
    if (!form.sponsor_name.trim()) {
      toast("Sponsor name is required", "error");
      return;
    }
    if (!form.house_name.trim()) {
      toast("House name is required", "error");
      return;
    }
    if (!form.photo_url.trim()) {
      toast("Sponsor photo is required", "error");
      return;
    }
    if (form.donated_amount < 0) {
      toast("Amount cannot be negative", "error");
      return;
    }

    setSaving(true);
    const payload = {
      ...form,
      status: publish ? "published" : form.status,
    };

    const result = isNew
      ? await sponsorService.create(payload)
      : await sponsorService.update(id, payload, publish);

    setSaving(false);

    if (result.error) {
      toast(result.error, "error");
      return;
    }

    toast(isNew ? "Sponsor created" : "Sponsor updated", "success");
    router.push("/sponsors");
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

  if (loading) return <FormPageSkeleton />;

  return (
    <div className="mx-auto max-w-4xl space-y-6" onKeyDown={handleKeyDown}>
      <PageHeader
        title={isNew ? "New Sponsor" : "Edit Sponsor"}
        subtitle={isNew ? "Add a sponsor with amount and visibility" : "Update sponsor details"}
        action={
          <Link
            href="/sponsors"
            className="inline-flex items-center gap-2 text-sm text-muted hover:text-foreground"
          >
            <ArrowLeft className="h-4 w-4" />
            Back
          </Link>
        }
      />

      <div className="rounded-xl border border-border-main bg-card p-5 shadow-sm">
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <div>
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">
              <HandCoins className="mr-1 inline h-3.5 w-3.5" />
              Sponsor Name *
            </label>
            <input
              name="sponsor_name"
              value={form.sponsor_name}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Enter sponsor name"
            />
          </div>

          <div>
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">
              <House className="mr-1 inline h-3.5 w-3.5" />
              House Name *
            </label>
            <input
              name="house_name"
              value={form.house_name}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Enter house name"
            />
          </div>

          <div>
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">
              <IndianRupee className="mr-1 inline h-3.5 w-3.5" />
              Amount Donated *
            </label>
            <input
              type="number"
              name="donated_amount"
              value={form.donated_amount}
              onChange={onChange}
              min={0}
              step="0.01"
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="0.00"
            />

            <label className="mt-3 flex items-center justify-between rounded-lg border border-border-main bg-surface-hover px-3 py-2">
              <span className="text-xs font-medium text-foreground">Show amount publicly</span>
              <span className="relative inline-flex h-6 w-11 items-center">
                <input
                  type="checkbox"
                  name="amount_visible"
                  checked={form.amount_visible}
                  onChange={onChange}
                  className="peer sr-only"
                />
                <span className="absolute inset-0 rounded-full bg-gray-300 transition peer-checked:bg-indigo-600 dark:bg-gray-600" />
                <span className="absolute left-0.5 h-5 w-5 rounded-full bg-white transition-transform peer-checked:translate-x-5" />
              </span>
            </label>
            <p className="mt-1 text-xs text-muted">
              {form.amount_visible ? "Amount will be visible." : "Amount will be hidden."}
            </p>
          </div>

          {!isNew && (
            <div>
              <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">Visibility</label>
              <select
                name="status"
                value={form.status}
                onChange={onChange}
                className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              >
                <option value="draft">Hidden</option>
                <option value="published">Shown</option>
              </select>
            </div>
          )}
        </div>
      </div>

      <div className="rounded-xl border border-border-main bg-card p-5 shadow-sm">
        <div className="flex items-center justify-between">
          <label className="text-xs font-semibold uppercase tracking-wider text-muted">Sponsor Photo *</label>
          <button
            type="button"
            onClick={() => fileInputRef.current?.click()}
            disabled={uploading}
            className="inline-flex items-center gap-1.5 rounded-lg border border-input-border px-3 py-1.5 text-xs font-medium text-foreground transition hover:bg-surface-hover disabled:opacity-50"
          >
            <Upload className="h-3.5 w-3.5" />
            {uploading ? "Uploading..." : "Upload"}
          </button>
          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            className="hidden"
            onChange={(e) => handleUpload(e.target.files)}
          />
        </div>

        <div className="mt-4">
          {form.photo_url ? (
            <div className="relative h-40 w-40 overflow-hidden rounded-lg border border-border-main">
              <img src={form.photo_url} alt={form.sponsor_name || "Sponsor"} className="h-full w-full object-cover" />
              <button
                type="button"
                onClick={() => setForm((prev) => ({ ...prev, photo_url: "" }))}
                className="absolute right-1 top-1 rounded-full bg-black/60 p-1 text-white"
                title="Remove photo"
              >
                <X className="h-3.5 w-3.5" />
              </button>
            </div>
          ) : (
            <div className="flex h-40 w-40 items-center justify-center rounded-lg border-2 border-dashed border-border-main text-xs text-muted">
              No photo uploaded
            </div>
          )}
        </div>
      </div>

      <div className="sticky bottom-0 -mx-6 border-t border-border-main bg-card/90 px-6 py-3 backdrop-blur-sm">
        <div className="mx-auto flex max-w-4xl items-center justify-between">
          <Link href="/sponsors" className="text-sm text-muted hover:text-foreground">
            Cancel
          </Link>
          <div className="flex items-center gap-3">
            <button
              onClick={() => handleSave(false)}
              disabled={saving}
              className="inline-flex items-center gap-2 rounded-lg border border-input-border bg-card px-4 py-2 text-sm font-medium text-foreground transition hover:bg-surface-hover disabled:opacity-50"
            >
              <Save className="h-4 w-4" />
              {saving ? "Saving..." : "Save Hidden"}
            </button>
            <button
              onClick={() => handleSave(true)}
              disabled={saving}
              className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-indigo-700 disabled:opacity-50"
            >
              <Globe className="h-4 w-4" />
              {saving ? "Publishing..." : "Show Sponsor"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
