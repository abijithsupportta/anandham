
# Project Journey — Anandham Web Admin

Last updated: 2026-02-17

## Executive Summary

This document is an authoritative, in-depth technical and operational guide for the Anandham `web-admin` application. It is written to the standards expected from a senior engineering lead, intended for stakeholders including developers, SREs, product owners, and security reviewers. The goal is to capture the current implementation in detail, reasoning behind architectural choices, operational guidance, developer workflows, data governance, security rules, and an actionable roadmap.

The document is intentionally verbose and prescriptive — where decisions have been made, the rationale and alternatives are recorded; where work remains, specific next steps and acceptance criteria are proposed.

---

## How this document is organized

- Section A: Architecture & Design — high-level architecture, module boundaries, key abstractions
- Section B: Data Model & Migrations — complete schema notes, migrations strategy, RLS patterns
- Section C: Security & Auth — Supabase integration, session handling, middleware contract
- Section D: Feature Catalogue & User Flows — exhaustive per-module flows, pages, states, failure modes
- Section E: Developer Experience (DX) — repo layout, local dev, Turbopack caveats, tooling
- Section F: CI/CD, Deployment & Operations — pipelines, migration orchestration, rollback
- Section G: Observability & Monitoring — metrics, logs, alerts, audit review
- Section H: Testing & QA — unit, integration, E2E, data seeding strategies
- Section I: Troubleshooting & Known Issues — problems, diagnostics, mitigations
- Section J: Roadmap & Backlog — prioritized work, milestones, owner recommendations
- Appendices: code references, commands, contact list, glossary

Each section contains prescriptive recommendations, concrete commands, and code pointers to accelerate onboarding and audits.

---

## Section A — Architecture & Design

1. High-level architecture

The `web-admin` is a server-rendered React application using Next.js App Router. It is built inside a monorepo that also includes other consumer web apps and Flutter mobile apps. Core responsibilities for `web-admin` include content authoring, moderation, publishing workflows, media management, user/author management, and operational dashboards.

Architecture diagram (textual):

- User (browser) → Next.js App Router (Server & Client components) → Supabase (Postgres + Auth + Storage) / Cloudflare R2 (object storage for media) → CDN for public assets

Key runtime zones:

