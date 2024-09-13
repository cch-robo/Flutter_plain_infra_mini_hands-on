// デフォルト・カウンターアプリのコードに、カウント値が 10ごとに REST API をコールするよう変更。
// REST API コール基盤により、GitHub Android コントリビュータ取得の動作確認を行います。
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    // カウント値が、10ごとに REST API をコールします。
    if (_counter % 10 == 0) {
      () async {
        // REST API 実行の動作確認
        RestApiService service = RestApiCreator.create();
        service.init();

        // コントリビュータ一覧取得確認
        RestApiServiceResponse response = await service.get(
          url: 'https://api.github.com/repositories/90792131/contributors',
          queries: {'per_page': '100', 'page': '1', 'anon': 'false'},
        );
        if (response.isSuccess) {
          debugLog('contributors=${response.optionBody?.length}');
        }

        // コントリビュータ詳細取得確認
        List<OverviewModel> models = OverviewModel.fromJsonList(response.optionBody ?? []);
        debugLog('contributors.first.login=${models.first.login}');
        response = await service.get(
          url: 'https://api.github.com/users/${models.first.login}',
        );
        if (response.isSuccess) {
          DetailModel model = DetailModel.fromJson(response.optionBody?.first ?? {});
          debugLog('contributor=${model.login}');
          debugLog('');
        }

        // タイムアウト確認
        response = await service.get(
          url: 'https://api.github.com/repos/googlesamples/android-architecture-components/contributors',
          timeoutDuration: const Duration(microseconds: 10),
        );

        service.dispose();
      }();
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


// ignore_for_file: non_constant_identifier_names
/// （コントリビュータ）概要モデル
@immutable
class OverviewModel {
  final String login;
  final int id;
  final String node_id;
  final String avatar_url;
  final String gravatar_id;
  final String url;
  final String html_url;
  final String followers_url;
  final String following_url;
  final String gists_url;
  final String starred_url;
  final String subscriptions_url;
  final String organizations_url;
  final String repos_url;
  final String events_url;
  final String received_events_url;
  final String type;
  final bool site_admin;
  final int contributions;

  const OverviewModel({
    required this.login,
    required this.id,
    required this.node_id,
    required this.avatar_url,
    required this.gravatar_id,
    required this.url,
    required this.html_url,
    required this.followers_url,
    required this.following_url,
    required this.gists_url,
    required this.starred_url,
    required this.subscriptions_url,
    required this.organizations_url,
    required this.repos_url,
    required this.events_url,
    required this.received_events_url,
    required this.type,
    required this.site_admin,
    required this.contributions,
  });

  OverviewModel.fromJson(Map<String, dynamic> json) : this(
    login: json['login'] as String,
    id: json['id'] as int,
    node_id: json['node_id'] as String,
    avatar_url: json['avatar_url'] as String,
    gravatar_id: json['gravatar_id'] as String,
    url: json['url'] as String,
    html_url: json['html_url'] as String,
    followers_url: json['followers_url'] as String,
    following_url: json['following_url'] as String,
    gists_url: json['gists_url'] as String,
    starred_url: json['starred_url'] as String,
    subscriptions_url: json['subscriptions_url'] as String,
    organizations_url: json['organizations_url'] as String,
    repos_url: json['repos_url'] as String,
    events_url: json['events_url'] as String,
    received_events_url: json['received_events_url'] as String,
    type: json['type'] as String,
    site_admin: json['site_admin'] as bool,
    contributions: json['contributions'] as int,
  );

  static List<OverviewModel> fromJsonList(List<dynamic> jsonList) {
    return List.unmodifiable(jsonList.map((json) => OverviewModel.fromJson(json)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'id': id,
      'node_id': node_id,
      'avatar_url': avatar_url,
      'gravatar_id': gravatar_id,
      'url': url,
      'html_url': html_url,
      'followers_url': followers_url,
      'following_url': following_url,
      'gists_url': gists_url,
      'starred_url': starred_url,
      'subscriptions_url': subscriptions_url,
      'organizations_url': organizations_url,
      'repos_url': repos_url,
      'events_url': events_url,
      'received_events_url': received_events_url,
      'type': type,
      'site_admin': site_admin,
      'contributions': contributions,
    };
  }

  @override
  String toString() {
    return """{
  "login": $login,
  "id": $id,
  "node_id": $node_id,
  "avatar_url": $avatar_url,
  "gravatar_id": $gravatar_id,
  "url": $url,
  "html_url": $html_url,
  "followers_url": $followers_url,
  "following_url": $following_url,
  "gists_url": $gists_url,
  "starred_url": $starred_url,
  "subscriptions_url": $subscriptions_url,
  "organizations_url": $organizations_url,
  "repos_url": $repos_url,
  "events_url": $events_url,
  "received_events_url": $received_events_url,
  "type": $type,
  "site_admin": $site_admin,
  "contributions": $contributions,
}""";
  }
}


/// （コントリビュータ）詳細モデル
@immutable
class DetailModel {
  final String login;
  final int id;
  final String node_id;
  final String? avatar_url;
  final String? gravatar_id;
  final String? url;
  final String? html_url;
  final String? followers_url;
  final String? following_url;
  final String? gists_url;
  final String? starred_url;
  final String? subscriptions_url;
  final String? organizations_url;
  final String? repos_url;
  final String? events_url;
  final String? received_events_url;
  final String? type;
  final bool site_admin;
  final String? name;
  final String? company;
  final String? blog;
  final String? location;
  final String? email;
  final String? hireable;
  final String? bio;
  final String? twitter_username;
  final int followers;
  final int following;
  final int public_repos;
  final int public_gists;

  const DetailModel({
    required this.login,
    required this.id,
    required this.node_id,
    this.avatar_url,
    this.gravatar_id,
    this.url,
    this.html_url,
    this.followers_url,
    this.following_url,
    this.gists_url,
    this.starred_url,
    this.subscriptions_url,
    this.organizations_url,
    this.repos_url,
    this.events_url,
    this.received_events_url,
    this.type,
    required this.site_admin,
    this.name,
    this.company,
    this.blog,
    this.location,
    this.email,
    this.hireable,
    this.bio,
    this.twitter_username,
    required this.followers,
    required this.following,
    required this.public_repos,
    required this.public_gists,
  });

  DetailModel.fromJson(Map<String, dynamic> json)
      : this(
    login: json["login"] as String,
    id: json["id"] as int,
    node_id: json["node_id"] as String,
    avatar_url: json["avatar_url"] as String?,
    gravatar_id: json["gravatar_id"] as String?,
    url: json["url"] as String?,
    html_url: json["html_url"] as String?,
    followers_url: json["followers_url"] as String?,
    following_url: json["following_url"] as String?,
    gists_url: json["gists_url"] as String?,
    starred_url: json["starred_url"] as String?,
    subscriptions_url: json["subscriptions_url"] as String?,
    organizations_url: json["organizations_url"] as String?,
    repos_url: json["repos_url"] as String?,
    events_url: json["events_url"] as String?,
    received_events_url: json["received_events_url"] as String?,
    type: json["type"] as String?,
    site_admin: json["site_admin"] as bool,
    name: json["name"] as String?,
    company: json["company"] as String?,
    blog: json["blog"] as String?,
    location: json["location"] as String?,
    email: json["email"] as String?,
    hireable: json["hireable"] as String?,
    bio: json["bio"] as String?,
    twitter_username: json["twitter_username"] as String?,
    followers: json["followers"] as int,
    following: json["following"] as int,
    public_repos: json["public_repos"] as int,
    public_gists: json["public_gists"] as int,
  );

  static List<DetailModel> fromJsonList(List<dynamic> jsonList) {
    return List.unmodifiable(jsonList.map((json) => DetailModel.fromJson(json)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "login": login,
      "id": id,
      "node_id": node_id,
      "avatar_url": avatar_url,
      "gravatar_id": gravatar_id,
      "url": url,
      "html_url": html_url,
      "followers_url": followers_url,
      "following_url": following_url,
      "gists_url": gists_url,
      "starred_url": starred_url,
      "subscriptions_url": subscriptions_url,
      "organizations_url": organizations_url,
      "repos_url": repos_url,
      "events_url": events_url,
      "received_events_url": received_events_url,
      "type": type,
      "site_admin": site_admin,
      "name": name,
      "company": company,
      "blog": blog,
      "location": location,
      "email": email,
      "hireable": hireable,
      "bio": bio,
      "twitter_username": twitter_username,
      "followers": followers,
      "following": following,
      "public_repos": public_repos,
      "public_gists": public_gists,
    };
  }

  @override
  String toString() {
    return """{
  "login": $login,
  "id": $id,
  "node_id": $node_id,
  "avatar_url": $avatar_url,
  "gravatar_id": $gravatar_id,
  "url": $url,
  "html_url": $html_url,
  "followers_url": $followers_url,
  "following_url": $following_url,
  "gists_url": $gists_url,
  "starred_url": $starred_url,
  "subscriptions_url": $subscriptions_url,
  "organizations_url": $organizations_url,
  "repos_url": $repos_url,
  "events_url": $events_url,
  "received_events_url": $received_events_url,
  "type": $type,
  "site_admin": $site_admin,
  "name": $name,
  "company": $company,
  "blog": $blog,
  "location": $location,
  "email": $email,
  "hireable": $hireable,
  "bio": $bio,
  "twitter_username": $twitter_username,
  "followers": $followers,
  "following": $following,
  "public_repos": $public_repos,
  "public_gists": $public_gists,
}""";
  }
}


// REST API 通信サービスを提供するパッケージ

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
    "content-type": "application/json; charset=utf-8",
    "accept": "application/json",
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
      /*
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
    */
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
