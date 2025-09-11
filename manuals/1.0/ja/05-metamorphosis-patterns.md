---
layout: docs-ja
title: "5. 変容パターン"
category: Manual
permalink: /manuals/1.0/ja/05-metamorphosis-patterns.html
---

# 変容パターン

Beフレームワークは、単純な線形チェーンから複雑な分岐する運命まで、様々な変容パターンをサポートします。これらのパターンを理解することで、自然な変容フローを設計できます。

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

## 分岐する運命

オブジェクトはその性質に基づいて複数の可能な未来を持つことができます：

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

オブジェクトは**型駆動変容**を通して自身の運命を決定します。

## フォーク・ジョインパターン

単一の入力が並列変容に分岐し、後に収束します：

```php
#[Be(PersonalizedRecommendation::class)]
final class UserAnalysis
{
    public readonly PersonalizedRecommendation $being;
    
    public function __construct(
        #[Input] string $userId,                  // 内在的
        #[Inject] BehaviorAnalyzer $behavior,     // 超越的
        #[Inject] PreferenceAnalyzer $preference, // 超越的
        #[Inject] SocialAnalyzer $social          // 超越的
    ) {
        // 並列分析
        $behaviorScore = $behavior->analyze($userId);
        $preferenceScore = $preference->analyze($userId);
        $socialScore = $social->analyze($userId);
        
        // 収束
        $this->being = new PersonalizedRecommendation(
            $behaviorScore,
            $preferenceScore, 
            $socialScore
        );
    }
}
```

## 条件付き変容

時として変容はランタイム条件に依存します：

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

これらのパターンの美しさは、それらが**自己組織化**であることです。オブジェクトは自身の運命を宣言し、フレームワークは外部のオーケストレーションなしに自然に変容パスに従います。

```php
// コントローラーもオーケストレーターもなし—ただ自然な流れ
$finalObject = $becoming(new ApplicationInput($documents));

// オブジェクトはあるべき姿になりました
match (true) {
    $finalObject->being instanceof ApprovedApplication => $this->sendApprovalEmail($finalObject->being),
    $finalObject->being instanceof RejectedApplication => $this->sendRejectionEmail($finalObject->being),
};
```

## パターンの選択

ドメインの自然な流れに基づいてパターンを選択してください：

- **線形**: 順次プロセス（検証 → 処理 → 完了）
- **分岐**: 決定ポイント（承認/拒否、成功/失敗）
- **フォーク・ジョイン**: 収束する並列分析
- **条件付き**: 機能フラグ、権限、サブスクリプション
- **ネストした**: サブプロセスを持つ複雑な操作

重要なのは、変容をドメインロジックから自然に生まれさせることであり、人工的なパターンに強制することではありません。