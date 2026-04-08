import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useCartStore } from '@/stores/cartStore';
import { useAuthStore } from '@/stores/authStore';
import { useOrderStore } from '@/stores/orderStore';
import { products, formatPrice } from '@/data/products';
import { Input, Button } from '@/components/ui';
import type { ShippingAddress, OrderItem, Order } from '@/types/order';

const SHIPPING_FLAT = 15;

export function CheckoutPage() {
  const navigate = useNavigate();
  const items = useCartStore(s => s.items);
  const subtotal = useCartStore(s => s.subtotal());
  const clearCart = useCartStore(s => s.clearCart);
  const user = useAuthStore(s => s.user);
  const placeOrder = useOrderStore(s => s.placeOrder);

  const [form, setForm] = useState<ShippingAddress>({
    fullName: user?.fullName || '',
    company: user?.company || '',
    phone: user?.phone || '',
    email: user?.email || '',
    addressLine1: '',
    addressLine2: '',
    city: '',
    state: '',
    postalCode: '',
    country: 'Malaysia',
  });
  const [paymentMethod, setPaymentMethod] = useState<Order['paymentMethod']>('bank_transfer');
  const [notes, setNotes] = useState('');
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [submitting, setSubmitting] = useState(false);

  if (items.length === 0) {
    return (
      <div className="container-main text-center" style={{ paddingTop: '6rem', paddingBottom: '4rem' }}>
        <h1 className="font-heading font-bold text-3xl text-white mb-3">Checkout</h1>
        <p className="text-sm text-text-muted mb-8">Your cart is empty.</p>
        <Link to="/catalog">
          <Button variant="primary" size="md">Browse Parts</Button>
        </Link>
      </div>
    );
  }

  const shippingCost = subtotal >= 500 ? 0 : SHIPPING_FLAT;
  const total = subtotal + shippingCost;

  function updateField(field: keyof ShippingAddress, value: string) {
    setForm(prev => ({ ...prev, [field]: value }));
    if (errors[field]) {
      setErrors(prev => { const next = { ...prev }; delete next[field]; return next; });
    }
  }

  function validate(): boolean {
    const errs: Record<string, string> = {};
    if (!form.fullName.trim()) errs.fullName = 'Required';
    if (!form.phone.trim()) errs.phone = 'Required';
    if (!form.email.trim()) errs.email = 'Required';
    else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) errs.email = 'Invalid email';
    if (!form.addressLine1.trim()) errs.addressLine1 = 'Required';
    if (!form.city.trim()) errs.city = 'Required';
    if (!form.state.trim()) errs.state = 'Required';
    if (!form.postalCode.trim()) errs.postalCode = 'Required';
    setErrors(errs);
    return Object.keys(errs).length === 0;
  }

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!validate()) return;

    setSubmitting(true);

    const orderItems: OrderItem[] = items.map(item => {
      const product = products.find(p => p.id === item.productId);
      return {
        productId: item.productId,
        productName: product?.name || 'Unknown',
        sku: product?.sku || '',
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        total: item.unitPrice * item.quantity,
      };
    });

    const order = placeOrder({
      items: orderItems,
      shipping: form,
      subtotal,
      shippingCost,
      paymentMethod,
      notes: notes.trim() || undefined,
    });

    clearCart();
    navigate(`/order-confirmation/${order.id}`);
  }

  const paymentOptions: { value: Order['paymentMethod']; label: string; desc: string }[] = [
    { value: 'bank_transfer', label: 'Bank Transfer', desc: 'Pay via online banking or manual transfer' },
    { value: 'cod', label: 'Cash on Delivery', desc: 'Pay when you receive your order' },
    { value: 'online', label: 'Online Payment', desc: 'Credit/debit card (coming soon)' },
  ];

  return (
    <div className="container-main" style={{ paddingTop: '2.5rem', paddingBottom: '4rem' }}>
      <nav className="flex items-center gap-1.5 text-[13px] mb-8">
        <Link to="/cart" className="text-text-muted hover:text-white transition-colors">Cart</Link>
        <span className="text-text-muted/40">/</span>
        <span className="text-white">Checkout</span>
      </nav>

      <h1 className="font-heading font-bold text-3xl text-white mb-10">Checkout</h1>

      <form onSubmit={handleSubmit}>
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-10">
          {/* Left — form */}
          <div className="lg:col-span-2 flex flex-col gap-10">
            {/* Shipping */}
            <section>
              <h2 className="font-heading font-bold text-lg text-white mb-6">Shipping details</h2>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <Input
                    label="Full name"
                    value={form.fullName}
                    onChange={e => updateField('fullName', e.target.value)}
                    placeholder="Your full name"
                  />
                  {errors.fullName && <p className="text-xs text-error mt-1">{errors.fullName}</p>}
                </div>
                <div>
                  <Input
                    label="Company (optional)"
                    value={form.company}
                    onChange={e => updateField('company', e.target.value)}
                    placeholder="Workshop / company name"
                  />
                </div>
                <div>
                  <Input
                    label="Phone"
                    value={form.phone}
                    onChange={e => updateField('phone', e.target.value)}
                    placeholder="+60 12-345 6789"
                  />
                  {errors.phone && <p className="text-xs text-error mt-1">{errors.phone}</p>}
                </div>
                <div>
                  <Input
                    label="Email"
                    type="email"
                    value={form.email}
                    onChange={e => updateField('email', e.target.value)}
                    placeholder="you@company.com"
                  />
                  {errors.email && <p className="text-xs text-error mt-1">{errors.email}</p>}
                </div>
              </div>

              <div className="flex flex-col gap-4" style={{ marginTop: '1rem' }}>
                <div>
                  <Input
                    label="Address line 1"
                    value={form.addressLine1}
                    onChange={e => updateField('addressLine1', e.target.value)}
                    placeholder="Street address"
                  />
                  {errors.addressLine1 && <p className="text-xs text-error mt-1">{errors.addressLine1}</p>}
                </div>
                <Input
                  label="Address line 2 (optional)"
                  value={form.addressLine2}
                  onChange={e => updateField('addressLine2', e.target.value)}
                  placeholder="Apartment, unit, etc."
                />
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                  <div>
                    <Input
                      label="City"
                      value={form.city}
                      onChange={e => updateField('city', e.target.value)}
                      placeholder="Kuala Lumpur"
                    />
                    {errors.city && <p className="text-xs text-error mt-1">{errors.city}</p>}
                  </div>
                  <div>
                    <Input
                      label="State"
                      value={form.state}
                      onChange={e => updateField('state', e.target.value)}
                      placeholder="Selangor"
                    />
                    {errors.state && <p className="text-xs text-error mt-1">{errors.state}</p>}
                  </div>
                  <div>
                    <Input
                      label="Postal code"
                      value={form.postalCode}
                      onChange={e => updateField('postalCode', e.target.value)}
                      placeholder="50000"
                    />
                    {errors.postalCode && <p className="text-xs text-error mt-1">{errors.postalCode}</p>}
                  </div>
                </div>
              </div>
            </section>

            {/* Payment method */}
            <section>
              <h2 className="font-heading font-bold text-lg text-white mb-6">Payment method</h2>
              <div className="flex flex-col gap-3">
                {paymentOptions.map(opt => (
                  <label
                    key={opt.value}
                    className={`flex items-start gap-4 p-5 rounded-md cursor-pointer transition-colors border ${
                      paymentMethod === opt.value
                        ? 'border-blue-bright/40 bg-surface'
                        : 'border-white/[0.06] bg-transparent hover:border-white/10'
                    } ${opt.value === 'online' ? 'opacity-50 cursor-not-allowed' : ''}`}
                  >
                    <input
                      type="radio"
                      name="payment"
                      value={opt.value}
                      checked={paymentMethod === opt.value}
                      onChange={() => opt.value !== 'online' && setPaymentMethod(opt.value)}
                      disabled={opt.value === 'online'}
                      className="mt-0.5 accent-[var(--color-blue-bright)]"
                    />
                    <div>
                      <span className="text-sm font-medium text-white">{opt.label}</span>
                      <p className="text-[13px] text-text-muted mt-0.5">{opt.desc}</p>
                    </div>
                  </label>
                ))}
              </div>
            </section>

            {/* Notes */}
            <section>
              <h2 className="font-heading font-bold text-lg text-white mb-4">Order notes (optional)</h2>
              <textarea
                value={notes}
                onChange={e => setNotes(e.target.value)}
                rows={3}
                placeholder="Special instructions, preferred delivery time, etc."
                className="w-full rounded-md bg-surface px-4 py-3 text-sm text-white placeholder:text-text-muted/40 border border-white/5 focus:border-blue-bright/50 focus:outline-none transition-colors resize-none"
              />
            </section>
          </div>

          {/* Right — summary */}
          <div className="lg:col-span-1">
            <div className="bg-bg-secondary rounded-md p-6 sticky" style={{ top: '6rem' }}>
              <h2 className="font-heading font-bold text-lg text-white mb-6">Order summary</h2>

              <div className="flex flex-col gap-3 mb-6">
                {items.map(item => {
                  const product = products.find(p => p.id === item.productId);
                  if (!product) return null;
                  return (
                    <div key={item.productId} className="flex justify-between text-sm">
                      <span className="text-text-muted truncate pr-4">
                        {product.name} <span className="text-text-muted/50">x{item.quantity}</span>
                      </span>
                      <span className="text-white font-medium tabular-nums shrink-0">
                        {formatPrice(item.unitPrice * item.quantity)}
                      </span>
                    </div>
                  );
                })}
              </div>

              <div className="border-t border-white/[0.06] pt-4 flex flex-col gap-2 mb-4">
                <div className="flex justify-between text-sm">
                  <span className="text-text-muted">Subtotal</span>
                  <span className="text-white font-medium tabular-nums">{formatPrice(subtotal)}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-text-muted">Shipping</span>
                  <span className="text-white font-medium tabular-nums">
                    {shippingCost === 0 ? 'Free' : formatPrice(shippingCost)}
                  </span>
                </div>
                {shippingCost > 0 && (
                  <p className="text-[11px] text-text-muted/60">Free shipping on orders over RM 500</p>
                )}
              </div>

              <div className="border-t border-white/[0.06] pt-4 mb-6">
                <div className="flex justify-between">
                  <span className="text-sm font-medium text-white">Total</span>
                  <span className="text-xl font-bold text-white tabular-nums">{formatPrice(total)}</span>
                </div>
              </div>

              <Button
                type="submit"
                variant="primary"
                size="lg"
                className="w-full"
                disabled={submitting}
              >
                {submitting ? 'Placing order...' : 'Place Order'}
              </Button>

              {!user && (
                <p className="text-[11px] text-text-muted/60 mt-4 text-center">
                  <Link to="/login" className="text-blue-bright hover:text-white transition-colors">Sign in</Link>
                  {' '}to save your details for future orders
                </p>
              )}
            </div>
          </div>
        </div>
      </form>
    </div>
  );
}
