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
| `src/Reason/`     | 「存在理由」 — その存在に必要な能力を1つに集めたもの。                          | [Reason レイヤー](../08-reason-layer.html) |
| `src/Module/`     | Ray.Di モジュール。`MODULE=<name>` 環境変数で有効モジュールを切り替える。       | [Ray.Di マニュアル](https://ray-di.github.io/manuals/1.0/ja/index.html) |
| `src/Becoming/`   | フレームワーク配線層 — `BecomingInterface` の実装やデコレータ。                 | [Becoming](../04a-becoming.html) |
| `src/Being/`      | 分岐 — `$being` 判別子 + `#[Be([A, B])]`。                                     | [Being クラス](../03-being-classes.html) |
| `src/LogContext/` | `Been` に添えるセマンティックログのイベントクラス。                              | [セマンティックロギング](../10-semantic-logging.html) |
| `src/Moment/`     | Moment — Reason が返した Potential を保持し、`be()` で実現する。                | [Reason レイヤー](../08-reason-layer.html) |

## `src/Input/`

```php
#[Be(HelloFinal::class)]
final readonly class HelloInput
{
    public function __construct(
        public string $name,
    ) {}
}
```

Input は外部から渡されるデータで作られる最初のドメインクラスです。`#[Be(...)]` 属性で「次に何になるか」を1つ、または複数持ちます。

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

変容の終点のクラスです。`#[Be(...)]` は持ちません。`#[Input]` は内在(前段から渡ってきたもの)、`#[Inject]` は超越(外から与えられるサービス)です。完了の証拠は `#[Inject] Been` で記されます。

→ [Final オブジェクト](../04-final-objects.html)

## `src/Semantic/`

```php
final class Email
{
    #[Validate]
    public function validate(string $email): void
    {
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new InvalidEmailException($email);
        }
    }
}
```

クラス名がそのままパラメータ名になります。`#[Validate]` は `$email` という名の引数すべてに自動で効きます — 一度定義すれば、アプリ全域に適用されます。

→ [セマンティック変数](../06-semantic-variables.html)

## `src/Exception/`

```php
#[Message([
    'en' => 'Invalid email: {email}',
    'ja' => '不正なメールアドレス: {email}',
])]
final class InvalidEmailException extends \DomainException
{
    public function __construct(public string $email) {}
}
```

`#[Message]` には言語コード（`en`、`ja` など）をキーにした配列を1つ渡します。`{email}` のようなプレースホルダは、throw 時に例外のプロパティからアサインされます。

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

「`ExpressDelivery` として存在するには何が必要か?」 — その答えが `ExpressShipping` です。その存在に必要な能力を1つに集めたクラスで、`#[Inject]` で能力として注入することも、`$being` の型として次段を決めることもできます。

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

`MODULE=Dev` のような環境変数で切り替えるDIの束縛設定です。本番用の `AppModule` を変えずに、`DevModule` や `TestModule` で実装を差し替えられます。

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

普段は触りません。メタモルフォーシスの実行そのものに手を入れたいとき(ログ・トレース・計測)だけ使います。

→ [Becoming](../04a-becoming.html)

## `src/Being/`

```php
#[Be([ApprovalNotification::class, RejectionNotification::class])]
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

ユニオン型の `$being` には Reason オブジェクト（`Approved` か `Rejected`）が入り、その型が `#[Be([...])]` のどの候補に進むかを決めます。`ApprovalNotification` は `#[Input] Approved $being` を、`RejectionNotification` は `#[Input] Rejected $being` を宣言します。フレームワークは候補のうち、引数が用意できる最初のものを選びます（[マッチングルール](../05-metamorphosis.html#matching-rules)参照）。

→ [Being クラス](../03-being-classes.html)

## `src/LogContext/`

```php
final class EmailFormatAssertedContext extends AbstractContext
{
    public const string TYPE = 'email_format_asserted';
    public const string SCHEMA_URL = '../schemas/email-format-asserted.json';

    public function __construct(
        public readonly string $email,
    ) {}
}
```

`TYPE` はログに出るイベント名、`SCHEMA_URL` はスキーマへのリンクです。Final 内で `$been->with(new EmailFormatAssertedContext(...))` として、そのオブジェクトが成立したことの証拠を記録します。

→ [セマンティックロギング](../10-semantic-logging.html)

## `src/Moment/`

```php
final readonly class PaymentCompleted implements MomentInterface
{
    public PaymentCapture $capture;

    public function __construct(
        #[CardNumber] string $cardNumber,   // DI qualifier attribute
        #[Amount] int $amount,              // DI qualifier attribute
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

Moment は前段のオブジェクトからではなく DI コンテナによって生成されるので、値はモジュールで束縛したアプリケーション定義の修飾属性（`#[CardNumber]`、`#[Amount]`）経由で渡されます。コンストラクタで `authorize()` は済みます(Potential)が、`capture()` はまだです。全 Moment を生成できた Final だけが `be()` を順に呼びます — 準備に失敗した場合は何もコミットされません。後続の `be()` が失敗すると先に成功したコミットは残るので、その補償は Reason の責務です。

→ [Reason レイヤー](../08-reason-layer.html)

---

3つのディレクトリ — `Being/`、`LogContext/`、`Moment/` — はデフォルトでは空です。必要に応じて、クラスを追加していきます。