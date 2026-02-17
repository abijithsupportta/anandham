import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

// ── Types ────────────────────────────────────────────────────

interface CreateAuthorBody {
  name: string;
  email: string;
  password: string;
  phone?: string;
  address?: string;
  bio?: string;
  photo_url?: string;
  content_type_ids?: string[];
}

interface UpdateAuthorBody {
  id: string;
  name: string;
  phone?: string;
  address?: string;
  bio?: string;
  photo_url?: string;
  is_verified?: boolean;
  is_active?: boolean;
  password?: string; // optional reset
  content_type_ids?: string[];
}

// ── POST: Create new author ──────────────────────────────────

export async function POST(req: NextRequest) {
  try {
    const body: CreateAuthorBody = await req.json();

    if (!body.name?.trim() || !body.email?.trim() || !body.password?.trim()) {
      return NextResponse.json(
        { error: "Name, email, and password are required" },
        { status: 400 }
      );
    }

    if (body.password.length < 6) {
      return NextResponse.json(
        { error: "Password must be at least 6 characters" },
        { status: 400 }
      );
    }

    const sb = createAdminClient();

    // 1. Create auth user (trigger auto-creates profile with role='author')
    const { data: authData, error: authError } = await sb.auth.admin.createUser({
      email: body.email,
      password: body.password,
      email_confirm: true, // skip email verification — admin-created
      user_metadata: {
        full_name: body.name,
        role: "author",
      },
    });

    if (authError) {
      return NextResponse.json(
        { error: authError.message },
        { status: 400 }
      );
    }

    const userId = authData.user.id;

    // 2. Update profile name (trigger may have set it, but ensure it's correct)
    await sb
      .from("profiles")
      .update({ full_name: body.name, role: "author" })
      .eq("id", userId);

    // 3. Create author record linked to the auth user
    const { data: author, error: authorError } = await sb
      .from("authors")
      .insert({
        user_id: userId,
        name: body.name,
        email: body.email,
        phone: body.phone || "",
        address: body.address || "",
        bio: body.bio || "",
        photo_url: body.photo_url || null,
        is_verified: true,
        is_active: true,
      })
      .select()
      .single();

    if (authorError) {
      // Rollback: delete the auth user we just created
      await sb.auth.admin.deleteUser(userId);
      return NextResponse.json(
        { error: authorError.message },
        { status: 400 }
      );
    }

    // 4. Create content type assignments
    if (body.content_type_ids && body.content_type_ids.length > 0) {
      const assignments = body.content_type_ids.map((ctId) => ({
        user_id: userId,
        content_type_id: ctId,
        can_create: true,
        can_edit: true,
        can_delete: false,
      }));

      const { error: assignError } = await sb
        .from("author_assignments")
        .insert(assignments);

      if (assignError) {
        console.error("Failed to save assignments:", assignError);
      }
    }

    return NextResponse.json({ data: author });
  } catch (err) {
    console.error("POST /api/authors error:", err);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}

// ── PUT: Update existing author ──────────────────────────────

export async function PUT(req: NextRequest) {
  try {
    const body: UpdateAuthorBody = await req.json();

    if (!body.id || !body.name?.trim()) {
      return NextResponse.json(
        { error: "ID and name are required" },
        { status: 400 }
      );
    }

    const sb = createAdminClient();

    // 1. Get the author to find user_id
    const { data: existing, error: fetchError } = await sb
      .from("authors")
      .select("user_id")
      .eq("id", body.id)
      .single();

    if (fetchError || !existing) {
      return NextResponse.json(
        { error: "Author not found" },
        { status: 404 }
      );
    }

    // 2. Update author record
    const { data: author, error: updateError } = await sb
      .from("authors")
      .update({
        name: body.name,
        phone: body.phone || "",
        address: body.address || "",
        bio: body.bio || "",
        photo_url: body.photo_url ?? null,
        is_verified: body.is_verified ?? true,
        is_active: body.is_active ?? true,
      })
      .eq("id", body.id)
      .select()
      .single();

    if (updateError) {
      return NextResponse.json(
        { error: updateError.message },
        { status: 400 }
      );
    }

    // 3. Update profile name
    if (existing.user_id) {
      await sb
        .from("profiles")
        .update({ full_name: body.name })
        .eq("id", existing.user_id);

      // 4. Reset password if provided
      if (body.password && body.password.length >= 6) {
        const { error: pwError } = await sb.auth.admin.updateUserById(
          existing.user_id,
          { password: body.password }
        );
        if (pwError) {
          console.error("Failed to update password:", pwError);
        }
      }

      // 5. Sync content type assignments
      if (body.content_type_ids !== undefined) {
        // Delete all existing
        await sb
          .from("author_assignments")
          .delete()
          .eq("user_id", existing.user_id);

        // Insert new
        if (body.content_type_ids.length > 0) {
          const assignments = body.content_type_ids.map((ctId) => ({
            user_id: existing.user_id,
            content_type_id: ctId,
            can_create: true,
            can_edit: true,
            can_delete: false,
          }));

          const { error: assignError } = await sb
            .from("author_assignments")
            .insert(assignments);

          if (assignError) {
            console.error("Failed to save assignments:", assignError);
          }
        }
      }
    }

    return NextResponse.json({ data: author });
  } catch (err) {
    console.error("PUT /api/authors error:", err);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
