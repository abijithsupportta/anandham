export default function Loading() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-background">
      <div className="flex flex-col items-center gap-4">
        <div className="relative h-10 w-10">
          <div className="absolute inset-0 animate-spin rounded-full border-[3px] border-transparent border-t-indigo-500" />
          <div className="absolute inset-1 animate-spin rounded-full border-[3px] border-transparent border-t-indigo-400/50" style={{ animationDirection: "reverse", animationDuration: "0.8s" }} />
        </div>
        <p className="text-sm font-medium text-muted">Loading...</p>
      </div>
    </div>
  );
}
