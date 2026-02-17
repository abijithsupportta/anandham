import 'package:flutter/material.dart';
import 'package:anandham_user/app/routes/app_router.dart';
import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/app/theme/app_theme.dart';

class AnandhamUserApp extends StatelessWidget {
  const AnandhamUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anandham',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
