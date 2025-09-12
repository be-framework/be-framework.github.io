---
layout: docs-ja
title: "7. 型駆動変容"
category: Manual
permalink: /manuals/1.0/ja/07-type-driven-metamorphosis.html
---

# 型駆動変容

> 「道生一、一生二、二生三、三生万物」
>
> 　　—老子『道徳経』第四十二章（紀元前6世紀）

## 型駆動による変容

型駆動変容では、オブジェクトが複数の可能な型から条件に応じて選択します。`#[Be()]`属性で複数のクラスを配列として宣言し、beingプロパティでその選択を表現します：

```php
#[Be([Success::class, Failure::class])]
final class PaymentAttempt
{
    public readonly Success|Failure $being;
    
    public function __construct(
        #[Input] Money $amount,
        #[Input] CreditCard $card,
        #[Inject] PaymentGateway $gateway
    ) {
        $result = $gateway->process($amount, $card);
        
        // 結果に応じた分岐
        $this->being = $result->isSuccessful() 
            ? new Success($result)
            : new Failure($result->getError());
    }
}
```

## beingプロパティ

`$being`プロパティは次の変容先を示すプロパティです：

```php
public readonly Success|Failure|Pending $being;
```

次のクラスのコンストラクタでこの型シグネチャがマッチするクラスが選ばれます。
例えば`$being`が`Success`型なら、以下のコンストラクタを持つクラスが選択されます：

```php
class NextStep {
    public function __construct(#[Input] Success $being) {
```

`#[Be]`がオブジェクトの全ての可能性を完全に表現します。型がワークフローやユースケースの仕様になります。

## 複数型の選択例

```php
#[Be([VIPUser::class, RegularUser::class, SuspendedUser::class])]
final class UserClassification
{
    public readonly VIPUser|RegularUser|SuspendedUser $being;
    
    public function __construct(
        #[Input] UserActivity $activity,
        #[Input] array $violations,
        #[Inject] UserPolicy $policy
    ) {
        $this->being = match (true) {
            $policy->shouldSuspend($violations) => new SuspendedUser($violations),
            $activity->qualifiesForVIP() => new VIPUser($activity),
            default => new RegularUser($activity)
        };
    }
}
```

## 継続処理の仕組み

型駆動処理の利点は、自動的な継続処理にあります：

```php
$evaluation = $becoming(new UserInput($data));
$notification = $becoming($evaluation);  // $evaluation->beingが自動選択される
```

フレームワークは`$being`プロパティを検出し、その型に応じて次の処理を行います。外部の条件分岐は不要になります。

## 拡張意思決定の展望

⚠️ **注記**: AMD（拡張意思決定）は現在未実装の将来構想です。

確定的判断を超えて、不確実性を受容する新しいパラダイムが準備されています：

```php
// 将来構想
#[Accept]  // 未実装：専門家への委譲
#[Be([Approved::class, Rejected::class, Undetermined::class])]
final class ComplexDecision
{
    public readonly Approved|Rejected|Undetermined $being;
    
    // AIと人間の協調による拡張意思決定
}
```

確定できるものは型で決定し、不確定なものは専門家に委譲する意思決定システムです。

## 制御構造の排除

Be Frameworkは従来の"メソッドの中にある複雑な制御構造"を排除します。フレームワークは`#[Be]`で宣言された流れに従い、型マッチングで次のクラスを選択します。

従来の複雑な条件分岐：

```php
if ($score > 800) {
    return new Approved($amount);
} elseif ($score < 400) {
    return new Rejected("Low score");
} else {
    return new Review($amount);
}
```

型駆動変容では、これらがユニオン型で表現されます：

```php
public readonly Approved|Rejected|Review $being;
```

## 型システムとの統合

型駆動変容により、複雑な決定ロジックが型システムに統合されます。ユニオン型が可能な結果を明示し、コンストラクタが実際の分岐を処理します。これにより、決定ロジックが理解しやすく、保守しやすいコードになります。

「型がマッチすれば次に進む」という単純な原理から、現実の複雑さに対応する豊かなワークフローシステムが構築されます。

---

**次へ**: 変容を支える依存性注入の哲学について[理性層: 存在論的能力](08-reason-layer.html)で学びましょう。

> 「型駆動変容は、複雑な制御フローを型システムに統合する手法です。」
