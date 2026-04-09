import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../config/supabase_config.dart';

class AuthService extends ChangeNotifier {
  AdminUser? _admin;
  bool _loading = false;
  bool _initialized = false;

  AdminUser? get user => _admin;
  AdminUser? get currentAdmin => _admin;
  bool get isAuthenticated => _admin != null;
  bool get loading => _loading;
  bool get initialized => _initialized;

  SupabaseClient get _client => SupabaseConfig.client;

  /// Call once from main() after SupabaseConfig.init().
  Future<void> init() async {
    _loading = true;
    notifyListeners();

    // Check for an existing session.
    final session = _client.auth.currentSession;
    if (session != null) {
      await _loadAdminProfile(session.user.id);
    }

    // Listen for future auth changes (token refresh, sign-out, etc.).
    _client.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        await _loadAdminProfile(session.user.id);
      } else {
        _admin = null;
        notifyListeners();
      }
    });

    _initialized = true;
    _loading = false;
    notifyListeners();
  }

  /// Sign in with email + password. Returns true if the user is an admin.
  Future<bool> login(String email, String password) async {
    _loading = true;
    notifyListeners();

    try {
      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user == null) {
        _loading = false;
        notifyListeners();
        return false;
      }

      final ok = await _loadAdminProfile(res.user!.id);
      if (!ok) {
        // User exists but is not an admin — sign them out.
        await _client.auth.signOut();
        _admin = null;
      }

      _loading = false;
      notifyListeners();
      return ok;
    } catch (e) {
      debugPrint('Login error: $e');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  /// Load admin profile from `admin_users` + `users` tables.
  /// Returns false if the user has no admin_users row.
  Future<bool> _loadAdminProfile(String userId) async {
    try {
      final adminRow = await _client
          .from('admin_users')
          .select('role')
          .eq('user_id', userId)
          .maybeSingle();

      if (adminRow == null) return false;

      final userRow = await _client
          .from('users')
          .select('email, display_name')
          .eq('id', userId)
          .maybeSingle();

      _admin = AdminUser(
        id: userId,
        email: userRow?['email'] as String? ?? '',
        fullName: userRow?['display_name'] as String? ?? '',
        role: adminRow['role'] as String,
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Failed to load admin profile: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
    _admin = null;
    notifyListeners();
  }

  void signOut() => logout();
}
