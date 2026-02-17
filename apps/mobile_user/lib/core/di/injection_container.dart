import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anandham_core/anandham_core.dart' hide ApiClient;
import 'package:anandham_user/core/network/api_client.dart';
import 'package:anandham_user/core/network/network_info.dart';
import 'package:anandham_user/data/datasources/local/local_data_source.dart';
import 'package:anandham_user/data/repositories/auth_repository_impl.dart';
import 'package:anandham_user/domain/repositories/auth_repository.dart';
import 'package:anandham_user/domain/usecases/get_current_user_usecase.dart';
import 'package:anandham_user/domain/usecases/sign_in_usecase.dart';
import 'package:anandham_user/domain/usecases/sign_out_usecase.dart';
import 'package:anandham_user/domain/usecases/sign_up_usecase.dart';
import 'package:anandham_user/presentation/blocs/auth/auth_cubit.dart';

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
  sl.registerLazySingleton(() => const FlutterSecureStorage());

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
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(secureStorage: sl()),
  );
  // sl.registerLazySingleton<RemoteDataSource>(
  //   () => RemoteDataSourceImpl(apiClient: sl()),
  // );

  //============================================================
  // Repositories
  //============================================================
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  //============================================================
  // Use Cases
  //============================================================
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  //============================================================
  // BLoCs / Cubits
  //============================================================
  sl.registerFactory(
    () => AuthCubit(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
}
