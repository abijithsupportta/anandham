import { ReactNode } from 'react';
import { Header } from './Header';
import { Footer } from './Footer';

export function MainLayout({ children }: { children: ReactNode }) {
  return (
    <div className="min-h-screen bg-white dark:bg-black">
      <Header />
      {children}
      <Footer />
    </div>
  );
}
