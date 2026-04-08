import type { ReactNode, HTMLAttributes } from 'react';

interface CardProps extends HTMLAttributes<HTMLDivElement> {
  children: ReactNode;
  hover?: boolean;
}

export function Card({ children, hover = true, className = '', ...props }: CardProps) {
  return (
    <div
      className={`bg-bg-secondary rounded-[10px] transition-all duration-150 ${
        hover ? 'hover:bg-[#17375A] hover:shadow-[0_8px_24px_rgba(0,0,0,0.25)]' : ''
      } ${className}`}
      {...props}
    >
      {children}
    </div>
  );
}
