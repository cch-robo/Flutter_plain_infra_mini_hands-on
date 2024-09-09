import 'package:flutter/material.dart';

// step.1:flutter create で作られたプロジェクトのデフォルト・カウンターアプリのコード
import 'src/step_1/counter_page.dart' as step_1;

// step.2:カウンター機能（状態オブジェクト）を DIコンテナ対応にします。
import 'src/step_2/counter_page.dart' as step_2;

// step.3:依存実態をラップした注入先にカウント値のログ出力を追加します。
import 'src/step_3/counter_page.dart' as step_3;


void main() {
  step_1.main();
}
