// カウンター機能を Dependency Inject コンテナ対応にする。
//
// 依存注入先クラスは、注入された機能実装を提供するだけでなく、
// 特定メソド実行時のログ出力など..仕様機能にない要件の追加にも利用できます。

import '../infra/debug_logger.dart';
import '../infra/default_error.dart';
import '../infra/dependency_injector.dart';

/// Counter オブジェクトの DIコンテナ・クラス
class CounterDiContainer extends AbstractDependencyInjector<Counter, ReferencableCounter, InjectableCounter> {
  /// シングルトン・インスタンス
  static CounterDiContainer? _singletonInstance;

  /// シングルトン・ゲッター
  static CounterDiContainer get singleton {
    if (_singletonInstance == null) {
      _singletonInstance = CounterDiContainer._();
      return _singletonInstance!;
    }
    return _singletonInstance!;
  }

  /// プライベート・コンストラクタ
  CounterDiContainer._();

  /// Counter オブジェクト生成
  @override
  Counter create() {
    if (!checkDebugMode(isThrowError: false)) {
      CounterImpl counter = CounterImpl._();
      super.addContainer(counter.id, counter);
      return counter;
    }
    // デバッグモードの場合のみ Dependency Inject 可能にします。
    CounterDouble counter = CounterDouble._();
    CounterImpl inject = CounterImpl._();
    counter.init(inject);
    super.addContainer(counter.id, counter);
    return counter;
  }

  /// 使用禁止
  @override
  void addContainer(int id, Counter object) {
    throw DefaultError('This method can use to only from the create method.');
  }
}

/// DI から依存元を注入可能な Counter クラス
///
/// _機能実態が注入されるため、機能実現は注入元に任せ、_<br/>
/// _Analytics ログ出力などの機能仕様にない要件追加に利用できます。_<br/>
class CounterDouble extends AbstractInjectable<ReferencableCounter> implements InjectableCounter {
  /// プライベート・コンストラクタ
  ///
  /// _DI コンテナを介してしか生成できないことに留意_
  CounterDouble._();

  @override
  int get count {
    // TODO add line start.
    // デバッグ用に、機能仕様と関係のないカウント値のログ出力を追加
    debugLog('count=${reference!.count}');
    // TODO add line end.
    return reference!.count;
  }

  @override
  set count(int value) => reference!.count = value;

  @override
  void clear() => reference!.clear();

  @override
  void increment() => reference!.increment();
}

/// DI から依存元として参照可能な Counter クラス
class CounterImpl extends AbstractReferencable implements ReferencableCounter {
  // ignore: prefer_final_fields
  late int? _value;

  /// プライベート・コンストラクタ
  ///
  /// _DI コンテナを介してしか生成できないことに留意_
  CounterImpl._() {
    _value = 0;
  }

  @override
  int get count => _value!;

  @override
  set count(int value) => _value = value;

  @override
  void clear() => _value = 0;

  @override
  void increment() => count++;
}

/// 機能実態の注入先 -  Counter オブジェクト注入先の基底インターフェース
abstract interface class InjectableCounter implements ReferencableCounter, Injectable<ReferencableCounter> {}

/// 機能挙動の依存元 - Counter オブジェクトの基底インターフェース
abstract interface class ReferencableCounter implements Counter, Referencable {}

/// 機能仕様の依存元 - Counter オブジェクトの基底インターフェース
abstract interface class Counter {
  int get count;

  set count(int value);

  void clear();

  void increment();
}
