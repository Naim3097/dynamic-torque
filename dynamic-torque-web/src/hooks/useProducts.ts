import { useQuery } from '@tanstack/react-query';
import {
  fetchProducts,
  fetchProductBySlug,
  type ProductListOptions,
} from '@/services/productService';
import type { ProductCategory } from '@/types/product';

export function useProducts(opts: ProductListOptions = {}) {
  return useQuery({
    queryKey: ['products', opts],
    queryFn: () => fetchProducts(opts),
    staleTime: 60_000,
  });
}

export function useFeaturedProducts(limit = 8) {
  return useQuery({
    queryKey: ['products', 'featured', limit],
    queryFn: () => fetchProducts({ featured: true, limit }),
    staleTime: 60_000,
  });
}

export function useProductsByCategory(category: ProductCategory | undefined) {
  return useQuery({
    queryKey: ['products', 'category', category],
    queryFn: () => fetchProducts({ category: category! }),
    enabled: !!category,
    staleTime: 60_000,
  });
}

export function useProductBySlug(slug: string | undefined) {
  return useQuery({
    queryKey: ['products', 'slug', slug],
    queryFn: () => fetchProductBySlug(slug!),
    enabled: !!slug,
    staleTime: 60_000,
  });
}
