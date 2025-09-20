---
layout: docs-ja
title: "5. 変容"
category: Manual
permalink: /manuals/1.0/ja/05-metamorphosis.html
---

# 変容

> 「空間と時間は独立に定義できない」
> 
> 　　—アルベルト・アインシュタイン『一般相対性理論の基礎』（1916年）

## 時間とドメインは分割できない

アインシュタインが時間と空間の不可分性を発見したように、Beフレームワークでは時間とドメインは分割できない一つの実体です。承認プロセスには承認の時間が、決済には決済の時間があり、それぞれのドメインロジックが持つ固有の時間軸に沿って変容が自然に現れます。

## 不可逆的時間の流れ

オブジェクトの変容は時間の矢に沿った一方向の流れです。過去に戻ることも、同じ瞬間に留まることもできません：

```php
// 時間 T0: 入力の誕生
#[Be(EmailValidation::class)]
final readonly class EmailInput { /* ... */ }

// 時間 T1: 第一変容（T0は既に過去）
#[Be(UserCreation::class)]
final readonly class EmailValidation { /* ... */ }

// 時間 T2: 第二変容（T1は記憶となる）
#[Be(WelcomeMessage::class)]
final readonly class UserCreation { /* ... */ }

// 時間 T3: 最終存在（すべての過去を内包）
final readonly class WelcomeMessage { /* ... */ }
```

各瞬間は二度と戻らず、新しい存在は前の形態をその内部に記憶として保持します。川が流れるように、時間は一方向にのみ流れます。

## 運命の自己決定

現実の生物と同様に、オブジェクトは内在的な性質と外部環境の相互作用によって、自身の運命を決定します。これは予め決められたルートを辿るのではなく、その瞬間の状況に応じた自然な変容です：

```php
#[Be([ApprovedApplication::class, RejectedApplication::class])]
final readonly class ApplicationReview
{
    public ApprovedApplication|RejectedApplication $being;
    
    public function __construct(
        #[Input] array $documents,                // 内在的性質
        #[Inject] ReviewService $reviewer         // 外部環境
    ) {
        $result = $reviewer->evaluate($documents);
        
        // 運命は今この瞬間に決まる
        $this->being = $result->isApproved()
            ? new ApprovedApplication($documents, $result->getScore())
            : new RejectedApplication($result->getReasons());
    }
}
```


## ネストした変容

複雑なオブジェクトは独自の変容チェーンを含むことができます：

```php
final readonly class OrderProcessing
{
    public PaymentResult $payment;
    public ShippingResult $shipping;
    
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

## 実装上の選択指針

### いつ線形変容を選ぶか

シーケンシャルな処理で、各段階が次に必要なデータを準備する場合：

```php
ユーザー登録 → メール検証 → アカウント有効化 → ウェルカム通知
```

各段階での失敗は全体を停止させる必要がある場合に適しています。

### いつ条件分岐を選ぶか

同じ入力から性質や権限によって異なる結果に分岐する場合：

```php
// 実装例：支払い能力による機能差
#[Be([FullAccess::class, LimitedAccess::class, ReadOnlyAccess::class])]
final readonly class AccessDetermination
{
    public FullAccess|LimitedAccess|ReadOnlyAccess $being;
    
    public function __construct(
        #[Input] User $user,
        #[Inject] PaymentStatus $payment
    ) {
        $this->being = match($payment->getStatus()) {
            'premium' => new FullAccess($user, $payment->getFeatures()),
            'basic' => new LimitedAccess($user, $payment->getLimits()),
            default => new ReadOnlyAccess($user)
        };
    }
}
```

### いつネストした変容を選ぶか

複数の独立した処理を並行して実行し、それぞれの結果を集約する場合：

```php
final readonly class OrderCompletion
{
    public function __construct(
        #[Input] OrderData $order,
        #[Inject] Becoming $becoming
    ) {
        // 独立した処理を並行実行
        $this->inventory = $becoming(new InventoryCheck($order->items));
        $this->payment = $becoming(new PaymentProcess($order->payment));
        $this->shipping = $becoming(new ShippingArrange($order->address));
    }
}
```

## 設計原則

変容パターンの選択は、ドメインロジックの自然な流れに従ってください：

- **強制しない**: 人工的なパターンに無理やり当てはめない
- **シンプルに**: 最も単純で理解しやすい形を選ぶ
- **テスト可能**: 各変容段階が独立してテストできる
- **型安全**: `#[Be()]` によって次の型が保証される

オブジェクトは自らが自らの変容を規定します。

ヘラクレイトスは『川が流れている』のではなく『流れているのが川だ』と言いました。存在は変化とは切り離せないと考えたのです。Be Frameworkも同じように本質を捉えるためにはドメインと時間は切り離せないものと考えました。
ドメインは時間的存在です。その時その時の可能性と存在があります。入力クラス、存在クラス、最終オブジェクトが時間の流れに沿って自然に変容していく様を捉えることが、Beフレームワークの核心です。

---

変数名が制約と契約をもつ[意味変数](./06-semantic-variables.html)へ ➡️



