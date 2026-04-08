import type { ButtonHTMLAttributes, ReactNode } from 'react';

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'ghost' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  children: ReactNode;
}

const paddings: Record<string, React.CSSProperties> = {
  sm: { paddingLeft: '1rem', paddingRight: '1rem' },
  md: { paddingLeft: '1.5rem', paddingRight: '1.5rem' },
  lg: { paddingLeft: '2rem', paddingRight: '2rem' },
};

export function Button({
  variant = 'primary',
  size = 'md',
  children,
  className = '',
  style,
  ...props
}: ButtonProps) {
  const base =
    'inline-flex items-center justify-center font-semibold tracking-wide transition-all duration-200 cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed select-none';

  const variants: Record<string, string> = {
    primary:
      'bg-blue-bright text-white rounded-md hover:bg-[#3399E0] active:bg-[#2480C0] shadow-[0_1px_2px_rgba(0,0,0,0.2)]',
    secondary:
      'bg-surface text-text-muted rounded-md hover:text-white hover:bg-[#1C3A58] active:bg-surface',
    ghost:
      'bg-transparent text-text-muted rounded-md hover:text-white hover:bg-white/5',
    danger:
      'bg-red-accent text-white rounded-md hover:bg-red-hover active:bg-[#991C1C]',
  };

  const sizes: Record<string, string> = {
    sm: 'h-9 text-[13px]',
    md: 'h-11 text-sm',
    lg: 'h-12 text-[15px]',
  };

  return (
    <button
      className={`${base} ${variants[variant]} ${sizes[size]} ${className}`}
      style={{ ...paddings[size], ...style }}
      {...props}
    >
      {children}
    </button>
  );
}
