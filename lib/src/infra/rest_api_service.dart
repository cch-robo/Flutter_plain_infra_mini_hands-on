// REST API 通信サービスを提供するパッケージ
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'debug_logger.dart';


class RestApiCreator {
  static RestApiService create() => RestApiServiceImpl._();
}

/// （汎用）REST API 通信サービス・インターフェース
abstract interface class RestApiService {
  void init();

  void dispose();

  Future<RestApiServiceResponse> get({
    required String url,
    Map<String, String>? queries,
    Map<String, dynamic>? tokens,
    List<int>? allowedStatusCodes,
    Duration? timeoutDuration,
});

  Future<RestApiServiceResponse> post({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? tokens,
    List<int>? allowedStatusCodes,
    Duration? timeoutDuration,
  });

  Future<RestApiServiceResponse> put({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? tokens,
    List<int>? allowedStatusCodes,
    Duration? timeoutDuration,
  });

  Future<RestApiServiceResponse> delete({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? tokens,
    List<int>? allowedStatusCodes,
    Duration? timeoutDuration,
  });
}

/// （汎用）REST API 通信サービス
class RestApiServiceImpl implements RestApiService {
  late final http.Client _httpClient;

  /// （デフォルト）ヘッダー設定
  ///
  /// {'Content-Type': 'application/json; charset=utf-8', 'accept': 'application/json'};
  Map<String, String>? get defHeaders => {
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
        HttpHeaders.acceptHeader: ContentType.json.value,
        // HttpHeaders.authorizationHeader: 'Bearer トークン'
        // HttpHeaders.cookieHeader: 'クッキー',
      };

  /// （デフォルト）許容するステータスコード列設定
  List<int> get defAllowedStatusCodes => [200];

  /// （デフォルト）タイムアウト設定
  Duration get defTimeoutDuration => const Duration(seconds: 5);


  /// プライベート・コンストラクタ
  RestApiServiceImpl._();

  @override
  void init() {
    _httpClient = http.Client();
  }

  @override
  void dispose() {
    _httpClient.close();
  }

  @override
  Future<RestApiServiceResponse> get({
    required String url,
    Map<String, String>? queries,
    Map<String, dynamic>? tokens,
    List<int>? allowedStatusCodes,
    Duration? timeoutDuration,
  }) async {
    if (url.isEmpty) {
      throw ArgumentError('It have no host address.');
    }
    final List<int> statusCodes = allowedStatusCodes ?? defAllowedStatusCodes;
    final Uri work = Uri.parse(url);
    final Uri uri =
        work.scheme == 'https' ? Uri.https(work.host, work.path, queries) : Uri.http(work.host, work.path, queries);
    final Map<String, String>? headers = defHeaders;
    final Duration timeLimit = timeoutDuration ?? defTimeoutDuration;

    final response = await _launchRestApi(
      () => _httpClient
          .get(
            uri,
            headers: headers,
          )
          .timeout(timeLimit),
    );

    debugLog('', info: this);
    debugLog('get - request.url=${uri.toString()}', info: this);
    debugLog('get - request.headers=${headers.toString()}', info: this);
    debugLog('get - response.statusCode=${response.statusCode}', info: this);
    debugLog('get - response.body=${response.body}', info: this);

    debugLog('', info: this);
    debugLog('get  url=${uri.toString()}', info: this);
    debugLog('get  url.scheme=${uri.scheme}', info: this);
    debugLog('get  url.host=${uri.host}', info: this);
    debugLog('get  url.path=${uri.path}', info: this);
    debugLog('get  url.port=${uri.port}', info: this);
    debugLog('get  url.query=${uri.query}', info: this);

    bool isSuccess = statusCodes.where((int statusCode) => statusCode == response.statusCode).isNotEmpty;
    if (isSuccess) {
      final List<Map<String, dynamic>> body = _parseBody(response.body);
      return RestApiServiceResponse(true, response.statusCode, body: body);
    } else {
      debugLog('', info: this);
      debugLog('get - failed: statusCode=${response.statusCode}, errors=${response.body}', info: this);
      return RestApiServiceResponse(false, response.statusCode, cause: response.cause);
    }
  }

