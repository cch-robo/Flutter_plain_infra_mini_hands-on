// カウンター機能を Dependency Inject コンテナ対応にした、カウンターアプリのテストコード
// DIにより、カウンター機能（状態オブジェクト）のモック差替/テストダブル差替が簡易になります。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infra/src/step_3/counter_di.dart';
import 'package:infra/src/step_3/counter_page.dart';

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

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    CounterRepository di = CounterRepository.singleton;
    int id = di.listUpIds().first;

    MockCounter mock = MockCounter();
    di.swapReference(id, mock);

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    mock.count = 100;
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);
    expect(find.text('101'), findsOneWidget);
  });
}

/// DI コンテナを介して参照可能で、動的注入されるモックオブジェクト
///
/// _テストコードから値読み出しや状態更新など操作可能_
class MockCounter implements ReferencableCounter {
  MockCounter();

  // ignore: prefer_final_fields
  int _count = 0;

  @override
  int get count => _count;

  @override
  set count(int value) => _count = value;

  @override
  int get id => hashCode;

  @override
  void clear() {
    count = 0;
  }

  @override
  void increment() {
    count++;
  }
}
