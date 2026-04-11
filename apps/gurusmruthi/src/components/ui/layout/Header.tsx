import Link from 'next/link';
import { ThemeToggle } from '@/components/ui/theme';

export function Header() {
  return (
    <div className="bg-white dark:bg-black backdrop-blur-sm border-b border-gray-200 dark:border-gray-800">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 sm:py-6">
        <div className="flex flex-col sm:flex-row justify-between items-center gap-4">
          <div className="flex items-center gap-3 sm:gap-4 w-full sm:w-auto justify-center sm:justify-start">
            <img
              src="https://vksqkmtdysbzomrhlcqv.supabase.co/storage/v1/object/public/guru/gurusmruthi.png"
              alt="Gurusmruthi"
              className="w-12 h-12 sm:w-14 sm:h-14 md:w-16 md:h-16 rounded-full object-contain"
            />
            <div className="text-center sm:text-left">
              <Link href="/" className="text-xl sm:text-2xl md:text-3xl lg:text-4xl font-bold text-black dark:text-white block">
                Gurusmruthi
              </Link>
              <p className="text-xs sm:text-sm text-gray-700 dark:text-gray-300">
                ശ്രീ നാരായണ ഗുരുദേവകൃതികൾ
              </p>
            </div>
          </div>
          <ThemeToggle />
        </div>
      </div>
    </div>
  );
}
