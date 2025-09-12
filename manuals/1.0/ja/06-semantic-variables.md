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

データの妥当性はどこで保証されるべきでしょうか？コントローラー？モデル？バリデーター？

Be Frameworkの答えは明確です：**名前そのものが制約を持つべき**と考えます。
`$email`は単なる文字列ではなく、**有効なメールアドレス**であるべきです。`$age`にはマイナスの値は存在できません。

意味変数は、情報の識別子であり、意味を表し、制約を持つ**完全な情報モデル**です。

## 問題：分散した不完全性

従来のアプローチでは、意味の定義が散在しています：

```php
// コントローラー/model/validator...
if (empty($name)) throw new Exception("error.name.empty");
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) throw new Exception("error.email.invalid");

// messages/ja.yml
error.name.empty: "名前を入力してください"
error.email.invalid: "有効なメールアドレスを入力してください"

// README.md
// "名前は1-100文字で空白のみは不可..."
```

以下の問題が発生します：
- **バリデーション**：コントローラーに散在
- **エラーメッセージ**：別ファイルで管理
- **制約ルール**：複数の場所に重複
- **意味定義**：ドキュメントにのみ存在

システムが扱う意味を集中して見ることのできる場所がありません。

## 解決法：意味的完全性

Be Frameworkは、分散した定義を**完全な情報モデル**として統合します。コンストラクタの引数やクラスのプロパティには、登録された**意味変数**のみを使用できます。

## 存在の定義

意味変数は専用フォルダにクラスとして定義されます：

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

## 検証コンテキスト

異なるビジネスコンテキストには異なるルールが適用されることがあります。意味変数は複数の検証コンテキストを自然にサポートします：

```php
final class ProductCode
{
    #[Validate]
    public function validate(string $code): void 
    { 
        // 標準的な商品コード検証（例：8桁の英数字）
        if (!preg_match('/^[A-Z0-9]{8}$/', $code)) {
            throw new InvalidProductCodeException();
        }
    }

    #[Validate] 
    public function validateLegacy(#[Legacy] string $code): void 
    { 
        // レガシーシステム用の緩い検証（例：6-10桁の英数字）
        if (!preg_match('/^[A-Z0-9]{6,10}$/', $code)) {
            throw new InvalidLegacyProductCodeException();
        }
    }

    #[Validate]
    public function validatePremium(#[Premium] string $code): void 
    { 
        // プレミアム商品用の厳格な検証（例：特定のプレフィックス必須）
        if (!preg_match('/^PREM[A-Z0-9]{4}$/', $code)) {
            throw new InvalidPremiumProductCodeException();
        }
    }
}
```

## 失敗の意味

存在が失敗したとき、失敗の意味が保持されなければなりません：

```php
#[Message([
    'en' => 'Name cannot be empty.',
    'ja' => '名前は空にできません。'
])]
final class EmptyNameException extends DomainException {}
```

フレームワークは最初に投げられる例外だけでなく、**すべての検証エラー**を例外の集合として収集し、なぜ存在できないかの完全な理解を作り出します。

## 自然な統合

意味変数はコンストラクタで自動的に動作します：

```php
final readonly class UserProfile
{
    public function __construct(
        #[Input] #[English] public string $name,    // 英語名として自動検証
        #[Input] string $emailAddress,              // メールアドレスとして自動検証
        #[Inject] NameFormatter $formatter
    ) {
        // この時点で、すべての入力が有効であることが保証されています
    }
}
```

変数名`$name`は`Name`意味変数クラスと、`$emailAddress`は`EmailAddress`意味変数クラスと自動的に関連付けられます。

## 階層的検証

意味変数は他の意味変数を基盤として構築できます。これはビジネスルールの自然な階層構造を型システムで表現する強力な手法です。

```php
final class TeenAge  
{
    #[Validate]
    public function validate(#[Teen] int $age): void
    {
        // まず基本的なAge検証が実行される（#[Teen]により自動的に呼び出される）
        // その後、ティーン固有のルールを追加
        if ($age < 13) throw new TeenAgeTooYoungException();
        if ($age > 19) throw new TeenAgeTooOldException();
    }
}
```

この階層的アプローチにより、豊かな意味の階層が構築されます：

