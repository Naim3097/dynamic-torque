import { supabase } from './supabase';
import type { Json, Tables } from '@/types/database';
import type {
  Order,
  OrderItem,
  OrderStatus,
  PaymentMethod,
  PaymentStatus,
  ShippingAddress,
} from '@/types/order';
import type { CartItem } from '@/types/cart';

type OrderRow = Tables<'orders'>;
type OrderItemRow = Tables<'order_items'>;

function mapOrderItemRow(row: OrderItemRow): OrderItem {
  return {
    id: row.id,
    productId: row.product_id,
    productName: row.name,
    sku: row.sku,
    quantity: row.quantity,
    unitPrice: Number(row.unit_price),
    total: Number(row.line_total),
    thumbnailUrl: row.thumbnail_url ?? undefined,
  };
}

function mapOrderRow(row: OrderRow, items: OrderItemRow[] = []): Order {
  const shipping = (row.shipping_address ?? {}) as unknown as ShippingAddress;
  return {
    id: row.id,
    orderNumber: row.order_number,
    userId: row.user_id,
    accountType: row.account_type === 'b2b' ? 'b2b' : 'b2c',
    items: items.map(mapOrderItemRow),
    shipping,
    subtotal: Number(row.subtotal),
    discount: Number(row.discount),
    shippingCost: Number(row.shipping_cost),
    tax: Number(row.tax),
    total: Number(row.total),
    currency: row.currency,
    paymentMethod: (row.payment_method ?? 'bank_transfer') as PaymentMethod,
    paymentStatus: row.payment_status as PaymentStatus,
    status: row.order_status as OrderStatus,
    trackingNumber: row.tracking_number ?? undefined,
    poNumber: row.po_number ?? undefined,
    notes: row.notes ?? undefined,
    createdAt: row.created_at,
    updatedAt: row.updated_at,
  };
}

export interface PlaceOrderInput {
  items: CartItem[];
  shipping: ShippingAddress;
  paymentMethod: PaymentMethod;
  notes?: string;
  poNumber?: string;
  promoCode?: string;
}

export interface PlaceOrderResult {
  orderId: string;
}

export async function placeOrder(input: PlaceOrderInput): Promise<PlaceOrderResult> {
  const { data, error } = await supabase.rpc('place_order', {
    p_items: input.items.map((i) => ({
      product_id: i.productId,
      quantity: i.quantity,
    })) as unknown as Json,
    p_shipping_address: input.shipping as unknown as Json,
    p_payment_method: input.paymentMethod,
    p_po_number: input.poNumber,
    p_notes: input.notes,
    p_promo_code: input.promoCode,
  });
  if (error) throw new Error(error.message);
  if (!data) throw new Error('place_order returned no id');
  return { orderId: data };
}

/** Fetch a single order including its line items (scoped to current user). */
export async function fetchOrderById(id: string): Promise<Order | null> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return null;

  const { data, error } = await supabase
    .from('orders')
    .select('*, order_items(*)')
    .eq('id', id)
    .eq('user_id', user.id)
    .maybeSingle();
  if (error) throw new Error(error.message);
  if (!data) return null;
  const { order_items, ...row } = data as unknown as OrderRow & {
    order_items: OrderItemRow[];
  };
  return mapOrderRow(row, order_items ?? []);
}

/** Fetch all orders for the currently signed-in user. */
export async function fetchUserOrders(): Promise<Order[]> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return [];
  const { data, error } = await supabase
    .from('orders')
    .select('*, order_items(*)')
    .eq('user_id', user.id)
    .order('created_at', { ascending: false });
  if (error) throw new Error(error.message);
  return ((data ?? []) as unknown as Array<
    OrderRow & { order_items: OrderItemRow[] }
  >).map((d) => {
    const { order_items, ...row } = d;
    return mapOrderRow(row, order_items ?? []);
  });
}
