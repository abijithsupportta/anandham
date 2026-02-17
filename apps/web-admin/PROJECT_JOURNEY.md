
# Project Journey — Anandham Web Admin

Last updated: 2026-02-17

## Purpose
This document is a single-source project reference for the Anandham `web-admin` application. It captures architecture, the tech stack, content models, auth & security rules, user flows, developer setup, deployment guidance, troubleshooting, and the recommended roadmap for future work. Treat this as the canonical admin handbook for developers, maintainers, and operators.

---

## Table of Contents
- Overview
- Architecture & Folder Layout
- Technology Stack
- Key Concepts
- Data Model (tables & fields)
- Migrations & RLS policies
- Authentication & Roles
- Major Features & Services
- UI Components & UX Patterns
- Routing & Middleware
- Developer Setup & Local Workflow
- CI/CD & Deployment Recommendations
- Testing Strategy
- Observability & Monitoring
- Troubleshooting & Known Issues
- Roadmap & Next Steps

---

## Overview
`web-admin` is the Next.js-based administrative interface for the Anandham platform. It provides content management (CRUD) for spiritual content (krithis, keerthanams, dharmas), blog management, author and user administration, media uploads, and operational dashboards. The app is part of a monorepo that also contains consumer web apps and Flutter mobile apps.

Primary goals:
- Provide a secure admin surface for content authors and administrators.
- Expose operational dashboards and audit trails.
- Serve as the canonical interface for publishing and managing content.

---

## Architecture & Folder Layout
High-level repo layout (relevant parts):

- `apps/web-admin/` — Next.js admin app (this project)
   - `src/app/` — App router pages and layouts
   - `src/components/` — UI components, layout, providers
   - `src/services/` — Business logic that talks to Supabase (e.g., `dashboard.service.ts`)
   - `src/lib/` — small libraries (supabase client, constants, helpers)
   - `public/` — static assets
   - `PROJECT_JOURNEY.md` — this documentation
- `packages/` — shared packages like `ui`, `flutter_core`, `shared-utils`
- `supabase/migrations/` — PostgreSQL migration scripts and policies

Key files:
- `apps/web-admin/src/app/layout.tsx` — root layout and providers (ThemeProvider, navigation progress)
- `apps/web-admin/src/app/loading.tsx` — root loading UI used during Suspense boundaries
- `apps/web-admin/src/lib/supabase/middleware.ts` — middleware that checks session and guards routes
- `apps/web-admin/src/services/dashboard.service.ts` — dashboard aggregation logic

---

## Technology Stack
- Next.js 16 (App Router) with Turbopack in dev
- React 19, TypeScript 5
- Tailwind CSS v4 for styling and design tokens
- Supabase (Postgres) for DB, Auth, and Storage (R2 / file uploads)
- Cloudflare R2 for image storage (via upload API)
- Lucide icons for consistent iconography
- Monorepo managed with pnpm/npm (turbo.json present)

---

## Key Concepts
- Content Types: `krithis`, `keerthanams`, `dharmas`, `guru_photos`, `blogs`.
- Each content type supports: create, edit, publish/unpublish, multi-image attachments (where applicable), draft state, and categories.
- Audit Logs: All important operations are recorded to `audit_logs` with user and action metadata.
- RLS: Row-level security policies protect data access by role; migrations create and maintain these policies.

---

## Data Model (high-level)
This is a simplified schema overview. For full schema and migrations see the `supabase/migrations/` folder.

- `krithis`
   - `id UUID PK`, `title TEXT`, `content TEXT`, `author_name TEXT`, `status TEXT` (`published`/`draft`), `cover_images TEXT[]`, `created_at`, `updated_at`
- `keerthanams`
   - `id UUID PK`, `title`, `lyrics`, `author_name`, `status`, `categories` (junction table `keerthanam_categories`), `created_at`, `updated_at`
