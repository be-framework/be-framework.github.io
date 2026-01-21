---
layout: docs-ja
title: "デモ"
category: Manual
permalink: /manuals/1.0/ja/demos.html
---

# デモ

Be Frameworkの概念を実際に動作する例で示します。

## Hello World デモ

最もシンプルな変換です。名前を持つInputが、挨拶を持つFinalになります。

```text
HelloInput  →  Hello
(name)         (greeting)
```

### Input（潜在性）

```php
#[Be([Hello::class])]
final readonly class HelloInput
{
    public function __construct(
        public string $name,
    ) {}
}
```

`#[Be]`属性は、このInputが「何になれるか」を宣言します。

### Final（現実態）

```php
final readonly class Hello
{
    public string $greeting;

    public function __construct(
        #[Input] string $name,       // HelloInputから
        #[Inject] Greeting $greeting, // DIコンテナから
    ) {
        $this->greeting = "{$greeting->greeting} {$name}";
    }
}
```

### Reason（存在理由）

```php
final class Greeting
{
    public string $greeting = 'Hello';
}
```

名前がReasonという外部の力を借りて挨拶になります。ここではGreetingが'Hello'を提供しています。

### 使用例

```php
$input = new HelloInput(name: 'World');
$final = ($becoming)($input);

echo $final->greeting; // "Hello World"
```

### リンク

- [ソースコード](https://github.com/be-framework/demos/tree/1.x/demos/hello-world)

---

## Order Processing デモ

Order Processingデモは、**Diamond Metamorphosis**パターンを示します。複数の並列パイプラインが単一のFinal状態に収束するパターンです。

```text
                OrderInput
                    │
        ┌───────────┼───────────┐
        ↓           ↓           ↓
   [inventory]  [payment]  [shipping]
        ↓           ↓           ↓
   InventoryReserved PaymentCompleted ShippingArranged
        │           │           │
        └───────────┼───────────┘
                    ↓
              OrderConfirmed
```

### 主要な概念

#### Moment（契機）

> **注意**: Momentは発展途上の概念です。ここで紹介するアイデアは現時点での理解を表しており、実践的な経験やフィードバックに基づいて改善される可能性があります。

Momentには3つの側面があります：

- **デュナミス（δύναμις）** - 実現可能な潜在性、`be()`により現実化
- **契機** - 全体を構成する不可欠な要素
- **自己の部分** - 外部ではなく、Finalの内部

```php
final readonly class PaymentCompleted implements MomentInterface
{
    public PaymentCapture $capture;

    public function __construct(
        #[CardNumber] public string $cardNumber,
        #[Amount] public int $amount,
        #[Inject] PaymentGatewayInterface $gateway,
    ) {
        $this->capture = $gateway->authorize($cardNumber, $amount);
    }

    public function be(): void
    {
        $this->capture->be();  // 潜在性を実現
    }
}
```

#### Reason（存在理由）

Reasonは**内在と超越が出会う場所** - 内部データを外部システムやドメインルールに接続するステートレスなゲートウェイです。

```php
final class PaymentGateway implements PaymentGatewayInterface
{
    public function authorize(string $cardNumber, int $amount): PaymentCapture
    {
        $authCode = $this->api->authorize($cardNumber, $amount);

        return new PaymentCapture(
            $authCode,
            $amount,
            fn () => $this->capture($authCode, $amount),
        );
    }
}
```

#### Final（エネルゲイア）

すべてのMomentが自己完成により実現される収束点：

```php
final readonly class OrderConfirmed
{
    public function __construct(
        #[Inject] public InventoryReserved $inventory,
        #[Inject] public PaymentCompleted $payment,
        #[Inject] public ShippingArranged $shipping,
    ) {
        // 自己完成：すべての部分を実現
        $this->inventory->be();
        $this->payment->be();
        $this->shipping->be();
    }
}
```

### 哲学的基盤

ディレクトリ構造は存在論的な概念に基づいています。

| ディレクトリ | 説明 | 概念 |
|------------|------|------|
| `Input/` | 「何になれるか」という潜在性を持つ入力 | δύναμις（アリストテレス） |
| `Being/` | 変容の途中段階 | Dasein（ハイデガー） |
| `Moment/` | 全体を構成する不可欠な部分 | 契機（ヘーゲル） |
| `Final/` | 変容の完了形 | ἐνέργεια（アリストテレス） |
| `Semantic/` | 検証と変換の力を持つ意味的な型 | Sinn（フレーゲ） |
| `Reason/` | 存在を可能にする外部の力 | 充足理由律（ライプニッツ） |

### リンク

- [デモサイト](https://be-framework.github.io/demos/) - インタラクティブなALPS状態図
- [ソースコード](https://github.com/be-framework/demos/tree/1.x/demos/order-processing) - 完全な実装
- [ALPSプロファイル](https://be-framework.github.io/demos/alps.html) - セマンティックオントロジー

---

*"Be, Don't Do"*
