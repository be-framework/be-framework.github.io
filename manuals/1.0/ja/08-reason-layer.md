---
layout: docs-ja
title: "存在理由層"
category: Manual
permalink: /manuals/1.0/ja/08-reason-layer.html
---

# 存在理由層

> 「すべてのものには、それが存在するための理由がある」
>
> 　　—ライプニッツ『充足理由律』（1714年）

## 存在の理由

`ExpressDelivery`が速達配送として成り立つのは、速達配送の能力を持っているからです。`StandardDelivery`が通常配送として成り立つのは、通常配送の能力を持っているからです。この「なぜその存在でいられるのか」の根拠が、**raison d'être**（レーゾンデートル：存在理由）です。

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

存在理由オブジェクトは`$being`プロパティとしても使えます。このとき、そのオブジェクトの**型**が変容先の判別根拠になると同時に、その存在様式に固有のメソッドも提供します。

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

どのReasonオブジェクトも`#[Inject]`（超越の能力を提供）にも`$being`（運命を決定）にもなれます。違いはオブジェクト自体ではなく、使われ方にあります。ある文脈で`#[Inject]`として患者を評価する`JTASProtocol`が、別の文脈では`$being`として運命を決定することもできます。

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

## Potentialを返すReason

ここまでのReasonは`Fee`のような即時の値を返していました。しかし注文処理を考えてみましょう。在庫確保・決済・配送手配のすべてが成功してからコミットする必要があります。決済が失敗したのに在庫だけ確保されたままでは困ります。

このような一括実現が必要な場面で、Reasonは値の代わりに**Potential**を返します。Potentialは遅延操作を保持するオブジェクトで、後から`be()`で実現されます。このパターンは複数の外部操作をアトミックにコミットする必要があるときだけ使います。

### Potential: 準備済み・未コミット

Reasonのメソッドは外部操作を準備し、Potentialを返します：

```php
final class PaymentGateway
{
    public function authorize(string $cardNumber, int $amount): PaymentCapture
    {
        $authCode = $this->api->authorize($cardNumber, $amount);

        return new PaymentCapture(
            $authCode,
            $amount,
            fn () => $this->api->capture($authCode, $amount),
        );
    }
}
```

`PaymentCapture`はPotentialです。認証コードとキャプチャの遅延操作を保持しています。決済は認証済みですが、まだ確定していません。`be()`で確定します：

```php
$capture = $gateway->authorize($cardNumber, $amount);
$capture->authorizationCode;  // 即座に利用可能
$capture->be();               // キャプチャを確定
```

### Moment: Potentialを保持する

ReasonからPotentialを受け取って保持するクラスを**Moment**（ヘーゲルの契機—全体の中でのみ意味を持つ不可欠な側面）と呼びます。Momentはフレームワークが提供する`MomentInterface`を実装します：

```php
interface MomentInterface
{
    public function be(): void;
}
```

```php
final readonly class PaymentCompleted implements MomentInterface
{
    public PaymentCapture $capture;

    public function __construct(
        #[Input] public string $cardNumber,
        #[Input] public int $amount,
        #[Inject] PaymentGateway $gateway,
    ) {
        $this->capture = $gateway->authorize($cardNumber, $amount);
    }

    public function be(): void
    {
        $this->capture->be();
    }
}
```

### 収束: FinalがMomentを実現する

複数のMomentがすべて揃う必要があるとき、Final Objectはそれらを受け取り、各Momentの`be()`を呼びます。これは外部からの命令ではなく、自己完成です：

```php
final readonly class OrderConfirmed
{
    public string $orderId;
    public string $status;

    public function __construct(
        public InventoryReserved $inventory,
        public PaymentCompleted $payment,
        public ShippingArranged $shipping,
    ) {
        $this->inventory->be();
        $this->payment->be();
        $this->shipping->be();

        $this->orderId = 'ORD-' . date('Ymd') . '-' . bin2hex(random_bytes(4));
        $this->status = 'confirmed';
    }
}
```

いずれかのMomentが生成できなければ（Reasonが失敗したため）、Final Objectは構築されません。すべてのMomentが存在すれば、`be()`がすべての遅延操作をコミットします。手動のロールバックフラグもネストされたtry-catchも不要です。

### このパターンを使う場面

複数の外部操作をアトミックに成功させる必要があるときに、Potentialを返すReasonを使います。Reasonが即時の値を返す単純なケースでは不要です。

---

存在できなかった、という結果もまた扱う必要があります。[検証とエラーハンドリング](./09-error-handling.html)でその扱い方を学びます ➡️
