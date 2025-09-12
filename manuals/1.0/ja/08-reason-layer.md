---
layout: docs-ja
title: "8. 存在理由層"
category: Manual
permalink: /manuals/1.0/ja/08-reason-layer.html
---

# 存在理由層

> 「すべてのものには、それが存在するための理由がある」
>
> 　　—ライプニッツ『充足理由律』（1714年）

## なぜこの名前か？

存在理由層には2つの「理由」があります。

### 1. 型マッチングの理由

まず、次の変容先を決定する判断基準としての理由：

```php
final class BeGreeting
{
    public readonly CasualStyle|FormalStyle $being;
    
    public function __construct(
        #[Input] string $name,
        #[Input] string $style
    ) {
        // 'formal'という条件が FormalStyle を選ぶ理由
        $this->being = $style === 'formal' 
            ? new FormalStyle() 
            : new CasualStyle();
    }
}
```

### 2. 存在の理由

次に、オブジェクトがその存在でいるための根拠としての理由：

```php
final class FormalGreeting
{
    public readonly string $greeting;
    public readonly string $businessCard;
    
    public function __construct(
        #[Input] string $name,           // 内在的性質
        #[Input] FormalStyle $being      // 存在理由
    ) {
        // FormalStyleが、このオブジェクトがFormalGreetingでいる理由を提供
        $this->greeting = $being->formalGreeting($name);
        $this->businessCard = $being->formalBusinessCard($name);
    }
}
```

`FormalGreeting`が`FormalGreeting`として存在できるのは、`FormalStyle`が必要な振る舞いを提供するからです。これが存在の理由です。

## 存在理由クラスの定義

存在理由クラスは、特定の存在様式を実現するメソッドを提供します：

```php
namespace App\Reason;

final class FormalStyle
{
    public function formalGreeting(string $name): string
    {
        return "おはようございます、{$name}様。";
    }
    
    public function formalBusinessCard(string $name): string
    {
        return "【{$name}様】\n正式なご挨拶をさせていただきます。";
    }
}

final class CasualStyle  
{
    public function casualGreeting(string $name): string
    {
        return "やあ、{$name}！";
    }
    
    public function casualMessage(string $name): string
    {
        return "Hi {$name}! 😊 よろしく！";
    }
}
```

## raison d'être としての存在理由

存在理由層は、オブジェクトの**raison d'être**（レーゾンデートル：存在理由）を提供します。

```php
final class ValidatedUser
{
    public function __construct(
        #[Input] string $email,
        #[Input] ValidationReason $raisonDEtre    // この存在の raison d'être
    ) {
        // ValidationReasonが、ValidatedUserの存在理由を提供
    }
}
```

**raison d'être**とは：
- なぜそのオブジェクトがその存在でいられるのか
- `ValidatedUser`の raison d'être は検証能力
- `SavedUser`の raison d'être は保存能力
- `DeletedUser`の raison d'être は削除・アーカイブ能力

存在理由オブジェクトは、そのオブジェクトがその状態でいるために必要な道具セットを提供します。これがBeフレームワークの「存在理由層」の名前の由来です。

## #[Inject]との違い

存在理由層の独自価値は、従来の依存性注入との比較で明確になります：

**従来のInject**：
```php
public function __construct(
    #[Input] string $email,
    #[Inject] EmailValidator $emailValidator,
    #[Inject] PasswordChecker $passwordChecker, 
    #[Inject] SecurityAuditor $auditor,
    #[Inject] DatabaseSaver $saver
) {
    // バラバラの道具を個別に使用
}
```

**存在理由層**：
```php
public function __construct(
    #[Input] string $email,
    #[Input] UserValidationReason $reason    // 関連道具がまとまった存在理由
) {
    // ValidatedUserになるための道具一式が提供される
    $this->result = $reason->validateUser($email, $this);
}
```

**違い**：
- **Inject**: 個別の道具を別々に注入
- **存在理由層**: 「その状態になるための道具セット」として意味的にまとまって提供

**価値**：
- **概念的まとまり**: 「ValidatedUserになるには何が必要？」が明確
- **テストの簡素化**: 存在理由オブジェクト一つをモックすれば済む
- **関心の分離**: 関連する道具が一か所に集約

## 委譲による状態実現

存在理由層では、オブジェクトが自身の状態実現を存在理由に委譲します：

```php
final class SavedUser
{
    public function __construct(
        #[Input] UserData $data,
        #[Input] SaveReason $reason    // 存在理由を受け取り
    ) {
        // 保存処理を存在理由に委譲
        $this->result = $reason->saveUser($data);
    }
}
```

オブジェクト自身は「何になるか」を宣言し、存在理由は「どうやってその状態になるか」を実現します。この分離により、状態定義と実現手段が明確に分けられます。

`SavedUser`になるためには保存用の道具セットが、`ValidatedUser`になるためには検証用の道具セットが必要です。存在理由オブジェクトは「この状態になるには何が必要か？」を明確に整理し、単一責任原則に従うため、テストも簡潔になります。

---

**次へ**: エラーの意味保持について[検証とエラーハンドリング](09-error-handling.html)で学びましょう。

> 「存在理由層は、オブジェクトがその存在様式を実現するために必要な道具セットを提供します。」
