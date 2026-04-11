import Link from "next/link";

export function Footer() {
  return (
    <footer className="w-full py-8">
      {/* Top border with gold accent */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="h-px mb-8" style={{ backgroundColor: 'var(--color-gold)', opacity: 0.2 }} />
        
        {/* Centered content */}
        <div className="text-center">
          <Link
            href="https://abijithcb.com"
            target="_blank"
            rel="noopener noreferrer"
            className="text-sm inline-block transition-colors hover:opacity-80"
            style={{ color: 'var(--color-text)', opacity: 0.6 }}
          >
            Developed by abijithcb.com
          </Link>
        </div>
      </div>
    </footer>
  );
}
