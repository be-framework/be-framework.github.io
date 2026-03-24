---
layout: docs-ja
title: "意味例外"
category: Manual
permalink: /manuals/1.0/ja/09-error-handling.html
---

# 意味例外

> 「過ちて改めざる、これを過ちという」
>
> 　　—孔子『論語』(紀元前551-479年)

## 意味のある失敗

汎用例外は**何が起きたか**を伝えます：

```php
catch (Exception $e) {
    echo $e->getMessage();  // "検証に失敗しました"
}
```

それに対して意味例外は**なぜ存在できないか**を伝えます：

```php
catch (SemanticVariableException $e) {
    foreach ($e->getErrors()->exceptions as $exception) {
        echo get_class($exception) . ": " . $exception->getMessage();
        // EmptyNameException: 名前は空にできません
        // InvalidEmailException: メール形式が無効です
    }
}
```

## ドメイン例外クラス

すべての例外は`DomainException`を継承します。ドメイン層では技術的例外（`RuntimeException`、`InvalidArgumentException`等）を使わず、常にドメイン例外を使います。失敗は常に**ドメインの意味を持つ失敗**として表現されます：

```php
abstract class DomainException extends Exception {}

final readonly class EmptyNameException extends DomainException {}

final readonly class InvalidEmailException extends DomainException
{
    public function __construct(public string $invalidEmail)
    {
        parent::__construct("メール形式が無効です: {$invalidEmail}");
    }
}

// 年齢関連の存在失敗
abstract class AgeException extends DomainException {}
final readonly class NegativeAgeException extends AgeException {}
final readonly class AgeTooHighException extends AgeException {}
```

ドメイン例外はメッセージだけでなく**構造化データ**を持ちます。`$invalidEmail`プロパティから、プログラムは無効なメールアドレスの値にアクセスできます——表示、APIレスポンス、ログなど、さまざまな用途に：

```php
catch (InvalidEmailException $e) {
    $logData = [
        'invalid_email' => $e->invalidEmail,    // プログラムからアクセス可能
        'user_ip' => $request->getClientIp(),
        'timestamp' => now()
    ];
    Logger::warning('Invalid email attempt', $logData);
}
```

## 多言語メッセージ

`#[Message]`属性で、例外はユーザーの言語で話します：

```php
#[Message([
    'en' => 'Name cannot be empty.',
    'ja' => '名前は空にできません。',
    'es' => 'El nombre no puede estar vacío.'
])]
final readonly class EmptyNameException extends DomainException {}

#[Message([
    'en' => 'Age must be at least {min} years.',
    'ja' => '年齢は最低{min}歳でなければなりません。'
])]
final readonly class AgeTooYoungException extends DomainException
{
    public function __construct(public int $min = 13) {}
}
```

## エラー収集

フレームワークは最初のエラーで止まらず、**すべての検証エラー**を収集します：

```php
try {
    $user = $becoming(new UserInput('', 'invalid-email', 10));
} catch (SemanticVariableException $e) {
    // 3つのエラーが同時に収集される:
    // - EmptyNameException
    // - InvalidEmailException
    // - AgeTooYoungException

    $messages = $e->getErrors()->getMessages('ja');
    // ["名前は空にできません", "メール形式が無効です", "年齢は最低13歳でなければなりません"]
}
```

最初のエラーで即座に失敗するのではなく、すべての問題を一度に把握できます。

## エラーも存在の１つ

エラー状態も変容の有効な結果として扱えます：

```php
#[Be([ValidUser::class, InvalidUser::class])]
final readonly class UserValidation
{
    public ValidUser|InvalidUser $being;

    public function __construct(#[Input] string $data)
    {
        try {
            $this->being = new ValidUser($data);
        } catch (ValidationException $e) {
            $this->being = new InvalidUser($e->getErrors());
        }
    }
}
```

例外で実行を止めるのではなく、エラーを型として表現する。失敗も成功と同じく、変容の正当な結果です。

---

フレームワークの全体像は[リファレンス](./11-reference-resources.html)へ ➡️
