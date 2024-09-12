import 'package:flutter/material.dart';

// step.1:flutter create で作られたプロジェクトのデフォルト・カウンターアプリのコード
import 'src/step_1/counter_page.dart' as step_1;

// step.2:カウンター機能（状態オブジェクト）を DIコンテナで生成させます。
import 'src/step_2/counter_page.dart' as step_2;

// step.3:カウンター機能（状態オブジェクト）を DIコンテナでラップ先に注入可能にします。
import 'src/step_3/counter_page.dart' as step_3;

// step.4:依存実態をラップした注入先にカウント値のログ出力を追加します。
import 'src/step_4/counter_page.dart' as step_4;

// step.5:簡易DIコンテナによる依存注入のまとめ。
import 'src/step_5/counter_page.dart' as step_5;

/*
// step_creatable:カウンター機能（状態オブジェクト）を DIコンテナで生成させます。
import 'src/step_di_creatable/counter_page.dart' as step_creatable;

// step_injectable:カウンター機能（状態オブジェクト）を DIコンテナでラップ先に注入可能にします。
import 'src/step_di_injectable/counter_page.dart' as step_injectable;

// step_usage:依存実態をラップした注入先にカウント値のログ出力を追加します。
import 'src/step_di_usage/counter_page.dart' as step_usage;
*/

void main() {
  step_1.main();
}
