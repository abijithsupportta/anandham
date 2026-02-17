interface StatusBadgeProps {
  status: string;
  size?: "sm" | "md";
}

const statusStyles: Record<string, string> = {
  // Generic
  active: "bg-green-50 text-green-700 ring-green-600/20",
  inactive: "bg-gray-50 text-gray-600 ring-gray-500/20",
  pending: "bg-yellow-50 text-yellow-700 ring-yellow-600/20",
  suspended: "bg-red-50 text-red-700 ring-red-600/20",

  // Content
  draft: "bg-gray-50 text-gray-600 ring-gray-500/20",
  published: "bg-green-50 text-green-700 ring-green-600/20",
  rejected: "bg-red-50 text-red-700 ring-red-600/20",
  archived: "bg-purple-50 text-purple-700 ring-purple-600/20",

  // Authors
  approved: "bg-green-50 text-green-700 ring-green-600/20",

  // Reports
  reviewing: "bg-blue-50 text-blue-700 ring-blue-600/20",
  resolved: "bg-green-50 text-green-700 ring-green-600/20",
  dismissed: "bg-gray-50 text-gray-600 ring-gray-500/20",

  // Users
  verified: "bg-green-50 text-green-700 ring-green-600/20",
  unverified: "bg-yellow-50 text-yellow-700 ring-yellow-600/20",
};

export default function StatusBadge({ status, size = "sm" }: StatusBadgeProps) {
  const key = status.toLowerCase().replace(/_/g, "");
  const style = statusStyles[key] || "bg-gray-50 text-gray-600 ring-gray-500/20";
  const sizeClasses = size === "sm" ? "px-2 py-0.5 text-xs" : "px-2.5 py-1 text-sm";

  return (
    <span
      className={`inline-flex items-center rounded-full font-medium ring-1 ring-inset ${style} ${sizeClasses}`}
    >
      {status.charAt(0).toUpperCase() + status.slice(1).toLowerCase().replace(/_/g, " ")}
    </span>
  );
}
