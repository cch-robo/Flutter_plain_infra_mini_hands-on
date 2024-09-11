// カウンター機能を Dependency Inject コンテナ対応にする。
//
// カウンター機能は、仕様基底インターフェースと、仕様実装クラスのみ追加して、
// オブジェクトの生成と保管管理ができるようにしますが、DI コンテナで依存注入はできません。

/// Counter オブジェクトの DIコンテナ・クラス
class CounterDiContainer {}

/// DI から依存元として参照可能な Counter クラス
class CounterImpl implements ReferencableCounter {}

/// 機能実態の注入先 -  Counter オブジェクト注入先の基底インターフェース
abstract interface class InjectableCounter {}

/// 機能挙動の依存元 - Counter オブジェクトの基底インターフェース
abstract interface class ReferencableCounter {}

/// 機能仕様の依存元 - Counter オブジェクトの基底インターフェース
abstract interface class Counter {
}
