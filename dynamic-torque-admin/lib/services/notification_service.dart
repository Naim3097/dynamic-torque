import '../config/supabase_config.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _client = SupabaseConfig.client;

  /// Send a push notification via the send-push Edge Function.
  /// Returns the number of recipients and tokens pushed.
  Future<Map<String, dynamic>> sendPush({
    String? userId,
    String? target, // 'all', 'b2b', 'b2c'
    required String title,
    required String body,
    String? type,
    Map<String, String>? data,
  }) async {
    final payload = <String, dynamic>{
      'title': title,
      'body': body,
    };
    if (userId != null) payload['user_id'] = userId;
    if (target != null) payload['target'] = target;
    if (type != null) payload['type'] = type;
    if (data != null) payload['data'] = data;

    final res = await _client.functions.invoke(
      'send-push',
      body: payload,
    );

    if (res.status != 200) {
      throw Exception('send-push failed: ${res.data}');
    }

    return res.data is Map ? Map<String, dynamic>.from(res.data) : {};
  }

  /// Record a broadcast in the notification_broadcasts table.
  Future<void> recordBroadcast({
    required String title,
    required String body,
    required String target,
    String? targetUserId,
    String? deepLink,
    String? imageUrl,
    String? createdBy,
  }) async {
    await _client.from('notification_broadcasts').insert({
      'title': title,
      'body': body,
      'target': target,
      'target_user_id': targetUserId,
      'deep_link': deepLink,
      'image_url': imageUrl,
      'created_by': createdBy,
      'sent_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  /// Fetch broadcast history.
  Future<List<Map<String, dynamic>>> fetchBroadcasts() async {
    final res = await _client
        .from('notification_broadcasts')
        .select()
        .order('created_at', ascending: false)
        .limit(50);
    return List<Map<String, dynamic>>.from(res);
  }
}
