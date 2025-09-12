---
layout: docs-ja
title: "3. 存在クラス"
category: Manual
permalink: /manuals/1.0/ja/03-being-classes.html
---

# 存在クラス

> 「道常無為而無不為」
> 
> —道は常に無為にして、而も為さざることなし（老子『道徳経』第三十七章　紀元前6世紀）

## 内在と超越

存在クラスは変容が実際に起こる場所です。

オブジェクト自身が持つ性質（**内在的性質（イマナンス）**）と、外部から提供される力（**超越的な力（トランセンデンス）**）が出会い、次の新しい存在が生まれます。入力クラスが「始まり」なら、存在クラスは「変わる瞬間」を表現します。

## 基本構造

```php
final class UserProfile
{
    public readonly string $displayName;
    public readonly bool $isValid;
    
    public function __construct(
        #[Input] string $name,                    // 内在的
        #[Input] string $email,                   // 内在的
        #[Inject] NameFormatter $formatter,       // 超越的
        #[Inject] EmailValidator $validator       // 超越的
    ) {
        $this->displayName = $formatter->format($name);     // 新しい内在的
        $this->isValid = $validator->validate($email);      // 新しい内在的
    }
}
```

## 変容パターン

すべての存在クラスは同じ変容の流れに従います：

**内在的性質** (`#[Input]`) + **超越的力** (`#[Inject]`) → **新しい内在的性質**

- **内在的要因**: オブジェクトが前の形態から継承するもの
- **超越的要因**: 世界によって提供される外部の能力と文脈
- **新しい内在的**: この相互作用から生まれる変容した存在

## エンテレケイア - なりたい自分になる

コンストラクタは新しい自己が生まれる特別な場所です。なるべき自己になるために、内在的性質と、自らは持たないが世界から与えられる超越的な力が出会い、変容のロジックが働きます。

```php
final class OrderCalculation
{
    public readonly Money $subtotal;
    public readonly Money $tax;
    public readonly Money $total;
    
    public function __construct(
        #[Input] array $items,                    // 内在的
        #[Input] string $currency,                // 内在的
        #[Inject] PriceCalculator $calculator,    // 超越的
        #[Inject] TaxService $taxService          // 超越的
    ) {
        $this->subtotal = $calculator->calculateSubtotal($items, $currency);
        $this->tax = $taxService->calculateTax($this->subtotal);
        $this->total = $this->subtotal->add($this->tax);     // 新しい内在的
    }
}
```

1. 前のクラスから受け継いだプロパティがコンストラクタの引数となって、注入された外部の能力と出会う。
2. 相互に作用して変容のロジックが働く。
3. プロパティの代入によって新しい存在が誕生する。

エンテレケイア（entelecheia）とは、アリストテレスが提唱した哲学概念で、潜在性が現実性へと移行する過程を表します。オブジェクトが持つ可能性が、外部の力との相互作用によって実現される瞬間です。Be Frameworkでは、このコンストラクタでの変容過程がまさにエンテレケイアの実現と考えています。

## 最終オブジェクトへの橋渡し

存在クラスはしばしば橋として機能し、最終変容のためのデータを準備します：

```php
#[Be([SuccessfulOrder::class, FailedOrder::class])]  // 複数の運命
final class OrderValidation
{
    public readonly bool $isValid;
    public readonly array $errors;
    public readonly SuccessfulOrder|FailedOrder $being;  // 存在プロパティ
    
    public function __construct(
        #[Input] Money $total,                    // 内在的
        #[Input] CreditCard $card,                // 内在的
        #[Inject] PaymentGateway $gateway         // 超越的
    ) {
        $result = $gateway->validate($card, $total);
        $this->isValid = $result->isValid();
        $this->errors = $result->getErrors();
        
        // 運命の自己決定
        $this->being = $this->isValid 
            ? new SuccessfulOrder($total, $card)
            : new FailedOrder($this->errors);
    }
}
```

## 自然な流れ

存在クラスは何かを「する」のではありません。自身の内在的性質と、世界から与えられる（自らは持たない）超越的力との相互作用を通して、自然にあるべき姿へと変容します。これは道教でいう無為自然の原理です。他の何かを変えるのではなく、自分自身が変わっていきます。
