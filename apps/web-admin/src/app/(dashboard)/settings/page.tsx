"use client";

import { useState } from "react";
import {
  Save,
  Globe,
  Shield,
  Bell,
  Database,
  Info,
} from "lucide-react";
import type { AppSettings as BaseAppSettings, ContentLanguage } from "@/types/database";

// Extended settings for the admin UI (superset of database AppSettings)
// TODO: Wire to Supabase when settings table is created
interface AdminSettings extends BaseAppSettings {
  support_email: string;
  require_email_verification: boolean;
  max_krithi_length: number;
  min_krithi_length: number;
  allow_comments: boolean;
  moderate_comments: boolean;
  notification_email_new_author: boolean;
  notification_email_new_report: boolean;
  notification_email_daily_digest: boolean;
  content_guidelines_url: string;
}

const initialSettings: AdminSettings = {
  site_name: "",
  site_description: "",
  support_email: "",
  maintenance_mode: false,
  allow_registration: false,
  auto_approve_authors: false,
  require_email_verification: false,
  max_krithi_length: 0,
  min_krithi_length: 0,
  allow_comments: false,
  moderate_comments: false,
  notification_email_new_author: false,
  notification_email_new_report: false,
  notification_email_daily_digest: false,
  default_language: "ta",
  supported_languages: ["ta", "en", "sa"],
  content_guidelines_url: "",
};

