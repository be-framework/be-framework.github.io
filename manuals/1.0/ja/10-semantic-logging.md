---
layout: docs-ja
title: "意味的ログ"
category: Manual
permalink: /manuals/1.0/ja/10-semantic-logging.html
---

# 意味的ログ

> 「記録されるものは記憶となり、記憶されるものは真実となる」
>
> 　　—オーウェル『1984年』の概念より（1949年）

## 概要

従来のログは「何が起きたか」を記録します。

```
[INFO] User registered: alice@example.com
```

意味的ログは「なぜそうなったか」を記録します。メールの形式が検証され、ユーザーテーブルにIDが払い出され、その二つの事実を根拠にこのオブジェクトは`RegisteredUser`になった — その全体が構造化データとして残ります。

Be Frameworkには二つの意味的記録の仕組みがあります。

- **`$been`** — Finalオブジェクトが自分の来歴を保持する証明（proof）
- **`SemanticLoggerInterface`** — 階層的な操作を記録するログ（log）

技術的基盤は[Koriym.SemanticLogger](https://github.com/koriym/Koriym.SemanticLogger)です。

## `$been` — 存在証明

`$been`はFinalオブジェクトの来歴を型付きイベントの列として保持します。

```php
final class RegisteredUser
{
    public readonly int $userId;
    public readonly Been $been;

    public function __construct(
        #[Input] string $value,
        #[Inject] EmailVerifier $verifier,
        #[Inject] UserRepository $users,
        #[Inject] Been $been,
    ) {
        if (! $verifier->check($value)) {
            throw new UnbecomingException('email format failed');
        }

        $this->userId = $users->insert(['email' => $value]);
        $this->been = $been
            ->with(new EmailFormatAssertedContext(
                email: $value,
            ))
            ->with(new UserInsertedContext(
                userId: $this->userId,
                email: $value,
            ));
    }
}
```

`Been`は`#[Inject]`でDIコンテナから受け取ります。`with()`を呼ぶたびに新しい`Been`が返り、同時にSemanticLoggerのストリームにもイベントが書き込まれます。

`Been`は証明に徹します。階層構造やスコープの概念はありません。「何がこのオブジェクトを今の状態にしたか」をフラットなイベント列で保持する — それだけです。

## イベントコンテキスト

`Been`に渡すイベントは`AbstractContext`のサブクラスです。

```php
final class EmailFormatAssertedContext extends AbstractContext
{
    public const string TYPE = 'email_format_asserted';
    public const string SCHEMA_URL = 'https://myvendor.example.com/schemas/email-format-asserted.json';

    public function __construct(
        public readonly string $email,
    ) {}
}
```

`TYPE`はログ上のイベント種別、`SCHEMA_URL`はそのイベントのJSONスキーマを指します。コンストラクタのプロパティがそのままJSONの`context`フィールドになります。

フレームワークはドメインイベントを一切提供しません。何を「起きたこと」として記録するかはアプリケーションが決めます。

## 意味的ログ

階層的な操作記録が必要な場合は、`SemanticLoggerInterface`を直接インジェクトします。

```php
final class RegisteredUser
{
    public function __construct(
        #[Input] string $value,
        #[Inject] UserRepository $users,
        #[Inject] SemanticLoggerInterface $logger,
    ) {
        // 意図を宣言（open）
        $id = $logger->open(new DbTransactionContext(table: 'users'));

        // 途中の出来事を記録（event）
        $this->userId = $users->insert(['email' => $value]);
        $logger->event(new RowInsertedContext(userId: $this->userId));

        // 結果を記録（close）
        $logger->close(new TransactionResultContext(committed: true), $id);
    }
}
```

open/event/closeは[Koriym.SemanticLogger](https://github.com/koriym/Koriym.SemanticLogger)の階層構造をそのまま使います。意図（intent）→ 出来事（occurrences）→ 結果（result）の三層で、ひとまとまりの操作を記録できます。

`$been`が「このオブジェクトは何者か」の証明であるのに対し、`SemanticLoggerInterface`は「何がどう行われたか」の詳細な記録です。

## 変容の自動記録

`$been`や`SemanticLoggerInterface`とは別に、`Becoming`エンジンは変容そのものをopen/closeで自動記録します。開発者がこの記録コードを書く必要はありません。

出力されるJSONの全体像です。

```json
{
  "open": {
    "type": "metamorphosis_open",
    "context": {
      "fromClass": "MyVendor\\MyApp\\UnverifiedEmail",
      "beAttribute": "#[Be(RegisteredUser::class)]",
      "immanentSources": {
        "value": "MyVendor\\MyApp\\UnverifiedEmail::value"
      },
      "transcendentSources": {
        "verifier": "MyVendor\\MyApp\\EmailVerifier",
        "users": "MyVendor\\MyApp\\UserRepository",
        "been": "Be\\Framework\\SemanticLog\\Been"
      }
    }
  },
  "events": [
    {
      "type": "email_format_asserted",
      "context": { "email": "alice@example.com" }
    },
    {
      "type": "user_inserted",
      "context": { "userId": 42, "email": "alice@example.com" }
    }
  ],
  "close": {
    "type": "metamorphosis_close",
    "context": {
      "properties": { "userId": 42, "value": "alice@example.com" },
      "be": { "finalClass": "MyVendor\\MyApp\\RegisteredUser" }
    }
  }
}
```

openが変容の意図（何から何へ、どの材料で）、eventsが`$been->with()`で記録された出来事、closeが結果（最終プロパティと変容先）です。

`$been`プロパティ自身はcloseの`properties`から自動的に除外されます。

## ログ駆動開発への接続

`$been`が内部に持つイベント列と、SemanticLoggerが外部に出力するJSON。この二つは同じものの表と裏です。

ということは、このJSONを先に手で書いて、そこからPHPクラスを生成することもできる。その発想がログ駆動開発（LDD）です。詳しくは[ログ駆動開発](./13-vision-ldd.html)の章で扱います。

---

フレームワークの全体像は[リファレンス](./11-reference-resources.html)へ ➡️
