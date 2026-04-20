---
layout: docs-ja
title: "Be Framework ディレクトリ構成"
category: Convention
permalink: /manuals/1.0/ja/convention/directory-layout.html
---

# ディレクトリ構成

> 「論理的空間の中にある諸事実が、世界である」
>
> 　　—ルートヴィヒ・ウィトゲンシュタイン(『論理哲学論考』1.13, 1921年)

## 全体マップ

| dir | 役割 | マニュアル |
|---|---|---|
| `src/Input/`      | パイプラインの起点。`#[Be(...)]` を宣言。                                     | [Input クラス](../02-input-classes.html) |
| `src/Final/`      | 終点。`#[Input]` データと `#[Inject]` サービスを受ける。                       | [Final オブジェクト](../04-final-objects.html) |
| `src/Semantic/`   | セマンティック変数。クラス名 = パラメータ名。                                  | [セマンティック変数](../06-semantic-variables.html) |
| `src/Exception/`  | セマンティック検証例外。`#[Message]` で多言語化。                               | [エラーハンドリング](../09-error-handling.html) |
| `src/Reason/`     | 「存在理由」 — ある存在のしかたに必要なサービスを束ねたもの。                   | [Reason レイヤー](../08-reason-layer.html) |
| `src/Module/`     | Ray.Di モジュール。`MODULE=<name>` 環境変数で有効モジュールを切り替える。       | [Ray.Di マニュアル](https://ray-di.github.io/manuals/1.0/ja/index.html) |
| `src/Becoming/`   | フレームワーク配線層 — `BecomingInterface` の実装やデコレータ。                 | [Becoming](../04a-becoming.html) |
| `src/Being/`      | 分岐 — `$being` 判別子 + `#[Be([A, B])]`。                                     | [Being クラス](../03-being-classes.html) |
| `src/LogContext/` | `Been` に添えるセマンティックログのイベントクラス。                              | [セマンティックロギング](../10-semantic-logging.html) |
| `src/Moment/`     | Moment — Reason が返した Potential を保持し、`be()` で実現する。                | [メタモルフォーシスパターン](../05-metamorphosis-patterns.html) |

## `src/Input/`

```php
#[Be(HelloFinal::class)]
final readonly class HelloInput
{
    public function __construct(
        #[Input] public string $name,
    ) {}
}
```

Input はデータだけでなく「次に何になるか」を持ちます。`#[Be(...)]` が次段への引き渡しになります。

→ [Input クラス](../02-input-classes.html)

## `src/Final/`

```php
final readonly class HelloFinal
{
    public string $message;

    public function __construct(
        #[Input] string $name,
        #[Inject] Greeting $greeting,
    ) {
        $this->message = $greeting->say($name);
    }
}
```

`#[Be(...)]` は持ちません — ここが終点です。`#[Input]` は内在(前段から渡ってきたもの)、`#[Inject]` は超越(外から与えられるサービス)。完了の証拠は `#[Inject] Been` に記されます。

→ [Final オブジェクト](../04-final-objects.html)

## `src/Semantic/`

```php
final class Email
{
    #[Validate]
    public function validate(string $email): void
    {
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new InvalidEmailException();
        }
    }
}
```

クラス名そのものがパラメータ名です。`#[Validate]` は `$email` という名の引数すべてに自動で効きます — 一度定義すれば、アプリ全域に適用されます。

→ [セマンティック変数](../06-semantic-variables.html)

## `src/Exception/`

```php
#[Message(
    en: 'Invalid email: {email}',
    ja: '不正なメールアドレス: {email}',
)]
final class InvalidEmailException extends \DomainException {}
```

`#[Message]` の `en`/`ja` が i18n の単位です。`{email}` のようなプレースホルダは、throw 時に例外のプロパティから埋まります。

→ [エラーハンドリング](../09-error-handling.html)

## `src/Reason/`

```php
final readonly class ExpressShipping
{
    public function __construct(
        private PriorityCarrier $carrier,
        private RealTimeTracker $tracker,
    ) {}

    public function calculateFee(Weight $weight): Fee
    {
        return $this->carrier->expressFee($weight);
    }
}
```

1つのオブジェクトが「`ExpressDelivery` になるために必要なものは?」に答えます — carrier と tracker を束ねる形で。`#[Inject]` で能力として使うことも、`$being` に型付けして次段を決めることもできます。

→ [Reason レイヤー](../08-reason-layer.html)

## `src/Module/`

```php
final class AppModule extends AbstractModule
{
    protected function configure(): void
    {
        $this->bind(PriorityCarrier::class)->to(FedExPriority::class);
        $this->bind(RealTimeTracker::class)->to(FedExTracker::class);
    }
}
```

`MODULE=Dev` のような環境変数で切り替わります。代替モジュール側で `override` を使えば、本番配線に一切触れずに実装を差し替えられます。

→ [Ray.Di マニュアル](https://ray-di.github.io/manuals/1.0/ja/index.html)

## `src/Becoming/`

```php
final readonly class LoggingBecoming implements BecomingInterface
{
    public function __construct(
        private Becoming $inner,
        private LoggerInterface $logger,
    ) {}

    public function __invoke(object $input): object
    {
        $this->logger->info('becoming', ['input' => $input::class]);
        return ($this->inner)($input);
    }
}
```

普段は触りません。メタモルフォーシスの実行そのものに手を入れたいとき(ログ・トレース・計測)だけ使います。ドメインコードは置きません。

→ [Becoming](../04a-becoming.html)

## `src/Being/`

```php
#[Be([Approved::class, Rejected::class])]
final readonly class ApplicationReview
{
    public Approved|Rejected $being;

    public function __construct(
        #[Input] LoanApplication $app,
        #[Inject] CreditCheck $check,
    ) {
        $this->being = $check->evaluate($app);
    }
}
```

`$being` の実行時の型が `#[Be([...])]` の中から次段を選びます。プロパティ名はユニオン型でありさえすれば自由ですが、`$being` と書くと分岐点であることが一目で伝わります。

→ [Being クラス](../03-being-classes.html)

## `src/LogContext/`

```php
final class EmailFormatAssertedContext extends AbstractContext
{
    public const string TYPE = 'email_format_asserted';
    public const string SCHEMA_URL = 'https://example.com/schemas/email-format-asserted.json';

    public function __construct(
        public readonly string $email,
    ) {}
}
```

`TYPE` はログに出るイベント名、`SCHEMA_URL` は外部スキーマへのリンクです。Final 内で `$been->with(new EmailFormatAssertedContext(...))` として添付します。

→ [セマンティックロギング](../10-semantic-logging.html)

## `src/Moment/`

```php
final readonly class PaymentCompleted implements MomentInterface
{
    public PaymentCapture $capture;

    public function __construct(
        #[Input] string $cardNumber,
        #[Input] int $amount,
        #[Inject] PaymentGateway $gateway,
    ) {
        $this->capture = $gateway->authorize($cardNumber, $amount);
    }

    public function be(): void
    {
        $this->capture->be();
    }
}
```

コンストラクタで `authorize()` は済みます(Potential)が、`capture()` はまだです。全 Moment を生成できた Final だけが `be()` を一斉に呼びます — 部分的なコミットは起こりません。

→ [メタモルフォーシスパターン](../05-metamorphosis-patterns.html)

---

3つのディレクトリ — `Being/`、`LogContext/`、`Moment/` — はデフォルトでは空です。スケルトンのデフォルトは `Input → Final` の線形パイプラインで、分岐・セマンティックロギング・Diamond パターンは opt-in です。空のまま置いておくことで、そのパターンが必要になるまで静的解析とカバレッジをクリーンに保てます。
