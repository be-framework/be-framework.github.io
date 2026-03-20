---
layout: docs-ja
title: "生成"
category: Manual
permalink: /manuals/1.0/ja/04a-becoming.html
---

# 生成

> 「存在は無へと移行し、無は存在へと移行する。この運動が生成である」
>
> 　　—G.W.F. ヘーゲル『大論理学』（1812年）

## 変容の起動

2-4章で、入力クラス、存在クラス、最終オブジェクトの構造を見てきました。`#[Be()]`属性は「何になるか」を宣言しますが、宣言だけでは何も起きません。その宣言を実行に移すのが`Becoming`です：

```php
$finalObject = $becoming(new EmailInput($name, $email));
```

`EmailInput` → `EmailValidation` → `UserCreation` → `WelcomeMessage`。各クラスの`#[Be()]`宣言に従い、チェーン全体が自動的に実行されます。各オブジェクトは次のオブジェクトを生み出すと消滅し、この連鎖が終端まで続きます。

## Becomingの取得

`Becoming`はDIコンテナから注入されます：

```php
final readonly class UserRegistrationPage
{
    public function __construct(
        private BecomingInterface $becoming
    ) {}

    public function __invoke(string $name, string $email): WelcomeMessage
    {
        return ($this->becoming)(new EmailInput($name, $email));
    }
}
```

呼び出し側が知るのは、入力と出力だけです。途中の変容は`#[Be()]`宣言が決めます。

## ネストした生成

存在クラスの中で`Becoming`を使うことで、生成の中に別の生成を含むことができます：

```php
final readonly class OrderProcessing
{
    public PaymentResult $payment;
    public ShippingResult $shipping;

    public function __construct(
        #[Input] Order $order,                    // 内在
        #[Inject] Becoming $becoming              // 超越
    ) {
        $this->payment = $becoming(new PaymentInput($order->getPayment()));
        $this->shipping = $becoming(new ShippingInput($order->getAddress()));
    }
}
```

`Becoming`は超越として注入されるため、存在クラスの内部からも変容チェーンを起動できます。分岐した結果を最後に1つのオブジェクトに収束させるダイアモンド型の構成も可能です。

---

道は１つではありません。[変容](./05-metamorphosis.html)で様々な道を学びます ➡️
