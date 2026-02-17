import * as React from 'react';

export interface AvatarProps extends React.HTMLAttributes<HTMLDivElement> {
  src?: string;
  alt?: string;
  name?: string;
  size?: 'sm' | 'md' | 'lg' | 'xl';
}

export const Avatar = React.forwardRef<HTMLDivElement, AvatarProps>(
  ({ src, alt, name, size = 'md', className = '', ...props }, ref) => {
    const sizeStyles: Record<string, string> = {
      sm: 'w-8 h-8 text-xs',
      md: 'w-10 h-10 text-sm',
      lg: 'w-14 h-14 text-base',
      xl: 'w-20 h-20 text-xl',
    };

    const getInitials = (name?: string) => {
      if (!name) return '?';
      return name
        .split(' ')
        .map((word) => word[0])
        .join('')
        .toUpperCase()
        .slice(0, 2);
    };

    const colors = [
      'bg-blue-500',
      'bg-green-500',
      'bg-yellow-500',
      'bg-purple-500',
      'bg-pink-500',
      'bg-indigo-500',
      'bg-red-500',
      'bg-teal-500',
    ];

    const getColorFromName = (name?: string) => {
      if (!name) return colors[0];
      const index = name.charCodeAt(0) % colors.length;
      return colors[index];
    };

    return (
      <div
        ref={ref}
        className={`relative inline-flex items-center justify-center rounded-full overflow-hidden ${sizeStyles[size]} ${className}`}
        {...props}
      >
        {src ? (
          <img src={src} alt={alt || name || 'Avatar'} className="w-full h-full object-cover" />
        ) : (
          <div
            className={`w-full h-full flex items-center justify-center text-white font-semibold ${getColorFromName(name)}`}
          >
            {getInitials(name)}
          </div>
        )}
      </div>
    );
  },
);

Avatar.displayName = 'Avatar';
