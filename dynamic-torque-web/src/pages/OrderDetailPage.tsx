import { useParams, Link } from 'react-router-dom';
import { useOrder } from '@/hooks/useOrders';
import { formatPrice } from '@/data/products';
import { Button, LoadingPulse } from '@/components/ui';
import type { OrderStatus } from '@/types/order';

const statusLabels: Record<OrderStatus, string> = {
  pending: 'Pending',
  confirmed: 'Confirmed',
  processing: 'Processing',
  shipped: 'Shipped',
  delivered: 'Delivered',
  cancelled: 'Cancelled',
};

const statusColors: Record<OrderStatus, string> = {
  pending: 'text-warning',
  confirmed: 'text-blue-bright',
  processing: 'text-blue-bright',
  shipped: 'text-blue-light',
  delivered: 'text-success',
  cancelled: 'text-error',
};

const steps: OrderStatus[] = ['pending', 'confirmed', 'processing', 'shipped', 'delivered'];

export function OrderDetailPage() {
  const { id } = useParams<{ id: string }>();
  const { data: order, isLoading } = useOrder(id);

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
        <Link to="/orders">
          <Button variant="primary" size="md">View all orders</Button>
        </Link>
      </div>
    );
  }

  const currentStep = order.status === 'cancelled' ? -1 : steps.indexOf(order.status);

  return (
    <div className="container-main" style={{ paddingTop: '2.5rem', paddingBottom: '4rem' }}>
      <nav className="flex items-center gap-1.5 text-[13px] mb-8">
        <Link to="/orders" className="text-text-muted hover:text-white transition-colors">Orders</Link>
        <span className="text-text-muted/40">/</span>
        <span className="text-white">{order.orderNumber}</span>
      </nav>

      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-10">
        <div>
          <h1 className="font-heading font-bold text-3xl text-white">{order.orderNumber}</h1>
          <p className="text-sm text-text-muted mt-1">
            Placed{' '}
            {new Date(order.createdAt).toLocaleDateString('en-MY', {
              day: 'numeric',
              month: 'long',
              year: 'numeric',
              hour: '2-digit',
              minute: '2-digit',
            })}
          </p>
        </div>
        <span className={`text-sm font-semibold ${statusColors[order.status]}`}>
          {statusLabels[order.status]}
        </span>
      </div>

      {/* Progress tracker */}
      {order.status !== 'cancelled' && (
        <div className="mb-12">
          <div className="flex items-center gap-0 overflow-x-auto">
            {steps.map((step, i) => {
              const completed = i <= currentStep;
              const isLast = i === steps.length - 1;
              return (
                <div key={step} className="flex items-center shrink-0">
                  <div className="flex flex-col items-center">
                    <div
                      className={`w-8 h-8 rounded-full flex items-center justify-center text-[11px] font-bold ${
                        completed ? 'bg-blue-bright text-white' : 'bg-surface text-text-muted/50'
                      }`}
                    >
                      {i + 1}
                    </div>
                    <span className={`text-[11px] mt-1.5 ${completed ? 'text-white' : 'text-text-muted/50'}`}>
                      {statusLabels[step]}
                    </span>
                  </div>
                  {!isLast && (
                    <div className={`w-8 sm:w-16 h-px mx-1 ${i < currentStep ? 'bg-blue-bright' : 'bg-white/10'}`} />
                  )}
                </div>
              );
            })}
          </div>
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-10">
        {/* Items + totals */}
        <div className="lg:col-span-2">
          <h2 className="font-heading font-bold text-lg text-white mb-4">Items</h2>
          <div className="flex flex-col gap-2 mb-6">
            {order.items.map((item) => (
              <div
                key={item.id ?? item.productId}
                className="flex items-center justify-between bg-bg-secondary rounded-md p-5"
              >
                <div className="min-w-0">
                  <p className="text-sm text-white font-medium truncate">{item.productName}</p>
                  <span className="text-[11px] text-text-muted/50 font-mono">{item.sku}</span>
                </div>
                <div className="text-right shrink-0 ml-4">
                  <p className="text-sm text-white font-medium tabular-nums">{formatPrice(item.total)}</p>
                  <span className="text-[11px] text-text-muted">
                    {item.quantity} x {formatPrice(item.unitPrice)}
                  </span>
                </div>
              </div>
            ))}
          </div>

          <div className="border-t border-white/[0.06] pt-4 flex flex-col gap-1">
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
            <div className="flex justify-between text-sm font-bold mt-3 pt-3 border-t border-white/[0.06]">
              <span className="text-white">Total</span>
              <span className="text-white tabular-nums">{formatPrice(order.total)}</span>
            </div>
          </div>
        </div>

        {/* Sidebar info */}
        <div className="flex flex-col gap-8">
          <div>
            <h2 className="font-heading font-bold text-lg text-white mb-4">Shipping</h2>
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
            </div>
          </div>

          <div>
            <h2 className="font-heading font-bold text-lg text-white mb-4">Payment</h2>
            <div className="text-sm text-text-muted">
              <p>
                {order.paymentMethod === 'bank_transfer'
                  ? 'Bank Transfer'
                  : order.paymentMethod === 'cod'
                  ? 'Cash on Delivery'
                  : 'Online Payment'}
              </p>
              <p
                className={`font-medium mt-1 ${
                  order.paymentStatus === 'paid'
                    ? 'text-success'
                    : order.paymentStatus === 'refunded'
                    ? 'text-error'
                    : 'text-warning'
                }`}
              >
                {order.paymentStatus === 'paid'
                  ? 'Paid'
                  : order.paymentStatus === 'refunded'
                  ? 'Refunded'
                  : order.paymentStatus === 'failed'
                  ? 'Payment failed'
                  : 'Pending'}
              </p>
            </div>
          </div>

          {order.trackingNumber && (
            <div>
              <h2 className="font-heading font-bold text-lg text-white mb-4">Tracking</h2>
              <p className="text-sm text-white font-mono">{order.trackingNumber}</p>
            </div>
          )}

          {order.notes && (
            <div>
              <h2 className="font-heading font-bold text-lg text-white mb-4">Notes</h2>
              <p className="text-sm text-text-muted">{order.notes}</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
