import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// Thin convenience wrapper around the Supabase client singleton.
///
/// All Postgres / Auth / Storage / Realtime access in the admin app should
/// flow through this service so tests can stub it in one place.
class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  SupabaseClient get client => SupabaseConfig.client;

  GoTrueClient get auth => client.auth;
  SupabaseStorageClient get storage => client.storage;
  RealtimeClient get realtime => client.realtime;

  User? get currentUser => auth.currentUser;
  Session? get currentSession => auth.currentSession;
  bool get isSignedIn => currentSession != null;
}
