import 'package:flutter/foundation.dart';
import 'debug_logger.dart';
import 'default_error.dart';

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
