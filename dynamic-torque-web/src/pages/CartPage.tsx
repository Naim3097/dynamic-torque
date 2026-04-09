import { Link } from 'react-router-dom';
import { useCartStore } from '@/stores/cartStore';
import { formatPrice } from '@/data/products';
import { Button } from '@/components/ui';

export function CartPage() {
  const items = useCartStore((s) => s.items);
  const updateQuantity = useCartStore((s) => s.updateQuantity);
  const removeItem = useCartStore((s) => s.removeItem);
  const subtotal = useCartStore((s) => s.subtotal());

  if (items.length === 0) {
    return (
      <div className="container-main" style={{ paddingTop: '6rem', paddingBottom: '4rem' }}>
        <h1 className="font-heading font-bold text-3xl text-white mb-3">Your Cart</h1>
        <p className="text-sm text-text-muted mb-8">No items yet.</p>
        <Link to="/catalog">
          <Button variant="primary" size="md">Browse Parts</Button>
        </Link>
      </div>
    );
  }

  return (
    <div className="container-main" style={{ paddingTop: '2.5rem', paddingBottom: '4rem' }}>
      <h1 className="font-heading font-bold text-3xl text-white mb-10">
        Your Cart
        <span className="text-lg text-text-muted font-normal ml-3">
          ({items.reduce((sum, i) => sum + i.quantity, 0)} items)
        </span>
      </h1>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-10">
        {/* Items */}
        <div className="lg:col-span-2 flex flex-col gap-3">
          {items.map((item) => (
            <div
              key={item.productId}
              className="flex items-center gap-4 bg-bg-secondary rounded-md p-5"
            >
              {/* Thumbnail */}
              <Link to={`/product/${item.slug}`} className="shrink-0">
                <div className="w-16 h-16 rounded bg-surface overflow-hidden flex items-center justify-center">
                  {item.thumbnailUrl ? (
                    <img src={item.thumbnailUrl} alt={item.name} className="w-full h-full object-cover" />
                  ) : (
                    <span className="text-text-muted/20 text-[8px] uppercase">img</span>
                  )}
                </div>
              </Link>

              {/* Info */}
              <div className="flex-1 min-w-0">
                <Link
                  to={`/product/${item.slug}`}
                  className="text-sm font-medium text-white hover:text-blue-bright transition-colors line-clamp-1"
                >
                  {item.name}
                </Link>
                <span className="text-[11px] text-text-muted/50 font-mono block mt-0.5">{item.sku}</span>
              </div>

              {/* Qty stepper */}
              <div className="inline-flex items-center h-9 rounded bg-surface border border-white/5 overflow-hidden shrink-0">
                <button
                  onClick={() => updateQuantity(item.productId, item.quantity - 1)}
                  className="w-9 h-full flex items-center justify-center text-text-muted hover:text-white hover:bg-white/5 text-sm transition-colors"
                >
                  &minus;
                </button>
                <span className="w-9 h-full flex items-center justify-center text-[13px] text-white font-medium border-x border-white/5">
                  {item.quantity}
                </span>
                <button
                  onClick={() => updateQuantity(item.productId, item.quantity + 1)}
                  className="w-9 h-full flex items-center justify-center text-text-muted hover:text-white hover:bg-white/5 text-sm transition-colors"
                >
                  +
                </button>
              </div>

              {/* Price */}
              <span className="text-sm font-medium text-white w-24 text-right shrink-0 tabular-nums">
                {formatPrice(item.unitPrice * item.quantity)}
              </span>

              {/* Remove */}
              <button
                onClick={() => removeItem(item.productId)}
                className="text-[13px] text-text-muted/50 hover:text-error transition-colors shrink-0"
              >
                Remove
              </button>
            </div>
          ))}
        </div>

        {/* Order summary */}
        <div className="lg:col-span-1">
          <div className="bg-bg-secondary rounded-md p-6 sticky top-20">
            <h2 className="font-heading font-bold text-lg text-white mb-6">Summary</h2>

            <div className="flex justify-between text-sm mb-2">
              <span className="text-text-muted">Subtotal</span>
              <span className="text-white font-medium tabular-nums">{formatPrice(subtotal)}</span>
            </div>
            <div className="flex justify-between text-sm mb-6">
              <span className="text-text-muted">Shipping</span>
              <span className="text-text-muted">Calculated at checkout</span>
            </div>

            <div className="border-t border-white/5 pt-4 mb-6">
              <div className="flex justify-between">
                <span className="text-sm font-medium text-white">Total</span>
                <span className="text-xl font-bold text-white tabular-nums">{formatPrice(subtotal)}</span>
              </div>
            </div>

            <Link to="/checkout">
              <Button variant="primary" size="lg" className="w-full">
                Checkout
              </Button>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
