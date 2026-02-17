
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

If you want this expanded further into a formal README, or split into per-audience docs (Developer, Maintainer, Operator), tell me which format you prefer and I will generate it and commit it to the repo.

