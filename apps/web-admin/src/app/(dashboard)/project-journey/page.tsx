import React from "react";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Project Journey - Anandham Admin",
  description: "Project summary, completed work and roadmap for Anandham web-admin",
};

export default function ProjectJourneyPage() {
  return (
    <div className="p-6">
      <h1 className="text-2xl font-semibold mb-4">Project Journey</h1>

      <section className="mb-6">
        <h2 className="text-lg font-medium mb-2">Completed (So Far)</h2>
        <ul className="list-disc ml-6 space-y-1 text-sm text-muted">
          <li><strong>Monorepo</strong>: Next.js + Flutter apps, shared packages.</li>
          <li><strong>Auth</strong>: Supabase auth integrated with RLS and admin checks.</li>
          <li><strong>Content Modules</strong>: CRUD for Krithis, Keerthanams, Dharmas, Guru Photos, Blogs.</li>
          <li><strong>Database</strong>: Supabase migrations, idempotent policies and triggers.</li>
          <li><strong>Dashboard</strong>: Live stats, recent activity, drafts, top categories, charts.</li>
          <li><strong>Performance</strong>: Fixed slow navigation by using cookie session read in middleware and narrowing matcher.</li>
          <li><strong>UX</strong>: Professional loading experience — top progress bar and skeleton screens.</li>
          <li><strong>CI/Git</strong>: Commits pushed to main; assets and favicon updated.</li>
        </ul>
      </section>

      <section className="mb-6">
        <h2 className="text-lg font-medium mb-2">Current Project State</h2>
        <ul className="list-disc ml-6 space-y-1 text-sm text-muted">
          <li>All admin routes compile and run locally.</li>
          <li>Dev environment uses Turbopack (note: occasional local cache issues on Windows).</li>
          <li>Dashboard reads real Supabase data (krithis, dharmas, blogs, authors, categories).</li>
        </ul>
      </section>

      <section>
        <h2 className="text-lg font-medium mb-2">Roadmap / Future Work</h2>
        <ol className="list-decimal ml-6 space-y-1 text-sm text-muted">
          <li>Automate database migration deployments and add monitoring for RLS policies.</li>
          <li>Integrate CI/CD (Vercel or other) with pre-deploy checks and seed migrations.</li>
          <li>Harden auth: use server-side verified `getUser()` where identity matters; keep `getSession()` for routing checks only.</li>
          <li>Add comprehensive end-to-end tests for admin flows and API endpoints.</li>
          <li>Improve Turbopack stability: add `.next` exclusions to antivirus; optionally switch to stable bundler if needed in dev.</li>
          <li>Analytics: add event tracking and content performance metrics in the dashboard.</li>
          <li>Enhance editor UX: image uploads, multi-image galleries, YouTube embeds, and rich text improvements.</li>
          <li>Access controls: per-author roles, audit log filtering, and admin impersonation tools.</li>
        </ol>
      </section>
    </div>
  );
}
