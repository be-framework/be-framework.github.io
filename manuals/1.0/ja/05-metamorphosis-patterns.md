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

アインシュタインが時間と空間の不可分性を発見したように、Be Frameworkでは時間とドメインは分割できない一つの実体です。承認プロセスには承認の時間が、決済には決済の時間があり、それぞれのドメインロジックが持つ固有の時間軸に沿って変容が自然に現れます。

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

現実の生物と同様に、オブジェクトは内在と超越の相互作用によって、自身の運命を決定します。これは予め決められたルートを辿るのではなく、その瞬間の状況に応じた自然な変容です：

```php
#[Be([ApprovedApplication::class, RejectedApplication::class])]
final readonly class ApplicationReview
{
    public ApprovedApplication|RejectedApplication $being;

    public function __construct(
        #[Input] array $documents,                // 内在
        #[Inject] ReviewService $reviewer         // 超越
    ) {
        $result = $reviewer->evaluate($documents);

        // 運命は今この瞬間に決まる
        $this->being = $result->isApproved()
            ? new ApprovedApplication($documents, $result->getScore())
            : new RejectedApplication($result->getReasons());
    }
}
```

## 型による継続

次の変容先は自動的に選択されます。具体的には、`#[Be()]`で指定された候補クラスのうち、現在のオブジェクトのpublicプロパティの型と`#[Input]`引数の型が一致するクラスが選ばれます：

```php
// ApplicationReviewのプロパティがApprovedApplication型なら
// #[Input]の型がマッチするこのクラスが自動的に選択される
final readonly class ApprovalNotification
{
    public function __construct(
        #[Input] ApprovedApplication $application,
        #[Inject] Mailer $mailer
    ) {
        $mailer->send($application->getEmail(), 'Approved!');
    }
}
```

`$being`はこの自己決定パターンでよく使われるプロパティ名のコンベンションですが、フレームワークが要求する名前ではありません。どのpublicプロパティでもマッチングの対象になります。

## 自己組織化パイプライン

Unixパイプが単純なコマンドを組み合わせて強力なシステムを作るように、Be Frameworkは型付きオブジェクトを組み合わせて自然な変容の流れを作ります。

```bash
# Unix: テキストが流れる外部制御のパイプライン
cat access.log | grep "404" | awk '{print $7}' | sort | uniq -c
```

Unixではshellがパイプを制御しますが、Be Frameworkではオブジェクト自身が`#[Be()]`で運命を宣言します。コントローラーやオーケストレーターのような外部の制御は存在しません。

ヘラクレイトスは「流れているのが川だ」と言いました。川が流れるのではなく、流れそのものが川であるように、Be Frameworkのドメインは、終端に至るまで流れ続ける時間的存在です。

---

変数名が制約と契約をもつ[意味変数](./06-semantic-variables.html)へ ➡️
