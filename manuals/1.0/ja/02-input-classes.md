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

ここにはオブジェクト自身が持つ要素だけが含まれ、外部依存がありません。いわばオブジェクトのアイデンティティです。オブジェクトの内側にあるものなので、これを**内在的性質、イマナンス（Immanence）**と呼びます。

## 基本構造

```php
#[Be(UserProfile::class)]  // 変容の運命
final readonly class UserInput
{
    public function __construct(
        public string $name,     // 内在的
        public string $email     // 内在的
    ) {}
}
```

## 主要な特徴

**純粋なアイデンティティ**: 入力クラスはオブジェクトが根本的に*何であるか*のみを含みます—外部依存関係や複雑なロジックはありません。

**変容先（オブジェクトの運命）**: `#[Be()]`属性は、この入力が何になるかを宣言します。

**読み取り専用プロパティ**: すべてのデータは不変であり、変異ではなく変容する固定されたアイデンティティを表します。

## 例

### 単純なデータ入力
```php
#[Be(OrderCalculation::class)]
final readonly class OrderInput
{
    public function __construct(
        public array $items,        // 内在的
        public string $currency     // 内在的
    ) {}
}
```

### 複雑な構造化入力
```php
#[Be(PaymentProcessing::class)]
final readonly class PaymentInput
{
    public function __construct(
        public Money $amount,           // 内在的
        public CreditCard $card,        // 内在的
        public Address $billing         // 内在的
    ) {}
}
```

## イマナンスの役割

入力クラスでは、すべてが**イマナンス**です。ここには**トランセンデンス（Transcendence／超越的な力）**はありません。トランセンデンスは外部から提供される、自分だけでは実現不可能な力であり、それらは後で**存在クラス（Being クラス）**において現れます。

入力クラスは変容の出発点です。自己を超えたものと出会って、新しい何かへと変わっていく最初の姿を表します。

---

**次へ**: イマナンスが世界と出会う[存在クラス](./03-being-classes.html)について学びましょう。
