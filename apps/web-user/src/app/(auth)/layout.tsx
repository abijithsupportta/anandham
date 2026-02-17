export default function AuthLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-orange-50 to-amber-50">
      <div className="w-full max-w-md px-4">
        <div className="mb-8 text-center">
          <h1 className="text-3xl font-bold text-orange-600">Anandham</h1>
          <p className="mt-2 text-gray-600">Welcome back</p>
        </div>
        {children}
      </div>
    </div>
  );
}
