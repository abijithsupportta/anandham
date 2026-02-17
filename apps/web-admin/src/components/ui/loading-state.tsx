import { ListPageSkeleton } from "./page-skeleton";

interface LoadingStateProps {
  message?: string;
  variant?: "list" | "spinner";
}

export default function LoadingState({ variant = "list" }: LoadingStateProps) {
  if (variant === "list") {
    return <ListPageSkeleton />;
  }

  return (
    <div className="flex items-center justify-center py-24">
      <div className="relative h-8 w-8">
        <div className="absolute inset-0 animate-spin rounded-full border-[3px] border-transparent border-t-indigo-500" />
        <div
          className="absolute inset-1 animate-spin rounded-full border-[3px] border-transparent border-t-indigo-400/50"
          style={{ animationDirection: "reverse", animationDuration: "0.8s" }}
        />
      </div>
    </div>
  );
}
