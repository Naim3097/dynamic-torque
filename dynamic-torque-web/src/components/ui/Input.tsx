import type { InputHTMLAttributes } from 'react';

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
}

export function Input({ label, className = '', id, ...props }: InputProps) {
  const inputId = id || label?.toLowerCase().replace(/\s+/g, '-');

  return (
    <div className="flex flex-col gap-2">
      {label && (
        <label htmlFor={inputId} className="text-[13px] font-medium text-text-muted">
          {label}
        </label>
      )}
      <input
        id={inputId}
        className={`h-11 rounded-md bg-surface px-4 text-sm text-white placeholder:text-text-muted/40 border border-white/5 focus:border-blue-bright/50 focus:outline-none transition-colors duration-200 ${className}`}
        {...props}
      />
    </div>
  );
}
