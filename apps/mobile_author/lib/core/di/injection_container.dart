import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anandham_core/anandham_core.dart' hide ApiClient;
import 'package:anandham_author/core/network/api_client.dart';
import 'package:anandham_author/core/network/network_info.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Initializes all dependencies.
Future<void> init() async {
  //============================================================
  // External Dependencies
  //============================================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());

  //============================================================
  // Supabase Services (from anandham_core)
  //============================================================
  sl.registerLazySingleton(() => SupabaseConfig.client);

  //============================================================
  // Core
  //============================================================
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  //============================================================
  // Data Sources
  //============================================================
  // Register local and remote data sources here

  //============================================================
  // Repositories
  //============================================================
  // Register repository implementations here

  //============================================================
  // Use Cases
  //============================================================
  // Register use cases here

  //============================================================
  // BLoCs / Cubits
  //============================================================
  // Register BLoCs here
}
