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

従来のログ:

```
[INFO] User registered: alice@example.com
[INFO] Verification passed
[INFO] Insert into users table
```

意味的ログ:

```json
{
  "open": { "from": "UnverifiedEmail", "to": "RegisteredUser" },
  "events": [
    { "type": "email_format_asserted", "context": { "email": "alice@example.com" } },
    { "type": "user_inserted", "context": { "userId": 42, "email": "alice@example.com" } }
  ],
  "close": { "properties": { "userId": 42, "value": "alice@example.com" } }
}
```

従来のログは行単位のテキストが時系列に並ぶだけで、どの行が同じ操作に属するかは読み手の推測に委ねられます。

意味的ログでは、ひとつの変容がひとつのJSONに収まります。変容元と変容先、途中の出来事、最終プロパティ — 「何が何になり、なぜそうなったか」が型付きの構造化データとして記録され、JSONスキーマで検証できます。

Be Frameworkには二つの意味的記録の仕組みがあります。

- **`$been`** — Finalオブジェクトが自分の来歴を保持する証明（proof）
- **`SemanticLoggerInterface`** — 階層的な操作を記録するログ（log）

|          | log                          | `$been`                          |
|----------|------------------------------|----------------------------------|
| 性質     | descriptive（記述）          | constitutive（構成）             |
| 視点     | 第三者（観測者）             | 一人称                           |
| 問い     | 何が起きたか                 | なぜ今の私なのか                 |
| 文法     | doing                        | being                            |
| 役割     | 記録                         | 証明                             |

## `$been` — 存在証明

Finalオブジェクトのコンストラクタで`Been`をインジェクトし、`with()`で出来事を記録していくと、そのオブジェクトがなぜ今の状態にあるかの証明になります。

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

`Been`は`#[Inject]`でDIコンテナから受け取ります。受け取った`Been`にはフレームワークが変容開始時に記録した変容元・変容先の情報がすでに含まれています。開発者は`with()`で、Finalオブジェクトの内部でしか知り得ない出来事 — メールを検証した、ユーザーを挿入した — を追記します。

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

DDDでいうドメインイベント — ビジネス上「起きたこと」を表すオブジェクトです。Finalオブジェクトが完了までに経験した事実を、アプリケーション固有のイベントコンテキストとして定義します。

## SemanticLoggerInterface — 階層的な操作記録

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

`$been`はFinalオブジェクトが何であるかの証明です。`SemanticLoggerInterface`は従来のログに近い、途中経過の詳細な記録です。通常は`$been`で足ります。

## 変容の自動記録

`$been`や`SemanticLoggerInterface`とは別に、変容そのものもフレームワークがopen/closeで自動記録します。開発者がこの記録コードを書く必要はありません。

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

## ログからDSLへ

従来のログは実行の記録です。コードが走った後に生まれ、デバッグに使われ、やがて消えます。

このJSONは違います。実行の記録であると同時に、変容の仕様でもあり、存在の証明でもあります。どこから来て、どう成ったのか、何であるのかの記録です。「`UnverifiedEmail`が`RegisteredUser`になる過程で`email_format_asserted`と`user_inserted`が起きる」— これは過去の事実の記述としても、未来の期待の宣言としても読めます。しかも型付きの構造化データなので、AIが読み書きできるDSLとしても機能します。

記録、仕様、証明、DSL。この四つが同じJSONに重なるとき、JSONスキーマによるテスト並みの厳密な検証と、ログからコードを生成しコードからログを生成する循環が可能になりえます。

---

技術的基盤: [Koriym.SemanticLogger](https://github.com/koriym/Koriym.SemanticLogger)

フレームワークの全体像は[リファレンス](./11-reference-resources.html)へ ➡️
