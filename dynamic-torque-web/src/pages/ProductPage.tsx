import { useParams, Link } from 'react-router-dom';
import { getProductBySlug, formatPrice, getProductsByCategory } from '@/data/products';
import { StatusText, Button } from '@/components/ui';
import { ProductGrid } from '@/components/product/ProductGrid';
import { useCartStore } from '@/stores/cartStore';
import { useState } from 'react';

export function ProductPage() {
  const { slug } = useParams<{ slug: string }>();
  const product = getProductBySlug(slug || '');
  const addItem = useCartStore(s => s.addItem);
  const [qty, setQty] = useState(1);

  if (!product) {
    return (
      <div className="container-main text-center" style={{ paddingTop: '6rem', paddingBottom: '4rem' }}>
        <p className="text-text-muted mb-4">Product not found.</p>
        <Link to="/catalog" className="text-sm text-blue-bright hover:text-white transition-colors">
          &larr; Back to all parts
        </Link>
      </div>
    );
  }

  const related = getProductsByCategory(product.category)
    .filter(p => p.id !== product.id)
    .slice(0, 4);

  const specEntries = Object.entries(product.specifications);

  return (
    <div className="container-main" style={{ paddingTop: '2.5rem', paddingBottom: '4rem' }}>
      {/* Breadcrumb */}
      <nav className="flex items-center gap-1.5 text-[13px] mb-10">
        <Link to="/catalog" className="text-text-muted hover:text-white transition-colors">All Parts</Link>
        <span className="text-text-muted/40">/</span>
        <Link
          to={`/category/${product.category}`}
          className="text-text-muted hover:text-white transition-colors"
        >
          {product.category.replace('_', ' ').replace(/\b\w/g, c => c.toUpperCase())}
        </Link>
        <span className="text-text-muted/40">/</span>
        <span className="text-white truncate">{product.name}</span>
      </nav>

      {/* Product layout */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-10 lg:gap-16">
        {/* Image */}
        <div className="aspect-[4/3] bg-surface rounded-md overflow-hidden flex items-center justify-center">
          {product.thumbnailUrl ? (
            <img src={product.thumbnailUrl} alt={product.name} className="w-full h-full object-cover" />
          ) : (
            <span className="text-text-muted/20 text-xs uppercase tracking-wider select-none">
              {product.category.replace('_', ' ')}
            </span>
          )}
        </div>

        {/* Details */}
        <div className="flex flex-col">
          <h1 className="font-heading font-bold text-2xl sm:text-3xl text-white leading-tight">
            {product.name}
          </h1>
          <span className="text-[13px] text-text-muted/50 font-mono mt-2">{product.sku}</span>

          <div className="mt-5">
            {product.stockStatus === 'out_of_stock' ? (
              <StatusText status="out_of_stock" className="text-sm" />
            ) : (
              <div className="flex items-baseline gap-3">
                <span className="text-3xl font-bold text-white tracking-tight">
                  {formatPrice(product.price, product.currency)}
                </span>
                <StatusText status={product.stockStatus} />
              </div>
            )}
          </div>

          {product.wholesalePrice && (
            <p className="text-[13px] text-text-muted mt-2">
              Wholesale from {formatPrice(product.wholesalePrice, product.currency)} (min {product.minWholesaleQty} units)
            </p>
          )}

          <p className="text-sm text-text-muted leading-relaxed mt-5">
            {product.description}
          </p>

          {/* Add to cart */}
          {product.stockStatus !== 'out_of_stock' && (
            <div className="flex items-center gap-3 mt-8">
              <div className="inline-flex items-center h-11 bg-surface rounded-md overflow-hidden border border-white/5">
                <button
                  onClick={() => setQty(Math.max(1, qty - 1))}
                  className="w-11 h-full flex items-center justify-center text-text-muted hover:text-white hover:bg-white/5 transition-colors"
                >
                  &minus;
                </button>
                <span className="w-11 h-full flex items-center justify-center text-sm text-white font-medium border-x border-white/5">
                  {qty}
                </span>
                <button
                  onClick={() => setQty(qty + 1)}
                  className="w-11 h-full flex items-center justify-center text-text-muted hover:text-white hover:bg-white/5 transition-colors"
                >
                  +
                </button>
              </div>
              <Button
                variant="primary"
                size="md"
                onClick={() => addItem(product.id, product.price, qty)}
              >
                Add to Cart
              </Button>
            </div>
          )}

          {/* Compatibility */}
          {(product.compatibleVehicles.length > 0 || product.compatibleGearboxes.length > 0) && (
            <div className="mt-8 pt-8 border-t border-white/[0.06] space-y-5">
              {product.compatibleVehicles.length > 0 && (
                <div>
                  <span className="text-[13px] font-medium text-text-muted">Fits</span>
                  <p className="text-sm text-white mt-0.5">{product.compatibleVehicles.join(', ')}</p>
                </div>
              )}
              {product.compatibleGearboxes.length > 0 && (
                <div>
                  <span className="text-[13px] font-medium text-text-muted">Gearbox</span>
                  <p className="text-sm text-white mt-0.5">{product.compatibleGearboxes.join(', ')}</p>
                </div>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Specs */}
      {specEntries.length > 0 && (
        <section style={{ marginTop: '4rem' }}>
          <h2 className="font-heading font-bold text-xl text-white mb-6">Specifications</h2>
          <div className="max-w-lg rounded-md overflow-hidden border border-white/[0.06]">
            {specEntries.map(([key, value], i) => (
              <div
                key={key}
                className={`flex justify-between py-3.5 px-6 text-sm ${
                  i % 2 === 0 ? 'bg-surface/50' : 'bg-transparent'
                }`}
              >
                <span className="text-text-muted capitalize">{key}</span>
                <span className="text-white font-medium">{value}</span>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* Related */}
      {related.length > 0 && (
        <section style={{ marginTop: '4rem' }}>
          <h2 className="font-heading font-bold text-xl text-white mb-8">Related Parts</h2>
          <ProductGrid products={related} />
        </section>
      )}
    </div>
  );
}
