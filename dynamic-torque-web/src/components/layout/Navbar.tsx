import { Link, NavLink } from 'react-router-dom';
import { useCartStore } from '@/stores/cartStore';
import { useAuthStore } from '@/stores/authStore';
import { NotificationDropdown } from '@/components/notifications/NotificationDropdown';
import logo from '@/assets/logo.png';
import { useState } from 'react';

const navLinks = [
  { to: '/', label: 'Home' },
  { to: '/catalog', label: 'Parts' },
  { to: '/about', label: 'About' },
];

export function Navbar() {
  const totalItems = useCartStore(s => s.totalItems());
  const user = useAuthStore(s => s.user);
  const [menuOpen, setMenuOpen] = useState(false);

  const linkClass = (active: boolean) =>
    `text-[13px] font-medium tracking-wide transition-colors duration-150 ${
      active ? 'text-white' : 'text-text-muted hover:text-white'
    }`;

  const accountLink = user ? '/account' : '/login';
  const accountLabel = user ? user.fullName.split(' ')[0] : 'Account';

  return (
    <header className="fixed top-0 left-0 right-0 z-50 bg-bg-primary border-b border-white/[0.06]">
      <nav className="container-main h-16 flex items-center justify-between">
        <Link to="/" className="shrink-0">
          <img src={logo} alt="MNA Dynamic Torque" className="h-7 w-auto" />
        </Link>

        {/* Desktop */}
        <div className="hidden md:flex items-center gap-8">
          {navLinks.map(link => (
            <NavLink
              key={link.to}
              to={link.to}
              end={link.to === '/'}
              className={({ isActive }) => linkClass(isActive)}
            >
              {link.label}
            </NavLink>
          ))}
          {user && (
            <NavLink to="/orders" className={({ isActive }) => linkClass(isActive)}>
              Orders
            </NavLink>
          )}
          {user && <NotificationDropdown />}
          <Link to="/cart" className={linkClass(false)}>
            Cart{totalItems > 0 ? ` (${totalItems})` : ''}
          </Link>
          <NavLink to={accountLink} className={({ isActive }) => linkClass(isActive)}>
            {accountLabel}
          </NavLink>
        </div>

        {/* Mobile toggle */}
        <button
          className="md:hidden text-[13px] font-medium text-text-muted hover:text-white tracking-wide"
          onClick={() => setMenuOpen(!menuOpen)}
          aria-label="Toggle menu"
        >
          {menuOpen ? 'Close' : 'Menu'}
        </button>
      </nav>

      {/* Mobile menu */}
      {menuOpen && (
        <div className="md:hidden bg-bg-primary border-t border-white/[0.06]">
          <div className="container-main py-5 flex flex-col gap-4">
            {navLinks.map(link => (
              <NavLink
                key={link.to}
                to={link.to}
                end={link.to === '/'}
                onClick={() => setMenuOpen(false)}
                className={({ isActive }) =>
                  `text-sm font-medium ${isActive ? 'text-white' : 'text-text-muted'}`
                }
              >
                {link.label}
              </NavLink>
            ))}
            {user && (
              <Link to="/orders" onClick={() => setMenuOpen(false)} className="text-sm font-medium text-text-muted">
                Orders
              </Link>
            )}
            <Link to="/cart" onClick={() => setMenuOpen(false)} className="text-sm font-medium text-text-muted">
              Cart{totalItems > 0 ? ` (${totalItems})` : ''}
            </Link>
            <Link to={accountLink} onClick={() => setMenuOpen(false)} className="text-sm font-medium text-text-muted">
              {accountLabel}
            </Link>
          </div>
        </div>
      )}
    </header>
  );
}
