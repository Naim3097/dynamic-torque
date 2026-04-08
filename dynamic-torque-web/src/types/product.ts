export type ProductCategory =
  | 'clutch_plate'
  | 'steel_plate'
  | 'auto_filter'
  | 'forward_drum'
  | 'oil_pump'
  | 'piston_seal'
  | 'overhaul_kit'
  | 'lubricants';

export type StockStatus = 'in_stock' | 'low_stock' | 'out_of_stock';

export interface Product {
  id: string;
  name: string;
  slug: string;
  sku: string;
  category: ProductCategory;
  description: string;
  specifications: Record<string, string>;
  compatibleVehicles: string[];
  compatibleGearboxes: string[];
  price: number;
  currency: string;
  wholesalePrice?: number;
  minWholesaleQty?: number;
  images: string[];
  thumbnailUrl: string;
  stockQty: number;
  stockStatus: StockStatus;
  lowStockThreshold: number;
  tags: string[];
  isFeatured: boolean;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface CategoryInfo {
  slug: ProductCategory;
  name: string;
  description: string;
  image: string;
}
