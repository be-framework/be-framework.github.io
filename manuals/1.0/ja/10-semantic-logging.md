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

Be Frameworkでは、オブジェクトの変容が構造化ログとして自動記録されます。

従来のログはイベントの断片的な記録です。`[INFO] User registered` と書かれたテキスト行からは、何がどう変わってその結果に至ったのかは読み取れません。意味的ログは変容の完全なストーリーを記録します。何が何になり、何を根拠にそうなったのか。

技術的基盤は[Koriym.SemanticLogger](https://github.com/koriym/Koriym.SemanticLogger)です。型安全な構造化ログ、Open/Event/Closeパターン、JSONスキーマ検証を提供します。

## 自動記録される変容ログ

`Becoming`エンジンは変容のたびにログを自動出力します。開発者が記録コードを書く必要はありません。

```php
#[Be(RegisteredUser::class)]
final readonly class UnverifiedEmail
{
    public function __construct(
        public string $value,
    ) {}
}
```

この`UnverifiedEmail`を`Becoming`に渡すだけで、以下の構造が記録されます。

- **open**: 変容の開始。どのクラスから何への変容か、引数の出自（`#[Input]`か`#[Inject]`か）
- **events**: 変容の途中で起きた出来事
- **close**: 変容の完了。最終オブジェクトのプロパティと変容先

openとcloseはフレームワークが自動で書きます。eventsは開発者が書く。この分担が意味的ログの基本構造です。

## `$been` — 存在証明

Finalオブジェクトは「自分が何者であるか」を知っています。`$been`はその証拠です。

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

`Been`は`#[Inject]`でDIコンテナから受け取ります。`with()`を呼ぶたびに新しい`Been`が返り、同時にSemanticLoggerのストリームにイベントが書き込まれます。不変コレクションでありながらライブ書き込みを行う。この二面性は意図的な設計です。

構築が完了したとき、`$been`はこのオブジェクトがなぜ今の状態にあるのかを型付きイベントの列として保持しています。外部のテストが検証するまでもなく、オブジェクト自身が自分の来歴を知っている。

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

## 出力されるJSON

上記のコードを実行すると、以下のJSONが出力されます。

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

openが「何から何へ、どの材料で」、eventsが「途中で何が起きたか」、closeが「結果として何を持っているか」。変容の全体がひとつのJSONに収まっています。

`$been`プロパティ自身はcloseの`properties`から自動的に除外されます。ログが自分自身を含めば無限再帰になる。

## ログ駆動開発への接続

このJSONを眺めると、ひとつのことに気づきます。`$been`が内部に持つイベント列と、SemanticLoggerが外部に出力するJSON — この二つは同じものの表と裏です。

ということは、このJSONを先に手で書いて、そこからPHPクラスを生成することもできるのではないか。

その発想がログ駆動開発（LDD）です。詳しくは[ログ駆動開発](./13-vision-ldd.html)の章で扱います。

---

フレームワークの全体像は[リファレンス](./11-reference-resources.html)へ ➡️
