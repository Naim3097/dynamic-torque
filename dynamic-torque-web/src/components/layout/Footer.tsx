import { Link } from 'react-router-dom';

const footerLinks = [
  { to: '/', label: 'Home' },
  { to: '/catalog', label: 'Parts' },
  { to: '/about', label: 'About' },
];

export function Footer() {
  return (
    <footer className="bg-bg-secondary mt-auto border-t border-white/[0.06]">
      <div className="container-main py-14">
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-10">
          {/* Navigation */}
          <div>
            <p className="text-[13px] font-semibold text-white tracking-wide mb-4">Navigation</p>
            <ul className="flex flex-col gap-2.5">
              {footerLinks.map(link => (
                <li key={link.to}>
                  <Link
                    to={link.to}
                    className="text-sm text-text-muted hover:text-white transition-colors duration-150"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Contact */}
          <div>
            <p className="text-[13px] font-semibold text-white tracking-wide mb-4">Contact</p>
            <ul className="flex flex-col gap-2.5 text-sm text-text-muted">
              <li>info@dynamictorque.com</li>
              <li>+60 12-345 6789</li>
              <li>Kuala Lumpur, Malaysia</li>
            </ul>
          </div>

          {/* Legal */}
          <div>
            <p className="text-[13px] font-semibold text-white tracking-wide mb-4">Legal</p>
            <ul className="flex flex-col gap-2.5 text-sm text-text-muted">
              <li className="hover:text-white transition-colors duration-150 cursor-pointer">Terms of Service</li>
              <li className="hover:text-white transition-colors duration-150 cursor-pointer">Privacy Policy</li>
              <li className="hover:text-white transition-colors duration-150 cursor-pointer">Returns</li>
            </ul>
          </div>
        </div>
      </div>

      <div className="border-t border-white/[0.04]">
        <div className="container-main py-5">
          <p className="text-xs text-text-muted/50">
            &copy; {new Date().getFullYear()} MNA Dynamic Torque. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}
