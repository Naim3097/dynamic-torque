import { Link } from 'react-router-dom';
import { Button, LoadingPulse } from '@/components/ui';
import { ProductGrid } from '@/components/product/ProductGrid';
import { categories } from '@/data/products';
import { useFeaturedProducts } from '@/hooks/useProducts';
import logo from '@/assets/logo.png';

export function HomePage() {
  const { data: featured = [], isLoading } = useFeaturedProducts();

  return (
    <>
      {/* ── Hero ── */}
      <section
        className="relative flex flex-col items-center justify-center overflow-hidden"
        style={{ minHeight: 'calc(100vh - 5rem)' }}
      >
        <div className="absolute inset-0 bg-gradient-to-b from-bg-secondary via-bg-primary to-bg-primary" />
        <div className="absolute inset-0 opacity-[0.08] bg-[radial-gradient(ellipse_at_center,_var(--color-blue-bright)_0%,_transparent_55%)]" />

        <div className="relative z-10 flex flex-col items-center px-6 text-center">
          <img
            src={logo}
            alt="MNA Dynamic Torque"
            className="w-[260px] sm:w-[340px] md:w-[400px] lg:w-[460px] h-auto"
          />
          <div className="mt-10">
            <Link to="/catalog">
              <Button variant="primary" size="lg">
                Browse Parts
              </Button>
            </Link>
          </div>
        </div>
      </section>

      {/* ── Categories ── */}
      <section className="py-24">
        <div className="container-main">
          <div className="mb-10">
            <h2 className="font-heading font-bold text-2xl text-white">Shop by Category</h2>
            <p className="text-sm text-text-muted mt-1">Transmission components for every rebuild</p>
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
            {categories.map(cat => (
              <Link
                key={cat.slug}
                to={`/category/${cat.slug}`}
                className="group relative aspect-[4/3] rounded-md overflow-hidden bg-surface"
              >
                <img
                  src={cat.image}
                  alt={cat.name}
                  className="absolute inset-0 w-full h-full object-cover opacity-40 group-hover:opacity-60 group-hover:scale-105 transition-all duration-500 ease-out"
                  loading="lazy"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/10 to-transparent" />
                <div className="absolute bottom-0 left-0 right-0 p-5">
                  <span className="text-white font-heading font-semibold text-[15px] sm:text-base">
                    {cat.name}
                  </span>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* ── Featured ── */}
      <section className="pb-24">
        <div className="container-main">
          <div className="flex items-end justify-between mb-10">
            <div>
              <h2 className="font-heading font-bold text-2xl text-white">Featured Parts</h2>
              <p className="text-sm text-text-muted mt-1">Popular items across all categories</p>
            </div>
            <Link
              to="/catalog"
              className="hidden sm:inline-flex text-sm text-text-muted hover:text-white transition-colors"
            >
              View all &rarr;
            </Link>
          </div>
          {isLoading ? <LoadingPulse /> : <ProductGrid products={featured} />}
        </div>
      </section>

      {/* ── Trust banner ── */}
      <section className="border-t border-white/[0.06]">
        <div className="container-main py-10">
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4 sm:gap-10 text-sm text-text-muted">
            <span>Trade accounts welcome</span>
            <span className="hidden sm:block text-white/10">/</span>
            <span>Same-day dispatch</span>
            <span className="hidden sm:block text-white/10">/</span>
            <span>Nationwide delivery</span>
          </div>
        </div>
      </section>
    </>
  );
}
