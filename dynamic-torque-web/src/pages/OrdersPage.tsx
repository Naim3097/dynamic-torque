import { Link } from 'react-router-dom';
import { useOrderStore } from '@/stores/orderStore';
import { useAuthStore } from '@/stores/authStore';
import { formatPrice } from '@/data/products';
import { Button } from '@/components/ui';
import type { OrderStatus } from '@/types/order';

const statusColors: Record<OrderStatus, string> = {
  pending: 'text-warning',
  confirmed: 'text-blue-bright',
  processing: 'text-blue-bright',
  dispatched: 'text-blue-light',
  delivered: 'text-success',
  cancelled: 'text-error',
};

const statusLabels: Record<OrderStatus, string> = {
  pending: 'Pending',
  confirmed: 'Confirmed',
  processing: 'Processing',
  dispatched: 'Dispatched',
  delivered: 'Delivered',
  cancelled: 'Cancelled',
};

export function OrdersPage() {
  const user = useAuthStore(s => s.user);
  const allOrders = useOrderStore(s => s.orders);

  // Show user's orders if logged in, otherwise show all local orders
  const orders = user
    ? allOrders.filter(o => o.shipping.email === user.email)
    : allOrders;

  if (!user) {
    return (
      <div className="container-main text-center" style={{ paddingTop: '6rem', paddingBottom: '4rem' }}>
        <h1 className="font-heading font-bold text-3xl text-white mb-3">Your Orders</h1>
        <p className="text-sm text-text-muted mb-8">Sign in to view your order history.</p>
        <Link to="/login">
          <Button variant="primary" size="md">Sign in</Button>
        </Link>
      </div>
    );
  }

  if (orders.length === 0) {
    return (
      <div className="container-main text-center" style={{ paddingTop: '6rem', paddingBottom: '4rem' }}>
        <h1 className="font-heading font-bold text-3xl text-white mb-3">Your Orders</h1>
        <p className="text-sm text-text-muted mb-8">You haven't placed any orders yet.</p>
        <Link to="/catalog">
          <Button variant="primary" size="md">Browse Parts</Button>
        </Link>
      </div>
    );
  }

  return (
    <div className="container-main" style={{ paddingTop: '2.5rem', paddingBottom: '4rem' }}>
      <h1 className="font-heading font-bold text-3xl text-white mb-2">Your Orders</h1>
      <p className="text-sm text-text-muted mb-10">{orders.length} {orders.length === 1 ? 'order' : 'orders'}</p>

      <div className="flex flex-col gap-3">
        {orders.map(order => (
          <Link
            key={order.id}
            to={`/orders/${order.id}`}
            className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-bg-secondary rounded-md p-6 hover:bg-surface transition-colors"
          >
            <div className="flex flex-col sm:flex-row sm:items-center gap-2 sm:gap-6">
              <span className="text-sm font-mono text-white font-medium">{order.orderNumber}</span>
              <span className="text-[13px] text-text-muted">
                {new Date(order.createdAt).toLocaleDateString('en-MY', { day: 'numeric', month: 'short', year: 'numeric' })}
              </span>
              <span className={`text-[13px] font-medium ${statusColors[order.status]}`}>
                {statusLabels[order.status]}
              </span>
            </div>
            <div className="flex items-center gap-4">
              <span className="text-[13px] text-text-muted">
                {order.items.length} {order.items.length === 1 ? 'item' : 'items'}
              </span>
              <span className="text-sm font-bold text-white tabular-nums">{formatPrice(order.total)}</span>
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
}
