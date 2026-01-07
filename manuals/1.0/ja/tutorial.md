---
layout: docs-ja
title: "Tutorial"
category: Manual
permalink: /manuals/1.0/ja/tutorial.html
---

# チュートリアル: 救急トリアージ

> バイタルサインが患者の存在を「緊急」または「経過観察」として決定するトリアージシステムを構築します。

## 前提条件

- [Getting Started](./getting-started.html) を完了していること
- PHP 8.4+
- [Be Framework の哲学](./01-overview.html) の基本的な理解

## はじめに

このチュートリアルでは、Be Framework の核心哲学を示す救急トリアージシステムを構築します：**オブジェクトは何かを「する」のではなく、何かに「なる」のです。**

患者は「トリアージされる」のではありません。医学プロトコルという超越的な知恵に基づいて、緊急症例または経過観察症例に**なる**のです。

## 変態の流れ

```
PatientArrival（生のバイタルサイン）
    ↓ JTAS プロトコルが評価
TriageAssessment（蛹の段階）
    ↓ 運命が決定される
EmergencyCase または ObservationCase（最終的な存在）
```

## ステップ 1: オントロジーを定義する

ロジックを書く前に、**ドメインオントロジー**—このドメインで何が存在できるかの語彙—を定義します。

### BodyTemperature

```php
// src/Semantic/BodyTemperature.php

/**
 * 30°C未満または45°Cを超えると、人間は生存できない。
 * そのような値はセマンティックレベルで拒否される。
 */
final class BodyTemperature
{
    #[Validate]
    public function validate(float $bodyTemperature): void
    {
        if ($bodyTemperature < 30.0 || $bodyTemperature > 45.0) {
            throw new LethalVitalException();
        }
    }
}
```

### HeartRate

```php
// src/Semantic/HeartRate.php

/**
 * 20 bpm未満または250 bpmを超えると心停止または致死的不整脈を示す。
 */
final class HeartRate
{
    #[Validate]
    public function validate(int $heartRate): void
    {
        if ($heartRate < 20 || $heartRate > 250) {
            throw new LethalVitalException();
        }
    }
}
```

**重要な洞察：** これらは単なる検証ルールではありません。**ドメインオントロジー**—何が存在できるかの語彙—を定義しています。この宣言的な基盤は、人間とAIの両方がドメインを理解するために読めるドキュメントとして機能します。（[セマンティック変数](./06-semantic-variables.html) でAI可読なシステム設計の詳細をご覧ください。）

## ステップ 2: 例外を定義する

バイタルサインが生存不可能な状態を示す場合、患者の存在は拒否されます：

```php
// src/Exception/LethalVitalException.php

#[Message([
    'en' => 'Vital signs indicate non-survivable conditions.',
    'ja' => 'バイタルサインが生存不可能な状態を示しています。'
])]
final class LethalVitalException extends DomainException
{
}
```

## ステップ 3: Reason（超越）を定義する

**JTASProtocol**（Japan Triage and Acuity Scale）はプログラマーの恣意的なルールではありません。**超越的な医学の知恵**—世界に独立して存在する客観的な知識—を表します。Be Framework では、このようなドメインロジックは**第一級市民**になります：注入可能、テスト可能、明示的に可視。

```php
// src/Reason/JTASProtocol.php

/**
 * JTAS (Japan Triage and Acuity Scale) プロトコル
 *
 * 個々の患者やプログラマーから独立して存在する
 * 超越的な医学の知恵。
 *
 * 注: 簡略化。実際のJTASは5レベル。
 */
final readonly class JTASProtocol
{
    /** @return 'emergency'|'observation' */
    public function assess(float $bodyTemperature, int $heartRate): string
    {
        if ($bodyTemperature >= 39.0 || $heartRate >= 120) {
            return 'emergency';
        }
        return 'observation';
    }
}
```

これが**Reason**—変態を可能にする外部の力です。幼虫が蝶になるために環境条件が必要なように、私たちのデータもトリアージされた患者になるために JTASProtocol が必要です。

## ステップ 4: Input クラスを作成

出発点—到着時の生のバイタルサイン：

