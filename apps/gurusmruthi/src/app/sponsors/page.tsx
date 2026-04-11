export default function SponsorsPage() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen px-4">
      <div className="text-center">
        <h1 className="font-malayalam text-3xl font-bold mb-4" style={{ color: 'var(--color-text)' }}>
          സ്പോൺസർമാർ
        </h1>
        <p className="text-xl mb-8" style={{ color: 'var(--color-text)', opacity: 0.7 }}>
          Coming Soon
        </p>
        <a
          href="https://abijithcb.com"
          target="_blank"
          rel="noopener noreferrer"
          className="inline-block px-4 py-2 rounded-lg transition-colors"
          style={{
            backgroundColor: 'var(--color-card-bg)',
            border: '1px solid var(--color-border)',
            color: 'var(--color-text)',
            fontSize: '12px'
          }}
        >
          Developed by abijithcb.com
        </a>
      </div>
    </div>
  );
}
