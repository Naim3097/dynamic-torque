import { Link } from 'react-router-dom';
import { StatusText } from '@/components/ui';
import { formatPrice } from '@/data/products';
import type { Product } from '@/types/product';

interface ProductCardProps {
  product: Product;
}

export function ProductCard({ product }: ProductCardProps) {
  return (
    <Link to={`/product/${product.slug}`} className="block group">
      <div className="bg-bg-secondary rounded-lg overflow-hidden transition-all duration-200 hover:bg-[#17375A] hover:shadow-[0_8px_32px_rgba(0,0,0,0.3)] hover:-translate-y-0.5">
        {/* Image area */}
        <div className="aspect-[4/3] bg-surface flex items-center justify-center overflow-hidden">
          {product.thumbnailUrl ? (
            <img
              src={product.thumbnailUrl}
              alt={product.name}
              className="w-full h-full object-cover transition-transform duration-300 group-hover:scale-[1.03]"
            />
          ) : (
            <div className="text-text-muted/20 text-[11px] uppercase tracking-[0.15em] select-none">
              {product.category.replace('_', ' ')}
            </div>
          )}
        </div>

        {/* Text area */}
        <div className="p-6 flex flex-col gap-2.5">
          <h3 className="font-heading font-semibold text-[17px] text-white leading-snug">
            {product.name}
          </h3>
          <span className="text-[11px] text-text-muted/60 font-mono">{product.sku}</span>
          <div className="flex items-baseline gap-2 mt-1">
            {product.stockStatus === 'out_of_stock' ? (
              <StatusText status="out_of_stock" className="text-sm" />
            ) : (
              <>
                <span className="text-xl font-semibold text-white">
                  {formatPrice(product.price, product.currency)}
                </span>
                <StatusText status={product.stockStatus} />
              </>
            )}
          </div>
        </div>
      </div>
    </Link>
  );
}
