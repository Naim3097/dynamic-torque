import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '@/stores/authStore';
import { Input, Button } from '@/components/ui';

export function RegisterPage() {
  const navigate = useNavigate();
  const register = useAuthStore(s => s.register);
  const user = useAuthStore(s => s.user);

  const [fullName, setFullName] = useState('');
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
    if (!fullName.trim() || !email.trim() || !password.trim()) {
      setError('All fields are required');
      return;
    }
    if (password.length < 8) {
      setError('Password must be at least 8 characters');
      return;
    }
    const result = register({ fullName, email, password });
    if (result.success) {
      navigate('/account');
    } else {
      setError(result.error || 'Registration failed');
    }
  }

  return (
    <div className="container-main flex justify-center" style={{ paddingTop: '4rem', paddingBottom: '4rem' }}>
      <div className="w-full max-w-sm">
        <h1 className="font-heading font-bold text-3xl text-white mb-2">Create account</h1>
        <p className="text-sm text-text-muted mb-10">Start ordering parts for your workshop</p>

        {error && <p className="text-sm text-error mb-6">{error}</p>}

        <form className="flex flex-col gap-5" onSubmit={handleSubmit}>
          <Input
            label="Full name"
            type="text"
            placeholder="Your name"
            value={fullName}
            onChange={e => setFullName(e.target.value)}
          />
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
            placeholder="Min 8 characters"
            value={password}
            onChange={e => setPassword(e.target.value)}
          />
          <Button type="submit" variant="primary" size="lg" className="w-full mt-2">
            Create account
          </Button>
        </form>

        <p className="text-sm text-text-muted mt-8">
          Already have an account?{' '}
          <Link to="/login" className="text-blue-bright hover:text-white transition-colors font-medium">
            Sign in
          </Link>
        </p>
      </div>
    </div>
  );
}
