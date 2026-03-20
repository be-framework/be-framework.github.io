---
layout: docs-ja
title: "6. 意味変数"
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

## 属性による制約の拡張

同じ名前に属性を加えることで、存在条件をより精密にできます。`#[Validate]`属性が付いたメソッドでは、メソッド引数に属性（例: `#[Teen]`）が指定されていると、コンストラクタ側に同じ属性があるときだけ実行されます：

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

意味変数は単独の制約だけでなく、変数間の関係も制約として持ちます。`#[Validate]`属性が付いたメソッドの引数名がコンストラクタの引数名と部分一致すると、対応する値が自動的に渡されます：

```php
// フォーマット検証 — メールアドレスの一致確認
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
// 順序比較 — 開始日は終了日より前
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
// 外部サービス参照 — 郵便番号と都道府県の整合性
final readonly class ZipPrefecture
{
    public function __construct(
        private ZipResolver $resolver   // DIで注入
    ) {}

    #[Validate]
    public function validate(string $zipCode, string $prefecture): void
    {
        if (!$this->resolver->matches($zipCode, $prefecture)) {
            throw new ZipPrefectureMismatchException();
        }
    }
}
```

一度定義すれば、引数名がマッチする任意のコンストラクタに自動適用されます：

```php
// EmailConfirmation + DateRange が自動適用
public function __construct(
    string $email,
    string $confirmEmail,
    string $startDate,
    string $endDate,
) {}
```

```php
// ZipPrefecture が自動適用
public function __construct(
    string $zipCode,
    string $prefecture,
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