- `dharmas`
   - `id UUID PK`, `title`, `content`, `author_name`, `status`, `created_at`, `updated_at`
- `guru_photos`
   - `id UUID PK`, `url`, `caption`, `metadata`, `created_at`
- `blogs`
   - `id UUID PK`, `title`, `content`, `cover_images TEXT[]`, `youtube_url TEXT`, `author_id UUID? or author_name TEXT`, `status`, `created_at`, `updated_at`
- `authors`
   - `id UUID PK`, `name`, `email`, `bio`, `verified BOOLEAN`, `created_at`
- `content_categories` / `categories`
   - `id`, `name`, `slug`, `active BOOLEAN`
- `audit_logs`
   - `id`, `user_id`, `action`, `table_name`, `record_id`, `meta JSON`, `created_at`

Notes:
- Several earlier migrations changed `author_id` → `author_name` for certain content types; migrations are idempotent and include DO blocks to handle these transitions.

---

## Migrations & RLS Policies
- All SQL migrations are under `supabase/migrations/` and are numbered.
- Migrations include `DROP POLICY IF EXISTS` and `DROP TRIGGER IF EXISTS` before re-creating resources to be idempotent.
- Important policy patterns implemented:
   - Allow `authenticated` users to read published content.
   - Allow `author` role to insert/update their own drafts.
   - Allow `admin`/`super_admin` to bypass certain RLS rules.
- Triggers exist for audit logs and maintaining derived fields.

---

## Authentication & Roles
Primary auth is handled by Supabase Auth. Roles used in the system:

- `super_admin` — single owner email (configured by `SUPER_ADMIN_EMAIL` environment variable). Full control.
- `admin` — can manage content and authors.
- `author` — can create and manage their own content (permission-scoped by RLS policies).
- `authenticated` — logged-in users (read-only on public content in many cases).

Middleware approach (see `apps/web-admin/src/lib/supabase/middleware.ts`):
- For speed, middleware uses `supabase.auth.getSession()` which reads session data from cookies without a network round-trip — used only for route gating (redirect to `/login` when no session).
- For operations where identity must be verified, server components and API routes should call `supabase.auth.getUser()` or verify the JWT with Supabase to avoid trusting cookie values.

Sign-out behavior: middleware calls `supabase.auth.signOut()` for unauthorized users before redirecting.

---

## Major Features & Services

1. Dashboard
    - `dashboard.service.ts`: aggregates counts (total/published/drafts), recent activity from `audit_logs`, top categories, and monthly growth metrics.
    - Visuals: stat cards, area chart (monthly growth), horizontal bar (top categories), recent activity table, drafts list.

2. Content Management
    - Pages for lists and forms for each content type.
    - Form pages support saving as draft and publishing.
    - Multi-image uploads supported via R2 / API upload route.

3. Authors & Users
    - Author listing and profile editing.
    - Verified/Unverified author flag.

4. Blogs
    - Supports multiple cover images and `youtube_url` field.

5. Media Uploads
    - Upload endpoint stores media and returns URL; assets are stored in Cloudflare R2.

6. Audit Logs
    - Audit triggers capture create/update/delete operations with metadata.

---

## UI Components & UX Patterns
- Design system: `packages/ui` supplies shared React components and tokens.
- Key components in admin:
   - `Sidebar` — navigation with collapsible groups and responsive behavior.
   - `NavigationProgress` — slim top progress bar for route transitions.
   - `page-skeleton` components — skeletons for list, form, dashboard views used in `loading.tsx`.
   - `LoadingState` — wrapper that uses skeletons for seamless UX.
- Patterns:
   - Use `Suspense` boundaries at route-level to show skeletons during navigation.
   - Keep API calls in `services/*.ts` and use server components where possible for data fetching.

---

## Routing & Middleware
- App Router organizes pages under `src/app` with nested layouts.
- Middleware runs for protected routes and uses `getSession()` for fast checks; matcher is intentionally narrow to avoid running on static assets and API routes.