```php
// src/Input/PatientArrival.php

#[Be([TriageAssessment::class])]
final readonly class PatientArrival
{
    public function __construct(
        public float $bodyTemperature,
        public int $heartRate
    ) {}
}
```

`#[Be]` 属性は運命を宣言します：この到着は TriageAssessment に**なります**。

## ステップ 5: 運命マーカーを作成

これらの型は2つの可能な運命を表します：

```php
// src/Reason/Emergency.php
final readonly class Emergency {}

// src/Reason/Observation.php
final readonly class Observation {}
```

これらは空のクラスではありません—それ自体が**区別**です。`Emergency` は `Observation` とは根本的に異なります。型自体が意味を持ちます。

## ステップ 6: Being クラスを作成

ここで変態が起こります。患者は中間状態にあり、最終形態はまだ決まっていません：

```php
// src/Being/TriageAssessment.php

/**
 * 生のバイタルサインが JTAS プロトコル（超越的な知恵）と出会い、
 * 患者の運命が決定される。
 */
#[Be([EmergencyCase::class, ObservationCase::class])]
final readonly class TriageAssessment
{
    public Emergency|Observation $being;

    public function __construct(
        #[Input] public float $bodyTemperature,
        #[Input] public int $heartRate,
        #[Inject] JTASProtocol $protocol
    ) {
        $urgency = $protocol->assess($bodyTemperature, $heartRate);
        $this->being = ($urgency === 'emergency')
            ? new Emergency()
            : new Observation();
    }
}
```

**重要な概念：**
- `#[Inject]` が JTASProtocol を持ち込む—外部からの超越的な知恵
- `$being` プロパティ（Union型）がどの Final クラスが変態を受け取るかを決定
- 「ステータスを設定する」のではなく、患者がその運命に**なる**

## ステップ 7: Final クラスを作成

最終形態—それぞれ独自の**能力**を持つ：

### EmergencyCase

```php
// src/Final/EmergencyCase.php

/**
 * 最高優先度として存在する患者。
 * これは単なるステータスフラグではない。この患者は緊急である。
 * その型が他にはない能力を与える。
 */
final readonly class EmergencyCase
{
    public string $priority;
    public string $color;

    public function __construct(
        #[Input] public float $bodyTemperature,
        #[Input] public int $heartRate,
        #[Input] public Emergency $being
    ) {
        $this->priority = 'IMMEDIATE';
        $this->color = 'RED';
    }

    /**
     * EmergencyCase だけが ER 割り当てを要求できる
     */
    public function assignER(): string
    {
        return "直ちに救急室1を確保。救急医を呼び出し。";
    }
}
```

### ObservationCase

```php
// src/Final/ObservationCase.php

/**
 * 安定として存在する患者。
 * 緊急症例が処理される間、安全に待機できる。
 */
final readonly class ObservationCase
{
    public string $priority;
    public string $color;

    public function __construct(
        #[Input] public float $bodyTemperature,
        #[Input] public int $heartRate,
        #[Input] public Observation $being
    ) {
        $this->priority = 'DELAYED';
        $this->color = 'GREEN';
    }

    /**
     * 経過観察症例は待合室に割り当てられる
     */
    public function assignWaitingArea(): string
    {
        return "待合室へ移動。30分ごとにバイタル監視。";
    }
}
```

注目：各 Final は**異なるメソッド**を持ちます。`EmergencyCase` は `assignER()` を、`ObservationCase` は `assignWaitingArea()` を持ちます。**型が能力を決定します**—経過観察の患者に救急室を割り当てることはできません。

## ステップ 8: 変態を実行

```php
// bin/app.php

use Be\App\Input\PatientArrival;
use Be\App\Module\AppModule;
use Be\Framework\Becoming;
use Ray\Di\Injector;

$injector = new Injector(new AppModule());
$becoming = new Becoming($injector, 'Be\\App\\Semantic');

// 高熱の患者
$patient = new PatientArrival(bodyTemperature: 39.5, heartRate: 90);
$result = $becoming($patient);

echo $result->priority;     // "IMMEDIATE"
echo $result->color;        // "RED"
echo $result->assignER();   // "直ちに救急室1を確保..."
```

