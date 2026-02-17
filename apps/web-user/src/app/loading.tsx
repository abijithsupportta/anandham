export default function Loading() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-orange-50">
      <div className="flex flex-col items-center gap-4">
        <div className="h-12 w-12 animate-spin rounded-full border-4 border-orange-200 border-t-orange-500" />
        <p className="text-lg font-medium text-orange-700">Loading...</p>
      </div>
    </div>
  );
}
