interface EmptyStateProps {
  message?: string;
  colSpan?: number;
  /** Render as a <tr> for use inside tables */
  asTableRow?: boolean;
}

export default function EmptyState({
  message = "No data found",
  colSpan = 4,
  asTableRow = false,
}: EmptyStateProps) {
  if (asTableRow) {
    return (
      <tr>
        <td colSpan={colSpan} className="py-12 text-center text-sm text-muted">
          {message}
        </td>
      </tr>
    );
  }

  return (
    <div className="py-12 text-center text-sm text-muted">
      {message}
    </div>
  );
}
