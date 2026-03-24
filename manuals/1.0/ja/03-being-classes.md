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

入力クラスが「始まり」なら、存在クラスは「変容した存在」を表現します。

入力クラスのpublicプロパティは、存在クラスのコンストラクタに引き継がれます。この引き継がれた値を**内在（Immanence）**と呼びます。内在はオブジェクトのアイデンティティであり、変容を経ても保たれます。

コンストラクタには外部から**超越（Transcendence）**もインジェクトされます。超越は内在と出会い、新しい内在へと変容させます。

## 基本構造

```php
final readonly class ValidatedUser
{
    public string $displayName;
    public bool $isValid;

    public function __construct(
        #[Input] string $name,                    // 内在
        #[Input] string $email,                   // 内在
        #[Inject] NameFormatter $formatter,       // 超越
        #[Inject] EmailValidator $validator       // 超越
    ) {
        $this->displayName = $formatter->format($name);     // 新しい内在
        $this->isValid = $validator->validate($email);      // 新しい内在
    }
}
```

`#[Input]`パラメータには、前のクラスのpublicプロパティが名前の一致により自動的に渡されます。`UserInput`の`public string $name`は`ValidatedUser`の`#[Input] string $name`に対応します。`#[Inject]`パラメータにはDIコンテナから外部の依存が注入されます。この自動マッチングの詳細なルールは[5章 変容](./05-metamorphosis-patterns.html)で説明します。

## 時間的存在としてのオブジェクト

Be Frameworkでは、オブジェクトを静的なデータ構造ではなく、特定の時間の中でのみ存在する時間的な存在として捉えます。

### 誕生

コンストラクタは、オブジェクトが生まれる場所です。すべての存在クラスは同じ変容の流れに従います：

**内在** (`#[Input]`) + **超越** (`#[Inject]`) → **新しい内在**

内在が超越と出会い、変容のロジックが働き、プロパティの代入によって新しい内在が生まれます。生まれた瞬間、そのオブジェクトのアイデンティティと状態は確定し、不変（Immutable）となります。

### 生

オブジェクトは `public readonly` プロパティとして、その「あるべき姿」を世界に晒します。フレームワークがこのプロパティを読み取り、次のクラスの `#[Input]` として引き渡します。その後、オブジェクトは消滅し、次の存在に道を譲ります。

### なりたい自分になる

すべての変容は、最終的な「なりたい自分、なるべき自分（Final Object）」になるための旅です。

出会った超越は、新しい内在に影響を与えて消滅します。幼少期の友人のように、オブジェクトを形作りその一部となりますが、その時だけの存在として、やがて消えていきます。

## 変容の例

```php
final readonly class OrderCalculation
{
    public Money $subtotal;
    public Money $tax;
    public Money $total;

    public function __construct(
        #[Input] array $items,                    // 内在
        #[Input] string $currency,                // 内在
        #[Inject] PriceCalculator $calculator,    // 超越
        #[Inject] TaxService $taxService          // 超越
    ) {
        $this->subtotal = $calculator->calculateSubtotal($items, $currency);
        $this->tax = $taxService->calculateTax($this->subtotal);
        $this->total = $this->subtotal->add($this->tax);     // 新しい内在
    }
}
```

`OrderCalculation`は計算された注文になりたい。`ValidatedUser`は検証済みユーザーになりたい。各クラスがコンストラクタで「なりたい自分」になるのです。Be Frameworkでは、動作(DOING)ではなく、存在(BEING)を中心に考えます。

## 変容についての考察

内在だけでは変われません。データがどれほど豊かでも、それ自身の力で新しい存在にはなれないのです。変容には必ず超越—自分の外にある力—との出会いが必要です。そして出会った超越は内在を変え、自らは消えていきます。この「出会い、変わり、消える」というパターンは、コードに限った話ではありません。小麦粉はイーストと熱に出会ってパンになります。ぶどうは酵母と時間に出会ってワインになります。種は土と水と光に出会って花になります。あらゆるドメインの変容がこのパターンに従います。

## 自然な流れ

存在クラスは何かを「する」わけではありません。自分が持つもの（内在）と、外部から与えられる力（超越）が出会うことで、自然にあるべき姿へと変容します。この流れを指揮するものはいません。各オブジェクトはただ次の存在に渡されるだけです。

---

変容の行き着く先、[最終オブジェクト](./04-final-objects.html)へ ➡️
