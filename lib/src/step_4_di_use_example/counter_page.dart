// 依存を分離するため、カウンター機能（状態オブジェクト）を、DI コンテナから取得させます。
// 状態オブジェクトを直接生成（ハードコード）していないため、注入依存が差替可能になります。

import 'package:flutter/material.dart';

import '../infra/debug_logger.dart';
import '../infra/dependency_injector.dart';
import 'counter_di.dart';

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
  late Counter _counter;

  @override
  void initState() {
    super.initState();
    var di = CounterDiContainer.singleton;
    _counter = di.create();
    /*
    // 依存元のカウンタ状態に Dark Magicをマウントする
    int id = di.listUpIds().first;
    DarkMagicCounter magic = DarkMagicCounter();
    di.mount(id, magic);
    */
  }

  @override
  void dispose() {
    var di = CounterDiContainer.singleton;
    /*
    // 依存元のカウンタ状態から Dark Magicをアンマウントする
    int id = di.listUpIds().first;
    di.unmount(id);
    */
    di.deleteAll();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter.increment();
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

/// 自身に依存元が注入され、注入先の依存元として差し替えられる「多段階の入れ子注入先」
class DarkMagicCounter extends AbstractInjectable<ReferencableCounter> implements InjectableCounter {
  DarkMagicCounter();

  @override
  int get count {
    return reference!.count;
  }

  @override
  set count(int value) => reference!.count = value;

  @override
  void increment() {
    // increment 実行前後の counter値をログ出力する。
    debugLog('before - increment: count=$count');
    reference!.increment();
    debugLog('after  - increment: count=$count');
  }
}
