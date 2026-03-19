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

## 存在の理由

`ExpressDelivery`がその存在でいられるのは、速達配送の能力を持っているからです。`StandardDelivery`がその存在でいられるのは、通常配送の能力を持っているからです。この「なぜその存在でいられるのか」の根拠が、**raison d'être**（レーゾンデートル：存在理由）です。

存在理由層は、このraison d'êtreを一つのオブジェクトとして表現する設計パターンです。

```php
final readonly class ExpressDelivery
{
    public Fee $fee;

    public function __construct(
        #[Input] OrderData $order,             // 内在
        #[Inject] ExpressShipping $reason      // 存在理由
    ) {
        $this->fee = $reason->calculateFee($order->weight);
    }
}
```

`ExpressShipping`が`ExpressDelivery`のraison d'êtreです。速達配送に必要な道具一式をまとめて提供します。

## $beingとしての存在理由

存在理由オブジェクトは`$being`として渡されることで、もう一つの役割を担います。その**型**が変容先の判別根拠になると同時に、その存在様式に固有のメソッド群を提供します。

```php
final readonly class ExpressDelivery
{
    public Fee $fee;

    public function __construct(
        #[Input] OrderData $order,
        #[Input] ExpressShipping $being    // 型が変容先を決定し、速達固有のメソッドを提供
    ) {
        $this->fee = $being->calculateFee($order->weight);
    }
}

final readonly class StandardDelivery
{
    public Fee $fee;

    public function __construct(
        #[Input] OrderData $order,
        #[Input] StandardShipping $being   // 型が変容先を決定し、通常配送固有のメソッドを提供
    ) {
        $this->fee = $being->calculateFee($order->weight);
    }
}
```

`ExpressShipping $being`という型そのものが、なぜ`ExpressDelivery`になるのかの理由です。フレームワークはこの型を読み取り、対応する変容先を自動選択します。

## 存在理由クラスの定義

存在理由クラスは、特定の存在様式を実現するために必要なサービスをまとめたものです：

```php
namespace App\Reason;

final readonly class ExpressShipping
{
    public function __construct(
        private PriorityCarrier $carrier,
        private RealTimeTracker $tracker,
    ) {}

    public function calculateFee(Weight $weight): Fee        // 速達料金
    {
        return $this->carrier->expressFee($weight);
    }

    public function guaranteeDeliveryBy(Address $address): \DateTimeImmutable  // 配達日保証
    {
        return $this->carrier->guaranteedDate($address);
    }

    public function realTimeTrack(TrackingId $id): TrackingStatus  // リアルタイム追跡
    {
        return $this->tracker->realTimeStatus($id);
    }
}
```

```php
final readonly class StandardShipping
{
    public function __construct(
        private RegularCarrier $carrier,
        private BatchTracker $tracker,
    ) {}

    public function calculateFee(Weight $weight): Fee        // 通常料金
    {
        return $this->carrier->standardFee($weight);
    }

    public function estimateDeliveryWindow(Address $address): DateRange  // 配達期間の見積もり
    {
        return $this->carrier->estimateWindow($address);
    }
}
```

## 個別注入との違い

存在理由層は`#[Inject]`を使います。では複数の`#[Inject]`をバラバラに使う場合と何が違うのでしょうか。

**個別の注入**：
```php
public function __construct(
    #[Input] OrderData $order,
    #[Inject] PriorityCarrier $carrier,
    #[Inject] RealTimeTracker $tracker,
    #[Inject] InsuranceService $insurance,
    #[Inject] DeliveryScheduler $scheduler
) {
    // バラバラの道具を個別に使用
}
```

**存在理由層**：
```php
public function __construct(
    #[Input] OrderData $order,
    #[Inject] ExpressShipping $reason    // 関連道具がまとまった存在理由
) {
    $this->fee = $reason->calculateFee($order->weight);
}
```

「ExpressDeliveryになるには何が必要か？」という問いに、存在理由オブジェクト一つが答えます。オブジェクト自身は「何になるか」を宣言し、存在理由は「どうやってその状態になるか」を実現します。

---

存在できない事自体は存在します。[検証とエラーハンドリング](./09-error-handling.html)でその扱い方を学びます ➡️
