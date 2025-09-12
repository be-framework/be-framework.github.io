---
layout: docs-ja
title: "7. 型駆動変容"
category: Manual
permalink: /manuals/1.0/ja/07-type-driven-metamorphosis.html
---

# 型駆動変容

> 「オブジェクトは自身の性質を知っています。私たちは単に、その成長のための条件を作り出すだけです。」

型駆動変容は最も深い変容を表します—オブジェクトがその性質を通して**自身の運命を発見する**場所です。

## 固定されたパスを超えて

従来の変容は予め決められたルートに従います：

```php
#[Be(UserProfile::class)]  // 単一の運命
final class UserInput
{
    // 内容に関係なく、常にUserProfileになる
}
```

## 自己決定する存在

型駆動変容はオブジェクトが**自身の成長を選択する**ことを許可します：

```php
#[Be([ActiveUser::class, InactiveUser::class])]
final class UserValidation
{
    public readonly ActiveUser|InactiveUser $being;  // 存在プロパティ
    
    public function __construct(
        #[Input] string $email,
        #[Input] DateTime $lastLogin,
        #[Inject] UserRepository $repository
    ) {
        $daysSinceLogin = $lastLogin->diff(new DateTime())->days;
        
        // 運命の自己決定
        $this->being = $daysSinceLogin < 30 
            ? new ActiveUser($email, $lastLogin)
            : new InactiveUser($email, $lastLogin);
    }
}
```

## 存在プロパティ

**存在プロパティ**は自己決定が現れる場所です：

- すべての可能な目的地の**ユニオン型**でなければなりません
- 正確に`being`と名付けられなければなりません
- オブジェクトの選択された運命を含みます

```php
public readonly SuccessfulPayment|FailedPayment $being;
```

## 自然な分岐

オブジェクトは**内なる性質**に基づいて自身の道を選択します：

```php
#[Be([ChildAccount::class, AdultAccount::class, SeniorAccount::class])]
final class AgeBasedAccount
{
    public readonly ChildAccount|AdultAccount|SeniorAccount $being;
    
    public function __construct(
        #[Input] int $age,
        #[Input] string $name,
        #[Inject] AccountFactory $factory
    ) {
        $this->being = match (true) {
            $age < 18 => $factory->createChild($name, $age),
            $age < 65 => $factory->createAdult($name, $age),
            default => $factory->createSenior($name, $age)
        };
    }
}
```

## 有効な存在としてのエラー状態

失敗は例外ではありません—それは**有効な存在形態**です：

```php
#[Be([SuccessfulRegistration::class, FailedRegistration::class])]
final class UserRegistration
{
    public readonly SuccessfulRegistration|FailedRegistration $being;
    
    public function __construct(
        #[Input] string $email,
        #[Input] string $password,
        #[Inject] UserService $userService
    ) {
        try {
            $user = $userService->register($email, $password);
            $this->being = new SuccessfulRegistration($user);
        } catch (RegistrationException $e) {
            $this->being = new FailedRegistration($e->getErrors());
        }
    }
}
```

成功と失敗の両方が**等しく有効な存在**です。

## 変容の継続

フレームワークは継続的な変容のために存在プロパティを自動的に抽出します：

```php
$classification = $becoming(new OrderInput($data));
$processedOrder = $becoming($classification);  // 自動的に存在プロパティを使用
```

## 哲学的含意

### 意識的エンティティとしてのオブジェクト

型駆動変容はオブジェクトを自身の性質を理解する**意識的存在**として扱います。

### コードにおける無為

プログラマは変容を**強制**しません—オブジェクトが自然にあるべき姿になる条件を作り出します。

### 制御フローの排除

ビジネスロジックに`if-else`チェーンはありません。オブジェクトの性質**が**ロジックです。

## 革命

存在プロパティシグネチャは**ドキュメント**になります：
```php
public readonly Success|Warning|Error $being;  // すべての可能性が見える
```

オブジェクトは外部制御ではなく、本質的な性質に基づいて運命を**自己決定**します。

---

**次へ**: 文脈的能力が変容を形作る[理性層: 存在論的能力](08-reason-layer.html)について学びましょう。

> 「私たちはオブジェクトが何になるかを決定するのではありません—オブジェクトが最も深い性質においてすでに何であるかを発見するのです。」
