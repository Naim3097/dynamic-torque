import { Navigate, Outlet, useLocation } from 'react-router-dom';
import { useAuthStore } from '@/stores/authStore';
import { LoadingPulse } from '@/components/ui';

export function ProtectedRoute() {
  const location = useLocation();
  const user = useAuthStore((s) => s.user);
  const initialized = useAuthStore((s) => s.initialized);

  if (!initialized) {
    return (
      <div className="container-main flex justify-center" style={{ paddingTop: '6rem' }}>
        <LoadingPulse />
      </div>
    );
  }

  if (!user) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  return <Outlet />;
}
