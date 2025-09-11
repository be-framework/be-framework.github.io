---
layout: docs-ja
title: "2. 入力クラス"
category: Manual
permalink: /manuals/1.0/ja/02-input-classes.html
---

# 入力クラス

入力クラスは、Beフレームワークにおけるすべての変容の出発点です。これらは純粋な**内在的**本質—何かが既にあるもの、その本質的なアイデンティティを運びます。

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

**変容の運命**: `#[Be()]`属性は、この入力が何になるかを宣言します。

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

## 内在的の役割

入力クラスでは、すべてが**内在的**—オブジェクトが変容へと運び込む固有の本質です。ここには**超越的**な力はありません；それらは後で存在クラスにおいて現れます。

これは変容方程式の「自己」部分を表します：
**内在的 + 超越的 → 新しい内在的**

入力クラスは基礎を提供します—世界と出会い、何か新しいものになる「既にあるもの」です。