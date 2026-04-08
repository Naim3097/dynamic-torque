import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { Order, ShippingAddress, OrderItem } from '@/types/order';

interface OrderState {
  orders: Order[];
  placeOrder: (data: {
    items: OrderItem[];
    shipping: ShippingAddress;
    subtotal: number;
    shippingCost: number;
    paymentMethod: Order['paymentMethod'];
    notes?: string;
  }) => Order;
  getOrder: (id: string) => Order | undefined;
  getOrderByNumber: (orderNumber: string) => Order | undefined;
  getUserOrders: (email: string) => Order[];
}

function generateOrderNumber(): string {
  const date = new Date();
  const y = date.getFullYear().toString().slice(-2);
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  const seq = Math.floor(Math.random() * 9000 + 1000);
  return `DT-${y}${m}${d}-${seq}`;
}

export const useOrderStore = create<OrderState>()(
  persist(
    (set, get) => ({
      orders: [],

      placeOrder: (data) => {
        const now = new Date().toISOString();
        const order: Order = {
          id: crypto.randomUUID(),
          orderNumber: generateOrderNumber(),
          items: data.items,
          shipping: data.shipping,
          subtotal: data.subtotal,
          shippingCost: data.shippingCost,
          total: data.subtotal + data.shippingCost,
          currency: 'MYR',
          status: 'pending',
          notes: data.notes,
          paymentMethod: data.paymentMethod,
          paymentStatus: 'unpaid',
          createdAt: now,
          updatedAt: now,
        };
        set({ orders: [order, ...get().orders] });
        return order;
      },

      getOrder: (id) => get().orders.find(o => o.id === id),

      getOrderByNumber: (orderNumber) =>
        get().orders.find(o => o.orderNumber === orderNumber),

      getUserOrders: (email) =>
        get().orders.filter(o => o.shipping.email === email),
    }),
    { name: 'dt-orders' }
  )
);
