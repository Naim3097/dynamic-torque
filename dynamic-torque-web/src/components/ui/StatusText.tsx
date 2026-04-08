import type { StockStatus } from '@/types/product';

interface StatusTextProps {
  status: StockStatus;
  className?: string;
}

const config: Record<StockStatus, { label: string; color: string }> = {
  in_stock: { label: 'Available', color: 'text-success' },
  low_stock: { label: 'Limited stock', color: 'text-warning' },
  out_of_stock: { label: 'Out of stock', color: 'text-error' },
};

export function StatusText({ status, className = '' }: StatusTextProps) {
  const { label, color } = config[status];
  return <span className={`text-xs ${color} ${className}`}>{label}</span>;
}
