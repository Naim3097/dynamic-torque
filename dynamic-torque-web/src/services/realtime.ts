import type { RealtimeChannel } from '@supabase/supabase-js';
import { supabase } from './supabase';
import type { Tables } from '@/types/database';

type OrderRow = Tables<'orders'>;
type NotificationRow = Tables<'notifications'>;

export function subscribeToOrder(
  orderId: string,
  onChange: (row: OrderRow) => void
): RealtimeChannel {
  return supabase
    .channel(`order:${orderId}`)
    .on(
      'postgres_changes',
      {
        event: 'UPDATE',
        schema: 'public',
        table: 'orders',
        filter: `id=eq.${orderId}`,
      },
      (payload) => onChange(payload.new as OrderRow)
    )
    .subscribe();
}

export function subscribeToUserNotifications(
  userId: string,
  onInsert: (row: NotificationRow) => void
): RealtimeChannel {
  return supabase
    .channel(`notifications:${userId}`)
    .on(
      'postgres_changes',
      {
        event: 'INSERT',
        schema: 'public',
        table: 'notifications',
        filter: `user_id=eq.${userId}`,
      },
      (payload) => onInsert(payload.new as NotificationRow)
    )
    .subscribe();
}

export function unsubscribe(channel: RealtimeChannel) {
  supabase.removeChannel(channel);
}
