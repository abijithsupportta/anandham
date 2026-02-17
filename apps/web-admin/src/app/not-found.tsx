import Link from "next/link";

export default function NotFound() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center bg-gray-900 px-4">
      <div className="max-w-md text-center">
        <h1 className="mb-4 text-8xl font-bold text-emerald-500">404</h1>
        <h2 className="mb-2 text-2xl font-semibold text-gray-200">
          Page Not Found
        </h2>
        <p className="mb-8 text-gray-400">
          The admin page you&apos;re looking for doesn&apos;t exist or you may
          not have permission to access it.
        </p>
        <Link
          href="/"
          className="inline-block rounded-lg bg-emerald-600 px-6 py-3 font-medium text-white transition-colors hover:bg-emerald-700 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:ring-offset-2 focus:ring-offset-gray-900"
        >
          Back to Dashboard
        </Link>
      </div>
    </div>
  );
}
