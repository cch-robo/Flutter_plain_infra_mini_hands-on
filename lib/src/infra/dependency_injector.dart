import 'package:flutter/foundation.dart';

import 'default_error.dart';

/// 依存実態として注入される（参照可能）なオブジェクトの基底インターフェース
abstract interface class Referencable {
  int get id;
}

/// 依存実態を注入可能なオブジェクトの基底インターフェース
///
/// T: 注入可能や参照可能で機能実態を提供するオブジェクトの基底インターフェース型
abstract interface class Injectable<T extends Referencable> implements Referencable {
  @override
  int get id;

  void init(T inject);

  void dispose();

  T? get reference;

  bool get hasReference;

  T swap(T inject);
}

/// 依存実態の生成と注入を行う Dependency Inject コンテナ・オブジェクトの基底インターフェース
///
/// T: 機能仕様の基底インターフェース型
/// RT: 機能実態を提供するオブジェクトの基底インターフェース型 (依存参照元)
/// IT: 機能実態を注入先するオブジェクトの基底インターフェース型 (依存注入先)
abstract interface class DependencyInjector<T, RT extends Referencable, IT extends Injectable> {
  T create();

  void addContainer(int id, T object);

  List<int> listUpIds();

  IT getInjector(int id);

  void deleteInjector(int id);

  RT swapReference(int id, RT inject);

  void deleteAllInjector();

  bool checkDebugMode({bool isThrowError = true});
}

/// 依存実態として注入可能（参照可能）なオブジェクトの基底抽象クラス
///
/// _DI から依存元として参照可能にするための基本機能を提供します。_
abstract class AbstractReferencable implements Referencable {
  /// コンストラクタ
  ///
  /// _派生先のコンストラクタは、プライベート・コンストラクタにして、_<br/>
  /// _同一パッケージの DI コンテナから生成させるようにしてください。_<br/>
  AbstractReferencable();

  @override
  int get id => hashCode;
}

/// 依存実態を注入可能なオブジェクトの抽象基底クラス
///
/// _DI から依存元を注入可能にするための基本機能を提供します。_<br/>
abstract class AbstractInjectable<T extends Referencable> implements Injectable<T>, Referencable {
  // ignore: prefer_final_fields
  T? _reference;

  @override
  T? get reference => _reference;

  /// コンストラクタ
  ///
  /// _派生先のコンストラクタは、プライベート・コンストラクタにして、_<br/>
  /// _同一パッケージの DI コンテナから生成させるようにしてください。_<br/>
  AbstractInjectable();

  @override
  late final int id;

  @override
  void init(T inject) {
    _reference = inject;
    id = _reference!.id;
  }

  @override
  void dispose() {
    _reference = null;
  }

  @override
  bool get hasReference => _reference != null;

  @override
  T swap(T inject) {
    if (_reference == null) throw DefaultError('');
    T temp = _reference!;
    _reference = inject;
    return temp;
  }
}

/// DIコンテナの抽象基盤クラス
///
/// _派生先では、テストなどアプリ外部からも DIコンテナが使えるよう、_<br/>
/// _下記のようなシングルトン・インスタンスやゲッターおよび、_<br/>
/// _プライベート・コンストラクタを実装してください。_<br/>
///
/// ```dart
///   // シングルトン・インスタンス
///   static SampleDependencyInjector? _singletonInstance;
///
///   // シングルトン・ゲッター
///   static AbstractDependencyInjector get singleton {
///     if (_singletonInstance == null) {
///       _singletonInstance = SampleDependencyInjector._();
///       return _singletonInstance!;
///     }
///     return _singletonInstance!;
///   }
///
///   // プライベート・コンストラクタ
///   SampleDependencyInjector._();
/// ```
abstract class AbstractDependencyInjector<T, RT extends Referencable, IT extends Injectable>
    implements DependencyInjector<T, RT, IT> {
  final Map<int, T> _repo = {};

  /// 機能実態オブジェクト生成
  ///
  /// 機能仕様のインターフェースを実装した、機能実態オブジェクトを生成します。
  ///
  /// _派生先では、DI コンテナと連携するよう、以下のような実装を行ってください。_<br/>
  /// ```dart
  ///   // 【実装例】
  ///   // このサンプルでのジェネリクス型と実態クラスとの割当は、以下の通りです。
  ///   // T ⇒ 機能仕様： Counter、
  ///   // RT ⇒ 機能実装： CounterImpl、
  ///   // IT ⇒ 機能実態注入先： CounterDouble
  ///   //
  ///   @override
  ///   Counter create() {
  ///     if (!checkDebugMode(isThrowError: false)) {
  ///       CounterImpl counter = CounterImpl._();
  ///       addContainer(counter.id, counter);
  ///       return counter;
  ///     }
  ///     // デバッグモードの場合のみ動的 Dependency Inject 可能にします。
  ///     CounterDouble counter = CounterDouble._();
  ///     CounterImpl inject = CounterImpl._();
  ///     counter.init(inject);
  ///     addContainer(counter.id, counter);
  ///     return counter;
  ///   }
  /// ```
  @override
  T create();

  /// [create]メソッドで生成したオブジェクトをコンテナに追加します。
  ///
  /// _このメソッドは、[create] のヘルパー・メソッドのため、_<br/>
  /// _[create]実装内で、`super.addContainer()` のようにして利用します。_<br/>
  /// _派生先では、不用意に使われないよう、以下のようにオーバーライドして使用禁止にしてください。_<br/>
  /// ```dart
  ///  @override
  ///  void addContainer(int id, T object) {
  ///    throw DefaultError('This method can use to only from the create method.');
  ///  }
  /// ```
  @override
  void addContainer(int id, T object) {
    _repo[id] = object;
  }

  @override
  List<int> listUpIds() {
    checkDebugMode();
    return _repo.keys.toList();
  }

  @override
  IT getInjector(int id) {
    checkDebugMode();
    if (!_repo.containsKey(id)) {
      throw DefaultError('There are no objects in this container for ID values.');
    }
    return _repo[id]! as IT;
  }

  @override
  void deleteInjector(int id) {
    IT instance = getInjector(id);
    instance.dispose();
    _repo.remove(id);
  }

  @override
  RT swapReference(int id, RT inject) {
    IT instance = getInjector(id);
    return instance.swap(inject) as RT;
  }

  @override
  void deleteAllInjector() {
    checkDebugMode();
    for (T instance in _repo.values) {
      (instance as IT).dispose();
    }
    _repo.clear();
  }

  @override
  bool checkDebugMode({bool isThrowError = true}) {
    if (!kDebugMode && isThrowError) {
      throw DefaultError('Dependency Injection methods can use to only Debug mode.');
    }
    return kDebugMode;
  }
}
