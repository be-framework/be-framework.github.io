---
layout: docs-ja
title: "Be Framework命名規約"
category: Convention
permalink: /manuals/1.0/ja/convention/naming-standards.html
---

# Be Framework命名規約

> 哲学としてのコード：行動ではなく存在を反映する名前

この文書は、Be Frameworkの存在論的プログラミング原則に整合する命名規約を定め、**行動**ではなく**存在**を表現するコードを保証します。

## 核心哲学

**「オブジェクトは物事をするのではない—あるべき姿になる」**

私たちの命名は、命令的思考から存在論的思考への根本的転換を反映します：
- **行動指向**の名前 → **存在指向**の名前
- **何をするか** → **何であるか**
- **制御する** → **存在する**

## クラス命名パターン

### 入力クラス
**パターン**: `{ドメイン}Input`
**目的**: メタモルフォーシスの出発点を表す純粋なデータコンテナ

```php
// ✅ 正しい
final readonly class UserInput
final readonly class OrderInput  
final readonly class DataInput
final readonly class PaymentInput

// ❌ 避けるべき
final readonly class UserData          // 一般的すぎる
final readonly class CreateUserRequest // 行動指向
final readonly class UserDto           // 技術指向
```

### 存在クラス
**パターン**: `{状態}{ドメイン}`
**目的**: 中間変容段階を表現

```php
// ✅ 正しい
final readonly class ValidatedUser
final readonly class AuthenticatedUser
final readonly class ProcessedOrder
final readonly class VerifiedPayment

// ❌ 避けるべき
final readonly class UserValidator     // サービス的
final readonly class OrderProcessor    // 行動指向
```

### 最終オブジェクト
**パターン**: `{完成した存在状態}`
**目的**: 変容の目的地を表現

```php
// ✅ 正しい
final readonly class RegisteredUser
final readonly class CompletedOrder
final readonly class SuccessfulPayment
final readonly class PublishedArticle

// ❌ 避けるべき
final readonly class UserEntity       // 技術指向
final readonly class OrderResult      // 結果指向
```

## プロパティ命名

### 意味変数としてのプロパティ
プロパティ名は意味変数システムと自動的に関連付けられます：

```php
// プロパティ名が自動的に意味変数クラスにマッピング
#[Input] string $emailAddress    // → EmailAddress意味変数
#[Input] string $userName        // → UserName意味変数
#[Input] int $age               // → Age意味変数
```

### Being プロパティ
**パターン**: `$being`
**目的**: オブジェクトの次の存在状態を表現

```php
public SuccessfulPayment|FailedPayment $being;
public ActiveUser|SuspendedUser $being;
```

## メソッド命名原則

### Be Frameworkでは従来のメソッドは存在しません

```php
// ❌ 従来のOOPスタイル（避ける）
class User {
    public function validate() { }
    public function save() { }
    public function delete() { }
}

// ✅ Be Frameworkスタイル
final readonly class ValidatedUser {
    public function __construct(UserInput $input) {
        // バリデーションは存在の前提条件として実行される
    }
}
```

## 変数命名

### ローカル変数
存在の状態を反映する名前を使用：

```php
// ✅ 正しい
$validatedInput = new ValidatedUserInput($rawInput);
$authenticatedUser = new AuthenticatedUser($validatedInput);
$finalUser = $authenticatedUser->being;

// ❌ 避けるべき
$result = validateUser($input);     // 行動指向
$data = processInput($rawInput);    // 一般的すぎる
```

### 依存性注入
**パターン**: `{インターフェース名}`（Serviceサフィックスなし）

```php
final readonly class AuthenticatedUser {
    public function __construct(
        #[Input] UserInput $input,
        #[Inject] PasswordHasher $hasher,        // ✅ 能力として
        #[Inject] UserRepository $repository     // ✅ リポジトリとして
    ) {}
}
```

## ファイル・ディレクトリ構造

### 意味変数
**場所**: `src/Domain/SemanticVariable/`
**命名**: 単語の組み合わせ、PascalCase

```
src/Domain/SemanticVariable/
├── EmailAddress.php
├── UserName.php
├── ProductCode.php
└── PaymentAmount.php
```

### ドメインオブジェクト
**場所**: `src/Domain/`
**命名**: 存在状態を反映

```
src/Domain/
├── User/
│   ├── UserInput.php
│   ├── ValidatedUser.php
│   └── RegisteredUser.php
└── Order/
    ├── OrderInput.php
    ├── ProcessedOrder.php
    └── CompletedOrder.php
```

## 命名の哲学的原則

### 1. 存在優先
```php
// 行動ではなく存在を表現
final readonly class DeletedUser    // ✅ 削除された状態の存在
final readonly class UserDeleter    // ❌ 削除する行動
```

### 2. 時間の方向性
```php
// 変容の自然な流れを表現
$input → $validated → $authenticated → $registered
```

### 3. 意味の完全性
```php
// 名前自体が制約を含む
string $emailAddress      // 有効なメールアドレスでなければならない
int $age                 // 負の値は存在できない
```

## まとめ

Be Frameworkの命名規約は単なるスタイルガイドではなく、存在論的プログラミングの哲学を体現します。名前を通じて、コードは**行う**ものから**存在する**ものへと変容し、より自然で理解しやすいソフトウェアが実現されます。

---

*「名前は単なるラベルではありません。存在の意味そのものです。」*