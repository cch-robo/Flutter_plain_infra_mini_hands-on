import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'debug_logger.dart';

/// アプリ・エラーハンドラ設定クラス
class AppErrorHandler {
  /// シングルトン・インスタンス
  static late final AppErrorHandler _instance;

  /// コンストラクタ
  ///
  /// _シングルトン・インスタンスのため、_<br/>
  /// _2回目の生成はエラーとなることに注意ください。_
  AppErrorHandler() {
    _instance = this;
  }

  /// アプリ起動
  ///
  /// Flutter アプリのエラーハンドラを設定して、アプリを起動します。
  void runAppWithErrorHandler(Widget app) {
    runZonedGuarded(() async {
      // アプリ全体のエラーハンドリングを行うため、
      // アプリ起動は、この関数パラメータ内で行う必要があることに留意。
      WidgetsFlutterBinding.ensureInitialized();
      _oldExceptionHandler = FlutterError.onError!;
      FlutterError.onError = exceptionHandler;

      // アプリ起動
      runApp(app);
    }, (Object error, StackTrace stack) {
      errorHandler(error, stack);
    });

    // Flutter フレームワーク・レベルではない、プラットフォーム由来の非同期エラーのハンドラ
    PlatformDispatcher.instance.onError = (error, stack) {
      // TODO トップレベルまで上がってきた未処置のエラーなので、Crashlytics でログ記録を取ること。
      // TODO 想定外の例外の場合は、アプリを強制終了できるようにすること。
      debugLog('PlatformDispatcher  - onError', info: _instance);
      return true;
    };
  }

  /// 既存 Flutter system exception handler
  late final FlutterExceptionHandler _oldExceptionHandler;

  /// オプション Flutter system exception handler
  late final FlutterExceptionHandler? _optionExceptionHandler;

  /// オプション Flutter system error handler
  late final Function(Object error, StackTrace stackTrace)? _optionErrorHandler;

  /// アプリ全体での Exception Handler (内部使用のみ)
  void exceptionHandler(FlutterErrorDetails details) {
    debugLog('Application ExceptionHandler');
    debugLog('handling err type=${details.exception.runtimeType.toString()}');
    debugLog('exceptionAsString=${details.exceptionAsString()}');
    debugLog('StackTraces=\n${details.stack.toString()}');
    debugLog('FlutterError.dumpErrorToConsole');
    FlutterError.dumpErrorToConsole(details, forceReport: true);

    // オプションのエクセプションハンドラ処置実行
    if (_optionExceptionHandler != null) _optionExceptionHandler(details);

    // 既存エクセプションハンドラ処置実行
    _oldExceptionHandler(details);

    // TODO トップレベルまで上がってきた未処置のエラーなので、Crashlytics でログ記録を取ること。
    // TODO 想定外の例外の場合は、アプリを強制終了できるようにすること。
    debugLog('exceptionHandler  - ${details.exception}', info: _instance);
  }

  /// アプリ全体での Error handler （Error だけでなく Exceptionも捕捉します）
  void errorHandler(Object error, StackTrace stack) {
    debugLog('Application ErrorHandler', cause: error);
    debugLog('StackTraces=\n${stack.toString()}');

    // オプションのエラーハンドラ処置実行
    if (_optionErrorHandler != null) _optionErrorHandler(error, stack);

    // TODO トップレベルまで上がってきた未処置のエラーなので、Crashlytics でログ記録を取ること。
    // TODO 想定外のエラーの場合は、アプリを強制終了できるようにすること。
    debugLog('errorHandler  - $error', info: _instance);
  }
}