---

## Developer Setup & Local Workflow
Recommended local workflow:

1. Install dependencies from repo root (monorepo):
```powershell
cd C:\Personal Projects\anandham
npm install
```

2. Run admin locally:
```powershell
cd apps/web-admin
npm run dev
```

3. If Turbopack (dev) cache corrupts on Windows, delete `.next` and restart:
```powershell
Remove-Item -Recurse -Force .next
npm run dev
```

4. Linting and formatting:
 - Follow the repository's `package.json` scripts for lint and format (if available).

---

## CI/CD & Deployment Recommendations
- Recommended: Deploy `web-admin` as a separate project (Vercel or self-hosted) with environment variables stored securely.
- Build step should run migrations (or run them in a separate deployment job) before switching traffic.
- Suggested pipeline steps:
   1. Run tests
   2. Build (`next build`) and run audit/SSG checks
   3. Run DB migrations in a controlled environment (migrations script with locking)
   4. Deploy to staging, run smoke tests, then deploy to production

---

## Testing Strategy
- Unit tests for services (`apps/web-admin/src/services`) and utility functions.
- Integration tests for database interactions (use a test Supabase instance or dockerized Postgres).
- End-to-end (E2E) tests with Playwright covering:
   - Authentication flow
   - Create/edit/publish lifecycle for each content type
   - Media uploads

---

## Observability & Monitoring
- Add server-side logging for API routes and critical services.
- Capture audit logs to monitor critical actions and anomalous behavior.
- Integrate error tracking (Sentry) and metrics (Prometheus/Grafana or Datadog) for production.

---

## Troubleshooting & Known Issues
- Turbopack dev cache corruption on Windows
   - Symptom: panics referencing `.sst` files or "Failed to restore task data" errors and missing `build-manifest.json` under `.next`.
   - Cause: RocksDB files used by Turbopack can be corrupted by abrupt process termination or antivirus interference.
   - Workaround: Delete `.next` and restart dev server:
      ```powershell
      Remove-Item -Recurse -Force .next
      npm run dev
      ```
   - Mitigation: Exclude `.next` from antivirus scans; avoid multiple dev servers writing to same `.next`.

- Supabase session warning in middleware
   - The app uses `supabase.auth.getSession()` in middleware for speed. Supabase warns that this value is read from cookies and not verified by calling the auth server — this is acceptable for routing checks but server APIs should call `getUser()`.

---

## Roadmap & Next Steps (detailed)
Priority items:

1. CI/CD and migration automation
    - Add migration locking and a `deploy:migrate` job.
2. Tests and E2E coverage
    - Implement Playwright suites and add to CI.
3. Role-based access controls
    - Add richer roles (editor, moderator), map to RLS policies.
4. Admin UX improvements
    - Media manager, bulk operations, scheduled publishing, content versioning.
5. Observability
    - Error tracking and content analytics dashboards.

Longer-term:
- Internationalization (i18n)
- Multi-tenant support (if required)
- Analytics-driven content recommendations

