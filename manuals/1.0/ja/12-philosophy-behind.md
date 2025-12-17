---
layout: docs-ja
title: "12. 背後にある哲学"
category: Manual
permalink: /manuals/1.0/ja/12-philosophy-behind.html
---

# 背後にある哲学

> 「万物は流転する」（パンタ・レイ）
> ——ヘラクレイトス（紀元前535-475年）

## なぜこの章を読むのか

Beフレームワークの使い方は学びました。この章では、**なぜ**このように設計されたのか——その背後にある哲学的なアイデアを探ります。

古代哲学と現代のコードを結びつけるのは、格好つけるためではありません。これらを理解することで、馴染みのある問題を違う角度から見られるようになり、パターンがより直感的に感じられるかもしれない——そう思って紹介しています。

---

## 1.「Tell」から「Be」へ

### 強調点の違い

**1967年：Tell, Don't Ask**

> 「オブジェクトにデータを尋ねるな、何をすべきか伝えよ」

この原則は何十年もOOPを導いてきました。しかし気づいてください——私たちはまだオブジェクトに*命令*していたのです。

**2025年：Be, Don't Do**

> 「オブジェクトに何をすべきか伝えるな、あるべき姿にならせよ」

```php
// Tell, Don't Ask（命令的）
$user->validate();
$user->save();

// Be, Don't Do（宣言的）
$user = $becoming(new UserInput($data));
```

### 考えてみる価値のある問い

アラン・ケイは、オブジェクトをメッセージでコミュニケーションする自律的な細胞として構想しました。しかし実際に生まれたものは、受動的なデータ構造を操作するコントローラーに近いものでした。

Beフレームワークの一つの見方：オブジェクトが自らの変容に参加する——そのオリジナルのビジョンに近づこうとする試みです。

---

## 2.「WHETHER?」という問い

### 三つの問い

| 問い | 焦点 | パラダイム |
|------|------|------------|
| **HOW?** | 実装 | 命令型 |
| **WHAT?** | 変換 | 関数型 |
| **WHETHER?** | 存在 | 存在論的 |

従来のプログラミングは「どう検証するか？」「何に変換するか？」と問いました。

存在論的プログラミングは、まず「そもそも存在できるか？」と問います。

```php
#[Be(ValidatedUser::class)]
final readonly class UserInput
{
    public function __construct(
        public string $email,
        public int $age
    ) {}
}
```

条件が満たされれば`ValidatedUser`は存在します。満たされなければ、存在しません。

---

## 3. 不可能性のための設計

### 二つのアプローチ

**防御的アプローチ：**

```txt
「エラーが起きたらどうする？」
→ チェックを追加し、例外を処理する
```

**存在アプローチ：**

```txt
「無効な状態は存在できるか？」
→ 存在できないように設計する
```

```php
// 防御的
function processUser(User $user) {
    if (!$user->isValid()) { throw new Exception(); }
    if (!$user->hasEmail()) { throw new Exception(); }
    // ...
}

// 存在ベース
function processUser(ValidatedUser $user) {
    // ValidatedUserが存在する以上、構造的に有効
}
```

アイデア：エラーを処理するのではなく、特定のエラーを表現不可能にする。

---

## 4. ヘラクレイトス：万物は流転する

### 時間の中のオブジェクト

ヘラクレイトスは、同じ川に二度入ることはできないと観察しました。

従来のオブジェクトは、しばしば時間の外に存在します：

```php
$user->age = 5;
$user->age = 50;   // 同じオブジェクト、違う年齢
$user->delete();
$user->getName();  // 削除後に？
```

### 時間的な順序

一つの観察：ドメイン概念にはしばしば自然な時間的順序があります。

```php
// 型でこの順序を表現できる：
UserInput → RegisteredUser → ActiveUser → DeletedUser
```

各段階は区別されます。`DeletedUser`型は`ActiveUser`にはなれない——型システムがこの制約を反映しています。

```txt
時間 T0: EmailInput       — 初期状態
    ↓
時間 T1: ValidatedEmail   — 検証後
    ↓
時間 T2: RegisteredUser   — 登録後
```

各段階は部分的な状態ではなく、完全な状態を表します。

---

## 5. アリストテレスのデュナミス：可能態

アリストテレスは**デュナミス**（可能態）と**エネルゲイア**（現実態）を区別しました。どんぐりは樫の木になる可能性を持っています。

Union型でこのアイデアを表現できます：

```php
#[Be([ApprovedLoan::class, RejectedLoan::class])]
final readonly class LoanApplication
{
    public ApprovedLoan|RejectedLoan $being;

    public function __construct(
        #[Input] Money $amount,
        #[Input] CreditScore $score,
        #[Inject] LoanPolicy $policy
    ) {
        $this->being = $policy->evaluate($amount, $score) > 0.7
            ? new ApprovedLoan($amount, $score)
            : new RejectedLoan($amount, $score);
    }
}
```

`ApprovedLoan|RejectedLoan`という型は、最初から可能な結果を宣言しています。オブジェクトは自らの潜在的な未来を携えています。

---

## 6. 無為：強制しない

老子は書きました：

> 「道は常に無為にして、而も為さざるは無し」

これは、結果を強制するのではなく、自然な流れに従って作用することを示唆しています。

```php
// 強制する
$controller->forceUserToValidate();
$controller->forceUserToSave();

// 可能にする
#[Be(ValidatedUser::class)]
#[Be(SavedUser::class)]
$user = $becoming(new UserInput($data));
```

後者のアプローチは強制しません——オブジェクトが何になれるかを宣言し、変容が起こるに任せます。

---

## 7. 仏教の縁起

