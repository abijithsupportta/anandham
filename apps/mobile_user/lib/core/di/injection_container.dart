import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_user/data/local/db/app_database.dart';
import 'package:anandham_user/data/repositories/blogs_repository_impl.dart';
import 'package:anandham_user/data/repositories/home_repository_impl.dart';
import 'package:anandham_user/data/repositories/local_content_repository.dart';
import 'package:anandham_user/data/repositories/profile_repository_impl.dart';
import 'package:anandham_user/data/repositories/auth_repository_impl.dart';
import 'package:anandham_user/data/services/content_sync_service.dart';
import 'package:anandham_user/data/services/saved_items_orchestration_service.dart';
import 'package:anandham_user/domain/repositories/auth_repository.dart';
import 'package:anandham_user/domain/repositories/blogs_repository.dart';
import 'package:anandham_user/domain/repositories/home_repository.dart';
import 'package:anandham_user/domain/repositories/profile_repository.dart';
import 'package:anandham_user/domain/usecases/get_blogs_page_usecase.dart';
import 'package:anandham_user/domain/usecases/get_current_user_usecase.dart';
import 'package:anandham_user/domain/usecases/get_home_content_types_usecase.dart';
import 'package:anandham_user/domain/usecases/get_profile_name_usecase.dart';
import 'package:anandham_user/domain/usecases/get_profile_usecase.dart';
import 'package:anandham_user/domain/usecases/sign_in_usecase.dart';
import 'package:anandham_user/domain/usecases/sign_out_usecase.dart';
import 'package:anandham_user/domain/usecases/sign_up_usecase.dart';
import 'package:anandham_user/domain/usecases/update_profile_usecase.dart';
import 'package:anandham_user/presentation/blocs/auth/auth_cubit.dart';
import 'package:anandham_user/presentation/blocs/blogs/blogs_list_cubit.dart';
import 'package:anandham_user/presentation/blocs/home/home_cubit.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Initializes all dependencies.
Future<void> init() async {
  //============================================================
  // External Dependencies
  //============================================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //============================================================
  // Supabase Services (from anandham_core)
  //============================================================
  sl.registerLazySingleton(() => SupabaseConfig.client);

  //============================================================
  // Repositories
  //============================================================
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl());
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());
  sl.registerLazySingleton<BlogsRepository>(() => BlogsRepositoryImpl());
  sl.registerLazySingleton(() => AppDatabase());
  sl.registerLazySingleton(() => LocalContentRepository(sl<AppDatabase>()));
  sl.registerLazySingleton(() => ContentSyncService(sl<AppDatabase>()));
  sl.registerLazySingleton(() => SavedItemsOrchestrationService(sl(), sl()));

  //============================================================
  // Use Cases
  //============================================================
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileNameUseCase(sl()));
  sl.registerLazySingleton(() => GetHomeContentTypesUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetBlogsPageUseCase(sl()));

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
  sl.registerFactory(() => BlogsListCubit(getBlogsPageUseCase: sl()));
  sl.registerFactory(
    () => HomeCubit(
      getProfileNameUseCase: sl(),
      getHomeContentTypesUseCase: sl(),
    ),
  );
}
