import { Link } from 'react-router-dom';
import { Button } from '@/components/ui';

export function AboutPage() {
  return (
    <div className="container-main" style={{ paddingTop: '2.5rem', paddingBottom: '4rem' }}>
      <div className="max-w-2xl">
        <h1 className="font-heading font-bold text-3xl text-white mb-2">About</h1>
        <p className="text-sm text-text-muted mb-10">Specialist gearbox parts supplier since 2018</p>

        <div className="flex flex-col gap-6 text-[15px] text-text-muted leading-[1.75]">
          <p>
            MNA Dynamic Torque is a specialist marketplace for automatic transmission
            and gearbox spare parts. We supply workshops, independent resellers, and
            individual customers across Malaysia and beyond.
          </p>
          <p>
            Our inventory covers clutch plates, steel plates, auto filters, forward drums,
            oil pumps, piston seals, overhaul kits, and lubricants — everything needed for
            transmission rebuilds and servicing.
          </p>
          <p>
            Trade accounts are available for workshops and resellers with wholesale pricing
            and flexible ordering. Get in touch to set up your account.
          </p>
        </div>

        <div className="mt-12 pt-8 border-t border-white/5 flex flex-col sm:flex-row gap-4">
          <Link to="/catalog">
            <Button variant="primary" size="md">Browse Parts</Button>
          </Link>
          <Link to="/register">
            <Button variant="secondary" size="md">Create Trade Account</Button>
          </Link>
        </div>
      </div>
    </div>
  );
}