### 縁起（プラティーティヤサムトパーダ）

仏教哲学は教えます：

> 「これあるとき、かれあり」

これは相互依存的な生起を表しています——物事は孤立して存在しません。

```php
final readonly class ValidatedEmail
{
    public function __construct(
        #[Input] string $value,              // 先行する存在
        #[Inject] EmailValidator $validator  // 可能にする条件
    ) {
        // ValidatedEmailはこれらの条件から生起する
    }
}
```

### 何が続き、何が落ちるか

これはまた、変容を通じて何が続くか vs 何がそれを可能にするかを考えることを示唆します：

```php
#[Be(Adult::class)]
final readonly class Child
{
    public function __construct(
        #[Input] string $name,           // 続く：アイデンティティ
        #[Input] array $memories,        // 続く：経験
        #[Inject] SchoolService $school  // 可能にし、そして離れる
    ) {
        $this->wisdom = $school->learn($memories);
    }
}
```

- `#[Input]` — 引き継がれるもの
- `#[Inject]` — 変容を可能にするが持続しないもの

---

## 8. 内在と超越

### 出会いを通じた生成

スピノザは現実を、すでにそうであるもの（内在）と外から来るもの（超越）の相互作用として捉えました。

```php
final readonly class UserProfile
{
    public function __construct(
        #[Input] string $name,           // すでに持っているもの
        #[Input] string $email,          // 与えられた性質
        #[Inject] Formatter $formatter,  // 外部の能力
        #[Inject] Validator $validator   // 世界からの寄与
    ) {
        $this->displayName = $formatter->format($name);
        $this->isValid = $validator->validate($email);
    }
}
```

パターン：**与えられた性質** + **外部の能力** → **新しい状態**

これは人間の発達に似ています——内部の性質だけでなく、他者、文化、環境との出会いを通じて。

---

## 9. 三種類の透明性

Beフレームワークは三つのレベルでの明確さを目指しています：

### 1. 構造的

```php
UserInput → ValidatedUser → SavedUser → ActiveUser
```

変容の経路が型に見えています。

### 2. 意味的

```php
string $email     // 名前がEmail検証を示唆
string $password  // 名前がPassword検証を示唆
```

名前が意味を運びます。

### 3. 実行時

```json
{
  "metamorphosis": "UserInput → ValidatedUser",
  "inputs": { "email": "user@example.com" },
  "validations": ["email.format: passed"],
  "result": "ValidatedUser created"
}
```

ログが何が起きたかを記録します。

これらが揃うと、コードはそれ自身のドキュメントになります。

---

## 10. AIとの協働

決定論的なルールにうまく当てはまらない判断もあります。`#[Accept]`パターンはこれを認めています：

```php
#[Be(DiagnosedPatient::class)]
final readonly class PatientSymptoms
{
    public Diagnosis|Undetermined $being;

    public function __construct(
        #[Input] array $symptoms,
        #[Accept] DiagnosticAI $ai
    ) {
        $result = $ai->analyze($symptoms);
        $this->being = $result->confidence > 0.85
            ? new Diagnosis($result)
            : new Undetermined($symptoms, $result->suggestions);
    }
}
```

これは関心の分離を示唆しています：

- 人間がどの状態が存在でき、何を意味するかを定義する
- AIがどの状態が適用されるか判断を助ける

---

## 11. 関連性

これらの哲学的アイデアは共通のテーマを持っています：

| 出典 | 概念 | BOPでの表現 |
|------|------|-------------|
| ヘラクレイトス | 流転 | `Input → Being → Final` |
| アリストテレス | 可能態 | `Success|Failure $being` |
| 老子 | 無為 | `#[Be]`宣言 |
| 仏教 | 縁起 | `#[Input]` + `#[Inject]` |
| スピノザ | 内在/超越 | Input/Injectの区別 |
| ライプニッツ | 充足理由 | 存在理由層* |

*詳細は[第8章：存在理由層](./08-reason-layer.html)を参照。*

これらは無理やりな対応づけではありません——パターンが先に生まれ、哲学的な類似性は後から明らかになりました。

---

## 12. 視点の転換

### 異なる問い

| 時代 | 典型的な問い |
|------|--------------|
| アセンブリ | 「機械にどう指示するか？」 |
| 手続き型 | 「どのステップを実行するか？」 |
| OOP | 「誰が責任を持つか？」 |
| 関数型 | 「何が何になるか？」 |
| 存在論的 | 「何が存在できるか？」 |

### 異なる役割

このフレーミングは、プログラマの仕事に以下が含まれることを示唆します：

- どの状態が意味を持つか決める
- どの存在が可能か定義する
- 有効な状態の構造を設計する

---

## ここからどこへ

さらに探求するために：

1. **前の章を読み返す** — パターンが違って見えるかもしれません
2. **自分の習慣に気づく** — いつ制御し、いつ可能にしているか？
3. **実験する** — 「これは何をすべきか？」の代わりに「これは何になるべきか？」と問うてみる

---

## 結論

Beフレームワークは古いアイデアに基づいています：流転、可能態、縁起、自然な変容。これらは飾りではありません——設計を形作りました。

これらの哲学的な繋がりが響くかどうかは別として、実践的なパターンは残ります：イミュータブルなオブジェクト、型駆動の変容、コンストラクタベースの変容。

古代の哲学者と現代のプログラマは、異なる言語で似た問いを投げかけています。異なるパラダイムは、異なる見方を提供します。そして、どう見るかが、何を作れるかを形作るのです。

---

*次へ：[概要](./01-overview.html)に戻る、または[リファレンス](./11-reference-resources.html)で追加リソースを参照*
