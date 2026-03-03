import 'package:flutter/material.dart';
import 'package:anandham_author/app/routes/app_router.dart';
import 'package:anandham_author/app/routes/route_names.dart';
import 'package:anandham_author/app/theme/app_theme.dart';

class AnandhamAuthorApp extends StatelessWidget {
  const AnandhamAuthorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anandham Author',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
