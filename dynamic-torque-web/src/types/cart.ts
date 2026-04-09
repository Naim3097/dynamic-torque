export interface CartItem {
  productId: string;
  name: string;
  sku: string;
  slug: string;
  thumbnailUrl: string;
  quantity: number;
  unitPrice: number;
}

export interface Cart {
  items: CartItem[];
  promoCode?: string;
}
