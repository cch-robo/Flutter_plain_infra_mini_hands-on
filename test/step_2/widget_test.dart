// カウンター機能の Dependency Inject コンテナ対応が不十分な、カウンターアプリのテストコード
// DIコンテナは、依存注入に対応していないのでテストで使っていないため、オリジナルと変わらない。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infra/src/step_2/counter_page.dart';
/*
import 'package:infra/src/step_di_creatable/counter_page.dart';
*/

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
