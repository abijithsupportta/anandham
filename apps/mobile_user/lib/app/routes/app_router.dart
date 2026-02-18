import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/core/di/injection_container.dart';
import 'package:anandham_user/presentation/pages/home/home_page.dart';
import 'package:anandham_user/presentation/pages/auth/login_page.dart';
import 'package:anandham_user/presentation/pages/auth/register_page.dart';
import 'package:anandham_user/presentation/pages/main_shell/main_shell_page.dart';
import 'package:anandham_user/presentation/blocs/auth/auth_cubit.dart';
import 'package:anandham_user/presentation/pages/splash/splash_page.dart';
import 'package:anandham_user/presentation/pages/content/krithis_list_page.dart';
import 'package:anandham_user/presentation/pages/content/krithi_detail_page.dart';
import 'package:anandham_user/presentation/pages/content/dharmas_list_page.dart';
import 'package:anandham_user/presentation/pages/content/dharma_detail_page.dart';
import 'package:anandham_user/presentation/pages/content/keerthanams_list_page.dart';
import 'package:anandham_user/presentation/pages/content/keerthanam_detail_page.dart';
import 'package:anandham_user/presentation/pages/content/photos_list_page.dart';
import 'package:anandham_user/presentation/blocs/dharmas/dharmas_state.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const MainShellPage(),
          settings: settings,
        );
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthCubit>(
            create: (_) => sl<AuthCubit>(),
            child: const LoginPage(),
          ),
          settings: settings,
        );
      case RouteNames.register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthCubit>(
            create: (_) => sl<AuthCubit>(),
            child: const RegisterPage(),
          ),
          settings: settings,
        );
      case RouteNames.homeTab:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case RouteNames.krithisList:
        return MaterialPageRoute(
          builder: (_) => const KrithisListPage(),
          settings: settings,
        );
      case RouteNames.krithiDetail:
        final krithi = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => KrithiDetailPage(krithi: krithi),
          settings: settings,
        );
      case RouteNames.dharmasList:
        return MaterialPageRoute(
          builder: (_) => const DharmasListPage(),
          settings: settings,
        );
      case RouteNames.dharmaDetail:
        final dharma = settings.arguments as DharmaItemView;
        return MaterialPageRoute(
          builder: (_) => DharmaDetailPage(dharma: dharma),
          settings: settings,
        );
      case RouteNames.keerthanamsList:
        return MaterialPageRoute(
          builder: (_) => const KeerthanamsListPage(),
          settings: settings,
        );
      case RouteNames.keerthanamDetail:
        final keerthanam = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => KeerthanamDetailPage(keerthanam: keerthanam),
          settings: settings,
        );
      case RouteNames.photosList:
        return MaterialPageRoute(
          builder: (_) => const PhotosListPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }
}