---
## Appendices: Important File Links
- `apps/web-admin/src/lib/supabase/middleware.ts` — middleware auth check. ([file link](src/lib/supabase/middleware.ts#L1))
- `apps/web-admin/src/services/dashboard.service.ts` — dashboard aggregation. ([file link](src/services/dashboard.service.ts#L1))
- `apps/web-admin/src/components/layout/Sidebar.tsx` — main sidebar navigation. ([file link](src/components/layout/Sidebar.tsx#L1))
- `supabase/migrations/` — DB migrations folder.

---

## User Flows (Module-by-Module)

Last updated: 2026-02-17 — includes recent changes: dashboard uses real Supabase data, middleware uses `getSession()` for fast routing checks, skeleton loading + `NavigationProgress`, and Turbopack caveat for Windows.

This section documents the user experience and expected flows, page-by-page, for the web-admin. Each flow includes entry points, pages, available actions, success states, common errors and edge scenarios.

1) Authentication (Login / Session)
    - Entry: `/login` or attempt to access any protected admin route.
    - Pages: `/login` (login form), root redirect logic in middleware.
    - Actions:
       - Submit credentials (email + password) → Supabase Auth.
       - On success: set session cookie; redirect to requested callback URL or `/`.
       - On failure: show inline error message (invalid credentials), allow retry, show forgot-password link if available.
    - Middleware behavior:
       - `getSession()` reads cookie to determine if user is authenticated for routing; if no session, redirect to `/login` with `callbackUrl` param.
       - If user is authenticated but not authorized (not `SUPER_ADMIN_EMAIL`), middleware signs out and redirects to `/login?error=unauthorized`.
    - Edge cases:
       - Expired session → redirect to `/login` (user sees expired/login-required message).
       - Network error during login → show retry state and a helpful message.

2) Dashboard (`/`)
    - Entry: top-level admin landing page.
    - Data: Live stats for `krithis`, `dharmas`, `guru_photos`, `keerthanams`, `blogs`, `authors`, `categories`; recent activity from `audit_logs`; drafts list; charts for monthly growth and top categories.
    - Pages/components: `DashboardSkeleton` (loading), stat cards, charts, `RecentActivity` table, `Drafts` list.
    - Actions:
       - Click stat card → navigate to respective list (e.g., `/krithis`).
       - Click draft item → open edit form page.
       - Filter charts by time-range (if implemented) → re-query server-side data.
       - Quick actions from activity (view record) → navigate to record edit or detail page.
    - UX notes:
       - `NavigationProgress` shows top progress during navigation.
       - Page uses Suspense and `DashboardSkeleton` to avoid jarring spinners.
    - Edge cases:
       - Empty datasets → stat cards show zero and charts render empty state.
       - Supabase query error → show a non-blocking error toast and an option to retry.

3) Krithis (Content list, create, edit)
    - Entry: `/krithis`
    - Pages:
       - List: `/krithis` — table with rows, pagination, filters (status, category, author).
       - Form: `/krithis/new` (create) and `/krithis/[id]` (edit).
    - Actions (List):
       - Search and filtering → client sends query to services which request from Supabase.
       - Click “New” → navigate to form with blank fields.
       - Row actions: Edit, Duplicate, Publish/Unpublish, Delete, Bulk actions (select multiple rows to publish/delete).
    - Actions (Form):
       - Save as Draft → insert row with `status = draft`; create audit log entry.
       - Publish → set `status = published`; set `published_at`; create audit log entry.
       - Upload cover images → open media picker; files uploaded via `/api/upload` to R2; returns URLs stored in `cover_images` array.
       - Validation: title required. On validation fail, show inline errors.
    - Success states:
       - On save: redirect back to list or remain on form with success toast (configurable); draft appears in drafts list.
    - Error states:
       - Upload failures → retry option, keep form state intact.
       - Permissions error (RLS) → sign out or show unauthorized toast depending on context.
    - Special scenarios:
       - Duplicate workflow: copy all fields into new draft, allow quick publish after edit.
       - Versioning (future): show an info banner if a published version exists.

4) Keerthanams (List & Form)
    - Entry: `/keerthanams`
    - Pages: List and Form similar to `krithis` with addition of categories junction table.
    - Actions:
       - Assign categories via multi-select; backend manages `keerthanam_categories` junction table.
       - Edit lyrics and associated metadata.
    - Edge cases:
       - Category deletions: if category removed, ensure junction records cleaned or preserved per migration rules.

5) Dharmas (List & Form)
    - Entry: `/dharmas`
    - Similar to `krithis` but focused on prose/essays.
    - Actions: draft/publish, image attachments if applicable, author attribution.

6) Guru Photos (Gallery)
    - Entry: `/guru-photos`
    - Pages: Gallery list (grid), upload form, edit metadata.
    - Actions:
       - Upload photo(s) → `/api/upload` to Cloudflare R2; returned URL saved in `guru_photos`.
       - Edit caption/alt text for accessibility.
       - Delete photo → remove DB row and optionally purge from R2 (persistence policy to be defined).
    - UX:
       - Bulk uploads with progress indicators.
    - Edge cases:
       - Large file size → show client validation and reject; suggest guidelines.

