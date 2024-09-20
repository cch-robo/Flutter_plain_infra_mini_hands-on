// カウンター機能を Dependency Inject コンテナ対応にした、カウンターアプリのテストコード
// DIにより、カウンター機能（状態オブジェクト）のモック差替/テストダブル差替が簡易になります。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infra/src/step_4_di_use_example/counter_di.dart';
import 'package:infra/src/step_4_di_use_example/counter_page.dart';
import 'package:infra/src/step_4_di_use_example/additional_function.dart';

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

  testWidgets('Counter increments dark magic test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // 簡易DIコンテナから、カウンタ機能オブジェクトの参照（依存元） IDを取得する。
    CounterDiContainer di = CounterDiContainer.singleton;
    int id = di.listUpIds().first;

    // 簡易DIコンテナで、カウンタ機能オブジェクトの参照（依存元）を Dark Magic に注入する。
    DarkMagicCounter magic = DarkMagicCounter();
    di.mount(id, magic);

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    magic.count = 99;
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);
    expect(find.text('100'), findsOneWidget);

    // 後始末
    di.unmount(id);
  });
}
