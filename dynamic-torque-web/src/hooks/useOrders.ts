import { useEffect } from 'react';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { fetchOrderById, fetchUserOrders } from '@/services/orderService';
import { subscribeToOrder, unsubscribe } from '@/services/realtime';
import { useAuthStore } from '@/stores/authStore';

export function useUserOrders() {
  const user = useAuthStore((s) => s.user);
  return useQuery({
    queryKey: ['orders', 'user', user?.id],
    queryFn: fetchUserOrders,
    enabled: !!user,
    staleTime: 30_000,
  });
}

export function useOrder(id: string | undefined) {
  const queryClient = useQueryClient();

  const query = useQuery({
    queryKey: ['orders', 'detail', id],
    queryFn: () => fetchOrderById(id!),
    enabled: !!id,
    staleTime: 15_000,
  });

  // Live-update the cached order when it changes in Postgres.
  useEffect(() => {
    if (!id) return;
    const channel = subscribeToOrder(id, () => {
      queryClient.invalidateQueries({ queryKey: ['orders', 'detail', id] });
      queryClient.invalidateQueries({ queryKey: ['orders', 'user'] });
    });
    return () => {
      unsubscribe(channel);
    };
  }, [id, queryClient]);

  return query;
}
