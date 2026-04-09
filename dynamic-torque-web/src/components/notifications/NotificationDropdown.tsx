import { useEffect, useRef, useState } from 'react';
import { useNotifications } from '@/hooks/useNotifications';
import { formatDistanceToNow } from '@/utils/formatDate';

/**
 * Plain-text "Notifications" label in the nav that opens a dropdown list.
 * No bell icon (per ui-ux.md).
 */
export function NotificationDropdown() {
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);
  const { data: notifications = [], unreadCount, markRead, markAllRead } = useNotifications();

  // Close when clicking outside
  useEffect(() => {
    if (!open) return;
    const handler = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, [open]);

  return (
    <div ref={ref} className="relative">
      <button
        onClick={() => setOpen((v) => !v)}
        className="text-[13px] font-medium tracking-wide text-text-muted hover:text-white transition-colors duration-150"
      >
        Notifications{unreadCount > 0 ? ` (${unreadCount})` : ''}
      </button>

      {open && (
        <div className="absolute right-0 top-full mt-3 w-80 bg-bg-secondary rounded-md border border-white/[0.06] shadow-lg overflow-hidden">
          <div className="flex items-center justify-between px-5 py-3 border-b border-white/[0.06]">
            <span className="text-sm font-semibold text-white">Notifications</span>
            {unreadCount > 0 && (
              <button
                onClick={() => markAllRead()}
                className="text-[12px] text-text-muted hover:text-white transition-colors"
              >
                Mark all read
              </button>
            )}
          </div>

          <div className="max-h-96 overflow-y-auto">
            {notifications.length === 0 ? (
              <p className="text-[13px] text-text-muted px-5 py-8 text-center">
                No notifications yet.
              </p>
            ) : (
              <ul className="flex flex-col">
                {notifications.map((n) => (
                  <li
                    key={n.id}
                    className={`px-5 py-4 border-b border-white/[0.04] last:border-0 cursor-pointer hover:bg-surface/40 transition-colors ${
                      n.isRead ? 'opacity-60' : ''
                    }`}
                    onClick={() => !n.isRead && markRead(n.id)}
                  >
                    <div className="flex justify-between gap-3 mb-1">
                      <span className="text-sm text-white font-medium truncate">{n.title}</span>
                      <span className="text-[11px] text-text-muted/70 shrink-0">
                        {formatDistanceToNow(n.createdAt)}
                      </span>
                    </div>
                    <p className="text-[13px] text-text-muted leading-snug">{n.body}</p>
                  </li>
                ))}
              </ul>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
