---
layout: docs-ja
title: "4. 最終オブジェクト"
category: Manual
permalink: /manuals/1.0/ja/04-final-objects.html
---

# 最終オブジェクト

> 「あなたは私ではない。どうして私が魚の気持ちを知らないと分かるのか？」
>
> —「あなたは魚ではない。どうして魚の気持ちが分かるのか」と問われた時に荘子が返した言葉 （『荘子』紀元前4世紀）

## 終着点

ユーザーにとって見えるのは、入力と最終オブジェクトだけです。入力クラスで始まった旅が、最終オブジェクトとして届く—これが変容の到達点です。

## 基本構造

```php
final readonly class SuccessfulOrder
{
    public string $orderId;
    public string $confirmationCode;
    public DateTimeImmutable $timestamp;
    public string $message;
    public BeenProcessed $been;          // 完了の証跡

    public function __construct(
        #[Input] Money $total,                    // 内在
        #[Input] CreditCard $card,                // 内在
        #[Inject] OrderIdGenerator $generator,    // 超越
        #[Inject] Receipt $receipt                // 超越
    ) {
        $this->orderId = $generator->generate();
        $this->confirmationCode = $receipt->generate($total);
        $this->timestamp = new DateTimeImmutable();
        $this->message = "注文確認: {$this->orderId}";

        $this->been = new BeenProcessed(
            actor: $card->getHolderName(),
            timestamp: $this->timestamp,
            evidence: [
                'total' => $total->getAmount(),
                'payment_method' => $card->getType(),
                'confirmation' => $this->confirmationCode
            ]
        );
    }
}
```

`BeenProcessed`はアプリケーションが定義するクラスです。何を「完了の証跡」とするかはドメインによって異なります。誰がいつどのように削除したかを記録する必要があるかもしれませんし、タイムスタンプだけで十分かもしれません。ドメインが必要とする証跡に応じて`$been`クラスを設計します。

入力クラスとは対照的に、最終オブジェクトはドメインの豊かさを完全に表現した存在です。内在が超越と出会い、変容を経て、これ以上変わる必要のない完全な状態に達しています。成功も失敗も同じ構造です。たとえば`FailedOrder`も、拒否の証跡として`$been`を持ちます。

## 時間的存在の完全性

Be Frameworkでは、オブジェクトの時間的存在を二つの軸で捉えます：

- **`#[Be]`**: なりたい自分、向かう先（未来への方向性）
- **`$been`**: 完了した自分（過去完了の証跡）

`$orderId`や`$confirmationCode`はビジネス上の本質的な値です。一方`$been`は、いつ・誰が・何を根拠に完了したかという証跡を記録します。

## 内側からの完全性

従来のプログラミングでは、オブジェクトが正しく処理されたかどうかを外部のテストが判定します。しかし最終オブジェクトは、自分が何であるかを自分自身の構造として持っています。何が入力され、何が起こり、何になったか—その全てが一つの存在の中に収まり、完了の証拠になっています。

## 入力クラスとの対比

| 入力クラス | 最終オブジェクト |
|-----------|-----------------|
| 変容の出発点 | 変容の到達点 |
| ユーザーが提供するもの | ユーザーが受け取るもの |
| シンプルな構造 | 豊かで完全な状態 |

## 複数の最終的運命

オブジェクトはその性質によって複数の最終形態を持つことができます。ここで使っている`$becoming`は変容チェーンを起動する仕組みで、[次章](./04a-becoming.html)で説明します：

```php
$order = $becoming(new OrderInput($items, $card));

if ($order instanceof SuccessfulOrder) {
    echo $order->confirmationCode;
} else {
    echo $order->message;  // エラーメッセージ
}
```

## 設計者の仕事

入力と最終オブジェクトの間にある変容の仕組みを設計すること—それが設計者の責務です。ユーザーが触れるのは両端だけですが、その間の存在クラスがシステムの骨格になります。

最終オブジェクトは、自分が完了したことを内側から知っています。

---

宣言された変容はどう動き出すのか。[生成](./04a-becoming.html)へ ➡️
