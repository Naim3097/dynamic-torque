import { useParams, Link } from 'react-router-dom';
import { ProductGrid } from '@/components/product/ProductGrid';
import { getProductsByCategory, getCategoryBySlug } from '@/data/products';
import type { ProductCategory } from '@/types/product';

export function CategoryPage() {
  const { slug } = useParams<{ slug: string }>();
  const category = getCategoryBySlug(slug || '');
  const categoryProducts = getProductsByCategory((slug || '') as ProductCategory);

  if (!category) {
    return (
      <div className="container-main text-center" style={{ paddingTop: '6rem', paddingBottom: '4rem' }}>
        <p className="text-text-muted mb-4">Category not found.</p>
        <Link to="/catalog" className="text-sm text-blue-bright hover:text-white transition-colors">
          &larr; Back to all parts
        </Link>
      </div>
    );
  }

  return (
    <div className="container-main" style={{ paddingTop: '2.5rem', paddingBottom: '4rem' }}>
      {/* Breadcrumb */}
      <nav className="flex items-center gap-1.5 text-[13px] mb-8">
        <Link to="/catalog" className="text-text-muted hover:text-white transition-colors">All Parts</Link>
        <span className="text-text-muted/40">/</span>
        <span className="text-white">{category.name}</span>
      </nav>

      {/* Header */}
      <div className="mb-10">
        <h1 className="font-heading font-bold text-3xl text-white">{category.name}</h1>
        <p className="text-sm text-text-muted mt-1">{category.description}</p>
      </div>

      <ProductGrid products={categoryProducts} />
    </div>
  );
}
