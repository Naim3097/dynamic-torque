import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// Manages Supabase Realtime subscriptions for the admin app.
class RealtimeService {
  RealtimeService._();
  static final instance = RealtimeService._();

  final _client = SupabaseConfig.client;
  RealtimeChannel? _notificationsChannel;
  RealtimeChannel? _ordersChannel;

  /// Subscribe to new notifications for the current admin user.
  /// Calls [onNotification] with the row data whenever a new row is inserted.
  void subscribeToNotifications({
    required String userId,
    required void Function(Map<String, dynamic> payload) onNotification,
  }) {
    _notificationsChannel?.unsubscribe();
    _notificationsChannel = _client
        .channel('admin-notifications')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            onNotification(payload.newRecord);
          },
        )
        .subscribe();
  }

  /// Subscribe to all order changes (new orders + status updates).
  void subscribeToOrders({
    required void Function(Map<String, dynamic> payload) onOrderChange,
  }) {
    _ordersChannel?.unsubscribe();
    _ordersChannel = _client
        .channel('admin-orders')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'orders',
          callback: (payload) {
            onOrderChange(payload.newRecord);
          },
        )
        .subscribe();
  }

  /// Unsubscribe from all channels.
  void dispose() {
    _notificationsChannel?.unsubscribe();
    _ordersChannel?.unsubscribe();
  }
}
