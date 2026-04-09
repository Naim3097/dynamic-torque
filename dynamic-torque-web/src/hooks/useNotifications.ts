import { useEffect } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import {
  fetchNotifications,
  markAllAsRead,
  markAsRead,
} from '@/services/notificationService';
import { subscribeToUserNotifications, unsubscribe } from '@/services/realtime';
import { useAuthStore } from '@/stores/authStore';

export function useNotifications() {
  const queryClient = useQueryClient();
  const user = useAuthStore((s) => s.user);

  const query = useQuery({
    queryKey: ['notifications', user?.id],
    queryFn: () => fetchNotifications(20),
    enabled: !!user,
    staleTime: 30_000,
  });

  // Live-insert new notifications into the cache as they arrive.
  useEffect(() => {
    if (!user?.id) return;
    const channel = subscribeToUserNotifications(user.id, () => {
      queryClient.invalidateQueries({ queryKey: ['notifications', user.id] });
    });
    return () => {
      unsubscribe(channel);
    };
  }, [user?.id, queryClient]);

  const markRead = useMutation({
    mutationFn: (id: string) => markAsRead(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['notifications', user?.id] });
    },
  });

  const markAllRead = useMutation({
    mutationFn: markAllAsRead,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['notifications', user?.id] });
    },
  });

  const unreadCount = (query.data ?? []).filter((n) => !n.isRead).length;

  return {
    ...query,
    unreadCount,
    markRead: markRead.mutate,
    markAllRead: markAllRead.mutate,
  };
}
