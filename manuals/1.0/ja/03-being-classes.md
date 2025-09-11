---
layout: docs-ja
title: "3. 存在クラス"
category: Manual
permalink: /manuals/1.0/ja/03-being-classes.html
---

# 存在クラス

存在クラスは変容が起こる場所です。これらは前の段階からの**内在的**アイデンティティと世界からの**超越的**な力を受け取り、新しい存在形態を作り出します。

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

すべての存在クラスは同じ存在論的パターンに従います：

**内在的** (`#[Input]`) + **超越的** (`#[Inject]`) → **新しい内在的**

- **内在的要因**: オブジェクトが前の形態から継承するもの
- **超越的要因**: 世界によって提供される外部の能力と文脈
- **新しい内在的**: この相互作用から生まれる変容した存在

## 工房としてのコンストラクタ

コンストラクタは変容が起こる場所です。これは次のような完全な工房です：

1. アイデンティティが能力と出会う
2. 変容ロジックが存在する
3. 新しい不変の存在が生まれる

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

存在クラスは何かを「する」のではありません—自身の本質と世界の能力との相互作用を通して、自然にあるべき姿になります。これは強制的なコントロールなしに自然な変容の原理を体現しています。