function Toggle({
  enabled,
  onChange,
}: {
  enabled: boolean;
  onChange: (v: boolean) => void;
}) {
  return (
    <button
      onClick={() => onChange(!enabled)}
      className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${
        enabled ? "bg-indigo-600" : "bg-gray-200 dark:bg-gray-700"
      }`}
    >
      <span
        className={`inline-block h-4 w-4 transform rounded-full bg-card transition-transform ${
          enabled ? "translate-x-6" : "translate-x-1"
        }`}
      />
    </button>
  );
}

export default function SettingsPage() {
  const [settings, setSettings] = useState<AdminSettings>(initialSettings);
  const [saved, setSaved] = useState(false);
  const [activeTab, setActiveTab] = useState("general");

  function handleSave() {
    // TODO: Save to Supabase
    setSaved(true);
    setTimeout(() => setSaved(false), 3000);
  }

  function update<K extends keyof AdminSettings>(
    key: K,
    value: AdminSettings[K]
  ) {
    setSettings((prev) => ({ ...prev, [key]: value }));
    setSaved(false);
  }

  const tabs = [
    { id: "general", label: "General", icon: Globe },
    { id: "content", label: "Content", icon: Database },
    { id: "auth", label: "Auth & Security", icon: Shield },
    { id: "notifications", label: "Notifications", icon: Bell },
  ];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-foreground">Settings</h1>
          <p className="mt-1 text-sm text-muted">
            Configure platform settings and preferences
          </p>
        </div>
        <button
          onClick={handleSave}
          className={`inline-flex items-center gap-2 rounded-lg px-4 py-2 text-sm font-medium text-white transition ${
            saved
              ? "bg-green-600 hover:bg-green-700"
              : "bg-indigo-600 hover:bg-indigo-700"
          }`}
        >
          {saved ? (
            <>
              <Save className="h-4 w-4" />
              Saved!
            </>
          ) : (
            <>
              <Save className="h-4 w-4" />
              Save Changes
            </>
          )}
        </button>
      </div>

      {/* Tabs */}
      <div className="border-b border-border-main">
        <nav className="flex gap-6">
          {tabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex items-center gap-2 border-b-2 pb-3 pt-1 text-sm font-medium transition ${
                activeTab === tab.id
                  ? "border-indigo-600 text-indigo-600 dark:text-indigo-400"
                  : "border-transparent text-muted hover:text-foreground"
              }`}
            >
              <tab.icon className="h-4 w-4" />
              {tab.label}
            </button>
          ))}
        </nav>
      </div>

      {/* General Settings */}
      {activeTab === "general" && (
        <div className="rounded-xl border border-border-main bg-card p-6 shadow-sm">
          <h2 className="mb-6 text-lg font-semibold text-foreground">
            General Settings
          </h2>
          <div className="space-y-6">
            <div>
              <label className="mb-1 block text-sm font-medium text-foreground">
                Site Name
              </label>
              <input
                type="text"
                value={settings.site_name}
                onChange={(e) => update("site_name", e.target.value)}
                className="w-full max-w-md rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label className="mb-1 block text-sm font-medium text-foreground">
                Site Description
              </label>
              <textarea
                value={settings.site_description}
                onChange={(e) => update("site_description", e.target.value)}
                rows={3}
                className="w-full max-w-md rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label className="mb-1 block text-sm font-medium text-foreground">
                Support Email
              </label>
              <input
                type="email"
                value={settings.support_email}
                onChange={(e) => update("support_email", e.target.value)}
                className="w-full max-w-md rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label className="mb-1 block text-sm font-medium text-foreground">
                Default Language
              </label>
              <select
                value={settings.default_language}
                onChange={(e) => update("default_language", e.target.value as ContentLanguage)}
                className="w-full max-w-md rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              >
                <option value="ta">Tamil (தமிழ்)</option>
                <option value="en">English</option>
                <option value="sa">Sanskrit (संस्कृतम्)</option>
                <option value="ml">Malayalam (മലയാളം)</option>
                <option value="hi">Hindi (हिन्दी)</option>
              </select>
            </div>
            <div>
              <label className="mb-1 block text-sm font-medium text-foreground">
                Content Guidelines URL
              </label>
              <input
                type="url"
                value={settings.content_guidelines_url}
                onChange={(e) =>
                  update("content_guidelines_url", e.target.value)
                }
                className="w-full max-w-md rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
              />
            </div>

            {/* Maintenance Mode */}
            <div className="flex items-center justify-between rounded-lg border border-border-main p-4 max-w-md">
              <div>
                <p className="text-sm font-medium text-foreground">
                  Maintenance Mode
                </p>
                <p className="text-xs text-muted">
                  Temporarily disable the platform for users
                </p>
              </div>
              <Toggle
                enabled={settings.maintenance_mode}
                onChange={(v) => update("maintenance_mode", v)}
              />
            </div>


            {settings.maintenance_mode && (
              <div className="flex items-start gap-2 rounded-lg border border-amber-200 dark:border-amber-500/30 bg-amber-50 dark:bg-amber-500/10 p-3 max-w-md">
                <Info className="mt-0.5 h-4 w-4 text-amber-600 shrink-0" />
                <p className="text-sm text-amber-700 dark:text-amber-400">
                  Maintenance mode is active. Users cannot access the platform.
                </p>
              </div>
            )}
          </div>
        </div>
      )}

      {/* Content Settings */}
      {activeTab === "content" && (
        <div className="rounded-xl border border-border-main bg-card p-6 shadow-sm">
          <h2 className="mb-6 text-lg font-semibold text-foreground">
            Content Settings
          </h2>
          <div className="space-y-6">
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 max-w-md">
              <div>
                <label className="mb-1 block text-sm font-medium text-foreground">
                  Min Krithi Length (chars)
                </label>
                <input
                  type="number"
                  value={settings.min_krithi_length}
                  onChange={(e) =>
                    update("min_krithi_length", parseInt(e.target.value) || 0)
                  }
                  className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                />
              </div>
              <div>
                <label className="mb-1 block text-sm font-medium text-foreground">
                  Max Krithi Length (chars)
                </label>
                <input
                  type="number"
                  value={settings.max_krithi_length}
                  onChange={(e) =>
                    update("max_krithi_length", parseInt(e.target.value) || 0)
                  }
                  className="w-full rounded-lg border border-input-border bg-input-bg px-3 py-2 text-sm text-foreground focus:border-indigo-500 dark:border-indigo-400 focus:outline-none focus:ring-1 focus:ring-indigo-500"
                />
              </div>
            </div>

            <div className="space-y-4 max-w-md">
              <div className="flex items-center justify-between rounded-lg border border-border-main p-4">
                <div>
                  <p className="text-sm font-medium text-foreground">
                    Allow Comments
                  </p>
                  <p className="text-xs text-muted">
                    Let users comment on krithis
                  </p>
                </div>
                <Toggle
                  enabled={settings.allow_comments}
                  onChange={(v) => update("allow_comments", v)}
                />
              </div>

              <div className="flex items-center justify-between rounded-lg border border-border-main p-4">
                <div>
                  <p className="text-sm font-medium text-foreground">
                    Moderate Comments
                  </p>
                  <p className="text-xs text-muted">
                    Require approval before comments are visible
                  </p>
                </div>
                <Toggle
                  enabled={settings.moderate_comments}
                  onChange={(v) => update("moderate_comments", v)}
                />
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Auth & Security Settings */}
      {activeTab === "auth" && (
        <div className="rounded-xl border border-border-main bg-card p-6 shadow-sm">
          <h2 className="mb-6 text-lg font-semibold text-foreground">
            Auth & Security
          </h2>
          <div className="space-y-4 max-w-md">
            <div className="flex items-center justify-between rounded-lg border border-border-main p-4">
              <div>
                <p className="text-sm font-medium text-foreground">
                  Allow Registration
                </p>
                <p className="text-xs text-muted">
                  Allow new users to sign up
                </p>
              </div>
              <Toggle
                enabled={settings.allow_registration}
                onChange={(v) => update("allow_registration", v)}
              />
            </div>

            <div className="flex items-center justify-between rounded-lg border border-border-main p-4">
              <div>
                <p className="text-sm font-medium text-foreground">
                  Require Email Verification
                </p>
                <p className="text-xs text-muted">
                  Users must verify email before using the platform
                </p>
              </div>
              <Toggle
                enabled={settings.require_email_verification}
                onChange={(v) => update("require_email_verification", v)}
              />
            </div>

            <div className="flex items-center justify-between rounded-lg border border-border-main p-4">
              <div>
                <p className="text-sm font-medium text-foreground">
                  Auto-Approve Authors
                </p>
                <p className="text-xs text-muted">
                  Automatically approve author applications
                </p>
              </div>
              <Toggle
                enabled={settings.auto_approve_authors}
                onChange={(v) => update("auto_approve_authors", v)}
              />
            </div>

            {settings.auto_approve_authors && (
              <div className="flex items-start gap-2 rounded-lg border border-amber-200 dark:border-amber-500/30 bg-amber-50 dark:bg-amber-500/10 p-3">
                <Info className="mt-0.5 h-4 w-4 text-amber-600 shrink-0" />
                <p className="text-sm text-amber-700 dark:text-amber-400">
                  Auto-approve is enabled. All author applications will be
                  approved instantly without manual review.
                </p>
              </div>
            )}
          </div>
        </div>
      )}

      {/* Notification Settings */}
      {activeTab === "notifications" && (
        <div className="rounded-xl border border-border-main bg-card p-6 shadow-sm">
          <h2 className="mb-6 text-lg font-semibold text-foreground">
            Email Notifications
          </h2>
          <div className="space-y-4 max-w-md">
            <div className="flex items-center justify-between rounded-lg border border-border-main p-4">
              <div>
                <p className="text-sm font-medium text-foreground">
                  New Author Applications
                </p>
                <p className="text-xs text-muted">
                  Get notified when a new author applies
                </p>
              </div>
              <Toggle
                enabled={settings.notification_email_new_author}
                onChange={(v) => update("notification_email_new_author", v)}
              />
            </div>

            <div className="flex items-center justify-between rounded-lg border border-border-main p-4">
              <div>
                <p className="text-sm font-medium text-foreground">
                  New Reports
                </p>
                <p className="text-xs text-muted">
                  Get notified when a new report is filed
                </p>
              </div>
              <Toggle
                enabled={settings.notification_email_new_report}
                onChange={(v) => update("notification_email_new_report", v)}
              />
            </div>

            <div className="flex items-center justify-between rounded-lg border border-border-main p-4">
              <div>
                <p className="text-sm font-medium text-foreground">
                  Daily Digest
                </p>
                <p className="text-xs text-muted">
                  Receive a daily summary of platform activity
                </p>
              </div>
              <Toggle
                enabled={settings.notification_email_daily_digest}
                onChange={(v) => update("notification_email_daily_digest", v)}
              />
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
