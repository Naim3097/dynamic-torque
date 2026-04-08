import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '@/stores/authStore';
import { Input, Button } from '@/components/ui';

export function LoginPage() {
  const navigate = useNavigate();
  const login = useAuthStore(s => s.login);
  const user = useAuthStore(s => s.user);

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

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

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!email.trim() || !password.trim()) {
      setError('Please enter your email and password');
      return;
    }
    const result = login(email, password);
    if (result.success) {
      navigate('/account');
    } else {
      setError(result.error || 'Login failed');
    }
  }

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
            onChange={e => setEmail(e.target.value)}
          />
          <Input
            label="Password"
            type="password"
            placeholder="Your password"
            value={password}
            onChange={e => setPassword(e.target.value)}
          />
          <Button type="submit" variant="primary" size="lg" className="w-full mt-2">
            Sign in
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
