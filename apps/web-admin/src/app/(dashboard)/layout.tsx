"use client";

import Sidebar from "@/components/layout/Sidebar";
import Header from "@/components/layout/Header";
import Footer from "@/components/layout/Footer";
import { AuthProvider } from "@/components/providers/auth-provider";
import { ToastProvider } from "@/hooks/useToast";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <AuthProvider>
      <ToastProvider>
        <div className="min-h-screen bg-gray-50">
          <Sidebar />
          <div className="lg:pl-64">
            <Header />
            <main className="p-6">{children}</main>
            <Footer />
          </div>
        </div>
      </ToastProvider>
    </AuthProvider>
  );
}
