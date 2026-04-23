---
layout: docs-ja
title: "Getting Started"
category: Manual
permalink: /manuals/1.0/ja/getting-started.html
---

# Getting Started

> 概念を学んだら、実際に動かしてみましょう。

## 要件

- PHP 8.4+
- Composer

## インストール

```bash
composer create-project be-framework/skeleton my-project --stability dev
cd my-project
```

## サンプルを実行

```bash
composer dev
```

出力:

```txt
Hello World
```

これだけです！コードを見てみましょう。

## プロジェクト構造

```
bin/
└── be.php                  # CLIエントリポイント
src/
├── Input/
│   └── HelloInput.php      # 出発点
├── Final/
│   └── Hello.php           # 目的地
├── Reason/
│   └── Greeting.php        # 超越的な能力
├── Semantic/
│   └── Name.php            # 意味的変数
├── Exception/
│   └── EmptyNameException.php
└── Module/
    └── AppModule.php       # DI設定
```

## コード

### Input クラス

```php
#[Be([Hello::class])]
final readonly class HelloInput
{
    public function __construct(
        public string $name
    ) {}
}
```

`#[Be]` 属性はこの入力が何になるか、自らの**運命**を宣言します。

### Final クラス

```php
final readonly class Hello
{
    public string $greeting;

    public function __construct(
        #[Input] string $name,
        #[Inject] Greeting $greeting,
    ) {
        $this->greeting = "{$greeting->greeting} {$name}";
    }
}
```

- `#[Input]` は前の段階（HelloInput）からデータを受け取ります。
- `#[Inject]` は外部からの能力（超越）を受け取ります。

### Reason クラス

```php
final class Greeting
{
    public string $greeting = 'Hello';
}
```

Greeting は超越 — 挨拶する力—を提供します。

### 変容（メタモルフォーシス）の実行

```php
$injector = new Injector(new AppModule());
$becoming = new Becoming($injector, 'Be\\App\\Semantic');

$input = new HelloInput('World');
$hello = $becoming($input);

echo $hello->greeting;  // "Hello World"
```

## 何が起きたのか？

```
HelloInput('World')
    ↓ Becoming が実行
Hello (Greeting が注入された状態)
    → "Hello World"
```

入力オブジェクトは何もしていません — 変容を通じて Hello になった(BEING)のです。

## セマンティック検証を試す

`bin/be.php` を編集して空の名前を渡してみましょう:

```php
$input = new HelloInput('');
```

再度実行:

```bash
composer dev
```

`Semantic/Name.php` が名前が空であることを検証するため、エラーメッセージが表示されます。空の名前は存在できないのです。

## 示された主要概念

| 概念 | この例では |
|------|----------|
| **内在** | HelloInput の `$name` |
| **超越** | `#[Inject]` で注入された `Greeting` |
| **変容** | HelloInput → Hello の変換 |
| **セマンティック検証** | Name.php が入力を検証 |

## 次のステップ

Being クラスと分岐を含むより完全な例に進む準備ができましたか？ [チュートリアル](./tutorial.html) へ →

または概念を復習:
- [Input Classes](./02-input-classes.html) - 出発点
- [Final Objects](./04-final-objects.html) - 目的地
- [Semantic Variables](./06-semantic-variables.html) - ドメインオントロジー