## 完全なフロー

```
PatientArrival(39.5°C, 90 bpm)
    ↓ #[Be([TriageAssessment::class])]
TriageAssessment
    ├─ JTASProtocol->assess() が 'emergency' を返す
    └─ $being = Emergency
    ↓ #[Be([EmergencyCase::class, ObservationCase::class])]
EmergencyCase（$being が Emergency なので）
    → priority: IMMEDIATE
    → color: RED
    → assignER(): "直ちに救急室1を確保..."
```

## 生存不可能な存在の処理

```php
// 生存可能範囲外の体温
$invalid = new PatientArrival(bodyTemperature: 50.0, heartRate: 80);

try {
    $becoming($invalid);
} catch (SemanticVariableException $e) {
    echo $e->getErrors()->getMessages('ja')[0];
    // "バイタルサインが生存不可能な状態を示しています。"
}
```

変態は**拒否されます**。致死的なバイタルサインを持つ患者は私たちのシステムに存在できません。

## なぜこれが重要か

### 従来のアプローチ（Doing）

```php
$patient = new Patient($temp, $hr);
if ($triageService->isEmergency($patient)) {
    $patient->setStatus('emergency');
    $this->erService->assign($patient);
}
```

問題点：
- 患者は無効な状態で存在できる
- ステータスはいつでも変更できる
- `erService->assign()` はどの患者にも呼べる

### Be Framework のアプローチ（Being）

```php
$patient = new PatientArrival($temp, $hr);
$result = $becoming($patient);

// $result は EmergencyCase または ObservationCase である
// EmergencyCase だけが assignER() メソッドを持つ
$result->assignER();  // 型安全：EmergencyCase でのみ可能
```

利点：
- 生存不可能な状態は存在できない
- 型がステータスである（不変）
- 能力は存在に属する

## プロジェクト構造

```
src/
├── Being/
│   └── TriageAssessment.php    # 中間段階
├── Exception/
│   └── LethalVitalException.php
├── Input/
│   └── PatientArrival.php      # 生データ
├── Module/
│   └── AppModule.php           # DI設定
├── Final/
│   ├── EmergencyCase.php       # 最終形態：緊急
│   └── ObservationCase.php     # 最終形態：経過観察
├── Reason/
│   ├── Emergency.php           # 運命マーカー
│   ├── JTASProtocol.php        # 超越的な知恵
│   └── Observation.php         # 運命マーカー
└── Semantic/
    ├── BodyTemperature.php     # 何が存在できるか
    └── HeartRate.php
```

## 重要な洞察

1. **アクションより存在**: 患者は「トリアージされる」のではなく、トリアージされた状態に**なる**
2. **型がステータス**: `EmergencyCase` と `ObservationCase` は異なる能力を持つ異なる型
3. **セマンティックな境界**: 致死的なバイタルサインは変態前に拒否される
4. **超越的な知恵**: JTASProtocol は独立して存在する—作成されるのではなく注入される
5. **不変性**: 一度変態すると、新たな変態なしにステータスは変更できない

## 他のドメインでの変態

同じパターンがあらゆる場所に適用されます：

| ドメイン | Input | Being | Final | Reason |
|---------|-------|-------|-------|--------|
| **トリアージ** | PatientArrival | TriageAssessment | Emergency/Observation | JTASProtocol |
| **醸造** | RawMaterials | Fermentation | PremiumSake/Vinegar | YeastCulture |
| **入国審査** | VisaApplication | ConsularReview | Resident/Visitor | ImmigrationLaw |
| **裁判** | Evidence | Trial | Guilty/Acquitted | PenalCode |
| **恒星進化** | GasCloud | Protostar | Star/BlackHole | PhysicsLaws |

すべてのドメインに変態があります。すべての存在に理由があります。

## 次のステップ

- [Semantic Variables](./06-semantic-variables.html) - セマンティック検証の詳細
- [Type-Driven Metamorphosis](./07-type-driven-metamorphosis.html) - 高度な分岐パターン
- [Reason Layer](./08-reason-layer.html) - 超越の理解
