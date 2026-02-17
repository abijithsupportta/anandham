import Link from "next/link";

export default function Footer() {
  return (
    <footer className="border-t border-slate-200 bg-slate-50">
      <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
        <div className="flex flex-col items-center justify-between gap-4 md:flex-row">
          <div className="flex items-center gap-6">
            <span className="text-sm font-semibold text-indigo-600">
              Anandham Author Portal
            </span>
            <nav className="flex gap-4">
              <Link
                href="/help"
                className="text-sm text-slate-500 hover:text-indigo-600"
              >
                Help
              </Link>
              <Link
                href="/guidelines"
                className="text-sm text-slate-500 hover:text-indigo-600"
              >
                Content Guidelines
              </Link>
              <Link
                href="/support"
                className="text-sm text-slate-500 hover:text-indigo-600"
              >
                Support
              </Link>
            </nav>
          </div>
          <p className="text-sm text-slate-400">
            © {new Date().getFullYear()} Anandham. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}
