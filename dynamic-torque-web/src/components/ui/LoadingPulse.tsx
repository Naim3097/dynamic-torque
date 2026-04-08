export function LoadingPulse({ className = '' }: { className?: string }) {
  return (
    <div
      className={`bg-bg-secondary rounded-[10px] animate-pulse ${className}`}
      aria-label="Loading"
    />
  );
}