- Browser: Client components, editor, uploads (via secure signed requests)
- Server (Next.js): server components, APIs (/api/*), and middleware. Responsible for rendering, server-side data aggregation, and coordination with Supabase.
- Database: Supabase Postgres with RLS policies, migrations, and triggers (audit logs)
- Storage: Cloudflare R2 for media assets (uploads proxied through server API to keep credentials off the browser)

Design principles:

- Single source of truth for content in Postgres. Media stored as URLs referencing R2.
- Keep business logic in `services/*` files so pages remain thin and focused on rendering.
- Prefer Server Components for data fetching when rendering consistent list and stat pages; use Client Components for interactive forms and editors.
- Use RLS as the primary authorization enforcement mechanism — the server enforces additional checks for sensitive paths.

2. Module boundaries and directory mapping

- `src/app/` → Pages and nested layouts. App Router grouping used for `(dashboard)` layout.
- `src/components/` → Reusable UI building blocks (sidebar, header, modal, form controls).
- `src/services/` → Data access and aggregation logic that talks directly to Supabase client.
- `src/lib/` → Utilities, constants, and small wrappers (e.g., supabase client factory for SSR).

3. Data flow and contracts

- All writes (create/update/delete) go through service layer functions that return typed results and structured errors.
- For each critical action, the service should emit an `audit_logs` record. This is enforced via DB triggers where possible and via service-level calls for external side effects.

4. Component patterns

- `Server Component` usage:
   - Dashboard aggregation (`dashboard.service.ts`) — server-side to avoid redundant client calls.
   - List pages where SEO or pre-rendering is beneficial.
- `Client Component` usage:
   - Rich text editor, drag-and-drop media uploader, image preview, form interactions.

5. UI/UX decisions

- Navigation progress + Suspense skeletons to mask network latency and improve perceived performance.
- Use consistent design tokens from `packages/ui` to maintain brand consistency across web and mobile.

---

## Section B — Data Model & Migrations (detailed)

This section describes the canonical database schema, migration practices, and rules. Where possible, sample SQL fragments and migration snippets are included to illustrate patterns you should replicate.

1. Core tables and columns

- `krithis` (primary content table)
   - id: UUID PRIMARY KEY DEFAULT gen_random_uuid()
   - title: TEXT NOT NULL
   - slug: TEXT UNIQUE
   - content: TEXT (or JSONB rich representation)
   - author_name: TEXT
   - status: TEXT CHECK (status IN ('draft','published','archived')) DEFAULT 'draft'
   - cover_images: TEXT[] (list of R2 URLs)
   - created_at: TIMESTAMPTZ DEFAULT now()
   - updated_at: TIMESTAMPTZ DEFAULT now()

Notes:
- Use `pgcrypto` or `uuid-ossp` for UUID generation depending on Supabase runtime.
- Consider adding a lightweight `version` integer to support optimistic concurrency control in the future.

- `keerthanams`
   - Same base shape as `krithis` but with `lyrics` column and a junction table `keerthanam_categories(keerthanam_id, category_id)`.

- `dharmas`, `blogs`, `guru_photos`, `authors`, `content_categories`, `audit_logs` — as previously summarized in the top-level document.

2. Indexing strategy

- Add indexes on frequently queried columns: `status`, `created_at`, `updated_at`, `author_name`, `slug`.
- For tag/category joins, use a composite index on junction tables for fast lookups: `(category_id, keerthanam_id)` and `(keerthanam_id, category_id)` as necessary.

3. Migrations best-practices

- Always make migrations idempotent. Use `DROP IF EXISTS` before `CREATE` for policies/triggers and wrap schema-changing operations in `DO $$ BEGIN ... END $$` to detect and adapt to existing columns.
- Keep migrations small and focused. Group logically-related changes into the same migration when they are atomic.
- Test migrations locally against a snapshot of production schema in a staging environment.

Example migration snippet for idempotency (policy):

```sql
-- Drop if exists to ensure safe re-run
DROP POLICY IF EXISTS select_published ON public.krithis;

CREATE POLICY select_published ON public.krithis
   FOR SELECT
   USING (status = 'published' OR auth.role() = 'admin');
```

4. RLS patterns and common policy templates

- Read policy for public content:

```sql
CREATE POLICY "public_read_published" ON public.krithis
   FOR SELECT
   USING (status = 'published');
```

- Author-only write policy (update their own drafts):

```sql
CREATE POLICY "author_update_own" ON public.krithis
   FOR UPDATE
   USING (auth.role() = 'author' AND author_name = current_setting('request.jwt.claims.email', true));
```

Notes about claims: Supabase makes JWT claims available to RLS via `current_setting('request.jwt.claims.*')` depending on configuration. Test these thoroughly.

5. Audit logging and triggers

- Audit logs are created by either DB triggers or service-layer calls. Recommended pattern:
   - Add a `audit_logs` table with a JSON `meta` column.
   - Create triggers that fire on `INSERT`, `UPDATE`, `DELETE` for content tables to append normalized audit entries.

Example trigger function (simplified):

```sql
CREATE FUNCTION public.log_audit() RETURNS trigger AS $$
BEGIN
   INSERT INTO public.audit_logs (user_id, action, table_name, record_id, meta, created_at)
   VALUES (current_setting('request.jwt.claims.sub', true), TG_OP, TG_TABLE_NAME, NEW.id::text, row_to_json(NEW), now());
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

## Section C — Security & Authentication (deep dive)

This section focuses on the security posture, operational expectations, and recommendations for improving hardening over time.

1. Supabase Auth integration

- Authentication: Supabase Auth manages user sign-in, session cookies, and JWT issuance. Use `createServerClient` in server components to read and manipulate sessions securely.
- Session handling: For middleware routing checks, `supabase.auth.getSession()` is used to read cookie session without an external network call. Important: this returns data read from cookies and is not verified with Supabase.

Recommendation:
- Use `getSession()` only for routing/UX gating. For authorization-critical flows or to assert identity, call `getUser()` server-side or verify JWTs.

2. Roles & permissions design

- Role mapping:
   - `super_admin` — single-owner email; full rights
   - `admin` — content management and user management
   - `author` — create/manage their own content
   - `authenticated` — read access to published content

- Implement the principle of least privilege: RLS policies should default to deny.

3. Secret management

- Environment variables (Supabase URL/anon key, service role key, Cloudflare R2 credentials) should be stored in your hosting provider's secrets management (Vercel env vars, GitHub Actions secrets, or HashiCorp Vault). Never commit these to the repo.

4. Protection against common threats

- XSS: sanitize any HTML inserted into content fields on display. Prefer storing content as structured blocks (e.g., ProseMirror/JSON) and sanitize when rendering.
- CSRF: Next.js API routes with Supabase server client using cookies are generally protected; ensure CORS policies and same-site cookie flags are set.
- Rate limiting: protect `/api/upload` endpoints from abuse with per-IP throttling or signed upload tokens.

5. Incident response & auditability

- Audit logs must be immutable and accessible to admins. Retain logs for a suitable retention period (e.g., 90 days) and export to object storage or SIEM if required.

---

## Section D — Feature Catalogue & User Flows (exhaustive)

This section expands on the earlier User Flows with deeper behavioral descriptions, API endpoints used, DB tables affected, and sample success/failure payloads. Each module includes:
- Primary pages and routes
- Service calls and APIs
- DB write/read side-effects
- UX states (loading, success, error)
- Acceptance criteria for QA

We cover each module in alphabetical order for easy lookup.

Module: `Authors`

- Routes:
   - `GET /authors` — list (server-side rendered)
   - `GET /authors/[id]` — detail
   - `POST /api/authors` — create
   - `PUT /api/authors/[id]` — update
   - `DELETE /api/authors/[id]` — delete (soft-delete recommended)

- UI pages:
   - `/authors` — table with filters (verified, has posts, email)
   - `/authors/new` and `/authors/[id]` — create/edit forms

- Example service flow (create author):
   1. User fills form with `name`, `email`, `bio`, optional `photo`.
   2. If photo uploaded: `/api/upload` used to store photo in R2; response URL attached to payload.
   3. Client calls `POST /api/authors` with payload; server calls Supabase client to insert row.
   4. On success, server returns 201 with created record; UI shows success toast and redirects to `/authors`.
   5. Audit log: a row is inserted in `audit_logs` either via trigger or explicit service call.

- DB effects: `authors` table receives new row; optionally `profiles` table (if separate) could be updated.

- Acceptance criteria (QA):
   - Verify unique email constraint enforced.
   - Verify `verified` flag only changeable by `admin` or `super_admin`.
   - Photo upload persists to R2 and is reachable via CDN.

Module: `Blogs`

- Routes and APIs:
   - `GET /blogs`, `GET /blogs/[id]`
   - `POST /api/blogs`, `PUT /api/blogs/[id]`, `DELETE /api/blogs/[id]`

- Notable features:
   - Multi-image `cover_images` stored in `cover_images TEXT[]`.
   - `youtube_url` field that is optional; when present, frontend displays an embed preview in editor.
   - Rich-text editing stored as sanitized HTML or structured JSON.

- Sample payload (create):

```json
{
   "title": "A devotional post",
   "content": "<p>...sanitized html...</p>",
   "cover_images": ["https://cdn.../img1.jpg"],
   "youtube_url": "https://www.youtube.com/watch?v=...",
   "author_name": "Swami XYZ",
   "status": "draft"
}
```

- Business rules:
   - `title` required; `content` required for publish.

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

## Continued Section D — Feature Catalogue & User Flows (complete)

Module: `Dashboard` (detailed)

- APIs and server responsibilities:
   - `GET /` (server-side) renders the dashboard layout and invokes `dashboard.service.ts` methods:
      - `getStats()` — parallel counts across `krithis`, `dharmas`, `blogs`, `guru_photos`, `keerthanams`, `authors`, `content_categories`.
      - `getRecentActivity(limit)` — reads `audit_logs` and joins with `authors`/`users` for display.
      - `getDrafts(limit)` — union of drafts across content tables with type annotation for linking.
      - `getTopCategories(limit)` — aggregation over category relationships and content tables.
      - `getMonthlyGrowth()` — time-series aggregation for last N months.

- DB tables written: dashboard reads only; user actions triggered from dashboard (like quick-create) call content services which write to the respective content table and `audit_logs`.

- UI behaviors and acceptance criteria:
   - All stat cards must reflect counts consistent with raw DB queries — tests should validate counts against test fixtures.
   - Chart interactions should not block navigation; clicking filters should navigate to the appropriate list page preserving filters in query params.

Module: `Guru Photos` (detailed)

- APIs:
   - `GET /guru-photos` — gallery listing (server-side paginated)
   - `POST /api/guru-photos` — upload metadata (server will accept R2 URLs from `/api/upload`)
   - `DELETE /api/guru-photos/[id]` — soft-delete record and optionally request R2 purge

- DB side effects:
   - Insert/Update triggers add audit logs.
   - If purge requested, write a `purge_requested` flag for asynchronous worker to handle deletes from R2.

Module: `Keerthanams` / `Krithis` / `Dharmas` (shared patterns)

- Pagination: use cursor-based pagination via `created_at` or a stable integer `id` ordering to avoid skipping/duplicating items under concurrent writes.
- Draft autosave: implement client-side debounce and an autosave endpoint `POST /api/autosave` that stores a timestamped draft copy; provide UI to restore autosave.
- Publish workflow: publish should be an idempotent operation — if a second publish request arrives, it should be a no-op and return 200 with current published state.

Module: `Media Upload API` (security & resilience)

- Endpoint: `POST /api/upload`
   - Must validate session or signed token.
   - Validate `Content-Type` and file size.
   - Generate a content-addressed name or UUID path to avoid collisions.
   - Return the public CDN URL and internal storage key so UI can store both if needed.

- Resilience:
   - Use multipart upload when supported by R2 or chunked upload with retry.
   - Return deterministic error codes for client handling: `413` (Payload Too Large), `415` (Unsupported Media Type), `500` (Server Error), `429` (Too Many Requests).

Module: `Users` and `Admin` actions

- Elevated actions (change role, deactivate) must be validated server-side with `getUser()` and re-checked against RLS. UI should require a confirmation modal for destructive actions and log the action to `audit_logs`.

Cross-module acceptance tests

- Create content (krithi) end-to-end test:
   1. Sign in as `author`.
   2. Create new krithi with title, content, and cover image.
   3. Verify database record exists with `status = draft`.
   4. Publish and verify `status = published` and `published_at` present.
   5. Verify `audit_logs` contains create and publish actions.

---

## Section E — Developer Experience (DX) — expanded

1. Coding standards and conventions

- TypeScript strictness: enable `strict` in `tsconfig.json` for new modules; progressively migrate existing code.
- Lint rules: prefer explicit `any` avoidance, consistent import ordering, and enforced docstrings for exported services.

2. Branching and PR workflow

- Branch naming: `feature/<short-description>`, `fix/<issue-id>`, `chore/docs-...`.
- PR checklist (required before merge):
   - [ ] Lint passes
   - [ ] Typecheck passes
   - [ ] Unit tests added/updated
   - [ ] E2E smoke tests (if applicable) pass in CI
   - [ ] DB migration reviewed and reversible
   - [ ] Docs updated (`PROJECT_JOURNEY.md` or module-level README)

3. Local debugging tips

- Use `node --inspect` or VS Code remote debugger attached to Next.js server for server-side breakpoints.
- Use `supabase` CLI to run local Postgres if replicating DB issues.

4. Code ownership and reviews

- Add `CODEOWNERS` file for critical directories: `src/services`, `supabase/migrations`, and `src/lib/supabase`.

---

## Section F — CI/CD, Deployment & Operations — detailed

1. Example GitHub Actions workflow (skeleton)

```yaml
name: CI
on: [pull_request, push]
jobs:
   test:
      runs-on: ubuntu-latest
      steps:
         - uses: actions/checkout@v4
         - name: Use Node
            uses: actions/setup-node@v4
            with:
               node-version: 20
         - run: npm install
         - run: npm run -w apps/web-admin lint
         - run: npm run -w apps/web-admin build --if-present
         - run: npm test --workspaces --if-present

   deploy:
      needs: [test]
      if: github.ref == 'refs/heads/main'
      runs-on: ubuntu-latest
      steps:
         - uses: actions/checkout@v4
         - name: Run migrations
            env:
               SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
               SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}
            run: |
               # Run migration script with locking
               node tools/run-migrations.js --database $SUPABASE_URL --key $SUPABASE_SERVICE_ROLE_KEY
         - name: Deploy to Vercel
            uses: amondnet/vercel-action@v20
            with:
               vercel-token: ${{ secrets.VERCEL_TOKEN }}
               vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
               vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
```

2. Migration runner recommendations

- Implement a simple lock table in Postgres:

```sql
CREATE TABLE migration_lock (locked BOOLEAN PRIMARY KEY DEFAULT true, locked_at timestamptz DEFAULT now());
```

- Runner behavior:
   - Acquire lock with `INSERT` or `UPDATE` guarded by transaction.
   - Apply pending migrations.
   - Release lock on completion.

3. Blue/Green deployment considerations

- For database migrations that are not backward-compatible, use a staged migration: add columns first (compatible), deploy code that uses new columns optionally, then backfill, and finally drop old columns in a subsequent migration.

---

## Section G — Observability & Monitoring — detailed

1. Logging conventions

- Use structured JSON logs with fields: `timestamp`, `level`, `service`, `request_id`, `user_id`, `route`, `duration_ms`, `error`.
- Example log line:

```json
{"timestamp":"2026-02-17T10:00:00Z","level":"error","service":"web-admin","route":"/api/blogs","user_id":"...","request_id":"...","error":"upload failed","duration_ms":123}
```

2. Metrics to collect

- Business metrics: `content.created`, `content.published`, `media.uploaded`.
- Infrastructure metrics: `request.latency`, `request.error_rate`, `db.query_time`.

3. Tracing

- Instrument key service calls with OpenTelemetry spans: upload flow, publish workflow, dashboard aggregation.

4. Alerting

- Example alerts:
   - `avg(request.error_rate) > 5%` for 5 minutes → Slack/SMS paging
   - `db.query_time` for `getMonthlyGrowth` > 500ms → investigate slow query or missing index

---

## Section H — Testing & QA — expanded

1. Playwright E2E example

- Sample flow: publish blog post (headless)

```js
const { test, expect } = require('@playwright/test');

test('author can create and publish blog', async ({ page }) => {
   await page.goto('/login');
   await page.fill('input[name=email]', 'author@example.com');
   await page.fill('input[name=password]', 'password');
   await page.click('button[type=submit]');
   await page.goto('/blogs/new');
   await page.fill('input[name=title]', 'E2E test post');
   // attach image mock
   await page.fill('textarea[name=content]', '<p>Test body</p>');
   await page.click('button:has-text("Publish")');
   await expect(page.locator('.toast-success')).toBeVisible();
});
```

2. Test data and fixtures

- Provide seed scripts (`tools/seed-test-data.js`) that populate authors, categories, and sample content to create repeatable test runs.

---

## Section I — Troubleshooting & Runbooks (expanded)

1. Runbook: Turbopack .next corruption (Windows)

- Symptom: dev server panics with `.sst` or RocksDB errors, or missing `build-manifest.json`.

Steps:
   1. `CTRL+C` to stop dev server.
 2. Verify no other `next dev` is running in same workspace.
 3. Delete `.next` folder: `Remove-Item -Recurse -Force .next` (PowerShell) or `rm -rf .next` (bash).
 4. Restart: `npm run dev`.
 5. If recurring, add `.next` to antivirus exclusions and consider setting `turbopack.root` explicitly in `next.config.js` to avoid workspace root confusion.

2. Runbook: Failed migration in CI

Steps:
   1. Pause deploy and capture the error logs from migration runner.
 2. Re-run migration in a staging environment with `--dry-run` if supported.
 3. If a partial migration applied, restore DB from backup snapshot and re-run after fixing migration script.

3. Restore from DB backup (high level)

- Create regular logical backups with `pg_dump` and store in R2 or object storage.
- Restore steps (example):
   - `pg_restore -h host -U user -d dbname backup.dump`
   - Re-apply migrations that occurred after backup if needed.

---

## Section J — Roadmap & Backlog (expanded)

1. Concrete acceptance criteria for short-term items

- CI/CD migration lock: automated migration job that records `migration_run_id`, `started_at`, `completed_at`, and prevents concurrent runs; acceptance: no concurrent migration can run for 24 hours window.
- Playwright: 80% coverage for critical flows; acceptance: CI passes an E2E smoke suite on each `main` deploy.

2. Owners and timelines

- Assign owners for each area (DEV, SRE, PRODUCT) and create milestones in issue tracker with clear definition-of-done.

---

## Appendices — commands, SQL snippets, contact

- Useful SQL checks:

```sql
-- Check policies
SELECT * FROM pg_policies WHERE schemaname='public';

-- Recent audit logs
SELECT * FROM public.audit_logs ORDER BY created_at DESC LIMIT 50;
```

- Contact recommendations (replace with real addresses):
   - Owner / Super Admin: owner@example.com
   - Dev Lead: devlead@example.com
   - SRE: sre@example.com

---

## Final notes

This document is intended to be living. Update `PROJECT_JOURNEY.md` with each major change (migrations, auth changes, storage decisions) and link module-level READMEs where detail exists. If you'd like, I will now:

1. Finish generating a PDF export of this file and add it to the repo under `docs/`.
2. Split the document into `README_DEVELOPER.md`, `README_OPERATOR.md`, and `README_PRODUCT.md` and open PR drafts for review.
3. Render the document as a read-only admin page at `/admin/docs/project-journey` and wire a sidebar link to it.

Tell me which of these next steps you want and I'll proceed.
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

