import '../config/supabase_config.dart';
import '../models/order_model.dart';

class OrderService {
  OrderService._();
  static final instance = OrderService._();

  final _client = SupabaseConfig.client;

  /// Fetch all orders with line items (admin has full access via RLS).
  Future<List<Order>> fetchAll() async {
    final res = await _client
        .from('orders')
        .select('*, order_items(*)')
        .order('created_at', ascending: false);
    return (res as List)
        .map((r) => Order.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  /// Fetch a single order by id with line items.
  Future<Order?> fetchById(String id) async {
    final res = await _client
        .from('orders')
        .select('*, order_items(*)')
        .eq('id', id)
        .maybeSingle();
    if (res == null) return null;
    return Order.fromJson(res);
  }

  /// Update order status.
  Future<void> updateStatus(String id, String status) async {
    await _client.from('orders').update({'order_status': status}).eq('id', id);
  }

  /// Update payment status.
  Future<void> updatePaymentStatus(String id, String status) async {
    await _client.from('orders').update({'payment_status': status}).eq('id', id);
  }

  /// Set tracking number.
  Future<void> setTracking(String id, String trackingNumber) async {
    await _client
        .from('orders')
        .update({'tracking_number': trackingNumber})
        .eq('id', id);
  }
}
