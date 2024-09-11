// 依存を分離するため、カウンター機能（状態オブジェクト）を、DI コンテナから取得させます。
// 状態オブジェクトを直接生成（ハードコード）していませんが、DIコンテナは依存注入に対応していません。
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // TODO modify line start.
  /*
  int _counter = 0;
  */
  late Counter _counter;
  // TODO modify line end.

  // TODO add line start.
  @override
  void initState() {
    super.initState();
    var di = CounterDiContainer.singleton;
    _counter = di.create();
  }

  @override
  void dispose() {
    var di = CounterDiContainer.singleton;
    di.deleteAll();
    super.dispose();
  }
  // TODO add line end.

  void _incrementCounter() {
    setState(() {
      // TODO modify line start.
      /*
      _counter++;
      */
      _counter.increment();
      // TODO modify line end.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${_counter.count}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


// TODO add line start.
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
// TODO add line end.

// TODO add line start.
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
// TODO add line end.

// TODO add line start.
/// 機能実態の注入先 -  Counter オブジェクト注入先の基底インターフェース
abstract interface class InjectableCounter implements ReferencableCounter, Injectable<ReferencableCounter> {}

/// 機能挙動の依存元 - Counter オブジェクトの基底インターフェース
abstract interface class ReferencableCounter implements Counter, Referencable {}
// TODO add line end.

// TODO add line start.
/// 機能仕様の依存元 - Counter オブジェクトの基底インターフェース
abstract interface class Counter {
  int get count;

  set count(int value);

  void increment();
}
// TODO add line end.


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

  void init(T reference);

  void dispose();

  T? get reference;

  bool get hasReference;

  T swap(T reference);
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

  RT swapReference(int id, RT reference);

  void deleteAll();

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
  void init(T reference) {
    _reference = reference;
    id = _reference!.id;
  }

  @override
  void dispose() {
    _reference = null;
  }

  @override
  bool get hasReference => _reference != null;

  @override
  T swap(T reference) {
    if (_reference == null) throw DefaultError('');
    T temp = _reference!;
    _reference = reference;
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
///   // 注入禁止要請フラグ
///   static bool isForbiddenInject = false;
///
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
///   SampleDependencyInjector._() ｛
///     isForbiddenInject = isNoUseInject;
///   ｝
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
  ///     if (!checkDebugMode(isThrowError: false) || isForbiddenInject) {
  ///       // デバッグモードでないか注入禁止なので Dependency Inject を利用させません。
  ///       CounterImpl counter = CounterImpl._();
  ///       return counter;
  ///     }
  ///     // デバッグモードの場合のみ動的 Dependency Inject 可能にします。
  ///     CounterDouble counter = CounterDouble._();
  ///     CounterImpl reference = CounterImpl._();
  ///     counter.init(reference);
  ///     super.addContainer(counter.id, counter);
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
  RT swapReference(int id, RT reference) {
    IT instance = getInjector(id);
    return instance.swap(reference) as RT;
  }

  @override
  void deleteAll() {
    checkDebugMode();
    for (T instance in _repo.values) {
      if (instance is IT) (instance as IT).dispose();
    }
    _repo.clear();
  }

  @override
  bool checkDebugMode({bool isThrowError = true}) {
    return true;
  }
}


/// （汎用）エラー基底クラス
///
/// _独自のエラー型を定義する際の基底クラスとして利用します。_
///
/// ```dart
/// // 独自エラー定義例
/// class MyError extends DefaultError {
///   MyError(super.message, {super.cause});
/// }
/// ```
@immutable
class DefaultError extends Error implements DefaultAbnormal {
  late final String name;

  @override
  final String message;

  @override
  late final Error? error;

  @override
  late final Exception? exception;

  @override
  late final Object? cause;

  @override
  late final StackTrace? stackTrace;

  DefaultError(this.message, {this.cause})
      : error = cause is Error ? cause : null,
        exception = cause is Exception ? cause : null,
        stackTrace = cause is Error ? cause.stackTrace : StackTrace.current {
    name = runtimeType.toString();
  }

  @override
  bool get hasError => error != null;

  @override
  bool get hasException => exception != null;

  @override
  Type? get causeType => cause?.runtimeType;

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    if (cause != null && exception == null && error == null) {
      sb.write('$name on ${cause.runtimeType.toString()}: $message');
    }
    if (exception != null) {
      sb.write('$name on ${exception.runtimeType.toString()}: $message');
    }
    if (error != null) {
      sb.write('$name on ${error.runtimeType.toString()}: $message');
    }
    sb.write('\n${stackTrace?.toString() ?? ""}');
    return sb.toString();
  }
}

/// （汎用）例外基底クラス
///
/// _独自の例外型を定義する際の基底クラスとして利用します。_
///
/// ```dart
/// // 独自例外定義例
/// class MyException extends DefaultException {
///   MyException(super.message, {super.cause});
/// }
/// ```
@immutable
class DefaultException implements Exception, DefaultAbnormal {
  late final String name;

  @override
  final String? message;

  @override
  late final Error? error;

  @override
  late final Exception? exception;

  @override
  late final Object? cause;

  @override
  late final StackTrace? stackTrace;

  DefaultException(this.message, {this.cause})
      : error = cause is Error ? cause : null,
        exception = cause is Exception ? cause : null,
        stackTrace = cause is Error ? cause.stackTrace : StackTrace.current {
    name = runtimeType.toString();
  }

  @override
  bool get hasError => error != null;

  @override
  bool get hasException => exception != null;

  @override
  Type? get causeType => cause?.runtimeType;

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    if (cause != null && exception == null && error == null) {
      sb.write('$name on ${cause.runtimeType.toString()}: $message');
    }
    if (exception != null) {
      sb.write('$name on ${exception.runtimeType.toString()}: $message');
    }
    if (error != null) {
      sb.write('$name on ${error.runtimeType.toString()}: $message');
    }
    sb.write('\n${stackTrace?.toString() ?? ""}');
    return sb.toString();
  }
}

/// （汎用）異常系基底インターフェース
@immutable
abstract interface class DefaultAbnormal {
  String? get message;

  Error? get error;

  Exception? get exception;

  Object? get cause;

  StackTrace? get stackTrace;

  bool get hasError;

  bool get hasException;

  Type? get causeType;

  @override
  String toString();
}
