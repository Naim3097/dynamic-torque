import { supabase } from './supabase';
import type { Tables } from '@/types/database';
import type { Product, ProductCategory, StockStatus } from '@/types/product';

type ProductRow = Tables<'products'>;

/** Map a Supabase `products` row into the UI `Product` shape. */
export function mapProductRow(row: ProductRow): Product {
  return {
    id: row.id,
    name: row.name,
    slug: row.slug,
    sku: row.sku,
    category: row.category_slug as ProductCategory,
    description: row.description,
    specifications: (row.specifications ?? {}) as Record<string, string>,
    compatibleVehicles: row.compatible_vehicles ?? [],
    compatibleGearboxes: row.compatible_gearboxes ?? [],
    price: Number(row.price),
    currency: row.currency,
    wholesalePrice: row.wholesale_price != null ? Number(row.wholesale_price) : undefined,
    minWholesaleQty: row.min_wholesale_qty ?? undefined,
    images: row.images ?? [],
    thumbnailUrl: row.thumbnail_url ?? '',
    stockQty: row.stock_qty,
    stockStatus: row.stock_status as StockStatus,
    lowStockThreshold: row.low_stock_threshold,
    tags: row.tags ?? [],
    isFeatured: row.is_featured,
    isActive: row.is_active,
    createdAt: row.created_at,
    updatedAt: row.updated_at,
  };
}

export type ProductSort = 'newest' | 'price-asc' | 'price-desc' | 'name';

export interface ProductListOptions {
  category?: ProductCategory;
  featured?: boolean;
  search?: string;
  sort?: ProductSort;
  limit?: number;
  offset?: number;
}

/** Fetch a list of active products with optional filters. */
export async function fetchProducts(opts: ProductListOptions = {}): Promise<Product[]> {
  let query = supabase.from('products').select('*').eq('is_active', true);

  if (opts.category) query = query.eq('category_slug', opts.category);
  if (opts.featured) query = query.eq('is_featured', true);
  if (opts.search && opts.search.trim()) {
    // Escape SQL LIKE wildcards to prevent pattern injection
    const escaped = opts.search.trim().replace(/%/g, '\\%').replace(/_/g, '\\_');
    const term = `%${escaped}%`;
    query = query.or(`name.ilike.${term},sku.ilike.${term}`);
  }

  switch (opts.sort ?? 'newest') {
    case 'price-asc':
      query = query.order('price', { ascending: true });
      break;
    case 'price-desc':
      query = query.order('price', { ascending: false });
      break;
    case 'name':
      query = query.order('name', { ascending: true });
      break;
    case 'newest':
    default:
      query = query.order('created_at', { ascending: false });
  }

  if (opts.limit != null || opts.offset != null) {
    const from = opts.offset ?? 0;
    const to = from + (opts.limit ?? 50) - 1;
    query = query.range(from, to);
  }

  const { data, error } = await query;
  if (error) throw new Error(error.message);
  return (data ?? []).map(mapProductRow);
}

/** Fetch a single active product by slug. Returns null if not found. */
export async function fetchProductBySlug(slug: string): Promise<Product | null> {
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('slug', slug)
    .eq('is_active', true)
    .maybeSingle();
  if (error) throw new Error(error.message);
  return data ? mapProductRow(data) : null;
}
