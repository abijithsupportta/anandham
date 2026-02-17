import * as React from 'react';

export interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  variant?: 'default' | 'bordered' | 'elevated';
  padding?: 'none' | 'sm' | 'md' | 'lg';
  header?: React.ReactNode;
  footer?: React.ReactNode;
}

export const Card = React.forwardRef<HTMLDivElement, CardProps>(
  ({ variant = 'default', padding = 'md', header, footer, children, className = '', ...props }, ref) => {
    const variantStyles: Record<string, string> = {
      default: 'bg-white rounded-xl',
      bordered: 'bg-white rounded-xl border border-gray-200',
      elevated: 'bg-white rounded-xl shadow-lg',
    };

    const paddingStyles: Record<string, string> = {
      none: '',
      sm: 'p-3',
      md: 'p-5',
      lg: 'p-8',
    };

    return (
      <div ref={ref} className={`${variantStyles[variant]} ${className}`} {...props}>
        {header && (
          <div className="px-5 py-4 border-b border-gray-100 font-semibold text-gray-900">
            {header}
          </div>
        )}
        <div className={paddingStyles[padding]}>{children}</div>
        {footer && (
          <div className="px-5 py-4 border-t border-gray-100 bg-gray-50 rounded-b-xl">
            {footer}
          </div>
        )}
      </div>
    );
  },
);

Card.displayName = 'Card';
