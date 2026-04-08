export interface CartItem {
  productId: string;
  quantity: number;
  unitPrice: number;
}

export interface Cart {
  items: CartItem[];
  promoCode?: string;
}
