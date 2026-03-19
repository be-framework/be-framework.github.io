---
layout: docs-ja
title: "2. 入力クラス"
category: Manual
permalink: /manuals/1.0/ja/02-input-classes.html
---

# 入力クラス

> 「私たちは自分で選択できない条件から始まり、そこから自分の存在を築く」
> 
> 　　—ハイデガーの被投性（Geworfenheit）概念より（『存在と時間』1927年）

## 出発点

入力クラスは、Beフレームワークにおけるすべての変容の出発点です。

ここにはオブジェクト自身が持つ要素だけが含まれ、外部依存がありません。いわばオブジェクトのアイデンティティです。オブジェクトの内側にあるものなので、これを**内在（Immanence）**と呼びます。

## 基本構造

```php
#[Be(ValidatedUser::class)]  // 変容の運命
final readonly class UserInput
{
    public function __construct(
        public string $name,     // 内在
        public string $email     // 内在
    ) {}
}
```

## 主要な特徴

**純粋なアイデンティティ**: 入力クラスはオブジェクトが根本的に*何であるか*のみを含みます—外部依存関係や複雑なロジックはありません。

**ユースケースの起点**: すべてのユースケースは固有の入力クラスを持ちます。

**変容先（オブジェクトの運命）**: `#[Be()]`属性は、この入力が何になるかを宣言します。

**読み取り専用プロパティ**: すべてのプロパティは `readonly` です。入力クラスの値は変更されません。

## 例

### 単純なデータ入力
```php
#[Be(OrderCalculation::class)]
final readonly class OrderInput
{
    public function __construct(
        public array $items,        // 内在
        public string $currency     // 内在
    ) {}
}
```

### 複雑な構造化入力
```php
#[Be(PaymentProcessing::class)]
final readonly class PaymentInput
{
    public function __construct(
        public Money $amount,      // 内在
        public CreditCard $card,   // 内在
        public Address $billing    // 内在
    ) {}
}
```

---

入力クラスが外の世界と出会い、変容を始めます。その過程を[存在クラス](./03-being-classes.html)で見ていきます ➡️