7) Blogs (List, Form, Categories)
    - Entry: `/blogs` and `/blogs/categories`
    - Features:
       - Support multiple `cover_images` and `youtube_url`.
       - Rich-text content with media embeds.
    - Actions:
       - Create/Save Draft/Publish as per other modules.
       - Manage blog categories; assign to posts.
    - Special scenarios:
       - If `youtube_url` is present, show preview in editor and on public view.

8) Authors (Management)
    - Entry: `/authors`
    - Pages: List, Create/Edit author profile.
    - Actions:
       - Mark author as `verified` → visible on public profile.
       - Edit author bio, photo, social links.
    - Edge cases:
       - Email collisions — database-level unique constraint should prevent duplicates; UI should show friendly error.

9) Content Categories
    - Entry: `/content-categories`
    - Pages: List & Form for categories
    - Actions:
       - Create, edit slug, activate/deactivate categories.
       - When deactivating, ensure content referencing category continues to function (UI can show `uncategorized` fallback).

10) Users (Admin user management)
    - Entry: `/users`
    - Pages: List of users, ability to view last login, role, and to deactivate/ban.
    - Actions:
       - Search by email, change role, disable account.
    - Security:
       - Only `super_admin`/`admin` can modify critical properties.

11) Settings
    - Entry: `/settings`
    - Pages: App-level configuration (theme defaults, environment notes, external integrations).
    - Actions:
       - Update branding assets (logo used as favicon is already updated in `src/app/icon.png`).
       - Manage `SUPER_ADMIN_EMAIL` or other env-controlled features via deployment configs.

12) Audit Logs / Recent Activity
    - Entry: accessible via Dashboard and a dedicated `/audit-log` route.
    - Data: `audit_logs` table with action, user, table, record id, and meta JSON.
    - Actions:
       - Filter by user, action type, date range, and table.
       - Click entry → navigate to record when permitted.
    - Important: audit logs are append-only; only admins can query them.

13) Media Upload Flow (common)
    - Entry: any form that supports file upload.
    - Flow:
       1. User selects file(s) in editor or media picker.
       2. Client uploads to `/api/upload` (server) which authenticates and stores in Cloudflare R2.
       3. Server returns URL(s); client attaches URLs to record payload (e.g., `cover_images`).
       4. On save/publish, DB row stores the URLs. Triggers may create derived thumbnails or generate audit entries.
    - Error handling:
       - If upload fails, client retains local file reference and offers retry. Form state should not be lost.

Cross-cutting scenarios and behaviors
- Progressive navigation & loading:
   - Route transitions show `NavigationProgress` and Suspense skeletons so user perceives instant navigation even when server data is loading.
- Permissions & RLS:
   - For all create/update/delete operations, server-side RLS and API validations must ensure the acting user is authorized. Middleware gates the surface, but `getUser()` should be used in APIs where identity must be trusted.
- Error / Retry patterns:
   - All write actions should show optimistic UI or clear loading states and informative toasts on failures with actionable retry.
- Bulk operations:
   - Lists should support selecting multiple rows to perform publish/unpublish/delete with confirmation modal and a batched service call.

---

After adding these flows, operators and developers should be able to trace any user action end-to-end: which pages are involved, which services are called, what DB tables are written, and what audit entries are created.


If you want this expanded further into a formal README, or split into per-audience docs (Developer, Maintainer, Operator), tell me which format you prefer and I will generate it and commit it to the repo.

