---
layout: docs-ja
title: "Be Framework ディレクトリ構成"
category: Convention
permalink: /manuals/1.0/ja/convention/directory-layout.html
---

# ディレクトリ構成

> 10個の `src/<dir>/` スロット、それぞれに単一の責務

すべての Be Framework アプリケーションは同じ `src/<dir>/` スロット群を使います。最初から必須のものもあれば、対応するパターンを採用するまで空のままにしておくものもあります。[スケルトン](https://github.com/be-framework/skeleton)はそれらすべてを同梱しているので、コードを置く場所に迷う必要はありません。

## 全体マップ

| dir | 役割 | マニュアル |
|---|---|---|
| `src/Input/`      | パイプラインの起点。`#[Be([Target::class])]` で次段を宣言。                                | [Input クラス](../02-input-classes.html) |
| `src/Final/`      | 終点。`#[Input]` でデータ、`#[Inject]` でサービスを受け取る。                              | [Final オブジェクト](../04-final-objects.html) |
| `src/Semantic/`   | セマンティック変数（バリデータ）。クラス名 = パラメータ名（camelCase）。                   | [セマンティック変数](../06-semantic-variables.html) |
| `src/Exception/`  | セマンティック検証例外。`#[Message]` で多言語化。                                          | [エラーハンドリング](../09-error-handling.html) |
| `src/Reason/`     | 「存在を可能にするもの」— Entity、Media（Command/Query）、ポリシー、ガード。               | [Reason レイヤー](../08-reason-layer.html) |
| `src/Module/`     | Ray.Di モジュール。`MODULE=<name>` で有効モジュールを切り替え。                            | （スケルトン固有） |
| `src/Becoming/`   | フレームワーク配線層。ユーザーコードを置く場所ではない。                                    | [Becoming](../04a-becoming.html) |
| `src/Being/`      | *(空)* `$being` 判別子 + `#[Be([FinalA, ...])]` を使う Branching 中間形。                  | [Being クラス](../03-being-classes.html) |
| `src/LogContext/` | *(空)* `Been` に添えるセマンティックログのイベントクラス。                                  | [セマンティックロギング](../10-semantic-logging.html) |
| `src/Moment/`     | *(空)* Diamond の部分 — `MomentInterface` を実装し、`be()` で潜在性を実現。                | [メタモルフォーシスパターン](../05-metamorphosis-patterns.html) |

## ディレクトリ別リファレンス

### `src/Input/`

**役割**: あらゆるメタモルフォーシスパイプラインの起点。
**置くもの**: `<Domain>Input` という命名の final readonly クラス。`#[Be([Target::class])]` で次の姿を宣言する。
**置かないもの**: 検証、サービス、ビジネスロジック — Input は純粋なデータと「次は何になるか」の宣言だけ。
**スケルトン例**: `HelloInput.php`
**詳しく**: [Input クラス](../02-input-classes.html)

### `src/Final/`

**役割**: パイプラインの終点 — Input が変容した先の姿。
**置くもの**: コンストラクタで `#[Input]` データと `#[Inject]` サービスを受け取り、結果の状態を凍結する final readonly クラス。
**置かないもの**: `#[Be(...)]` 宣言 — Final に到達した時点でパイプラインは終わる。
**スケルトン例**: `HelloFinal.php`
**詳しく**: [Final オブジェクト](../04-final-objects.html)

### `src/Semantic/`

**役割**: パラメータに型レベルで意味を与える。クラス名そのものがパラメータ名。
**置くもの**: バリデータクラス（例: `EmailAddress`、`CustomerId`）。コンストラクタで制約を強制し、違反時は例外を投げる。
**置かないもの**: 汎用的な値オブジェクト — セマンティック変数は特定のパラメータ名に紐づく。
**スケルトン例**: `Name.php`
**詳しく**: [セマンティック変数](../06-semantic-variables.html)

### `src/Exception/`

**役割**: 多言語対応メッセージ付きのセマンティック検証失敗。
**置くもの**: `#[Message(en: "...", ja: "...")]` を付けた例外クラス。`src/Semantic/` のコンストラクタから throw される。
**置かないもの**: 汎用的な実行時エラー — それはフレームワークの関心事であって、ドメインのセマンティクスではない。
**スケルトン例**: `InvalidNameException.php`
**詳しく**: [エラーハンドリング](../09-error-handling.html)

### `src/Reason/`

**役割**: 「存在を可能にするもの」。Entity、Media（Ray.MediaQuery による Command/Query インタフェース）、ポリシー、ガードを収める。
**置くもの**: リポジトリインタフェース、Ray.MediaQuery インタフェース、ポリシークラス、それらが読み書きする Entity。
**置かないもの**: 具象サービスの実装はモジュールに置く — Reason は契約とルールの層。
**スケルトン例**: `Hello/HelloEntity.php`、`Hello/SayHelloInterface.php`
**詳しく**: [Reason レイヤー](../08-reason-layer.html)

### `src/Module/`

**役割**: 依存性配線。各モジュールは Ray.Di のモジュールクラス。
**置くもの**: `AppModule`（本番配線）と、`DevModule`、`TestModule` などの代替。`MODULE=<name>` 環境変数で選択する。
**置かないもの**: アプリケーションロジック — モジュールはインタフェースと実装の束縛だけを行う。
**スケルトン例**: `AppModule.php`、`DevModule.php`
**詳しく**: スケルトン固有（スケルトンの `CLAUDE.md` を参照）。

### `src/Becoming/`

**役割**: フレームワーク配線層 — `Becoming` 自体のアダプタ。
**置くもの**: デコレータや代替の `BecomingInterface` 実装（例: 実行ごとにセマンティックログを書き出すもの）。
**置かないもの**: アプリケーションコード。フレームワークの動作方法に関するものでなければここではない。
**スケルトン例**: `DevBecoming.php`
**詳しく**: [Becoming](../04a-becoming.html)

### `src/Being/` *(デフォルトでは空)*

**役割**: 分岐の中間形。`$being` 判別子を持ち `#[Be([FinalA::class, FinalB::class])]` を宣言するクラス。フレームワークが実行時に次の姿を選ぶ。
**置くもの**: 分岐ポイントごとに 1 ファイル — `$being` がユニオン型を返す `<Domain>Being.php`。
**置かないもの**: 線形パイプライン — 中間形を経由せず Input から Final まで直行する場合は不要。
**スケルトン例**: *(デフォルトでは空)*
**詳しく**: [Being クラス](../03-being-classes.html)

### `src/LogContext/` *(デフォルトでは空)*

**役割**: パイプライン内で起きたことを記述する、`Been` に添えるセマンティックログのイベントクラス。
**置くもの**: `AbstractContext` のサブクラス。イベントにちなんだ名前（例: `OrderFinalizedContext`）。
**置かないもの**: 単なる DTO — これらのクラスは `koriym/semantic-logger` が読み取り、ツリーへ描画する。
**スケルトン例**: *(デフォルトでは空)*
**詳しく**: [セマンティックロギング](../10-semantic-logging.html)

### `src/Moment/` *(デフォルトでは空)*

**役割**: Diamond パターンの部分。*潜在性* を保持し、`be()` でそれを実現する `MomentInterface` の実装。
**置くもの**: 捉える瞬間にちなんだ名前のクラス（`PaymentCapture`、`InventoryReservation`）。周囲のパイプラインから `realize` callable が配線される。
**置かないもの**: 単発の操作 — Moment は線形ステップではなく、Diamond の収束パターンのためのもの。
**スケルトン例**: *(デフォルトでは空)*
**詳しく**: [メタモルフォーシスパターン](../05-metamorphosis-patterns.html)

## なぜ 3 つのディレクトリは空のままなのか

`src/Being/`、`src/LogContext/`、`src/Moment/` は `.gitkeep` のプレースホルダで出荷されます。これらはオプションのパターン（Branching、セマンティックロギング、Diamond 収束）に対応しており、どのアプリケーションも必要とするわけではありません。

空のままにしておくことで、

- **静的解析がクリーンに保たれる** — PHPStan や psalm を惑わせるサンプルクラスがない。
- **カバレッジレポートが正直になる** — パーセンテージを水増し・水減らしするボイラープレートがない。
- **プロジェクトの形が意図を語る** — `src/Being/` にファイルがあれば *このアプリは分岐を使っている* という意味になる。スケルトンが偶然同梱していたから、ではない。

これらのパターンを採用するときに、対応するディレクトリへ最初の実クラスを置けば、そのスロットはもう空ではなくなります。
