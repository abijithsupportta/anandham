import { type LucideIcon } from "lucide-react";

interface StatCardProps {
  title: string;
  value: string | number;
  change?: string;
  changeType?: "positive" | "negative" | "neutral";
  icon: LucideIcon;
  iconColor?: string;
  iconBg?: string;
}

export default function StatCard({
  title,
  value,
  change,
  changeType = "neutral",
  icon: Icon,
  iconColor = "text-indigo-600",
  iconBg = "bg-indigo-50",
}: StatCardProps) {
  const changeColors = {
    positive: "text-green-600 bg-green-50 dark:text-green-400 dark:bg-green-500/10",
    negative: "text-red-600 bg-red-50 dark:text-red-400 dark:bg-red-500/10",
    neutral: "text-gray-600 bg-gray-50 dark:text-gray-400 dark:bg-gray-500/10",
  };

  return (
    <div className="rounded-xl border border-border-main bg-card p-6 shadow-sm transition hover:shadow-md dark:hover:bg-card-hover">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm font-medium text-muted">{title}</p>
          <p className="mt-1 text-3xl font-bold text-foreground">{value}</p>
          {change && (
            <span
              className={`mt-2 inline-block rounded-full px-2 py-0.5 text-xs font-medium ${changeColors[changeType]}`}
            >
              {change}
            </span>
          )}
        </div>
        <div className={`rounded-xl p-3 ${iconBg}`}>
          <Icon className={`h-6 w-6 ${iconColor}`} />
        </div>
      </div>
    </div>
  );
}
