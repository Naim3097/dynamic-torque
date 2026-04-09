import { useState, useMemo } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '@/stores/authStore';
import { Input, Button } from '@/components/ui';

interface PasswordCheck {
  label: string;
  passed: boolean;
}

function getPasswordChecks(pw: string): PasswordCheck[] {
  return [
    { label: 'At least 8 characters', passed: pw.length >= 8 },
    { label: 'One uppercase letter', passed: /[A-Z]/.test(pw) },
    { label: 'One lowercase letter', passed: /[a-z]/.test(pw) },
    { label: 'One digit', passed: /[0-9]/.test(pw) },
    { label: 'One special character (!@#$%...)', passed: /[^A-Za-z0-9]/.test(pw) },
  ];
}

export function RegisterPage() {
  const navigate = useNavigate();
  const register = useAuthStore((s) => s.register);
  const user = useAuthStore((s) => s.user);
  const loading = useAuthStore((s) => s.loading);

  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [pendingEmail, setPendingEmail] = useState<string | null>(null);

  const passwordChecks = useMemo(() => getPasswordChecks(password), [password]);
  const allChecksPassed = passwordChecks.every((c) => c.passed);

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

  if (pendingEmail) {
    return (
      <div className="container-main text-center" style={{ paddingTop: '6rem', paddingBottom: '4rem' }}>
        <h1 className="font-heading font-bold text-3xl text-white mb-3">Check your inbox</h1>
        <p className="text-sm text-text-muted mb-2 max-w-md mx-auto">
          We've sent a confirmation link to <span className="text-white">{pendingEmail}</span>.
        </p>
        <p className="text-sm text-text-muted mb-8 max-w-md mx-auto">
          Click the link to activate your account, then sign in.
        </p>
        <Link to="/login">
          <Button variant="primary" size="md">Go to sign in</Button>
        </Link>
      </div>
    );
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    if (!fullName.trim() || !email.trim() || !password.trim()) {
      setError('All fields are required');
      return;
    }
    if (!allChecksPassed) {
      setError('Password does not meet complexity requirements');
      return;
    }
    const result = await register({ fullName, email, password });
    if (!result.success) {
      setError(result.error || 'Registration failed');
      return;
    }
    if (result.needsConfirmation) {
      setPendingEmail(email);
    } else {
      navigate('/account');
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
            onChange={(e) => setFullName(e.target.value)}
          />
          <Input
            label="Email"
            type="email"
            placeholder="you@company.com"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <div>
            <Input
              label="Password"
              type="password"
              placeholder="Min 8 characters"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
            {password.length > 0 && (
              <ul className="mt-3 space-y-1">
                {passwordChecks.map((check) => (
                  <li
                    key={check.label}
                    className={`text-xs flex items-center gap-1.5 ${
                      check.passed ? 'text-green-400' : 'text-text-muted'
                    }`}
                  >
                    <span>{check.passed ? '\u2713' : '\u2022'}</span>
                    {check.label}
                  </li>
                ))}
              </ul>
            )}
          </div>
          <Button type="submit" variant="primary" size="lg" className="w-full mt-2" disabled={loading}>
            {loading ? 'Creating account\u2026' : 'Create account'}
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
