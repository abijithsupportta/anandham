"use client";

import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";

interface DiagResult {
  label: string;
  status: "pass" | "fail" | "warn" | "checking";
  detail: string;
}

export default function DiagnosticsPage() {
  const [results, setResults] = useState<DiagResult[]>([]);
  const [running, setRunning] = useState(true);

  useEffect(() => {
    runDiagnostics();
  }, []);

  async function runDiagnostics() {
    const diag: DiagResult[] = [];

    // 1. Check env vars
    const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
    const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
    diag.push({
      label: "Supabase URL",
      status: url ? "pass" : "fail",
      detail: url ? url : "NEXT_PUBLIC_SUPABASE_URL is not set",
    });
    diag.push({
      label: "Supabase Anon Key",
      status: key ? "pass" : "fail",
      detail: key ? `${key.substring(0, 20)}...` : "NEXT_PUBLIC_SUPABASE_ANON_KEY is not set",
    });
    setResults([...diag]);

    if (!url || !key) {
      setRunning(false);
      return;
    }

    // 2. Check auth session
    const supabase = createClient();
    const { data: sessionData, error: sessionError } = await supabase.auth.getSession();
    diag.push({
      label: "Auth Session",
      status: sessionData?.session ? "pass" : "fail",
      detail: sessionData?.session
        ? `Logged in as ${sessionData.session.user.email} (expires: ${new Date(sessionData.session.expires_at! * 1000).toLocaleString()})`
        : `No active session. ${sessionError?.message || "User is not logged in. Please login first."}`,
    });
    setResults([...diag]);

    // 3. Check auth user
    const { data: userData, error: userError } = await supabase.auth.getUser();
    diag.push({
      label: "Auth User (server-verified)",
      status: userData?.user ? "pass" : "warn",
      detail: userData?.user
        ? `User ID: ${userData.user.id}, Email: ${userData.user.email}`
        : `Could not verify user with server: ${userError?.message || "unknown"}`,
    });
    setResults([...diag]);

    // 4. Check JWT role claim
    const jwt = sessionData?.session?.access_token;
    if (jwt) {
      try {
        const payload = JSON.parse(atob(jwt.split(".")[1]));
        diag.push({
          label: "JWT Role",
          status: payload.role === "authenticated" ? "pass" : "warn",
          detail: `role=${payload.role}, aud=${payload.aud}, exp=${new Date(payload.exp * 1000).toLocaleString()}`,
        });
      } catch {
        diag.push({ label: "JWT Role", status: "fail", detail: "Could not decode JWT" });
      }
    } else {
      diag.push({ label: "JWT Role", status: "fail", detail: "No JWT token (not logged in)" });
    }
    setResults([...diag]);

    // 5. Test raw fetch to Supabase REST API (bypassing supabase-js)
    try {
      const headers: Record<string, string> = {
        apikey: key,
        "Content-Type": "application/json",
      };
      if (jwt) {
        headers["Authorization"] = `Bearer ${jwt}`;
      }
      const rawResp = await fetch(`${url}/rest/v1/categories?select=id&limit=1`, { headers });
      diag.push({
        label: "Raw API call (categories)",
        status: rawResp.ok ? "pass" : "fail",
        detail: rawResp.ok
          ? `Status ${rawResp.status} - API accessible`
          : `Status ${rawResp.status} ${rawResp.statusText} - ${await rawResp.text()}`,
      });
    } catch (err) {
      diag.push({ label: "Raw API call", status: "fail", detail: `Fetch error: ${err}` });
    }
    setResults([...diag]);

    // 6. Test via supabase-js client
    const { data: catData, error: catError } = await supabase.from("categories").select("id").limit(1);
    diag.push({
      label: "Supabase-JS categories query",
      status: catError ? "fail" : "pass",
      detail: catError
        ? `Error: ${catError.message} (code: ${catError.code}, hint: ${catError.hint || "none"}, details: ${catError.details || "none"})`
        : `OK - returned ${catData?.length ?? 0} row(s)`,
    });
    setResults([...diag]);

    // 7. Test content_types table
    const { data: ctData, error: ctError } = await supabase.from("content_types").select("id").limit(1);
    diag.push({
      label: "Supabase-JS content_types query",
      status: ctError ? "fail" : "pass",
      detail: ctError
        ? `Error: ${ctError.message} (code: ${ctError.code})`
        : `OK - returned ${ctData?.length ?? 0} row(s)`,
    });
    setResults([...diag]);

    // 8. Check profiles table for current user role
    if (userData?.user) {
      const { data: profile, error: profileError } = await supabase
        .from("profiles")
        .select("id, full_name, role, is_active")
        .eq("id", userData.user.id)
        .single();
      diag.push({
        label: "User Profile & Role",
        status: profileError
          ? "fail"
          : profile?.role === "super_admin" || profile?.role === "admin"
            ? "pass"
            : "fail",
        detail: profileError
          ? `Cannot read profile: ${profileError.message} (code: ${profileError.code})`
          : `role=${profile.role}, is_active=${profile.is_active}, name=${profile.full_name}. ${
              profile.role !== "super_admin" && profile.role !== "admin"
                ? "⚠️ Role must be 'super_admin' or 'admin' to create categories!"
                : "✓ Admin role confirmed"
            }`,
      });
    } else {
      diag.push({ label: "User Profile & Role", status: "fail", detail: "Cannot check - no authenticated user" });
    }
    setResults([...diag]);

    // 9. Test INSERT (dry run - actually insert then delete)
    diag.push({
      label: "Category INSERT test",
      status: "checking",
      detail: "Testing insert permission...",
    });
    setResults([...diag]);

    const testSlug = `_diag_test_${Date.now()}`;
    const { data: insertData, error: insertError } = await supabase
      .from("categories")
      .insert({
        name: "_diagnostic_test",
        slug: testSlug,
        description: "Diagnostic test - will be deleted",
        content_type_id: ctData?.[0]?.id ?? "00000000-0000-0000-0000-000000000000",
        is_active: false,
      })
      .select("id")
      .single();

    if (insertError) {
      diag[diag.length - 1] = {
        label: "Category INSERT test",
        status: "fail",
        detail: `INSERT FAILED: ${insertError.message} (code: ${insertError.code}, hint: ${insertError.hint || "none"}, details: ${insertError.details || "none"})`,
      };
    } else {
      // Clean up
      await supabase.from("categories").delete().eq("id", insertData.id);
      diag[diag.length - 1] = {
        label: "Category INSERT test",
        status: "pass",
        detail: "INSERT succeeded (test row cleaned up)",
      };
    }
    setResults([...diag]);

    setRunning(false);
  }

  const statusColors = {
    pass: "bg-green-100 text-green-800 border-green-200",
    fail: "bg-red-100 text-red-800 border-red-200",
    warn: "bg-amber-100 text-amber-800 border-amber-200",
    checking: "bg-blue-100 text-blue-800 border-blue-200",
  };

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Supabase Diagnostics</h1>
        <p className="mt-1 text-sm text-gray-500">
          Testing connection, auth, permissions, and RLS policies
        </p>
      </div>

      <div className="space-y-3">
        {results.map((r, i) => (
          <div key={i} className={`rounded-lg border p-4 ${statusColors[r.status]}`}>
            <div className="flex items-center gap-3">
              <span className="text-lg">
                {r.status === "pass" ? "✅" : r.status === "fail" ? "❌" : r.status === "warn" ? "⚠️" : "⏳"}
              </span>
              <div>
                <p className="font-semibold">{r.label}</p>
                <p className="text-sm font-mono break-all">{r.detail}</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      {running && (
        <div className="flex items-center gap-2 text-sm text-gray-500">
          <div className="h-4 w-4 animate-spin rounded-full border-2 border-indigo-600 border-t-transparent" />
          Running diagnostics...
        </div>
      )}

      {!running && (
        <div className="rounded-lg bg-gray-50 border border-gray-200 p-4">
          <h3 className="font-semibold text-gray-900 mb-2">Next Steps</h3>
          <div className="text-sm text-gray-600 space-y-1">
            <p>If you see ❌ on raw API or Supabase-JS queries:</p>
            <ol className="list-decimal ml-5 space-y-1">
              <li>Go to <strong>Supabase Dashboard → SQL Editor</strong></li>
              <li>Copy the contents of <code>supabase/migrations/fix_permissions.sql</code></li>
              <li>Paste and run it</li>
              <li>Come back here and refresh this page</li>
            </ol>
          </div>
          <button
            onClick={() => { setResults([]); setRunning(true); runDiagnostics(); }}
            className="mt-3 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-700"
          >
            Re-run Diagnostics
          </button>
        </div>
      )}
    </div>
  );
}
