import { supabase } from './supabase';
import type { Tables } from '@/types/database';

type NotificationRow = Tables<'notifications'>;

export type NotificationType = 'order_update' | 'promotion' | 'stock_alert' | 'system';

export interface AppNotification {
  id: string;
  userId: string;
  type: NotificationType;
  title: string;
  body: string;
  imageUrl?: string;
  data: Record<string, unknown>;
  isRead: boolean;
  createdAt: string;
}

export function mapNotificationRow(row: NotificationRow): AppNotification {
  return {
    id: row.id,
    userId: row.user_id,
    type: row.type as NotificationType,
    title: row.title,
    body: row.body,
    imageUrl: row.image_url ?? undefined,
    data: (row.data ?? {}) as Record<string, unknown>,
    isRead: row.is_read,
    createdAt: row.created_at,
  };
}

export async function fetchNotifications(limit = 20): Promise<AppNotification[]> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return [];
  const { data, error } = await supabase
    .from('notifications')
    .select('*')
    .eq('user_id', user.id)
    .order('created_at', { ascending: false })
    .limit(limit);
  if (error) throw new Error(error.message);
  return (data ?? []).map(mapNotificationRow);
}

export async function markAsRead(id: string): Promise<void> {
  const { error } = await supabase
    .from('notifications')
    .update({ is_read: true })
    .eq('id', id);
  if (error) throw new Error(error.message);
}

export async function markAllAsRead(): Promise<void> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return;
  const { error } = await supabase
    .from('notifications')
    .update({ is_read: true })
    .eq('is_read', false)
    .eq('user_id', user.id);
  if (error) throw new Error(error.message);
}