  @override
  Future<RestApiServiceResponse> post({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? tokens,
    List<int>? allowedStatusCodes,
    Duration? timeoutDuration,
  }) async {
    if (url.isEmpty) {
      throw ArgumentError('It have no host address.');
    }
    final List<int> statusCodes = allowedStatusCodes ?? defAllowedStatusCodes;
    final Uri uri = Uri.parse(url);
    final Map<String, String>? work = headers ?? defHeaders;
    final Map<String, String>? reqHeaders = work != null ? Map<String, String>.unmodifiable(work) : null;
    final Duration timeLimit = timeoutDuration ?? defTimeoutDuration;

    final response = await _launchRestApi(
      () => _httpClient
          .post(
            uri,
            headers: reqHeaders,
            body: json.encode(
              {}..addAll(body ?? {}),
            ),
          )
          .timeout(timeLimit),
    );

    debugLog('', info: this);
    debugLog('post - request.url=${uri.toString()}', info: this);
    debugLog('post - request.headers=${reqHeaders.toString()}', info: this);
    debugLog('post - request.body=$body', info: this);
    debugLog('post - response.statusCode=${response.statusCode}', info: this);
    debugLog('post - response.body=${response.body}', info: this);

    bool isSuccess = statusCodes.where((int statusCode) => statusCode == response.statusCode).isNotEmpty;
    if (isSuccess) {
      final List<Map<String, dynamic>> body = _parseBody(response.body);
      return RestApiServiceResponse(true, response.statusCode, body: body);
    } else {
      debugLog('', info: this);
      debugLog('post - failed: statusCode=${response.statusCode}, errors=${response.body}', info: this);
      return RestApiServiceResponse(false, response.statusCode, cause: response.cause);
    }
  }

  @override
  Future<RestApiServiceResponse> put({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? tokens,
    List<int>? allowedStatusCodes,
    Duration? timeoutDuration,
  }) async {
    if (url.isEmpty) {
      throw ArgumentError('It have no host address.');
    }
    final List<int> statusCodes = allowedStatusCodes ?? defAllowedStatusCodes;
    final Uri uri = Uri.parse(url);
    final Map<String, String>? work = headers ?? defHeaders;
    final Map<String, String>? reqHeaders = work != null ? Map<String, String>.unmodifiable(work) : null;
    final Duration timeLimit = timeoutDuration ?? defTimeoutDuration;

    final response = await _launchRestApi(
      () => _httpClient
          .post(
            Uri.parse(url),
            headers: reqHeaders,
            body: json.encode(
              {}..addAll(body ?? {}),
            ),
          )
          .timeout(timeLimit),
    );

    debugLog('', info: this);
    debugLog('put - request.url=${uri.toString()}', info: this);
    debugLog('put - request.headers=${reqHeaders.toString()}', info: this);
    debugLog('put - request.body=$body', info: this);
    debugLog('put - response.statusCode=${response.statusCode}', info: this);
    debugLog('put - response.body=${response.body}', info: this);

    bool isSuccess = statusCodes.where((int statusCode) => statusCode == response.statusCode).isNotEmpty;
    if (isSuccess) {
      final List<Map<String, dynamic>> body = _parseBody(response.body);
      return RestApiServiceResponse(true, response.statusCode, body: body);
    } else {
      debugLog('', info: this);
      debugLog('put - failed: statusCode=${response.statusCode}, errors=${response.body}', info: this);
      return RestApiServiceResponse(false, response.statusCode, cause: response.cause);
    }
  }

