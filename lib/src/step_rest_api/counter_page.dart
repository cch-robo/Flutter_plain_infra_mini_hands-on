// デフォルト・カウンターアプリのコードに、カウント値が 10以上で REST API をコールするよう変更。
// REST API コール基盤により、GitHub Android コントリビュータ取得の動作確認を行います。

import 'package:flutter/material.dart';

import '../infra/debug_logger.dart';
import '../infra/rest_api_service.dart';
import 'detail_model.dart';
import 'overview_model.dart';

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
    // カウント値が、10以上であれば REST API をコールします。
    if (_counter >= 10) {
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
