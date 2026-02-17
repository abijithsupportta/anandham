import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized Supabase configuration for all Anandham apps.
///
/// Usage:
/// ```dart
/// await SupabaseConfig.initialize();
/// final client = SupabaseConfig.client;
/// ```
class SupabaseConfig {
  SupabaseConfig._();

  // ── Project Credentials ──────────────────────────────────────────────
  static const String _supabaseUrl =
      'https://vksqkmtdysbzomrhlcqv.supabase.co';
  static const String _supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
      'eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZrc3FrbXRkeXNiem9tcmhsY3F2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzEzMTcwNzMsImV4cCI6MjA4Njg5MzA3M30.'
      'Td4cbaTsTF_xn27Ylapr_V5y8t9jmBrBrPrnJimx0VA';

  /// Initialize Supabase. Call once in `main()` before `runApp`.
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
  }

  /// The global Supabase client instance.
  static SupabaseClient get client => Supabase.instance.client;

  /// Shortcut to the auth module.
  static GoTrueClient get auth => client.auth;

  /// Shortcut to the database (PostgREST).
  static SupabaseQueryBuilder Function(String table) get from => client.from;

  /// Shortcut to the storage module.
  static SupabaseStorageClient get storage => client.storage;

  /// Shortcut to the realtime module.
  static RealtimeClient get realtime => client.realtime;

  /// Shortcut to the functions (Edge Functions) module.
  static FunctionsClient get functions => client.functions;

  /// The currently authenticated user, or `null`.
  static User? get currentUser => auth.currentUser;

  /// The current session, or `null`.
  static Session? get currentSession => auth.currentSession;

  /// Whether a user is currently signed in.
  static bool get isAuthenticated => currentUser != null;
}
