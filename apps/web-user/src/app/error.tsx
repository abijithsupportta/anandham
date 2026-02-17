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
    <div className="flex min-h-screen flex-col items-center justify-center bg-orange-50 px-4">
      <div className="max-w-md text-center">
        <h1 className="mb-4 text-6xl font-bold text-orange-600">Oops!</h1>
        <h2 className="mb-2 text-2xl font-semibold text-gray-800">
          Something went wrong
        </h2>
        <p className="mb-8 text-gray-600">
          We encountered an unexpected error. Please try again.
        </p>
        <button
          onClick={reset}
          className="rounded-lg bg-orange-500 px-6 py-3 font-medium text-white transition-colors hover:bg-orange-600 focus:outline-none focus:ring-2 focus:ring-orange-500 focus:ring-offset-2"
        >
          Try Again
        </button>
      </div>
    </div>
  );
}
