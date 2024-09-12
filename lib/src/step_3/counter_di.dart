// カウンター機能を Dependency Inject コンテナ対応にする。
//
// カウンター機能は、仕様基底インターフェースと、仕様実装クラスおよび、
// 機能実装を注入するクラスを追加して、DI コンテナで依存注入できるようにします。

import '../infra/default_error.dart';
import '../infra/dependency_injector.dart';

/// Counter オブジェクトの DIコンテナ・クラス
class CounterDiContainer extends AbstractDependencyInjector<Counter, ReferencableCounter, InjectableCounter> {
  // 動的操作禁止要請フラグ
  static bool isNoUseDynamicOperation = false;

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
  CounterDiContainer._() {
    isForbiddenDynamicOperation = isNoUseDynamicOperation;
  }

  /// Counter オブジェクト生成
  @override
  Counter create() {
    // オブジェクトを生成しますが、Dependency Inject は利用できません。
    CounterImpl counter = CounterImpl._();
    super.addContainer(counter.id, counter);
    return counter;
  }

  /// 使用禁止
  @override
  void addContainer(int id, Counter object) {
    throw DefaultError('This method can use to only from the create method.');
  }
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

  void increment();
}
