"use client";

import { useEffect } from "react";

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error("Application error:", error);
  }, [error]);

  return (
    <div className="flex min-h-screen flex-col items-center justify-center bg-gray-900 px-4">
      <div className="max-w-md text-center">
        <h1 className="mb-4 text-6xl font-bold text-red-500">Error</h1>
        <h2 className="mb-2 text-2xl font-semibold text-gray-200">
          System Error Encountered
        </h2>
        <p className="mb-8 text-gray-400">
          An unexpected error occurred in the admin panel. Please try again or
          contact the system administrator.
        </p>
        <button
          onClick={reset}
          className="rounded-lg bg-emerald-600 px-6 py-3 font-medium text-white transition-colors hover:bg-emerald-700 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:ring-offset-2 focus:ring-offset-gray-900"
        >
          Retry
        </button>
      </div>
    </div>
  );
}
