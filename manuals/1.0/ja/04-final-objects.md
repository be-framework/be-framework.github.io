---
layout: docs-ja
title: "4. 最終オブジェクト"
category: Manual
permalink: /manuals/1.0/ja/04-final-objects.html
---

# 最終オブジェクト

> 「あなたは私ではない。どうして私が魚の気持ちを知らないと分かるのか？」
> 
> —「あなたは魚ではない。どうして魚の気持ちが分かるのか」と問われた時に荘子が返した言葉 （『荘子』紀元前4世紀）

## 終着点

最終オブジェクトは変容の旅路の到達点です。
ユーザーが求める価値、アプリケーションが届けたい結果が具現化された、完全で最終的な存在です。

これは入力クラスから始まった内在的性質（イマナンス）が、様々な超越的力（トランセンデンス）と出会い、自然な変容を経て達成した最終形態です。アリストテレスの言うエンテレケイア、すなわち潜在性が完全に現実化された状態を体現しています。

## 最終オブジェクトの特徴

**完全性（エンテレケイア）**: これ以上の変容を必要としない、完全に現実化された存在です。

**ユーザー価値の実現**: ユーザーが本当に必要とするもの、意味のあるデータや操作の成功結果を表現します。

**豊かな状態**: 入力クラスとは対照的に、最終オブジェクトはドメインの豊富さを完全に表現した存在です。

## 時間的存在の完全性

ここで興味深い問いがあります。テストが不要になるほどの完全性を持つオブジェクトがあったらどうでしょう？

Be Frameworkでは、オブジェクトの時間的存在を二つの軸で捉えます：

- **`#[Be]`**: なりたい自分、向かう先（未来への方向性）
- **`$been`**: 完了した自分（過去完了の自己証明）

従来のプログラミングでは、オブジェクトが正しく処理されたかどうかを外部のテストで検証します。しかし、オブジェクト自身が完了の証拠を内包していたらどうでしょう？外部による検証ではなく、内在的な自己証明が可能になります。

## 例

### 内在的自己証明を持つ結果
```php
final readonly class SuccessfulOrder
{
    public string $orderId;
    public string $confirmationCode;
    public DateTimeImmutable $timestamp;
    public string $message;
    public BeenProcessed $been;          // 自己証明
    
    public function __construct(
        #[Input] Money $total,                    // 内在的性質
        #[Input] CreditCard $card,                // 内在的性質
        #[Inject] OrderIdGenerator $generator,    // 超越的力
        #[Inject] Receipt $receipt                // 超越的力
    ) {
        $this->orderId = $generator->generate();              // 新しい内在的性質
        $this->confirmationCode = $receipt->generate($total); // 新しい内在的性質
        $this->timestamp = new DateTimeImmutable();           // 新しい内在的性質
        $this->message = "注文確認: {$this->orderId}";         // 新しい内在的性質
        
        // 完了の自己証明
        $this->been = new BeenProcessed(
            actor: $card->getHolderName(),
            timestamp: $this->timestamp,
            evidence: [
                'total' => $total->getAmount(),
                'payment_method' => $card->getType(),
                'confirmation' => $this->confirmationCode
            ]
        );
    }
}
```

このオブジェクトは外部テストを必要としません。`$been`プロパティが完了の完全な証拠を内包しているからです。

### エラー状態の自己証明
```php
final readonly class FailedOrder
{
    public string $errorCode;
    public string $message;
    public DateTimeImmutable $timestamp;
    public BeenRejected $been;          // 失敗の自己証明
    
    public function __construct(
        #[Input] array $errors,                   // 内在的性質
        #[Inject] Logger $logger,                 // 超越的力
        #[Inject] ErrorCodeGenerator $generator   // 超越的力
    ) {
        $this->errorCode = $generator->generate();
        $this->message = "注文失敗: " . implode(', ', $errors);
        $this->timestamp = new DateTimeImmutable();
        
        // 失敗の自己証明
        $this->been = new BeenRejected(
            reason: 'validation_failed',
            timestamp: $this->timestamp,
            evidence: [
                'error_count' => count($errors),
                'error_types' => array_keys($errors),
                'error_code' => $this->errorCode
            ]
        );
        
        $logger->logOrderFailure($this->errorCode, $errors);  // 副作用
    }
}
```

成功も失敗も、どちらも完了の自己証明を持ちます。外部テストではなく、オブジェクト自身が何が起こったかの完全な記録を保持しているのです。

## 最終オブジェクト vs 入力クラス

| 入力クラス | 最終オブジェクト |
|-----------|-----------------|
| 純粋なアイデンティティ | 豊かで変容した状態 |
| 変容の出発点 | 変容の到達点 |
| ユーザーが提供するもの | ユーザーが受け取るもの |
| シンプルな構造 | 完全に実現された機能 |

## 複数の最終的運命

オブジェクトはその性質によって決定される複数の可能な最終形態を持つことができます：

```php
// OrderValidationの存在プロパティから：
public SuccessfulOrder|FailedOrder $being;

// 使用方法：
$order = $becoming(new OrderInput($items, $card));

if ($order->being instanceof SuccessfulOrder) {
    echo $order->being->confirmationCode;
} else {
    echo $order->being->message;  // エラーメッセージ
}
```

## 完了した旅

入力から最終オブジェクトへの道のりは完全な変容の旅を表します：

1. **入力クラス**: 純粋なアイデンティティ（「これが私です」）
2. **存在クラス**: 変容段階（「これが私の変化の仕方です」）
3. **最終オブジェクト**: 完全な結果（「これが私がなったものです」）

ユーザーは主に入力（彼らが提供するもの）と最終オブジェクト（彼らが受け取るもの）に関心を持ちます。間にある存在クラスは私たち設計者の責任です。意図と結果の間の橋渡しをするためにドメインの時間的変容をよく理解し、その変容の仕組みを設計することが重要です。

## 変容の完成

最終オブジェクトは、エンテレケイア（完全実現）の状態を表現します。変容の必要がもうない、完全に実現された存在です。

入力クラスから始まった内在的性質（イマナンス）が、様々な超越的力（トランセンデンス）と出会いながら自然な変容を経て、ついに到達した完成形です。ここにはもう「なろうとする」努力も、「変わろうとする」意図もありません。すべてが完了し、ユーザーが本当に求めていた価値がここに実現されています。私たちのシステムの本質的な価値です。

これこそが、Be Frameworkが目指すプログラミングの到達点—「何をするか」ではなく「何であるか」が体現された存在です。

---

道は１つではありません。[変容パターン](./05-metamorphosis-patterns.html)で様々な道を学びます ➡️
