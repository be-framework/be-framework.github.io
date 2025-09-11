---
layout: docs-ja
title: "2. 入力クラス"
category: Manual
permalink: /manuals/1.0/ja/02-input-classes.html
---

# 入力クラス

入力クラスは、Beフレームワークにおけるすべての変容の出発点です。

ここにはオブジェクト自身が持つ要素だけが含まれ、外部依存がありません。いわばオブジェクトのアイデンティティです。オブジェクトの内側にあるものなので、これを**内在的性質、イマナンス(Immanence)**と呼びます。

## 基本構造

```php
#[Be(UserProfile::class)]  // 変容の運命
final class UserInput
{
    public function __construct(
        public readonly string $name,     // 内在的
        public readonly string $email     // 内在的
    ) {}
}
```

## 主要な特徴

**純粋なアイデンティティ**: 入力クラスはオブジェクトが根本的に*何であるか*のみを含みます—外部依存関係や複雑なロジックはありません。

**変態先（オブジェクトの運命）**: `#[Be()]`属性は、この入力が何になるかを宣言します。

**読み取り専用プロパティ**: すべてのデータは不変であり、変異ではなく変容する固定されたアイデンティティを表します。

## 例

### 単純なデータ入力
```php
#[Be(OrderCalculation::class)]
final class OrderInput
{
    public function __construct(
        public readonly array $items,        // 内在的
        public readonly string $currency     // 内在的
    ) {}
}
```

### 複雑な構造化入力
```php
#[Be(PaymentProcessing::class)]
final class PaymentInput
{
    public function __construct(
        public readonly Money $amount,           // 内在的
        public readonly CreditCard $card,        // 内在的
        public readonly Address $billing         // 内在的
    ) {}
}
```

## イマナンス（内在的性質）の役割

入力クラスでは、すべてが**イマナンス（内在的性質）**です。ここには**トランセンデンス（超越的な力）**はありません。トランセンデンスとは外部から提供される、自分だけでは実現不可能な力のことです。それらは後で存在クラスにおいて現れます。

入力クラスは変容の出発点—世界と出会って、新しい何かへと変わっていく最初の姿を表します。
