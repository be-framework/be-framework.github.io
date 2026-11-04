---
layout: docs-ja
title: "変容"
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
#[Be([ApprovalNotification::class, RejectionNotification::class])]
final readonly class ApplicationReview
{
    public Approved|Rejected $being;

    public function __construct(
        #[Input] string $email,                    // 内在
        #[Input] array $documents,                 // 内在
        #[Inject] ReviewService $reviewer          // 超越
    ) {
        $result = $reviewer->evaluate($documents);

        // 運命は今この瞬間に決まる
        $this->being = $result->isApproved()
            ? new Approved($email, $result->getScore())
            : new Rejected($email, $result->getReasons());
    }
}
```

`Approved`と`Rejected`はReasonオブジェクトです。Tutorialの`Emergency`や`Observation`と同じ役割です。理由（Reason）が運命を決めます。判定結果とその根拠を持ち、`$being`に代入されると、その型が次のクラスを決定します。コンストラクタ内で完結する判定ロジックはReason層に置きます。一方、生成後に呼び出される振る舞い—Tutorialの`assignER()`のような遅延実行メソッド—はFinalクラスに持たせます。

## 型による継続

`#[Be()]`で指定された候補クラスのうち、現在のオブジェクトのpublicプロパティで`#[Input]`コンストラクタ引数を満たせるクラスが自動的に選択されます：

```php
// ApplicationReviewの$beingがApproved型なので
// #[Input] Approvedがマッチするこのクラスが選択される
final readonly class ApprovalNotification
{
    public function __construct(
        #[Input] Approved $being,
        #[Inject] Mailer $mailer
    ) {
        $mailer->send($being->email, 'Approved! Score: ' . $being->score);
    }
}
```

`$being`はこの自己決定パターンでよく使われるプロパティ名のコンベンションですが、フレームワークが要求する名前ではありません。どのpublicプロパティでもマッチングの対象になります。

## マッチングルール {#matching-rules}

`#[Be()]`に複数の候補があるとき、フレームワークは書かれた順に候補を調べ、最初に存在させられたものを選びます：

1. `#[Inject]`でないコンストラクタ引数はすべて、現在のオブジェクトに同じ**名前**のpublicプロパティを持っていなければなりません。
2. プロパティの値は、引数に宣言された**型**と互換でなければなりません。`Approved|Rejected $being`が進路を決めるのはここです。`#[Input] Approved $being`は、`$being`が`Approved`を保持しているときだけマッチします。
3. `#[Inject]`引数はマッチングでは無視され、後からDIコンテナが解決します。
4. マッチした候補がコンストラクタで`UnbecomingException`を投げた場合（「私はこれではない」）、次の候補が試されます。どの候補もマッチしなければ`BeMatchException`が送出されます。

`#[Be()]`に単一のクラスだけが指定されている場合、マッチングは行われず、オブジェクトはそのままそのクラスになります。

## 変容の形を選ぶ {#choosing-the-shape}

ほとんどのドメインは次の3つの形で表せます：

| 形 | 使う場面 | 書き方 |
|----|----------|--------|
| **線形** | 各ステップが前のステップに依存する | 各クラスに`#[Be(Next::class)]` |
| **分岐** | 結果が互いに排他的 | `#[Be([A::class, B::class])]`と、Reasonを保持するユニオン型の`$being` |
| **ネスト** | 独立したサブプロセスを合流させる | `BecomingInterface`を注入して内側のチェーンを実行（[生成](./04a-becoming.html)参照） |

迷ったら線形から始めてください。分岐はReasonが本当に排他的な結果を生むときだけ、ネストは独立した結果を結合する必要があるときだけ導入します。

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
