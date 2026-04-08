import { Link } from 'react-router-dom';
import { Button } from '@/components/ui';

export function NotFoundPage() {
  return (
    <div className="container-main flex flex-col items-center text-center" style={{ paddingTop: '6rem', paddingBottom: '4rem' }}>
      <span className="text-6xl font-heading font-bold text-white/10">404</span>
      <h1 className="font-heading font-bold text-2xl text-white mt-4 mb-2">Page not found</h1>
      <p className="text-sm text-text-muted mb-8">The page you're looking for doesn't exist or has been moved.</p>
      <Link to="/">
        <Button variant="primary" size="md">Back to Home</Button>
      </Link>
    </div>
  );
}
