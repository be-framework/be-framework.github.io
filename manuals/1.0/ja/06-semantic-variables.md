---
layout: docs-ja
title: "6. 意味変数"
category: Manual
permalink: /manuals/1.0/ja/06-semantic-variables.html
---

# 意味変数

> 「存在すべきものは有効でなければなりません。存在できないものは決して生まれることはありません。」

意味変数はBeフレームワークの最も深い原理を体現します：**意味のある存在のみが存在できる**。

## 問題

従来の型は無意味なものから守ります：

```php
function createUser(string $name, string $email, int $age) {
    if (empty($name)) throw new Exception();
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) throw new Exception();
    // ... 無限の防御的プログラミング
}
```

## 解決法

意味変数は「これは有効ですか？」から「これは存在できますか？」へと根本的な問いを変えます。

```php
function createUser(PersonName $name, EmailAddress $email, Age $age) {
    // ここに到達すれば、存在は既に保証されています
}
```

## 存在の定義

すべての意味変数はそのドメインで何が存在できるかを定義します：

```php
final class Name
{
    #[Validate]
    public function validate(string $name): void
    {
        if (empty(trim($name))) {
            throw new EmptyNameException();
        }
    }
}
```

複数の検証コンテキストが自然に存在します：

```php
final class ProductCode
{
    #[Validate]
    public function validate(string $code): void { /* 標準ルール */ }

    #[Validate] 
    public function validateLegacy(#[Legacy] string $code): void { /* レガシールール */ }

    #[Validate]
    public function validatePremium(#[Premium] string $code): void { /* プレミアムルール */ }
}
```

## 意味のある失敗

存在が失敗したとき、意味は保持されなければなりません：

```php
#[Message([
    'en' => 'Name cannot be empty.',
    'ja' => '名前は空にできません。'
])]
final class EmptyNameException extends DomainException {}
```

フレームワークは投げる前に**すべての検証エラー**を収集し、何が存在できないかの完全な理解を作り出します。

## 自然な統合

意味変数は存在コンストラクタで自動的に動作します：

```php
final readonly class UserProfile
{
    public function __construct(
        #[Input] #[English] public string $name,    // 英語名として自動検証
        #[Input] string $emailAddress,              // メールとして自動検証
        #[Inject] NameFormatter $formatter
    ) {
        // この時点で、すべての入力が有効であることが保証されています
    }
}
```

## 階層的検証

意味変数は互いに構築できます：

```php
final class TeenAge  
{
    #[Validate]
    public function validate(#[Teen] int $age): void
    {
        // 基本的なAge検証を継承し、ティーン固有のルールを追加
        if ($age < 13) throw new TeenAgeTooYoungException();
        if ($age > 19) throw new TeenAgeTooOldException();
    }
}
```

## エラーハンドリング

多言語エラーメッセージは自動的に適応します：

```php
try {
    $userProfile = $becoming(new UserRegistrationInput($data));
} catch (SemanticVariableException $e) {
    $englishMessages = $e->getErrors()->getMessages('en');
    $japaneseMessages = $e->getErrors()->getMessages('ja');
}
```

## 革命

意味変数は**不可能な状態を不可能にする**ことで防御的プログラミングを排除します。

型システムは**ドメイン言語**になります—各型があなたのビジネスドメインで何が存在できるかの意味を運びます。

関数シグネチャは**ドキュメント**になります：
```php
function processOrder(ProductCode $product, PaymentAmount $amount, CustomerAge $age)
{
    // シグネチャが仕様です
}
```

---

**次へ**: オブジェクトが自身の性質を発見する[型駆動変容](07-type-driven-metamorphosis.html)について学びましょう。

*「意味変数はデータを検証するだけでなく、意味のある存在のみが存在できることを保証します。」*