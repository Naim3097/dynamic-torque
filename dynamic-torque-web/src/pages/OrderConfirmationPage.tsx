import { useParams, Link } from 'react-router-dom';
import { useOrder } from '@/hooks/useOrders';
import { usePushNotifications } from '@/hooks/usePushNotifications';
import { formatPrice } from '@/data/products';
import { Button, LoadingPulse } from '@/components/ui';

const statusLabels: Record<string, string> = {
  pending: 'Pending',
  confirmed: 'Confirmed',
  processing: 'Processing',
  shipped: 'Shipped',
  delivered: 'Delivered',
  cancelled: 'Cancelled',
};

export function OrderConfirmationPage() {
  const { id } = useParams<{ id: string }>();
  const { data: order, isLoading } = useOrder(id);
  const { permission, registering, enable } = usePushNotifications();

  if (isLoading) {
    return (
      <div className="container-main" style={{ paddingTop: '6rem' }}>
        <LoadingPulse />
      </div>
    );
  }

  if (!order) {
    return (
      <div className="container-main text-center" style={{ paddingTop: '6rem', paddingBottom: '4rem' }}>
        <p className="text-text-muted mb-4">Order not found.</p>
        <Link to="/">
          <Button variant="primary" size="md">Back to Home</Button>
        </Link>
      </div>
    );
  }

  return (
    <div className="container-main" style={{ paddingTop: '2.5rem', paddingBottom: '4rem' }}>
      <div className="max-w-2xl mx-auto">
        {/* Header */}
        <div className="text-center mb-12">
          <div className="w-14 h-14 rounded-full bg-success/10 flex items-center justify-center mx-auto mb-5">
            <svg
              width="28"
              height="28"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2.5"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="text-success"
            >
              <polyline points="20 6 9 17 4 12" />
            </svg>
          </div>
          <h1 className="font-heading font-bold text-3xl text-white mb-2">Order placed</h1>
          <p className="text-sm text-text-muted">
            Thank you for your order. We'll process it shortly.
          </p>
        </div>

        {/* Order info */}
        <div className="bg-bg-secondary rounded-md p-6 mb-8">
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-6 text-sm">
            <div>
              <span className="text-text-muted text-[13px]">Order number</span>
              <p className="text-white font-mono font-medium mt-0.5">{order.orderNumber}</p>
            </div>
            <div>
              <span className="text-text-muted text-[13px]">Status</span>
              <p className="text-white font-medium mt-0.5">{statusLabels[order.status]}</p>
            </div>
            <div>
              <span className="text-text-muted text-[13px]">Payment</span>
              <p className="text-white font-medium mt-0.5">
                {order.paymentMethod === 'bank_transfer'
                  ? 'Bank Transfer'
                  : order.paymentMethod === 'cod'
                  ? 'Cash on Delivery'
                  : 'Online'}
              </p>
            </div>
            <div>
              <span className="text-text-muted text-[13px]">Total</span>
              <p className="text-white font-bold mt-0.5">{formatPrice(order.total)}</p>
            </div>
          </div>
        </div>

        {/* Items */}
        <section className="mb-8">
          <h2 className="font-heading font-bold text-lg text-white mb-4">Items</h2>
          <div className="flex flex-col gap-2">
            {order.items.map((item) => (
              <div
                key={item.id ?? item.productId}
                className="flex justify-between text-sm py-3 border-b border-white/[0.04] last:border-0"
              >
                <div>
                  <span className="text-white">{item.productName}</span>
                  <span className="text-text-muted/50 ml-2">x{item.quantity}</span>
                </div>
                <span className="text-white font-medium tabular-nums">{formatPrice(item.total)}</span>
              </div>
            ))}
          </div>
          <div className="flex flex-col gap-1 mt-4 pt-4 border-t border-white/[0.06]">
            <div className="flex justify-between text-sm">
              <span className="text-text-muted">Subtotal</span>
              <span className="text-white tabular-nums">{formatPrice(order.subtotal)}</span>
            </div>
            {order.discount > 0 && (
              <div className="flex justify-between text-sm">
                <span className="text-text-muted">Discount</span>
                <span className="text-white tabular-nums">-{formatPrice(order.discount)}</span>
              </div>
            )}
            <div className="flex justify-between text-sm">
              <span className="text-text-muted">Shipping</span>
              <span className="text-white tabular-nums">
                {order.shippingCost === 0 ? 'Free' : formatPrice(order.shippingCost)}
              </span>
            </div>
            <div className="flex justify-between text-sm font-bold mt-2">
              <span className="text-white">Total</span>
              <span className="text-white tabular-nums">{formatPrice(order.total)}</span>
            </div>
          </div>
        </section>

        {/* Shipping */}
        <section className="mb-8">
          <h2 className="font-heading font-bold text-lg text-white mb-4">Shipping to</h2>
          <div className="text-sm text-text-muted leading-relaxed">
            <p className="text-white font-medium">{order.shipping.fullName}</p>
            {order.shipping.company && <p>{order.shipping.company}</p>}
            <p>{order.shipping.addressLine1}</p>
            {order.shipping.addressLine2 && <p>{order.shipping.addressLine2}</p>}
            <p>
              {order.shipping.city}, {order.shipping.state} {order.shipping.postalCode}
            </p>
            <p>{order.shipping.country}</p>
            <p className="mt-2">{order.shipping.phone}</p>
            <p>{order.shipping.email}</p>
          </div>
        </section>

        {order.notes && (
          <section className="mb-8">
            <h2 className="font-heading font-bold text-lg text-white mb-4">Notes</h2>
            <p className="text-sm text-text-muted">{order.notes}</p>
          </section>
        )}

        {/* Push notifications opt-in — contextual prompt after first order */}
        {permission === 'default' && (
          <section className="bg-bg-secondary rounded-md p-6 mb-8 border border-blue-mid/30">
            <h2 className="font-heading font-bold text-lg text-white mb-2">
              Get order updates
            </h2>
            <p className="text-sm text-text-muted mb-4">
              Turn on browser notifications to be alerted the moment your order is
              confirmed, shipped, or delivered.
            </p>
            <Button
              variant="primary"
              size="md"
              onClick={() => { void enable(); }}
              disabled={registering}
            >
              {registering ? 'Enabling…' : 'Enable notifications'}
            </Button>
          </section>
        )}

        {/* Bank transfer instructions */}
        {order.paymentMethod === 'bank_transfer' && (
          <section className="bg-bg-secondary rounded-md p-6 mb-8">
            <h2 className="font-heading font-bold text-lg text-white mb-4">Bank transfer details</h2>
            <div className="text-sm text-text-muted space-y-1">
              <p>
                Bank: <span className="text-white">Maybank</span>
              </p>
              <p>
                Account: <span className="text-white font-mono">5621 4820 3917</span>
              </p>
              <p>
                Name: <span className="text-white">MNA Dynamic Torque Sdn Bhd</span>
              </p>
              <p className="pt-2 text-[13px] text-text-muted/60">
                Please include your order number ({order.orderNumber}) as the payment reference.
              </p>
            </div>
          </section>
        )}

        {/* Actions */}
        <div className="flex flex-col sm:flex-row gap-3">
          <Link to="/orders">
            <Button variant="secondary" size="md">View all orders</Button>
          </Link>
          <Link to="/catalog">
            <Button variant="ghost" size="md">Continue shopping</Button>
          </Link>
        </div>
      </div>
    </div>
  );
}
