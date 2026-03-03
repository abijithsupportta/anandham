import 'package:flutter/material.dart';
import 'package:anandham_admin/app/routes/app_router.dart';
import 'package:anandham_admin/app/routes/route_names.dart';
import 'package:anandham_admin/app/theme/app_theme.dart';

class AnandhamAdminApp extends StatelessWidget {
  const AnandhamAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
