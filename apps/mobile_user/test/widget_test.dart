import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anandham_user/app/routes/app_router.dart';
import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/core/di/injection_container.dart' as di;

void main() {
  testWidgets('Login page renders email and password fields', (
    WidgetTester tester,
  ) async {
    await di.init();

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: RouteNames.login,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );

    expect(find.byKey(const Key('login_email')), findsOneWidget);
    expect(find.byKey(const Key('login_password')), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });
}
