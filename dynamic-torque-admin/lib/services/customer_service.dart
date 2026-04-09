import '../config/supabase_config.dart';
import '../models/user_model.dart';

class CustomerService {
  CustomerService._();
  static final instance = CustomerService._();

  final _client = SupabaseConfig.client;

  /// Fetch all customer profiles (admin has RLS access to all users).
  Future<List<AppUser>> fetchAll() async {
    final res = await _client
        .from('users')
        .select()
        .order('created_at', ascending: false);
    return (res as List).map((r) => AppUser.fromJson(r)).toList();
  }
}
