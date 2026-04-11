import type { Metadata, Viewport } from "next";
import "./globals.css";
import { ThemeProvider } from "@/components/ui/theme";
import { ThemeInitializer } from "@/components/ThemeInitializer";
import { Header } from "@/components/Header";
import { Footer } from "@/components/Footer";
import AppDownloadButton from "@/components/AppDownloadButton";
import { Noto_Sans_Malayalam, Playfair_Display, Inter } from "next/font/google";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://gurusmruthi.abijithcb.com";

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
  metadataBase: new URL(SITE_URL),
  title: {
    default: "Gurusmruthi | ശ്രീ നാരായണ ഗുരുദേവ കൃതികൾ",
    template: "%s | Gurusmruthi",
  },
  description: "ശ്രീ നാരായണ ഗുരുദേവന്റെ സമ്പൂർണ്ണ കൃതികൾ, കീർത്തനങ്ങൾ, ധർമ്മോപദേശങ്ങൾ മലയാളത്തിൽ വായിക്കുക. Complete digital collection of Sree Narayana Guru krithis, keerthanams, dharmas and teachings in Malayalam.",
  keywords: [
    "sree narayana guru",
    "ശ്രീ നാരായണ ഗുരു",
    "gurudevakrithikal",
    "ഗുരുദേവകൃതികൾ",
    "narayana guru krithis",
    "narayana guru songs",
    "narayana guru keerthanams",
    "narayana guru malayalam",
    "sree narayana guru teachings",
    "sree narayana guru dharma",
    "kerala spiritual",
    "malayalam prayers",
    "gurusmruthi",
    "ഗുരുസ്മൃതി",
    "sndp",
    "narayana guru philosophy",
    "advaita kerala",
    "ezhava saint"
  ],
  authors: [{ name: "Abijith CB", url: "https://abijithcb.com" }],
  creator: "Abijith CB",
  publisher: "Gurusmruthi",
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  openGraph: {
    type: "website",
    locale: "ml_IN",
    alternateLocale: ["en_IN"],
    url: SITE_URL,
    siteName: "Gurusmruthi",
    title: "Gurusmruthi | ശ്രീ നാരായണ ഗുരുദേവ കൃതികൾ",
    description: "ശ്രീ നാരായണ ഗുരുദേവന്റെ സമ്പൂർണ്ണ കൃതികൾ, കീർത്തനങ്ങൾ, ധർമ്മോപദേശങ്ങൾ മലയാളത്തിൽ വായിക്കുക. Complete digital collection of Sree Narayana Guru krithis, keerthanams, dharmas and teachings in Malayalam.",
    images: [{
      url: `${SITE_URL}/og-image.png`,
      width: 1200,
      height: 630,
      alt: "Gurusmruthi - ശ്രീ നാരായണ ഗുരുദേവ കൃതികൾ"
    }]
  },
  twitter: {
    card: "summary_large_image",
    title: "Gurusmruthi | ശ്രീ നാരായണ ഗുരുദേവ കൃതികൾ",
    description: "ശ്രീ നാരായണ ഗുരുദേവന്റെ സമ്പൂർണ്ണ കൃതികൾ, കീർത്തനങ്ങൾ, ധർമ്മോപദേശങ്ങൾ മലയാളത്തിൽ വായിക്കുക. Complete digital collection of Sree Narayana Guru krithis, keerthanams, dharmas and teachings in Malayalam.",
    images: [`${SITE_URL}/og-image.png`]
  },
  icons: {
    icon: "https://vksqkmtdysbzomrhlcqv.supabase.co/storage/v1/object/public/guru/gurusmruthi.png",
    shortcut: "https://vksqkmtdysbzomrhlcqv.supabase.co/storage/v1/object/public/guru/gurusmruthi.png",
    apple: "https://vksqkmtdysbzomrhlcqv.supabase.co/storage/v1/object/public/guru/gurusmruthi.png",
  },
  alternates: {
    canonical: SITE_URL,
    languages: {
      "ml": SITE_URL,
      "en": SITE_URL,
      "x-default": SITE_URL
    }
  }
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
  themeColor: "#C9A84C",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ml" suppressHydrationWarning className={`light ${notoSansMalayalam.variable} ${playfairDisplay.variable} ${inter.variable}`} style={{ fontFamily: 'var(--font-body)' }}>
      <head>
        <meta name="google-site-verification" content="LEAVE_BLANK_FOR_NOW" />
        <meta name="application-name" content="Gurusmruthi" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
        <meta name="apple-mobile-web-app-title" content="Gurusmruthi" />
        <meta name="mobile-web-app-capable" content="yes" />
        <link rel="manifest" href="/manifest.json" />
      </head>
      <body>
        <ThemeInitializer />
        <ThemeProvider>
          <div id="app-shell">
            <Header />
            <main className="app-content">
              {children}
            </main>
          </div>
          <AppDownloadButton />
        </ThemeProvider>
      </body>
    </html>
  );
}
