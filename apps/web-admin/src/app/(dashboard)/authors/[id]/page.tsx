"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { useRouter, useParams } from "next/navigation";
import type { ContentType } from "@/types/database";
import { authorService } from "@/services/author.service";
import { useToast } from "@/hooks/useToast";
import {
  ArrowLeft,
  Save,
  Check,
  Mail,
  Lock,
  Phone,
  MapPin,
  User,
  ShieldCheck,
  Eye,
  EyeOff,
  Camera,
  X,
  Loader2,
} from "lucide-react";
import Link from "next/link";
import Image from "next/image";
import PageHeader from "@/components/ui/page-header";
import LoadingState from "@/components/ui/loading-state";

export default function AuthorFormPage() {
  const router = useRouter();
  const { id } = useParams<{ id: string }>();
  const isNew = id === "new";
  const { toast } = useToast();

  const [loading, setLoading] = useState(!isNew);
  const [saving, setSaving] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [contentTypes, setContentTypes] = useState<ContentType[]>([]);
  const photoInputRef = useRef<HTMLInputElement>(null);

  const [form, setForm] = useState({
    name: "",
    email: "",
    password: "",
    phone: "",
    address: "",
    bio: "",
    photo_url: "",
    is_verified: true,
    is_active: true,
    content_type_ids: [] as string[],
  });

  // ── Load data ──────────────────────────────────────────────

  useEffect(() => {
    async function load() {
      // Always fetch content types
      const ctResult = await authorService.getContentTypes();
      if (ctResult.data) setContentTypes(ctResult.data);

      if (!isNew) {
        const result = await authorService.getById(id);
        if (result.error) {
          toast(result.error, "error");
          router.push("/authors");
          return;
        }
        if (result.data) {
          setForm({
            name: result.data.name,
            email: result.data.email ?? "",
            password: "", // never pre-fill password
            phone: result.data.phone ?? "",
            address: result.data.address ?? "",
            bio: result.data.bio ?? "",
            photo_url: result.data.photo_url ?? "",
            is_verified: result.data.is_verified,
            is_active: result.data.is_active,
            content_type_ids: [],
          });

          // Load content type assignments
          if (result.data.user_id) {
            const assignResult = await authorService.getAssignments(result.data.user_id);
            if (assignResult.data) {
              setForm((prev) => ({
                ...prev,
                content_type_ids: assignResult.data!.map((a) => a.content_type_id),
              }));
            }
          }
        }
      }
      setLoading(false);
    }
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id, isNew]);

  // ── Handlers ───────────────────────────────────────────────

  function onChange(e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  }

  async function handlePhotoUpload(file: File) {
    if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) {
      toast('Please select a JPEG, PNG, or WebP image', 'error');
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      toast('Image must be under 5MB', 'error');
      return;
    }
    setUploading(true);
    try {
      const formData = new FormData();
      formData.append('files', file);
      formData.append('folder', 'author-photos');
      const res = await fetch('/api/upload', { method: 'POST', body: formData });
      const json = await res.json();
      if (!res.ok) throw new Error(json.error || 'Upload failed');
      setForm((prev) => ({ ...prev, photo_url: json.urls[0] }));
      toast('Photo uploaded', 'success');
    } catch (err) {
      toast(err instanceof Error ? err.message : 'Upload failed', 'error');
    } finally {
      setUploading(false);
    }
  }

  function handleRemovePhoto() {
    if (form.photo_url) {
      fetch('/api/upload', {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ url: form.photo_url }),
      }).catch(() => {});
    }
    setForm((prev) => ({ ...prev, photo_url: '' }));
  }

  function toggleContentType(ctId: string) {
    setForm((prev) => ({
      ...prev,
      content_type_ids: prev.content_type_ids.includes(ctId)
        ? prev.content_type_ids.filter((id) => id !== ctId)
        : [...prev.content_type_ids, ctId],
    }));
  }

  // ── Save ───────────────────────────────────────────────────

  async function handleSave() {
    if (!form.name.trim()) {
      toast("Name is required", "error");
      return;
    }
    if (isNew && !form.email.trim()) {
      toast("Email is required", "error");
      return;
    }
    if (isNew && !form.password.trim()) {
      toast("Password is required", "error");
      return;
    }
    if (isNew && form.password.length < 6) {
      toast("Password must be at least 6 characters", "error");
      return;
    }

    setSaving(true);

    const result = isNew
      ? await authorService.create(form)
      : await authorService.update(id, {
          name: form.name,
          phone: form.phone,
          address: form.address,
          bio: form.bio,
          photo_url: form.photo_url,
          is_verified: form.is_verified,
          is_active: form.is_active,
          content_type_ids: form.content_type_ids,
          ...(form.password ? { password: form.password } : {}),
        });

    setSaving(false);

    if (result.error) {
      toast(result.error, "error");
      return;
    }

    toast(isNew ? "Author created" : "Author updated", "success");
    router.push("/authors");
  }

  // Keyboard shortcut
  const handleKeyDown = useCallback(
    (e: React.KeyboardEvent) => {
      if ((e.ctrlKey || e.metaKey) && e.key === "s") {
        e.preventDefault();
        handleSave();
      }
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [form, isNew, saving]
  );

  // ── Render ─────────────────────────────────────────────────

  if (loading) return <LoadingState message="Loading author..." />;

  return (
    <div className="mx-auto max-w-3xl space-y-6" onKeyDown={handleKeyDown}>
      <PageHeader
        title={isNew ? "Add Author" : "Edit Author"}
        subtitle={isNew ? "Create a new author with login credentials" : "Update author profile and permissions"}
        action={
          <Link href="/authors" className="inline-flex items-center gap-2 text-sm text-muted hover:text-foreground">
            <ArrowLeft className="h-4 w-4" />
            Back
          </Link>
        }
      />

      {/* ── Credentials Section ────────────────────────────── */}
      <div className="rounded-xl border border-border-main bg-card p-5 shadow-sm">
        <div className="mb-4 flex items-center gap-2 text-sm font-semibold text-foreground">
          <ShieldCheck className="h-4 w-4 text-indigo-500" />
          Login Credentials
        </div>
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <div>
            <label className="mb-1 flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-muted">
              <Mail className="h-3.5 w-3.5" />
              Email *
            </label>
            <input
              name="email"
              type="email"
              value={form.email}
              onChange={onChange}
              disabled={!isNew}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500 disabled:bg-surface-hover disabled:text-muted"
              placeholder="author@example.com"
            />
            {!isNew && (
              <p className="mt-1 text-xs text-muted">Email cannot be changed after creation</p>
            )}
          </div>
          <div>
            <label className="mb-1 flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-muted">
              <Lock className="h-3.5 w-3.5" />
              {isNew ? "Password *" : "New Password"}
            </label>
            <div className="relative">
              <input
                name="password"
                type={showPassword ? "text" : "password"}
                value={form.password}
                onChange={onChange}
                className="w-full rounded-lg border border-input-border px-3 py-2 pr-10 text-sm focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                placeholder={isNew ? "Min 6 characters" : "Leave blank to keep unchanged"}
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-2 top-1/2 -translate-y-1/2 text-muted hover:text-gray-600 dark:text-gray-400"
              >
                {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
              </button>
            </div>
            {!isNew && (
              <p className="mt-1 text-xs text-muted">Leave blank to keep current password</p>
            )}
          </div>
        </div>
      </div>

      {/* ── Personal Details Section ───────────────────────── */}
      <div className="rounded-xl border border-border-main bg-card p-5 shadow-sm">
        <div className="mb-4 flex items-center gap-2 text-sm font-semibold text-foreground">
          <User className="h-4 w-4 text-indigo-500" />
          Personal Details
        </div>

        {/* Profile Photo */}
        <div className="mb-5 flex items-center gap-4">
          <div className="relative h-20 w-20 flex-shrink-0">
            {form.photo_url ? (
              <Image
                src={form.photo_url}
                alt="Profile"
                fill
                className="rounded-full object-cover"
                sizes="80px"
              />
            ) : (
              <div className="flex h-20 w-20 items-center justify-center rounded-full bg-gray-100 dark:bg-gray-800">
                <Camera className="h-8 w-8 text-gray-300 dark:text-gray-600" />
              </div>
            )}
            {form.photo_url && (
              <button
                type="button"
                onClick={handleRemovePhoto}
                className="absolute -right-1 -top-1 rounded-full bg-red-500 p-0.5 text-white shadow-sm hover:bg-red-600"
              >
                <X className="h-3.5 w-3.5" />
              </button>
            )}
          </div>
          <div>
            <button
              type="button"
              onClick={() => photoInputRef.current?.click()}
              disabled={uploading}
              className="inline-flex items-center gap-1.5 rounded-lg border border-input-border bg-card px-3 py-1.5 text-xs font-medium text-foreground transition hover:bg-surface-hover disabled:opacity-50"
            >
              {uploading ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : <Camera className="h-3.5 w-3.5" />}
              {uploading ? 'Uploading...' : form.photo_url ? 'Change Photo' : 'Upload Photo'}
            </button>
            <input
              ref={photoInputRef}
              type="file"
              accept="image/jpeg,image/png,image/webp"
              className="hidden"
              onChange={(e) => e.target.files?.[0] && handlePhotoUpload(e.target.files[0])}
            />
            <p className="mt-1 text-xs text-muted">JPEG, PNG, or WebP · Max 5MB</p>
          </div>
        </div>

        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <div className="sm:col-span-2">
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">Name *</label>
            <input
              name="name"
              value={form.name}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Full name"
            />
          </div>
          <div>
            <label className="mb-1 flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-muted">
              <Phone className="h-3.5 w-3.5" />
              Phone
            </label>
            <input
              name="phone"
              value={form.phone}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="+91 XXXXX XXXXX"
            />
          </div>
          <div>
            <label className="mb-1 flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-muted">
              <MapPin className="h-3.5 w-3.5" />
              Address
            </label>
            <input
              name="address"
              value={form.address}
              onChange={onChange}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="City, State"
            />
          </div>
          <div className="sm:col-span-2">
            <label className="mb-1 block text-xs font-semibold uppercase tracking-wider text-muted">Bio</label>
            <textarea
              name="bio"
              value={form.bio}
              onChange={onChange}
              rows={3}
              className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              placeholder="Short biography about the author..."
            />
          </div>
        </div>

        {/* Status toggles */}
        <div className="mt-4 flex items-center gap-6 border-t border-border-light pt-4">
          <label className="flex items-center gap-2">
            <input
              type="checkbox"
              checked={form.is_verified}
              onChange={(e) => setForm((prev) => ({ ...prev, is_verified: e.target.checked }))}
              className="h-4 w-4 rounded border-input-border text-indigo-600 dark:text-indigo-400 focus:ring-indigo-500"
            />
            <span className="text-sm text-foreground">Verified</span>
          </label>
          <label className="flex items-center gap-2">
            <input
              type="checkbox"
              checked={form.is_active}
              onChange={(e) => setForm((prev) => ({ ...prev, is_active: e.target.checked }))}
              className="h-4 w-4 rounded border-input-border text-indigo-600 dark:text-indigo-400 focus:ring-indigo-500"
            />
            <span className="text-sm text-foreground">Active</span>
          </label>
        </div>
      </div>

      {/* ── Content Permissions Section ────────────────────── */}
      <div className="rounded-xl border border-border-main bg-card p-5 shadow-sm">
        <div className="mb-1 flex items-center gap-2 text-sm font-semibold text-foreground">
          <ShieldCheck className="h-4 w-4 text-indigo-500" />
          Content Access Permissions
        </div>
        <p className="mb-4 text-xs text-muted">
          Select which content types this author is allowed to manage
        </p>

        {contentTypes.length === 0 ? (
          <p className="text-sm text-muted">No content types available</p>
        ) : (
          <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {contentTypes.map((ct) => {
              const isSelected = form.content_type_ids.includes(ct.id);
              return (
                <button
                  key={ct.id}
                  type="button"
                  onClick={() => toggleContentType(ct.id)}
                  className={`flex items-center gap-3 rounded-lg border-2 px-4 py-3 text-left transition ${
                    isSelected
                      ? "border-indigo-500 dark:border-indigo-400 bg-indigo-50 dark:bg-indigo-500/10 ring-1 ring-indigo-200 dark:ring-indigo-500/30"
                      : "border-border-main bg-card hover:border-input-border hover:bg-surface-hover"
                  }`}
                >
                  <div
                    className={`flex h-8 w-8 items-center justify-center rounded-lg text-lg ${
                      isSelected ? "bg-indigo-100 dark:bg-indigo-500/15" : "bg-gray-100 dark:bg-gray-800"
                    }`}
                  >
                    {ct.icon}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className={`text-sm font-medium ${isSelected ? "text-indigo-700 dark:text-indigo-400" : "text-foreground"}`}>
                      {ct.display_name}
                    </p>
                    <p className="truncate text-xs text-muted">{ct.description}</p>
                  </div>
                  <div
                    className={`flex h-5 w-5 items-center justify-center rounded-full border-2 transition ${
                      isSelected
                        ? "border-indigo-500 dark:border-indigo-400 bg-indigo-500"
                        : "border-input-border"
                    }`}
                  >
                    {isSelected && <Check className="h-3 w-3 text-white" />}
                  </div>
                </button>
              );
            })}
          </div>
        )}
      </div>

      {/* ── Sticky Action Bar ─────────────────────────────── */}
      <div className="sticky bottom-0 -mx-6 border-t border-border-main bg-card/90 px-6 py-3 backdrop-blur-sm">
        <div className="mx-auto flex max-w-3xl items-center justify-between">
          <Link href="/authors" className="text-sm text-muted hover:text-foreground">
            Cancel
          </Link>
          <button
            onClick={handleSave}
            disabled={saving}
            className="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-5 py-2 text-sm font-medium text-white transition hover:bg-indigo-700 disabled:opacity-50"
          >
            <Save className="h-4 w-4" />
            {saving ? "Saving..." : isNew ? "Create Author" : "Update Author"}
          </button>
        </div>
      </div>
    </div>
  );
}
