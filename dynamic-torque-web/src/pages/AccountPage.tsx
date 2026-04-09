import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '@/stores/authStore';
import { useUserOrders } from '@/hooks/useOrders';
import { Input, Button } from '@/components/ui';
import { formatPrice } from '@/data/products';

export function AccountPage() {
  const navigate = useNavigate();
  const user = useAuthStore(s => s.user);
  const logout = useAuthStore(s => s.logout);
  const updateProfile = useAuthStore(s => s.updateProfile);
  const { data: orders = [] } = useUserOrders();

  const [editing, setEditing] = useState(false);
  const [form, setForm] = useState({
    fullName: user?.fullName || '',
    phone: user?.phone || '',
    company: user?.company || '',
  });

  if (!user) {
    return (
      <div className="container-main text-center" style={{ paddingTop: '6rem', paddingBottom: '4rem' }}>
        <h1 className="font-heading font-bold text-3xl text-white mb-3">Account</h1>
        <p className="text-sm text-text-muted mb-8">Sign in to manage your account.</p>
        <Link to="/login">
          <Button variant="primary" size="md">Sign in</Button>
        </Link>
      </div>
    );
  }

  async function handleSave(e: React.FormEvent) {
    e.preventDefault();
    await updateProfile(form);
    setEditing(false);
  }

  async function handleLogout() {
    await logout();
    navigate('/');
  }

  const recentOrders = orders.slice(0, 3);

  return (
    <div className="container-main" style={{ paddingTop: '2.5rem', paddingBottom: '4rem' }}>
      <div className="flex items-center justify-between mb-10">
        <div>
          <h1 className="font-heading font-bold text-3xl text-white">Account</h1>
          <p className="text-sm text-text-muted mt-1">{user.email}</p>
        </div>
        <Button variant="ghost" size="sm" onClick={handleLogout}>Sign out</Button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-10">
        {/* Profile */}
        <div className="lg:col-span-2">
          <div className="flex items-center justify-between mb-6">
            <h2 className="font-heading font-bold text-lg text-white">Profile</h2>
            {!editing && (
              <button
                onClick={() => setEditing(true)}
                className="text-[13px] text-blue-bright hover:text-white transition-colors"
              >
                Edit
              </button>
            )}
          </div>

          {editing ? (
            <form onSubmit={handleSave} className="flex flex-col gap-4">
              <Input
                label="Full name"
                value={form.fullName}
                onChange={e => setForm(prev => ({ ...prev, fullName: e.target.value }))}
              />
              <Input
                label="Phone"
                value={form.phone}
                onChange={e => setForm(prev => ({ ...prev, phone: e.target.value }))}
              />
              <Input
                label="Company"
                value={form.company}
                onChange={e => setForm(prev => ({ ...prev, company: e.target.value }))}
              />
              <div className="flex gap-3 mt-2">
                <Button type="submit" variant="primary" size="md">Save</Button>
                <Button type="button" variant="ghost" size="md" onClick={() => setEditing(false)}>Cancel</Button>
              </div>
            </form>
          ) : (
            <div className="flex flex-col gap-4">
              <div className="flex justify-between text-sm py-4 border-b border-white/[0.04]">
                <span className="text-text-muted">Name</span>
                <span className="text-white">{user.fullName}</span>
              </div>
              <div className="flex justify-between text-sm py-4 border-b border-white/[0.04]">
                <span className="text-text-muted">Email</span>
                <span className="text-white">{user.email}</span>
              </div>
              <div className="flex justify-between text-sm py-4 border-b border-white/[0.04]">
                <span className="text-text-muted">Phone</span>
                <span className="text-white">{user.phone || '—'}</span>
              </div>
              <div className="flex justify-between text-sm py-4 border-b border-white/[0.04]">
                <span className="text-text-muted">Company</span>
                <span className="text-white">{user.company || '—'}</span>
              </div>
              <div className="flex justify-between text-sm py-4 border-b border-white/[0.04]">
                <span className="text-text-muted">Account type</span>
                <span className="text-white">{user.isTradeAccount ? 'Trade' : 'Standard'}</span>
              </div>
              <div className="flex justify-between text-sm py-4">
                <span className="text-text-muted">Member since</span>
                <span className="text-white">
                  {new Date(user.createdAt).toLocaleDateString('en-MY', { month: 'long', year: 'numeric' })}
                </span>
              </div>
            </div>
          )}
        </div>

        {/* Recent orders sidebar */}
        <div>
          <div className="flex items-center justify-between mb-6">
            <h2 className="font-heading font-bold text-lg text-white">Recent orders</h2>
            {orders.length > 0 && (
              <Link to="/orders" className="text-[13px] text-text-muted hover:text-white transition-colors">
                View all
              </Link>
            )}
          </div>

          {recentOrders.length === 0 ? (
            <p className="text-sm text-text-muted">No orders yet.</p>
          ) : (
            <div className="flex flex-col gap-3">
              {recentOrders.map(order => (
                <Link
                  key={order.id}
                  to={`/orders/${order.id}`}
                  className="bg-bg-secondary rounded-md p-5 hover:bg-surface transition-colors"
                >
                  <div className="flex justify-between text-sm mb-1">
                    <span className="font-mono text-white font-medium">{order.orderNumber}</span>
                    <span className="text-white font-bold tabular-nums">{formatPrice(order.total)}</span>
                  </div>
                  <div className="flex justify-between text-[11px] text-text-muted">
                    <span>{new Date(order.createdAt).toLocaleDateString('en-MY', { day: 'numeric', month: 'short' })}</span>
                    <span>{order.items.length} {order.items.length === 1 ? 'item' : 'items'}</span>
                  </div>
                </Link>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
