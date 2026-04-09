import { useState } from 'react';
import { ProductGrid } from '@/components/product/ProductGrid';
import { LoadingPulse } from '@/components/ui';
import { categories } from '@/data/products';
import { useProducts } from '@/hooks/useProducts';
import type { ProductCategory } from '@/types/product';
import type { ProductSort } from '@/services/productService';

export function CatalogPage() {
  const [selectedCategory, setSelectedCategory] = useState<ProductCategory | 'all'>('all');
  const [sort, setSort] = useState<ProductSort>('newest');

  const { data: products = [], isLoading } = useProducts({
    category: selectedCategory === 'all' ? undefined : selectedCategory,
    sort,
  });

  return (
    <div className="container-main" style={{ paddingTop: '2.5rem', paddingBottom: '4rem' }}>
      {/* Header */}
      <div className="mb-10">
        <h1 className="font-heading font-bold text-3xl text-white">All Parts</h1>
        <p className="text-sm text-text-muted mt-1">Browse our full inventory</p>
      </div>

      {/* Filters bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
        <div className="flex flex-wrap gap-2">
          <button
            onClick={() => setSelectedCategory('all')}
            className={`h-9 px-4 rounded-md text-[13px] font-medium transition-colors duration-150 ${
              selectedCategory === 'all'
                ? 'bg-blue-bright text-white'
                : 'bg-surface text-text-muted hover:text-white'
            }`}
          >
            All
          </button>
          {categories.map((cat) => (
            <button
              key={cat.slug}
              onClick={() => setSelectedCategory(cat.slug as ProductCategory)}
              className={`h-9 px-4 rounded-md text-[13px] font-medium transition-colors duration-150 ${
                selectedCategory === cat.slug
                  ? 'bg-blue-bright text-white'
                  : 'bg-surface text-text-muted hover:text-white'
              }`}
            >
              {cat.name}
            </button>
          ))}
        </div>

        <div className="flex items-center gap-4 shrink-0">
          <span className="text-[13px] text-text-muted tabular-nums">
            {products.length} {products.length === 1 ? 'item' : 'items'}
          </span>
          <select
            value={sort}
            onChange={(e) => setSort(e.target.value as ProductSort)}
            className="h-9 bg-surface text-[13px] text-text-muted rounded-md px-3.5 border border-white/5 focus:border-blue-bright/50 focus:outline-none cursor-pointer transition-colors"
          >
            <option value="newest">Newest</option>
            <option value="price-asc">Price: Low to High</option>
            <option value="price-desc">Price: High to Low</option>
            <option value="name">Name: A–Z</option>
          </select>
        </div>
      </div>

      {/* Grid */}
      {isLoading ? <LoadingPulse /> : <ProductGrid products={products} />}
    </div>
  );
}
