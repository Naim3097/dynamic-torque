import { useState, useCallback, useRef } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { useAuthStore } from '@/stores/authStore';
import { Input, Button } from '@/components/ui';

/** Return the redirect path only if it is a safe, same-origin relative path. */
function safePath(raw: string | undefined): string {
  if (!raw) return '/account';
  // Must start with "/" and must NOT contain "//" (protocol-relative redirect).
  if (raw.startsWith('/') && !raw.includes('//')) return raw;
  return '/account';
}

export function LoginPage() {
  const navigate = useNavigate();
  const location = useLocation();
  const login = useAuthStore((s) => s.login);
  const user = useAuthStore((s) => s.user);
  const loading = useAuthStore((s) => s.loading);

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  // --- Rate-limiting state ---
  const failCountRef = useRef(0);
  const [cooldown, setCooldown] = useState(0);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const startCooldown = useCallback((seconds: number) => {
    setCooldown(seconds);
    if (timerRef.current) clearInterval(timerRef.current);
    let remaining = seconds;
    timerRef.current = setInterval(() => {
      remaining -= 1;
      setCooldown(remaining);
      if (remaining <= 0 && timerRef.current) {
        clearInterval(timerRef.current);
        timerRef.current = null;
      }
    }, 1000);
  }, []);

  if (user) {
    return (
      <div className="container-main text-center" style={{ paddingTop: '6rem', paddingBottom: '4rem' }}>
        <h1 className="font-heading font-bold text-3xl text-white mb-3">Already signed in</h1>
        <p className="text-sm text-text-muted mb-8">You're signed in as {user.email}</p>
        <Link to="/account">
          <Button variant="primary" size="md">Go to Account</Button>
        </Link>
      </div>
    );
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (cooldown > 0) return;

    if (!email.trim() || !password.trim()) {
      setError('Please enter your email and password');
      return;
    }
    const result = await login(email, password);
    if (result.success) {
      // Reset on success
      failCountRef.current = 0;
      const from = (location.state as { from?: { pathname: string } } | null)?.from?.pathname;
      navigate(safePath(from));
    } else {
      failCountRef.current += 1;
      if (failCountRef.current >= 3) {
        const delay = Math.min(5 * Math.pow(2, failCountRef.current - 3), 60);
        startCooldown(delay);
        setError(`Too many failed attempts. Try again in ${delay}s.`);
      } else {
        setError(result.error || 'Login failed');
      }
    }
  }

  const isDisabled = loading || cooldown > 0;

  return (
    <div className="container-main flex justify-center" style={{ paddingTop: '4rem', paddingBottom: '4rem' }}>
      <div className="w-full max-w-sm">
        <h1 className="font-heading font-bold text-3xl text-white mb-2">Sign in</h1>
        <p className="text-sm text-text-muted mb-10">Access your account and order history</p>

        {error && <p className="text-sm text-error mb-6">{error}</p>}

        <form className="flex flex-col gap-5" onSubmit={handleSubmit}>
          <Input
            label="Email"
            type="email"
            placeholder="you@company.com"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <Input
            label="Password"
            type="password"
            placeholder="Your password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <Button type="submit" variant="primary" size="lg" className="w-full mt-2" disabled={isDisabled}>
            {loading
              ? 'Signing in\u2026'
              : cooldown > 0
                ? `Wait ${cooldown}s`
                : 'Sign in'}
          </Button>
        </form>

        <p className="text-sm text-text-muted mt-8">
          No account?{' '}
          <Link to="/register" className="text-blue-bright hover:text-white transition-colors font-medium">
            Create one
          </Link>
        </p>
      </div>
    </div>
  );
}
