import { getUserFromJwt } from "@/lib/appwrite/server";
import { NextResponse } from "next/server";

export const runtime = "nodejs";

const COOKIE_NAME = "ama_admin_session";
const SUPER_ADMIN_EMAIL =
  (process.env.SUPER_ADMIN_EMAIL || "").toLowerCase();
const MAX_AGE = 60 * 60 * 24 * 7;

export async function POST(request: Request) {
  try {
    const body = (await request.json()) as { jwt?: string };
    if (!body.jwt) {
      return NextResponse.json({ error: "jwt is required" }, { status: 400 });
    }

    const user = await getUserFromJwt(body.jwt);
    if (!SUPER_ADMIN_EMAIL || (user.email || "").toLowerCase() !== SUPER_ADMIN_EMAIL) {
      return NextResponse.json(
        { error: "Access denied. Only superadmin is allowed." },
        { status: 403 },
      );
    }

    const response = NextResponse.json({ ok: true });
    response.cookies.set(COOKIE_NAME, SUPER_ADMIN_EMAIL, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "lax",
      path: "/",
      maxAge: MAX_AGE,
    });

    return response;
  } catch (error) {
    return NextResponse.json(
      {
        error: error instanceof Error ? error.message : "Failed to create session",
      },
      { status: 401 },
    );
  }
}

export async function DELETE() {
  const response = NextResponse.json({ ok: true });
  response.cookies.set(COOKIE_NAME, "", {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax",
    path: "/",
    maxAge: 0,
  });
  return response;
}
