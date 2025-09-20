---
layout: docs-ja
title: "3. 存在クラス"
category: Manual
permalink: /manuals/1.0/ja/03-being-classes.html
---

# 存在クラス

> 「道常無為而無不為」
> 
> —道は常に無為にして、而も為さざることなし（老子『道徳経』第三十七章　紀元前6世紀）

## 内在と超越

存在クラスは変容が実際に起こる場所です。

オブジェクト自身が持つ性質（**内在的性質（イマナンス）**）と、外部から提供される力（**超越的な力（トランセンデンス）**）が出会い、次の新しい存在が生まれます。

例えば、`UserInput`が持つメールアドレスと名前（イマナンス）が、メール検証サービスやフォーマッター（トランセンデンス）と出会うことで、「検証済みのユーザープロフィール」という新しい存在が生まれます。データそのものは変わらないのに、検証という自分にはない超越的な力によって、自分自身が新しく変わるのです。

入力クラスが「始まり」なら、存在クラスは「変わる瞬間」を表現します。

## 基本構造

```php
final readonly class UserProfile
{
    public string $displayName;
    public bool $isValid;
    
    public function __construct(
        #[Input] string $name,                    // 内在的
        #[Input] string $email,                   // 内在的
        #[Inject] NameFormatter $formatter,       // 超越的
        #[Inject] EmailValidator $validator       // 超越的
    ) {
        $this->displayName = $formatter->format($name);     // 新しい内在的
        $this->isValid = $validator->validate($email);      // 新しい内在的
    }
}
```

## 変容パターン

すべての存在クラスは同じ変容の流れに従います：

**内在的性質** (`#[Input]`) + **超越的力** (`#[Inject]`) → **新しい内在的性質**

まるで料理のようです。素材（内在的性質）に、火や調味料（超越的力）を加えることで、料理（新しい内在的性質）が生まれます。小麦粉は小麦粉のままでは食べられませんが、イーストとオーブンの力を借りてパンになります。素材は変わらないのに、まったく新しい存在になるのです。

- **内在的要因**: オブジェクトが前の形態から継承するもの
- **超越的要因**: 世界によって提供される外部の能力と文脈
- **新しい内在的**: この相互作用から生まれる変容した存在

このパターンは自然界のあらゆるところに見られます。種（内在）が土と水と太陽（超越）と出会って花になる。生徒（内在）が教師と教材（超越）と出会って専門家になる。すべての成長、すべての学び、すべての変化がこのパターンに従います。Be Frameworkは、この普遍的な変容の法則をコードで表現しているのです。

プログラムの世界でも同じです。`$cartItems`（内在）が税率計算サービス（超越）と出会って請求金額になる。`$zipCode`（内在）が住所検索API（超越）と出会って完全な住所になる。`$rawImage`（内在）が画像処理エンジン（超越）と出会ってサムネイルになる。データは自分だけでは変われません。外部の力を借りて、初めて新しい存在になれるのです。

## エンテレケイア - なりたい自分になる

コンストラクタは新しい自己が生まれる特別な場所です。なるべき自己になるために、内在的性質と、自らは持たないが世界から与えられる超越的な力が出会い、変容のロジックが働きます。

```php
final readonly class OrderCalculation
{
    public Money $subtotal;
    public Money $tax;
    public Money $total;
    
    public function __construct(
        #[Input] array $items,                    // 内在的
        #[Input] string $currency,                // 内在的
        #[Inject] PriceCalculator $calculator,    // 超越的
        #[Inject] TaxService $taxService          // 超越的
    ) {
        $this->subtotal = $calculator->calculateSubtotal($items, $currency);
        $this->tax = $taxService->calculateTax($this->subtotal);
        $this->total = $this->subtotal->add($this->tax);     // 新しい内在的
    }
}
```

1. 前のクラスから受け継いだプロパティがコンストラクタの引数となって、注入された外部の能力と出会う。
2. 相互に作用して変容のロジックが働く。
3. プロパティの代入によって新しい存在が誕生する。

エンテレケイア（entelecheia）とは、アリストテレスが提唱した哲学概念で、「内に目的を持つ」という意味です。どんぐりは樫の木になるべく生まれ、卵は鳥になるべく存在します。それぞれが「なりたい自分」を内に秘めているのです。

Be Frameworkでは、このコンストラクタでの変容過程がまさにエンテレケイアの実現です。`OrderCalculation`は計算された注文になりたい。`ValidatedUser`は検証済みユーザーになりたい。各クラスがコンストラクタで「なりたい自分」になるのです。Be Frameworkでは、動作(DOING)ではなく、存在(BEING)を中心に考えます。

人生でも同じです。本を読むのは「深い洞察を持つ人」になるため、楽器を練習するのは「音楽で人の心を動かす人」になるためです。動作は手段であり、存在こそが目的なのです。「何をするか」ではなく「何になりたいか」に焦点を合わせる—この考え方を、Be Frameworkはコードで表現しています。

## 最終オブジェクトへの橋渡し

存在クラスはしばしば架け橋として機能し、最終変容のためのデータを準備します：

```php
#[Be([SuccessfulOrder::class, FailedOrder::class])]  // 複数の運命
final readonly class OrderValidation
{
    public bool $isValid;
    public array $errors;
    public SuccessfulOrder|FailedOrder $being;  // 存在プロパティ
    
    public function __construct(
        #[Input] Money $total,                    // 内在的
        #[Input] CreditCard $card,                // 内在的
        #[Inject] PaymentGateway $gateway         // 超越的
    ) {
        $result = $gateway->validate($card, $total);
        $this->isValid = $result->isValid();
        $this->errors = $result->getErrors();
        
        // 運命の自己決定
        $this->being = $this->isValid 
            ? new SuccessfulOrder($total, $card)
            : new FailedOrder($this->errors);
    }
}
```

## 自然な流れ

存在クラスは何かを「する」のではありません。自分が持つもの（イマナンス）と、外部から与えられる力（トランセンデンス）が出会うことで、自然にあるべき姿へと変容します。これは冒頭の老子の「道常無為而無不為」—無理に力を加えることなく、自然な流れの中ですべてが成し遂げられる—という教えと同じです。他の何かを変えるのではなく、自分自身が変わっていきます。

---

変容の行き着く先、[最終オブジェクト](./04-final-objects.html)へ ➡️
