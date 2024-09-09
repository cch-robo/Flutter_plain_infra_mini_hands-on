// デフォルト・カウンターアプリのコードに、カウント値が 10以上でエラーを発生するよう変更。
// トライキャッチ強制の処理実行基盤でエラーを捕捉して、エラー対応済のログを出力させます。
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    // TODO add line start.
    // カウント値が、10以上であればエラーを発生させます。
    if (_counter >= 10) {
      // エラーハンドリングの動作確認
      TryCatch.executeVoid(
        executor: () {
          debugLog('error throw.', info: this);
          throw DefaultError('Count value is over 10.');
        },
        causeHandler: (Object cause) {
          debugLog('handled -> ${cause.toString()}', info: this);
          return const Result<Void>.success();
        },
      );
    }
    // TODO add line end.
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
              '$_counter',
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


/// （汎用）トライ＆キャッチ実行クラス
///
/// **エラーや例外が発生する可能性のある実行処理** に対し、<br/>
/// エラーや例外のハンドリングを強制させるクラスです。
///
/// - エラーや例外のハンドリングが指定されていて、<br/>
///   ハンドリングに成功（[Result.isSuccess]）した場合は、<br/>
///   実行結果および捕捉したエラーや例外がラップされた [Result] オブジェクトを返します。<br/>
///
/// - エラーや例外のハンドリングの指定がないか、<br/>
///   ハンドリングに失敗（[Result.hasError]）した場合は、<br/>
///   捕捉されたエラーや例外を（rethrow/throw）投げ返します。
///
final class TryCatch {
  /// （結果あり）実行メソッド
  ///
  /// - [executor]:  エラーや例外が発生する可能性のある処理実行をラップした関数<br/>
  /// - [causeHandler]: （オプション）発生したエラーや例外のハンドラ関数<br/>
  ///   _設定していない場合、捕捉されたエラーや例外を rethrow/throw します。_
  static Result<T> execute<T>({
    required FlowExecutor<T> executor,
    CauseHandler<T>? causeHandler,
  }) {
    bool isRethrow = causeHandler == null;
    try {
      return Result.success(result: executor());
    } on DefaultException catch (exception) {
      if (isRethrow) rethrow;
      Result<T> result = causeHandler(exception);
      debugLog('execute: ${exception.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
      if (!result.isSuccess) rethrow;
      return result;
    } on DefaultError catch (error) {
      if (isRethrow) rethrow;
      Result<T> result = causeHandler(error);
      debugLog('execute: ${error.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
      if (!result.isSuccess) rethrow;
      return result;
    } catch (cause) {
      debugLog('execute: ${cause.runtimeType} caching.');
      if (cause is Error) {
        DefaultError error = DefaultError('error captured!', cause: cause);
        if (isRethrow) throw error;
        Result<T> result = causeHandler(error);
        debugLog('execute: ${error.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
        if (!result.isSuccess) rethrow;
        return result;
      }
      if (cause is Exception) {
        DefaultException exception = DefaultException('exception captured!', cause: cause);
        if (isRethrow) throw exception;
        Result<T> result = causeHandler(exception);
        debugLog('execute: ${exception.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
        if (!result.isSuccess) rethrow;
        return result;
      }
      // エラーや例外でない想定外の場合
      DefaultError error = DefaultError('unknown cause captured!', cause: cause);
      if (isRethrow) throw error;
      Result<T> result = causeHandler(error);
      debugLog('execute: ${error.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
      if (!result.isSuccess) rethrow;
      return result;
    } finally {}
  }

  /// （結果なし）実行メソッド
  ///
  /// - [executor]:  エラーや例外が発生する可能性のある処理実行をラップした関数<br/>
  /// - [causeHandler]: （オプション）発生したエラーや例外のハンドラ関数<br/>
  ///   _設定していない場合、捕捉されたエラーや例外を rethrow/throw します。_
  static Result<Void> executeVoid({
    required FlowVoidExecutor executor,
    CauseVoidHandler? causeHandler,
  }) {
    bool isRethrow = causeHandler == null;
    try {
      executor();
      return const Result<Void>.success();
    } on DefaultException catch (exception) {
      if (isRethrow) rethrow;
      Result<Void> result = causeHandler(exception);
      debugLog('executeResultVoid: ${exception.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
      if (!result.isSuccess) rethrow;
      return result;
    } on DefaultError catch (error) {
      if (isRethrow) rethrow;
      Result<Void> result = causeHandler(error);
      debugLog('executeResultVoid: ${error.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
      if (!result.isSuccess) rethrow;
      return result;
    } catch (cause) {
      debugLog('executeResultVoid: ${cause.runtimeType} caching.');
      if (cause is Error) {
        DefaultError error = DefaultError('error captured!', cause: cause);
        if (isRethrow) throw error;
        Result<Void> result = causeHandler(error);
        debugLog('executeResultVoid: ${error.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
        if (!result.isSuccess) rethrow;
        return result;
      }
      if (cause is Exception) {
        DefaultException exception = DefaultException('exception captured!', cause: cause);
        if (isRethrow) throw exception;
        Result<Void> result = causeHandler(exception);
        debugLog('executeResultVoid: ${exception.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
        if (!result.isSuccess) rethrow;
        return result;
      }
      // エラーや例外でない想定外の場合
      DefaultError error = DefaultError('unknown cause captured!', cause: cause);
      if (isRethrow) throw error;
      Result<Void> result = causeHandler(error);
      debugLog('executeResultVoid: ${error.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
      if (!result.isSuccess) rethrow;
      return result;
    } finally {}
  }

  /// （非同期結果あり）実行メソッド
  ///
  /// - [executor]:  エラーや例外が発生する可能性のある処理実行をラップした関数<br/>
  /// - [causeHandler]: （オプション）発生したエラーや例外のハンドラ関数<br/>
  ///   _設定していない場合、捕捉されたエラーや例外を rethrow/throw します。_
  static Future<Result<T>> asyncExecute<T>({
    required AsyncFlowExecutor<T> executor,
    AsyncCauseHandler<T>? causeHandler,
  }) async {
    bool isRethrow = causeHandler == null;
    try {
      return Result.success(result: await executor());
    } on DefaultException catch (exception) {
      if (isRethrow) rethrow;
      Result<T> result = await causeHandler(exception);
      debugLog('asyncExecute: ${exception.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
      if (!result.isSuccess) rethrow;
      return result;
    } on DefaultError catch (error) {
      if (isRethrow) rethrow;
      Result<T> result = await causeHandler(error);
      debugLog('asyncExecute: ${error.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
      if (!result.isSuccess) rethrow;
      return result;
    } catch (cause) {
      debugLog('asyncExecute: ${cause.runtimeType} caching.');
      if (cause is Error) {
        DefaultError error = DefaultError('error captured!', cause: cause);
        if (isRethrow) throw error;
        Result<T> result = await causeHandler(error);
        debugLog('asyncExecute: ${error.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
        if (!result.isSuccess) rethrow;
        return result;
      }
      if (cause is Exception) {
        DefaultException exception = DefaultException('exception captured!', cause: cause);
        if (isRethrow) throw exception;
        Result<T> result = await causeHandler(exception);
        debugLog('asyncExecute: ${exception.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
        if (!result.isSuccess) rethrow;
        return result;
      }
      // エラーや例外でない想定外の場合
      DefaultError error = DefaultError('unknown cause captured!', cause: cause);
      if (isRethrow) throw error;
      Result<T> result = await causeHandler(error);
      debugLog('asyncExecute: ${error.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
      if (!result.isSuccess) rethrow;
      return result;
    } finally {}
  }

  /// （非同期結果なし）実行メソッド
  ///
  /// - [executor]:  エラーや例外が発生する可能性のある処理実行をラップした関数<br/>
  /// - [causeHandler]: （オプション）発生したエラーや例外のハンドラ関数<br/>
  ///   _設定していない場合、捕捉されたエラーや例外を rethrow/throw します。_
  static Future<Result<Void>> asyncExecuteVoid({
    required AsyncFlowVoidExecutor executor,
    AsyncCauseVoidHandler? causeHandler,
  }) async {
    bool isRethrow = causeHandler == null;
    try {
      await executor();
      return const Result<Void>.success();
    } on DefaultException catch (exception) {
      if (isRethrow) rethrow;
      Result<Void> result = await causeHandler(exception);
      debugLog('asyncExecuteResultVoid: ${exception.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
      if (!result.isSuccess) rethrow;
      return result;
    } on DefaultError catch (error) {
      if (isRethrow) rethrow;
      Result<Void> result = await causeHandler(error);
      debugLog('asyncExecuteResultVoid: ${error.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
      if (!result.isSuccess) rethrow;
      return result;
    } catch (cause) {
      debugLog('asyncExecuteResultVoid: ${cause.runtimeType} caching.');
      if (cause is Error) {
        DefaultError error = DefaultError('error captured!', cause: cause);
        if (isRethrow) throw error;
        Result<Void> result = await causeHandler(error);
        debugLog('asyncExecuteResultVoid: ${error.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
        if (!result.isSuccess) rethrow;
        return result;
      }
      if (cause is Exception) {
        DefaultException exception = DefaultException('exception captured!', cause: cause);
        if (isRethrow) throw exception;
        Result<Void> result = await causeHandler(exception);
        debugLog(
            'asyncExecuteResultVoid: ${exception.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
        if (!result.isSuccess) rethrow;
        return result;
      }
      // エラーや例外でない想定外の場合
      DefaultError error = DefaultError('unknown cause captured!', cause: cause);
      if (isRethrow) throw error;
      Result<Void> result = await causeHandler(error);
      debugLog('asyncExecuteResultVoid: ${error.runtimeType} handling ${result.isSuccess ? "success" : "failed"}.');
      if (!result.isSuccess) rethrow;
      return result;
    } finally {}
  }
}

/// （実行結果あり）エラーや例外を伴う処理フローの実行関数
///
/// **エラーや例外の発生を伴う処理フローを実行させる関数型** です。<br/>
///
/// ```dart
/// T Function()
/// ```
/// - _トライ＆キャッチが強制される [TryCatch.execute]メソッドで利用され、_
///   _発生したエラーや例外は、同メソッドのペア引数となる [CauseHandler]関数でハンドリング可能です。_<br/>
/// - _関数内の **実行結果([T])を返す処理フロー** では、クロージャも利用可能です。_<br/>
typedef FlowExecutor<T> = T Function();

/// （実行結果あり）エラーハンドラ関数
///
/// **発生したエラーや例外を処置するハンドラ関数型** です。<br/>
///
/// ```dart
/// Result<T> Function(Object cause)
/// ```
/// - _トライ＆キャッチが強制される [TryCatch.execute]メソッドで利用され、_
///   _発生したエラーや例外を [cause]引数で受けとり、ハンドリング成功可否のいずれかを返します。_<br/>
/// - _関数内の **エラーハンドリングを行う処理フロー** では、クロージャも利用可能です。_<br/>
typedef CauseHandler<T> = Result<T> Function(Object cause);

/// （実行結果なし）エラーや例外を伴う処理フローの実行関数
///
/// **エラーや例外の発生を伴う処理フローを実行させる関数型** です。<br/>
///
/// ```dart
/// void Function()
/// ```
/// - _トライ＆キャッチが強制される [TryCatch.executeVoid]メソッドで利用され、_
///   _発生したエラーや例外は、同メソッドのペア引数となる [CauseVoidHandler]関数でハンドリング可能です。_<br/>
/// - _関数内の **実行結果を返さない処理フロー** では、クロージャも利用可能です。_<br/>
typedef FlowVoidExecutor = void Function();

/// （実行結果なし）エラーハンドラ関数
///
/// **発生したエラーや例外を処置するハンドラ関数型** です。<br/>
///
/// ```dart
/// Result<Void> Function(Object cause)
/// ```
/// - _トライ＆キャッチが強制される [TryCatch.executeVoid]メソッドで利用され、_
///   _発生したエラーや例外を [cause]引数で受けとり、ハンドリング成功可否のいずれかを返します。_<br/>
/// - _関数内の **エラーハンドリングを行う処理フロー** では、クロージャも利用可能です。_<br/>
typedef CauseVoidHandler = Result<Void> Function(Object cause);

/// （非同期実行結果あり）エラーや例外を伴う処理フローの実行関数
///
/// **エラーや例外の発生を伴う処理フローを実行させる関数型** です。<br/>
///
/// ```dart
/// Future<T> Function()
/// ```
/// - _トライ＆キャッチが強制される [TryCatch.asyncExecute]メソッドで利用され、_
///   _発生したエラーや例外は、同メソッドのペア引数となる [AsyncCauseHandler]関数でハンドリング可能です。_<br/>
/// - _関数内の **実行結果([T])を返す処理フロー** では、クロージャも利用可能です。_<br/>
typedef AsyncFlowExecutor<T> = Future<T> Function();

/// （非同期実行結果あり）エラーハンドラ関数
///
/// **発生したエラーや例外を処置するハンドラ関数型** です。<br/>
///
/// ```dart
/// Future<Result<T>> Function(Object cause)
/// ```
/// - _トライ＆キャッチが強制される [TryCatch.asyncExecute]メソッドで利用され、_
///   _発生したエラーや例外を [cause]引数で受けとり、ハンドリング成功可否のいずれかを返します。_<br/>
/// - _関数内の **エラーハンドリングを行う処理フロー** では、クロージャも利用可能です。_<br/>
typedef AsyncCauseHandler<T> = Future<Result<T>> Function(Object cause);

/// （非同期実行結果なし）エラーや例外を伴う処理フローの実行関数
///
/// **エラーや例外の発生を伴う処理フローを実行させる関数型** です。<br/>
///
/// ```dart
/// Future<void> Function()
/// ```
/// - _トライ＆キャッチが強制される [TryCatch.asyncExecuteVoid]メソッドで利用され、_
///   _発生したエラーや例外は、同メソッドのペア引数となる [AsyncCauseVoidHandler]関数でハンドリング可能です。_<br/>
/// - _関数内の **実行結果を返さない処理フロー** では、クロージャも利用可能です。_<br/>
typedef AsyncFlowVoidExecutor = Future<void> Function();

/// （非同期実行結果なし）エラーハンドラ関数
///
/// **発生したエラーや例外を処置するハンドラ関数型** です。<br/>
///
/// ```dart
/// Future<Result<Void>> Function(Object cause)
/// ```
/// - _トライ＆キャッチが強制される [TryCatch.asyncExecuteVoid]メソッドで利用され、_
///   _発生したエラーや例外を [cause]引数で受けとり、ハンドリング成功可否のいずれかを返します。_<br/>
/// - _関数内の **エラーハンドリングを行う処理フロー** では、クロージャも利用可能です。_<br/>
typedef AsyncCauseVoidHandler = Future<Result<Void>> Function(Object cause);

/// （汎用）実行結果ラップクラス
///
/// 成功可否にかかわらず、常に実行結果が返るよう、<br/>
/// 実行結果や発生したエラーや例外をラップするクラスです。
/// - ジェネリクス [T] には、ラップする結果型を指定します。
@immutable
class Result<T> {
  /// 実行結果
  ///
  /// _実行に失敗した場合は、null になります。_
  final Object? _result;

  /// 実行失敗理由
  ///
  /// _実行に失敗した理由のエラーや例外が設定されます。_
  final DefaultAbnormal? _cause;

  /// 実行成功可否
  bool get isSuccess => !hasError;

  /// 実行結果有無
  ///
  /// _実行成功でも、実行結果がないと true になることに留意_
  bool get hasResult => _result != null && _result is! Void;

  /// 実行失敗エラー有無
  bool get hasError => _cause != null && _cause is Error;

  /// 実行失敗例外有無
  bool get hasException => _cause != null && _cause is Exception;

  /// 実行結果
  ///
  /// _[hasResult]が false の場合は、エラーが発生することに注意。_
  T get result => hasResult ? _result as T : throw StateError('had no result.');

  /// 実行失敗理由
  ///
  /// _[isSuccess]が true の場合は、実行に失敗していないので null が返ります。_
  DefaultAbnormal? get cause => _cause;

  /// 実行失敗理由タイプ
  ///
  /// _[isSuccess]が true の場合は、null が返ります。_
  Type? get causeType => _cause?.runtimeType;

  const Result.success({
    T? result,
  })  : _result = result ?? const Void(),
        _cause = null;

  const Result.failed({required DefaultAbnormal cause})
      : _result = null,
        _cause = cause;
}

/// （汎用）Void 型
@immutable
class Void {
  const Void();
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


class DebugLog {
  static bool isDebugMode = true;
}

/// デバッグ出力
///
/// アプリがデバックモード([kDebugMode] == true)かつ
/// [DebugLog.isDebugMode]が true または [cause]が null でない
/// ときのみ [message]が出力されます。
///
/// - [message] : 出力メッセージ
/// - [info] : （オプション）パラメータ型を明示して出力元情報補助を行います。<br/>
/// - [cause] : （オプション）エラーまたは例外型を明示して出力元情報補助を行います。<br/>
/// _[Error]型が指定されていた場合は、[StackTrace]出力も伴います。_
void debugLog(String message, {Object? info, Object? cause}) {
  if ((DebugLog.isDebugMode || cause != null) && true) {
    debugPrint(createDebugLogText(message, info: info, cause: cause));
  }
}

String createDebugLogText(String message, {Object? info, Object? cause}) {
  if ((DebugLog.isDebugMode || cause != null) && true) {
    StringBuffer sb = StringBuffer();
    // メッセージ表示
    if (info != null) {
      sb.write('${info.runtimeType.toString()}: $message');
    } else {
      sb.write(message);
    }

    // リカーシブル・エラー表示
    bool isLoop = cause != null;
    while (isLoop) {
      isLoop = false;
      if (cause is DefaultAbnormal) {
        sb.write('\n${cause.runtimeType.toString()}: ${cause.message}');
        sb.write('\n${cause.stackTrace?.toString() ?? ""}');
        cause = cause.hasError
            ? cause.error
            : cause.hasException
            ? cause.exception
            : null;
        isLoop = true;
      } else {
        sb.write('\n${cause.runtimeType.toString()}: ${cause.toString()}');
        if (cause is Error) sb.write('\n${cause.stackTrace?.toString() ?? ""}');
      }
    }

    return sb.toString();
  }
  return '';
}
