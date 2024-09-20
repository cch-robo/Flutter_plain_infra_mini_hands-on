// 機能仕様になかった、追加要件の機能を提供するサンプルの注入先クラスです。
// increment メソッド実行ごとに、実行前後のカウント値をログ出力します。

import 'counter_di.dart';
import '../infra/dependency_injector.dart';
import '../infra/debug_logger.dart';

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
