import '../config/supabase_config.dart';
import '../models/product_model.dart';

class ProductService {
  ProductService._();
  static final instance = ProductService._();

  final _client = SupabaseConfig.client;

  /// Fetch all products (admin sees all, including inactive).
  Future<List<Product>> fetchAll() async {
    final res = await _client
        .from('products')
        .select()
        .order('created_at', ascending: false);
    return (res as List).map((r) => Product.fromJson(r)).toList();
  }

  /// Fetch a single product by id.
  Future<Product?> fetchById(String id) async {
    final res = await _client.from('products').select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return Product.fromJson(res);
  }

  /// Create a new product.
  Future<Product> create(Product product) async {
    final res = await _client
        .from('products')
        .insert(product.toJson())
        .select()
        .single();
    return Product.fromJson(res);
  }

  /// Update an existing product.
  Future<Product> update(String id, Map<String, dynamic> patch) async {
    final res = await _client
        .from('products')
        .update(patch)
        .eq('id', id)
        .select()
        .single();
    return Product.fromJson(res);
  }

  /// Toggle active status.
  Future<void> toggleActive(String id, bool isActive) async {
    await _client.from('products').update({'is_active': isActive}).eq('id', id);
  }

  /// Delete a product.
  Future<void> delete(String id) async {
    await _client.from('products').delete().eq('id', id);
  }
}
