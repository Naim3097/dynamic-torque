import { useState, useMemo } from 'react';
import { ProductGrid } from '@/components/product/ProductGrid';
import { products, categories } from '@/data/products';
import type { ProductCategory } from '@/types/product';

type SortOption = 'newest' | 'price-asc' | 'price-desc';

export function CatalogPage() {
  const [selectedCategory, setSelectedCategory] = useState<ProductCategory | 'all'>('all');
  const [sort, setSort] = useState<SortOption>('newest');

  const filtered = useMemo(() => {
    let result = products.filter(p => p.isActive);

    if (selectedCategory !== 'all') {
      result = result.filter(p => p.category === selectedCategory);
    }

    switch (sort) {
      case 'price-asc':
        result = [...result].sort((a, b) => a.price - b.price);
        break;
      case 'price-desc':
        result = [...result].sort((a, b) => b.price - a.price);
        break;
      case 'newest':
      default:
        result = [...result].sort(
          (a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
        );
    }

    return result;
  }, [selectedCategory, sort]);

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
          {categories.map(cat => (
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
            {filtered.length} {filtered.length === 1 ? 'item' : 'items'}
          </span>
          <select
            value={sort}
            onChange={e => setSort(e.target.value as SortOption)}
            className="h-9 bg-surface text-[13px] text-text-muted rounded-md px-3.5 border border-white/5 focus:border-blue-bright/50 focus:outline-none cursor-pointer transition-colors"
          >
            <option value="newest">Newest</option>
            <option value="price-asc">Price: Low to High</option>
            <option value="price-desc">Price: High to Low</option>
          </select>
        </div>
      </div>

      {/* Grid */}
      <ProductGrid products={filtered} />
    </div>
  );
}
