import { useCallback, useEffect, useState } from 'react';
import { useAuthStore } from '@/stores/authStore';
import {
  onForegroundMessage,
  registerPushToken,
} from '@/services/firebaseMessaging';
import toast from 'react-hot-toast';

type PushPermission = 'default' | 'granted' | 'denied' | 'unsupported';

/**
 * Hook that exposes the current browser push permission state and an
 * `enable()` function. Also wires up foreground message handling so
 * incoming FCM payloads surface as toasts while the tab is open.
 */
export function usePushNotifications() {
  const user = useAuthStore((s) => s.user);
  const [permission, setPermission] = useState<PushPermission>(() => {
    if (typeof window === 'undefined' || !('Notification' in window)) return 'unsupported';
    return Notification.permission as PushPermission;
  });
  const [registering, setRegistering] = useState(false);

  const enable = useCallback(async (): Promise<boolean> => {
    if (permission === 'unsupported') return false;
    setRegistering(true);
    try {
      const token = await registerPushToken();
      setPermission(Notification.permission as PushPermission);
      return !!token;
    } catch (err) {
      console.error('Failed to register push token', err);
      return false;
    } finally {
      setRegistering(false);
    }
  }, [permission]);

  // Subscribe to foreground messages once the user is authenticated and has
  // granted permission (otherwise getMessaging() throws).
  useEffect(() => {
    if (!user || permission !== 'granted') return;
    let unsubscribe: (() => void) | undefined;
    try {
      unsubscribe = onForegroundMessage((payload) => {
        const title = payload.notification?.title ?? 'Notification';
        const body = payload.notification?.body ?? '';
        toast(`${title}${body ? ` — ${body}` : ''}`);
      });
    } catch (err) {
      console.warn('onForegroundMessage unavailable', err);
    }
    return () => {
      if (unsubscribe) unsubscribe();
    };
  }, [user, permission]);

  return { permission, registering, enable };
}
