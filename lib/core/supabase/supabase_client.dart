import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper around the Supabase client. Only touched when the user
/// opts into encrypted backup — the app has no server dependency
/// otherwise. See ARCHITECTURE.md for why the backend's role is
/// deliberately minimal.
class AppSupabase {
  AppSupabase._();

  static Future<void> init({
    required String url,
    required String anonKey,
  }) {
    return Supabase.initialize(url: url, anonKey: anonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
