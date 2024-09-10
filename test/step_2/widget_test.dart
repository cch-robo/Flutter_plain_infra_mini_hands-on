// カウンター機能を Dependency Inject コンテナ対応にした、カウンターアプリのテストコード
// DIにより、カウンター機能（状態オブジェクト）のモック差替/テストダブル差替が簡易になります。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infra/src/step_2/counter_di.dart';
import 'package:infra/src/step_2/counter_page.dart';

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

  // TODO add line start.
  testWidgets('Counter increments mock test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    CounterDiContainer di = CounterDiContainer.singleton;
    int id = di.listUpIds().first;

    MockCounter mock = MockCounter();
    di.swapReference(id, mock);

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    // カウンタ値を99に設定する。
    mock.count = 99;
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);
    expect(find.text('100'), findsOneWidget);
  });
  // TODO add line end.
}

// TODO add line start.
/// DI コンテナを介して参照可能で、動的注入されるモックオブジェクト
///
/// _テストコードから値読み出しや状態更新など操作可能_
class MockCounter implements ReferencableCounter {
  MockCounter();

  @override
  int get id => hashCode;

  // ignore: prefer_final_fields
  late int? _value;

  @override
  int get count => _value!;

  @override
  set count(int value) => _value = value;

  @override
  void clear() => _value = 0;

  @override
  void increment() => count++;
}
// TODO add line end.
