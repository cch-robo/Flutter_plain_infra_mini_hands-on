// デフォルト・カウンターアプリのコードに、カウント値が 10以上でエラーを発生するよう変更。
// Flutter フレームワークのエラーハンドラ設定により、エラーの詳細ログを出力させます。

import 'package:flutter/material.dart';

import '../infra/app_error_handler.dart';
import '../infra/default_error.dart';

void main() {
  // TODO add line start.
  // アプリのエラーハンドラを設定して、アプリを起動します。
  // アプリ起動前に必要な設定は、起動前に実行しておいてください。
  AppErrorHandler().runAppWithErrorHandler(const MyApp());
  // TODO add line end.
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
      throw DefaultError('Count value is over 10.');
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