- `Email` → `CorporateEmail`（企業ドメイン必須）→ `ExecutiveEmail`（役員レベルの制約）
- `Price` → `DiscountPrice`（割引率制限）→ `MemberPrice`（会員特価ルール）
- `Password` → `AdminPassword`（管理者要件）→ `SystemPassword`（システム管理者の厳格要件）
- `Address` → `ShippingAddress`（配送可能地域）→ `InternationalAddress`（国際配送対応）

各階層は前の層の制約を継承し、さらに固有の制約を追加します。基本的な`Email`検証が通らないものは、決して`ExecutiveEmail`として存在できません。これは単なる検証の組み合わせではなく、**概念の自然な精緻化**です。

## 関係性制約

意味変数は単独で存在するだけでなく、他の意味変数との関係性も制約として持てます。特筆すべきは**その記述の容易さ**です：

```php
final readonly class UserRegistration
{
    public function __construct(
        #[Input] string $email,
        #[Input] string $confirmEmail,
        #[Input] string $password,
        #[Input] string $confirmPassword,
    ) {
        // 何も書く必要はありません！
        // フレームワークが自動的に関係性を検証します
    }
}
```

フレームワークは、対象のコンストラクタのシグネチャと**部分マッチ**する検証クラスを自動的に発見し、適用します。

```php
// これがあれば...
final class EmailConfirmation
{
    #[Validate]
    public function validate(string $email, string $confirmEmail): void
    {
        if ($email !== $confirmEmail) {
            throw new EmailMismatchException();
        }
    }
}

// $email, $confirmEmail を持つ任意のコンストラクタで自動適用される！
```

関係性制約の例：
- `$startDate` と `$endDate`：開始日は終了日より前でなければならない
- `$minPrice` と `$maxPrice`：最小価格は最大価格以下でなければならない
- `$email` と `$confirmEmail`：メールアドレスの確認一致が必要
- `$currentPassword` と `$newPassword`：新しいパスワードは現在のものと異なる必要

開発者はビジネスルールを一度定義するだけで、該当するシグネチャを持つ全てのオブジェクトで自動的に適用されます。これらの制約は、オブジェクトが存在する**前提条件**として機能します。前提が満たされない限り、そのオブジェクトは存在することすらできません。

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

## 意味がもたらすもの

**名前は、意味、制約の識別子です。**この単純な原理だけで、意味・制約フレームワークといえるほどの豊かな世界が実現されます。

意味変数により、**不可能な状態が不可能になります**。無効なメールアドレスは`$email`として存在できず、負の年齢は`$age`として生まれることすらありません。在庫のない商品は`$orderId`として注文されることなく、東京23区外の住所は`$city`として配送先に指定されることもありません。

型システムそのものが**ドメイン言語**となり、各型があなたのビジネスドメインで何が存在可能かを語ります。

## 契約による設計

コンストラクタの引数は事前条件を表し、プロパティは事後条件を表します：

```php
final class ProcessedOrder
{
    public function __construct(
        #[Input] #[Verified] string $productCode,    // 事前条件：検証済み商品コード
        #[Input] int $paymentAmount,                 // 事前条件：支払い金額
        #[Input] #[Adult] int $age                   // 事前条件：成人年齢
    ) {
        // 事前条件が満たされた時のみ存在可能
        $this->orderNumber = $this->generateOrderNumber();
        $this->processedAt = new DateTime();
    }
    
    public readonly string $orderNumber;    // 事後条件：注文番号は必ず存在
    public readonly DateTime $processedAt;  // 事後条件：処理時刻は必ず存在
}
```

コンストラクタの引数は**事前条件**（このオブジェクトが存在するために満たされなければならない条件）を表し、`public readonly`プロパティは**事後条件**（このオブジェクトが保証する状態）を表現します。

防御的プログラミングは不要になります。引数の検証、null チェック、範囲確認、在庫確認、地理的制約—これらはすべて意味変数が保証します。コードは本来の目的であるビジネスロジックの実装に集中できるのです。

単なる命名規約から始まった概念が、階層的検証、関係性制約、外部リソース統合まで発展し、完全なドメイン保証システムを構築します。**名前に込められた意味が、システム全体の整合性を支えるのです。**

---

**次へ**: オブジェクトが自身の性質を発見する[型駆動変容](07-type-driven-metamorphosis.html)について学びましょう。

*「意味変数はデータを検証するだけでなく、意味のある存在のみが存在できることを保証します。」*
