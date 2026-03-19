---
layout: docs-ja
title: "7. 意味変数"
category: Manual
permalink: /manuals/1.0/ja/06-semantic-variables.html
---

# 意味変数

> 「存在するものは必然的に存在し、存在しないものは必然的に存在しない」
>
> 　　—スピノザ『エチカ』第1部定理29（1677年）

## 意味と制約

`$email`は単なる文字列ではありません。意味変数は情報の識別子であり、意味を表し、制約を持つ完全な情報モデルです：

```php
final class Email
{
    #[Validate]
    public function validate(string $email): void
    {
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new InvalidEmailException();
        }
    }
}

// $emailという名前を持つ任意のコンストラクタ引数に自動適用される
public function __construct(string $email) {}
```

一度定義すれば、`$email`という名前のすべてのコンストラクタ引数に自動的に適用されます。`$email`の値が正しいのは偶然ではなく、必然です。正しくなれないものは存在できません。

## 名前の装飾

同じ名前に属性を加えることで、存在条件をより精密にできます。`#[Validate]`メソッドに属性が付いている場合、コンストラクタ引数の属性とマッチしたときだけ実行されます：

```php
// $ageの基本制約（0-150歳）
final readonly class Age
{
    #[Validate]
    public function validate(int $age): void
    {
        if ($age < 0 || $age > 150) {
            throw new InvalidAgeException();
        }
    }

    // #[Teen]属性がある場合のみ追加実行される
    #[Validate]
    public function validateTeen(#[Teen] int $age): void
    {
        if ($age < 13 || $age > 19) {
            throw new InvalidTeenAgeException();
        }
    }
}
```

```php
// 基本のAge検証のみ適用
public function __construct(int $age) {}

// Age検証 + Teen検証の両方が適用
public function __construct(#[Teen] int $age) {}
```

同じ`$age`でも、属性によって異なる存在条件が適用されます。

## 名前が関係を持つ

意味変数は単独の制約だけでなく、変数間の関係も制約として持ちます。`#[Validate]`メソッドの引数名がコンストラクタの引数名と部分マッチすると、対応する値が自動的に渡されます：

```php
// メールアドレスの一致確認
final readonly class EmailConfirmation
{
    #[Validate]
    public function validate(string $email, string $confirmEmail): void
    {
        if ($email !== $confirmEmail) {
            throw new EmailMismatchException();
        }
    }
}
```

```php
// 開始日は終了日より前でなければならない
final readonly class DateRange
{
    #[Validate]
    public function validate(string $startDate, string $endDate): void
    {
        if ($startDate > $endDate) {
            throw new InvalidDateRangeException();
        }
    }
}
```

```php
// 最小値は最大値以下でなければならない
final readonly class MinMax
{
    #[Validate]
    public function validate(int $min, int $max): void
    {
        if ($min > $max) {
            throw new MinExceedsMaxException();
        }
    }
}
```

一度定義すれば、引数名がマッチする任意のコンストラクタに自動適用されます：

```php
// EmailConfirmation + MinMax が自動適用
public function __construct(
    string $email,
    string $confirmEmail,
    int $min,
    int $max,
) {}
```

```php
// DateRange が自動適用
public function __construct(
    string $startDate,
    string $endDate,
) {}
```

## 名前に宿る制約

名前の力はフォーマット検証にとどまりません：

```php
public function __construct(
    public string $email,          // フォーマット制約
    public float $bodyTemperature, // 値の範囲制約
    public string $inStockItemId,  // ビジネスルール制約
) {}
```

フォーマットから値の範囲、さらにビジネスルールまで——名前が存在の条件を定義します。

名前に宿る制約が守られないとき、存在は失敗します。その扱い方は[意味例外](./09-error-handling.html)で学びます。

---

存在する理由のない存在はありません。[存在理由層](./08-reason-layer.html)へ ➡️
