// カウンター機能を Dependency Inject コンテナ対応にした、カウンターアプリのテストコード
// DIにより、カウンター機能（状態オブジェクト）のモック差替/テストダブル差替が簡易になります。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infra/src/infra/debug_logger.dart';
import 'package:infra/src/infra/dependency_injector.dart';
import 'package:infra/src/step_4/counter_di.dart';
import 'package:infra/src/step_4/counter_page.dart';
/*
import 'package:infra/src/step_di_usage/counter_di.dart';
import 'package:infra/src/step_di_usage/counter_page.dart';
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
    mock.count = 99;
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);
    expect(find.text('100'), findsOneWidget);
  });

  // TODO add line start.
  testWidgets('Counter increments reference test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    CounterDiContainer di = CounterDiContainer.singleton;
    int id = di.listUpIds().first;

    // アプリ内で生成された、カウンタ機能オブジェクトの参照を取得する。
    Injectable<ReferencableCounter> injector = di.getInjector(id);
    ReferencableCounter reference = injector.reference!;

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    reference.count = 99;
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);
    expect(find.text('100'), findsOneWidget);
  });
  // TODO add line end.

  // TODO add line start.
  testWidgets('Counter increments dark magic test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    CounterDiContainer di = CounterDiContainer.singleton;
    int id = di.listUpIds().first;

    // アプリ内で生成された、カウンタ機能オブジェクトの参照を取得する。
    Injectable<ReferencableCounter> injector = di.getInjector(id);
    ReferencableCounter reference = injector.reference!;

    // Dark Magic に、カウンタ機能オブジェクトの参照（依存元）を注入する。
    DarkMagicCounter magic = DarkMagicCounter();
    magic.init(reference);

    // 注入先の依存元を Dark Magic と差し替える。
    injector.swap(magic);

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    magic.count = 99;
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);
    expect(find.text('100'), findsOneWidget);

    // 後始末
    injector.swap(reference);
    magic.dispose();
  });
  // TODO add line end.
}

/// DI コンテナを介して参照可能で、動的注入されるモックオブジェクト
///
/// _テストコードから値読み出しや状態更新など操作可能_
class MockCounter extends AbstractReferencable implements ReferencableCounter {
  // ignore: prefer_final_fields
  late int? _value;

  MockCounter();

  @override
  int get count => _value!;

  @override
  set count(int value) => _value = value;

  @override
  void increment() => count++;
}

// TODO add line start.
/// 自身に依存元が注入され、注入先の依存元として差し替えられる「多段階の入れ子注入先」
class DarkMagicCounter extends AbstractInjectable<ReferencableCounter>
    implements InjectableCounter {
  DarkMagicCounter();

  @override
  int get count {
    return reference!.count;
  }

  @override
  set count(int value) => reference!.count = value;

  @override
  void increment() {
    reference!.increment();
    debugLog('increment!');
  }
}
// TODO add line end.
