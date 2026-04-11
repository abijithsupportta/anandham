export function Footer() {
  return (
    <div className="bg-white dark:bg-black backdrop-blur-sm border-t border-gray-200 dark:border-gray-800 mt-8 sm:mt-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 sm:py-6">
        <div className="flex flex-col sm:flex-row justify-between items-center gap-4">
          <div className="text-center sm:text-left">
            <p className="text-sm sm:text-base font-semibold text-gray-900 dark:text-white">
              © 2025 Gurusmruthi
            </p>
            <p className="text-xs text-gray-600 dark:text-gray-400 mt-1">
              All rights reserved
            </p>
          </div>
          <a
            href="https://abijithcb.com"
            target="_blank"
            rel="noopener noreferrer"
            className="group flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-full transition-all duration-300 hover:scale-105 hover:shadow-lg"
          >
            <span className="text-sm font-medium">Developed by</span>
            <span className="text-sm font-bold">abijithcb.com</span>
            <svg className="w-4 h-4 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
            </svg>
          </a>
        </div>
      </div>
    </div>
  );
}
