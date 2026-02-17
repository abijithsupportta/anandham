export default function Footer() {
  return (
    <footer className="border-t border-border-light bg-surface px-6 py-4">
      <div className="flex flex-col items-center justify-between gap-2 sm:flex-row">
        <p className="text-xs text-muted">
          &copy; {new Date().getFullYear()} Anandham Management Admin. All rights reserved.
        </p>
        <div className="flex items-center gap-4">
          <span className="text-xs text-muted">v1.0.0</span>
          <span className="h-1.5 w-1.5 rounded-full bg-green-500" title="System Online" />
          <span className="text-xs text-muted">Online</span>
        </div>
      </div>
    </footer>
  );
}
