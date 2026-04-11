import type { Metadata } from "next";
import "./globals.css";
import { ThemeProvider } from "@/components/ui/theme";
import { ThemeInitializer } from "@/components/ThemeInitializer";
import { Header } from "@/components/Header";
import { Footer } from "@/components/Footer";
import { Noto_Sans_Malayalam, Playfair_Display, Inter } from "next/font/google";

const notoSansMalayalam = Noto_Sans_Malayalam({
  subsets: ["malayalam"],
  variable: "--font-malayalam",
  display: "swap",
});

const playfairDisplay = Playfair_Display({
  subsets: ["latin"],
  variable: "--font-heading",
  display: "swap",
});

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-body",
  display: "swap",
});

export const metadata: Metadata = {
  title: "Gurusmruthi - Anandham",
  description: "Gurusmruthi frontend website powered by Anandham",
  icons: {
    icon: "https://vksqkmtdysbzomrhlcqv.supabase.co/storage/v1/object/public/guru/gurusmruthi.png",
    shortcut: "https://vksqkmtdysbzomrhlcqv.supabase.co/storage/v1/object/public/guru/gurusmruthi.png",
    apple: "https://vksqkmtdysbzomrhlcqv.supabase.co/storage/v1/object/public/guru/gurusmruthi.png",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning className={`light ${notoSansMalayalam.variable} ${playfairDisplay.variable} ${inter.variable}`} style={{ fontFamily: 'var(--font-body)' }}>
      <body>
        <ThemeInitializer />
        <ThemeProvider>
          <Header />
          <main className="min-h-screen">
            {children}
          </main>
          <Footer />
        </ThemeProvider>
      </body>
    </html>
  );
}
