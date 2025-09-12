---
layout: docs-ja
title: "5. 変容パターン"
category: Manual
permalink: /manuals/1.0/ja/05-metamorphosis-patterns.html
---

# 変容パターン

> 「同じ川に二度入ることはできない」
> 
> 　　—ヘラクレイトス『断片』（紀元前500年頃）

## 変容の流れ

Beフレームワークは、単純な線形チェーンから複雑な分岐まで、様々な変容パターンをサポートします。これらのパターンを理解することで、自然な変容フローを設計できます。

## 線形変容チェーン

最もシンプルなパターン：A → B → C → D

```php
// 入力
#[Be(EmailValidation::class)]
final class EmailInput { /* ... */ }

// 第一変容
#[Be(UserCreation::class)]
final class EmailValidation { /* ... */ }

// 第二変容
#[Be(WelcomeMessage::class)]
final class UserCreation { /* ... */ }

// 最終結果
final class WelcomeMessage { /* ... */ }
```

各段階は自然に次へと導かれ、川が海に流れるようです。

## 条件分岐パターン

オブジェクトはその性質に基づいて複数の可能な未来を持つことができます。これは条件によって異なる型へと分岐する自然な変容です：

```php
#[Be([ApprovedApplication::class, RejectedApplication::class])]
final class ApplicationReview
{
    public readonly ApprovedApplication|RejectedApplication $being;
    
    public function __construct(
        #[Input] array $documents,                // 内在的
        #[Inject] ReviewService $reviewer         // 超越的
    ) {
        $result = $reviewer->evaluate($documents);
        
        $this->being = $result->isApproved()
            ? new ApprovedApplication($documents, $result->getScore())
            : new RejectedApplication($result->getReasons());
    }
}
```

### 他の条件分岐例

機能レベルや権限による分岐も同様のパターンです：

```php
#[Be([PremiumFeatures::class, BasicFeatures::class])]
final class FeatureActivation
{
    public readonly PremiumFeatures|BasicFeatures $being;
    
    public function __construct(
        #[Input] User $user,                      // 内在的
        #[Inject] SubscriptionService $service    // 超越的
    ) {
        $subscription = $service->getSubscription($user);
        
        $this->being = $subscription->isPremium()
            ? new PremiumFeatures($user, $subscription)
            : new BasicFeatures($user);
    }
}
```

オブジェクトは**型駆動変容**を通して自身の運命を決定します。


## ネストした変容

複雑なオブジェクトは独自の変容チェーンを含むことができます：

```php
final class OrderProcessing
{
    public readonly PaymentResult $payment;
    public readonly ShippingResult $shipping;
    
    public function __construct(
        #[Input] Order $order,                    // 内在的
        #[Inject] Becoming $becoming              // 超越的
    ) {
        // ネストした変容
        $this->payment = $becoming(new PaymentInput($order->getPayment()));
        $this->shipping = $becoming(new ShippingInput($order->getAddress()));
    }
}
```

## 自己組織化パイプライン

これらのパターンの美しさは、それらが**自己組織化**であることです。Unixパイプが単純なコマンドを組み合わせて強力なシステムを作るように、Beフレームワークは型付きオブジェクトを組み合わせて自然な変容の流れを作ります。

### Unixパイプとの比較

```bash
# Unix: テキストが流れる外部制御のパイプライン
cat access.log | grep "404" | awk '{print $7}' | sort | uniq -c
```

```php
// Be Framework: リッチなオブジェクトが流れる内在的制御のパイプライン
$finalObject = $becoming(new ApplicationInput($documents));
// オブジェクト自身が次の変容先を知っている
```

重要な進化：
- **Unix**: 外部のshellがパイプを制御
- **Be Framework**: オブジェクト自身が`#[Be()]`で運命を宣言

### 自己組織化の実現

```php
// コントローラーもオーケストレーターもなし—ただ自然な流れ
$finalObject = $becoming(new ApplicationInput($documents));

// オブジェクトはあるべき姿になりました
match (true) {
    $finalObject->being instanceof ApprovedApplication => $this->sendApprovalEmail($finalObject->being),
    $finalObject->being instanceof RejectedApplication => $this->sendRejectionEmail($finalObject->being),
};
```

この自己組織化により：
- 外部オーケストレーションが不要
- 型安全性が保たれる
- 依存性注入による能力の提供
- テスト可能な独立したコンポーネント

## パターンの選択

ドメインの自然な流れに基づいてパターンを選択してください：

- **線形**: 順次プロセス（検証 → 処理 → 完了）
- **条件分岐**: 決定ポイント（承認/拒否、成功/失敗、権限レベル）
- **ネストした**: サブプロセスを持つ複雑な操作

重要なのは、変容をドメインの自然な流れから生まれさせることであり、人工的なパターンに強制することではありません。