  @override
  Future<RestApiServiceResponse> delete({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? tokens,
    List<int>? allowedStatusCodes,
    Duration? timeoutDuration,
  }) async {
    if (url.isEmpty) {
      throw ArgumentError('It have no host address.');
    }
    final List<int> statusCodes = allowedStatusCodes ?? defAllowedStatusCodes;
    final Uri uri = Uri.parse(url);
    final Map<String, String>? work = headers ?? defHeaders;
    final Map<String, String>? reqHeaders = work != null ? Map<String, String>.unmodifiable(work) : null;
    final Duration timeLimit = timeoutDuration ?? defTimeoutDuration;

    final response = await _launchRestApi(
      () => _httpClient
          .delete(
            Uri.parse(url),
            headers: reqHeaders,
            body: json.encode(
              {}..addAll(body ?? {}),
            ),
          )
          .timeout(timeLimit),
    );

    debugLog('', info: this);
    debugLog('delete - request.url=${uri.toString()}', info: this);
    debugLog('delete - request.headers=${reqHeaders.toString()}', info: this);
    debugLog('delete - request.body=$body', info: this);
    debugLog('delete - response.statusCode=${response.statusCode}', info: this);
    debugLog('delete - response.body=${response.body}', info: this);

    bool isSuccess = statusCodes.where((int statusCode) => statusCode == response.statusCode).isNotEmpty;
    if (isSuccess) {
      final List<Map<String, dynamic>> body = _parseBody(response.body);
      return RestApiServiceResponse(true, response.statusCode, body: body);
    } else {
      debugLog('', info: this);
      debugLog('delete - failed: statusCode=${response.statusCode}, errors=${response.body}', info: this);
      return RestApiServiceResponse(false, response.statusCode, cause: response.cause);
    }
  }

  List<Map<String, dynamic>> _parseBody(String responseBody) {
    if (responseBody.isEmpty) return [];

    final dynamic jsonBody = json.decode(responseBody);
    if (jsonBody is List) {
      return jsonBody.map((dynamic json) => json as Map<String, dynamic>).toList();
    }
    if (jsonBody is Map<String, dynamic>) {
      return [jsonBody];
    }

    throw UnsupportedError('unexpected data format as the response.body. ($responseBody})');
  }

  /// API 実行メソッド
  ///
  /// レスポンス以外のエラーをハンドリングできるようにするための<br/>
  /// API 実行のラッパーです。
  ///
  /// - [apiFunction]: HTTP REST API 実行関数
  /// - 返却値: レスポンスまたは通信エラーなどの API実行結果
  Future<_Result> _launchRestApi(Future<http.Response> Function() apiFunction) async {
    try {
      http.Response response = await apiFunction();
      return _Result.response(response);
    } on SocketException catch (exception) {
      debugLog(
        'SocketException - '
        'Type=${exception.runtimeType.toString()}, '
        'Message=${exception.message}, '
        'osError=${exception.osError}, '
        '${exception.toString()}',
        info: this,
      );
      return _Result.error(exception);
    } on http.ClientException catch (exception) {
      debugLog(
        'ClientException - '
        'Type=${exception.runtimeType.toString()}, '
        'Message=${exception.message}, '
        'uri=${exception.uri}, '
        '${exception.toString()}',
        info: this,
      );
      return _Result.error(exception);
    } catch (error) {
      debugLog('error - Type=${error.runtimeType.toString()}, ${error.toString()}', info: this);
      return _Result.error(error);
    }
  }
}

/// REST API 実行結果表現クラス
///
/// レスポンスだけでなく、<br/>
/// タイムアウトやネットワーク切断などの I/O Error を含めた、<br/>
/// API実行結果を扱えるようにするためのラッパークラスです。
class _Result {
  final http.Response? _response;
  final Object? _cause;

  bool get isResponse => _response != null;

  String get body => isResponse ? _response!.body : _cause!.toString();

  int get statusCode => isResponse ? _response!.statusCode : -1;

  Map<String, String> get headers => isResponse ? _response!.headers : {};

  Object? get cause => _cause;

  const _Result.response(this._response) : _cause = null;

  const _Result.error(this._cause) : _response = null;
}

/// REST API レスポンス表現バリュークラス
class RestApiServiceResponse {
  /// API実行成功可否
  final bool isSuccess;

  /// レスポンスコード値
  final int codeValue;

  /// オプション・レスポンスボディ
  ///
  /// 成功時のレスポンスボディの返却に利用します。
  final List<Map<String, dynamic>>? optionBody;

  /// オプション情報
  ///
  /// エラー時のレスポンスに含まれるオプション情報の返却に利用します。
  final Object? optionCause;

  bool get hasError => optionCause is Error;

  bool get hasException => optionCause is Exception;

  Type? get optionCauseType => optionCause?.runtimeType;

  const RestApiServiceResponse(
    this.isSuccess,
    this.codeValue, {
    List<Map<String, dynamic>>? body,
    Object? cause,
  })  : optionBody = body,
        optionCause = cause;
}
