---
layout: docs-ja
title: "9. エラーハンドリング"
category: Manual
permalink: /manuals/1.0/ja/09-error-handling.html
---

# エラーハンドリング & 検証

> 「存在できないものは理解されなければなりません。失敗は明確な言語を通して意味を保持します。」

Beフレームワークにおけるエラーハンドリングは例外をキャッチすることではありません—**存在が失敗したときに意味を保持する**ことです。

## 汎用的例外を超えて

従来のエラーハンドリングは意味を失います：

```php
try {
    $user = new User($name, $email, $age);
} catch (Exception $e) {
    // 何が間違っていたのか？なぜ？どう修正するのか？
    echo $e->getMessage();  // "検証に失敗しました"
}
```

## 意味的例外: 失敗における意味

すべての失敗は**特定の存在論的意味**を持ちます：

```php
try {
    $user = $becoming(new UserInput($name, $email, $age));
} catch (SemanticVariableException $e) {
    foreach ($e->getErrors()->exceptions as $exception) {
        echo get_class($exception) . ": " . $exception->getMessage();
        // EmptyNameException: 名前は空にできません。
        // InvalidEmailFormatException: メール形式が無効です。
        // AgeTooYoungException: 年齢は最低13歳でなければなりません。
    }
}
```

## 例外階層

ドメイン例外は意味のあるカテゴリーを形成します：

```php
abstract class DomainException extends Exception {}

final class EmptyNameException extends DomainException {}

final class InvalidEmailFormatException extends DomainException
{
    public function __construct(public readonly string $invalidEmail)
    {
        parent::__construct("メール形式が無効です: {$invalidEmail}");
    }
}

// 年齢関連の存在失敗
abstract class AgeException extends DomainException {}
final class NegativeAgeException extends AgeException {}
final class AgeTooHighException extends AgeException {}
```

## 多言語エラーメッセージ

意味的例外はユーザーの言語で話します：

```php
#[Message([
    'en' => 'Name cannot be empty.',
    'ja' => '名前は空にできません。',
    'es' => 'El nombre no puede estar vacío.'
])]
final class EmptyNameException extends DomainException {}

#[Message([
    'en' => 'Age must be between {min} and {max} years.',
    'ja' => '年齢は{min}歳から{max}歳の間でなければなりません。'
])]
final class AgeOutOfRangeException extends DomainException
{
    public function __construct(
        public readonly int $age,
        public readonly int $min = 0,
        public readonly int $max = 150
    ) {}
}
```

## 自動エラー収集

フレームワークは投げる前に**すべての検証失敗**を収集します：

```php
final class UserValidation
{
    public function __construct(
        #[Input] string $name,      // EmptyNameExceptionを投げる可能性
        #[Input] string $email,     // InvalidEmailFormatExceptionを投げる可能性
        #[Input] int $age           // NegativeAgeExceptionを投げる可能性
    ) {
        // いずれかの検証が失敗すると、すべてのエラーが収集される
        // 単一のSemanticVariableExceptionがすべてを含む
    }
}
```

「即座に失敗」ではなく—**完全な理解と共に完全に失敗**。

## エラー回復パターン

エラーは独自の権利における**有効な存在**になります：

```php
#[Be([ValidUser::class, InvalidUser::class])]
final class UserValidation
{
    public readonly ValidUser|InvalidUser $being;
    
    public function __construct(
        #[Input] string $name,
        #[Input] string $email,
        #[Input] int $age
    ) {
        try {
            $this->being = new ValidUser($name, $email, $age);
        } catch (ValidationException $e) {
            $this->being = new InvalidUser($e->getErrors());
        }
    }
}
```

## 意味ログ統合

検証失敗は文脈と共に自動的にログされます：

```php
{
    "event": "metamorphosis_failed",
    "source_class": "UserInput",
    "destination_class": "UserProfile", 
    "errors": [
        {
            "exception": "EmptyNameException",
            "message": "名前は空にできません",
            "field": "name",
            "value": ""
        }
    ]
}
```

## 開発 vs プロダクション

```php
// 開発: 詳細なエラー詳細
if (app()->environment('local')) {
    $errors->getDetailedMessages();
}

// プロダクション: ユーザーフレンドリーなメッセージ
$errors->getMessages('ja');
// ["名前は空にできません。", "メール形式が無効です。"]
```

## エラー条件のテスト

```php
public function testCollectsAllValidationErrors(): void
{
    try {
        $becoming(new UserInput('', 'invalid-email', -5));
        $this->fail('SemanticVariableExceptionが予期されました');
    } catch (SemanticVariableException $e) {
        $errors = $e->getErrors();
        $this->assertCount(3, $errors->exceptions);
    }
}
```

## 革命

意味的例外はエラーハンドリングを**問題報告**から**意味保持**に変換します。

存在が失敗したとき、理由は**明確で、実行可能で、多言語**になります。

エラーは障害ではありません—それらは成功した変容へとユーザーを導く**有効な存在**です。

---

**次へ**: より深い原理を理解するために[背後にある哲学](10-philosophy-behind.html)について学びましょう。

*「意味的例外は失敗を報告するだけではありません—存在できないものの意味を保持します。」*