---
layout: docs-ja
title: "4. 最終オブジェクト"
category: Manual
permalink: /manuals/1.0/ja/04-final-objects.html
---

# 最終オブジェクト

最終オブジェクトは変容の目的地を表します—ユーザーの実際の関心を体現する、完全で変容した存在です。これらはアプリケーションが最終的に気にかけるものです。

## 最終オブジェクトの特徴

**完全な存在**: 最終オブジェクトは意図された目的のためにさらなる変容を必要としない、完全に形成されたエンティティです。

**ユーザー中心**: これらはユーザーが実際に欲しいもの—成功した操作、意味のあるデータ、実行可能な結果を表します。

**豊富な状態**: 入力クラスとは異なり、最終オブジェクトは変容されたデータの完全な豊かさを含みます。

## 例

### 成功した結果
```php
final class SuccessfulOrder
{
    public readonly string $orderId;
    public readonly string $confirmationCode;
    public readonly DateTimeImmutable $timestamp;
    public readonly string $message;
    
    public function __construct(
        #[Input] Money $total,                    // 検証からの内在的
        #[Input] CreditCard $card,                // 検証からの内在的
        #[Inject] OrderIdGenerator $generator,    // 超越的
        #[Inject] Receipt $receipt                // 超越的
    ) {
        $this->orderId = $generator->generate();              // 新しい内在的
        $this->confirmationCode = $receipt->generate($total); // 新しい内在的
        $this->timestamp = new DateTimeImmutable();          // 新しい内在的
        $this->message = "注文確認: {$this->orderId}";        // 新しい内在的
    }
}
```

### 最終オブジェクトとしてのエラー状態
```php
final class FailedOrder
{
    public readonly string $errorCode;
    public readonly string $message;
    public readonly DateTimeImmutable $timestamp;
    
    public function __construct(
        #[Input] array $errors,                   // 検証からの内在的
        #[Inject] Logger $logger,                 // 超越的
        #[Inject] ErrorCodeGenerator $generator   // 超越的
    ) {
        $this->errorCode = $generator->generate();
        $this->message = "注文失敗: " . implode(', ', $errors);
        $this->timestamp = new DateTimeImmutable();
        
        $logger->logOrderFailure($this->errorCode, $errors);  // 副作用
    }
}
```

## 最終オブジェクト vs 入力クラス

| 入力クラス | 最終オブジェクト |
|-----------|-----------------|
| 純粋なアイデンティティ | 豊富で変容した状態 |
| 出発点 | 目的地 |
| ユーザーが提供するもの | ユーザーが受け取るもの |
| 単純な構造 | 完全な機能 |

## 複数の最終的運命

オブジェクトはその性質によって決定される複数の可能な最終形態を持つことができます：

```php
// OrderValidationの存在プロパティから：
public readonly SuccessfulOrder|FailedOrder $being;

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

ユーザーは主に入力（彼らが提供するもの）と最終オブジェクト（彼らが受け取るもの）に関心を持ちます。間にある存在クラスはフレームワークの責任です—意図と結果の間の橋を作る変容の機械です。

## 自然な完成

最終オブジェクトは自然な変容の完成を体現します。これらはもう何かを「する」必要がありません—単純に、元の入力が世界の能力と出会うことから生まれることを意図された結果*である*のです。