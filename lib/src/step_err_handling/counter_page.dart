// デフォルト・カウンターアプリのコードに、カウント値が 10以上でエラーを発生するよう変更。
// トライキャッチ強制の処理実行基盤でエラーを捕捉して、エラー対応済のログを出力させます。

import 'package:flutter/material.dart';

import '../infra/debug_logger.dart';
import '../infra/default_error.dart';
import '../infra/try_catch_executor.dart';

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
