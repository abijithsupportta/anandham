import 'package:anandham_user/app/routes/app_router.dart';
import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/presentation/blocs/dharmas/dharmas_state.dart';
import 'package:anandham_user/presentation/pages/blogs/blog_detail_page.dart';
import 'package:anandham_user/presentation/pages/content/dharma_detail_page.dart';
import 'package:anandham_user/presentation/pages/content/krithi_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pushNamed(
  WidgetTester tester, {
  required String route,
  Object? arguments,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      onGenerateRoute: AppRouter.generateRoute,
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, route, arguments: arguments);
              },
              child: const Text('go'),
            ),
          );
        },
      ),
    ),
  );

  await tester.tap(find.text('go'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('krithi detail route accepts map arguments', (tester) async {
    await _pushNamed(
      tester,
      route: RouteNames.krithiDetail,
      arguments: const {'id': 'k1', 'title': 'Krithi 1'},
    );

    expect(find.byType(KrithiDetailPage), findsOneWidget);
  });

  testWidgets('dharma detail route accepts DharmaItemView arguments', (
    tester,
  ) async {
    await _pushNamed(
      tester,
      route: RouteNames.dharmaDetail,
      arguments: const DharmaItemView(
        id: 'd1',
        title: 'Dharma 1',
        description: 'Description',
        translation: 'Translation',
        slokas: [],
        words: [],
      ),
    );

    expect(find.byType(DharmaDetailPage), findsOneWidget);
  });

  testWidgets('blog detail route works with missing arguments', (tester) async {
    await _pushNamed(tester, route: RouteNames.blogDetail);

    expect(find.byType(BlogDetailPage), findsOneWidget);
  });
}
