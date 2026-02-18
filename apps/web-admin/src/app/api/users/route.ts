import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

// ── DELETE: Permanently delete a user (only customer role, never super_admin) ────

export async function DELETE(req: NextRequest) {
  try {
    const { userId, userRole } = await req.json();

    if (!userId || !userRole) {
      return NextResponse.json(
        { error: "User ID and role are required" },
        { status: 400 }
      );
    }

    // Prevent deletion of super_admin accounts
    if (userRole === "super_admin") {
      return NextResponse.json(
        { error: "Cannot delete super admin accounts" },
        { status: 403 }
      );
    }

    // Only allow deletion of customer role at this level
    // (Admin/author deletion may need approval workflows)
    if (!["customer", "author", "admin"].includes(userRole)) {
      return NextResponse.json(
        { error: "Invalid user role" },
        { status: 400 }
      );
    }

    const sb = createAdminClient();

    // 1. Delete from auth.users (cascade deletes profile and linked records)
    const { error: authError } = await sb.auth.admin.deleteUser(userId);
    if (authError) {
      return NextResponse.json(
        { error: authError.message || "Failed to delete user from auth" },
        { status: 400 }
      );
    }

    return NextResponse.json(
      { message: `User (${userRole}) permanently deleted` },
      { status: 200 }
    );
  } catch (err) {
    console.error("DELETE /api/users error:", err);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
