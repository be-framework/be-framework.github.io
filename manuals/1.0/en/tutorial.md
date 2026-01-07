---
layout: docs-en
title: "Tutorial"
category: Manual
permalink: /manuals/1.0/en/tutorial.html
---

# Tutorial: Emergency Triage

> Build a triage system where vital signs determine a patient's existence as "emergency" or "observation."

## Prerequisites

- Complete [Getting Started](./getting-started.html)
- PHP 8.4+
- Basic understanding of [Be Framework philosophy](./01-overview.html)

## Introduction

In this tutorial, we'll build an emergency triage system that demonstrates the core philosophy of Be Framework: **objects don't DO things—they BECOME things.**

A patient doesn't "get triaged." They **become** an emergency case or an observation case, based on the transcendent wisdom of medical protocol.

## The Metamorphosis

```
PatientArrival (raw vital signs)
    ↓ JTAS Protocol assesses
TriageAssessment (the chrysalis stage)
    ↓ Destiny is determined
EmergencyCase or ObservationCase (final existence)
```

## Step 1: Define the Ontology

Before writing logic, we define our **domain ontology**—the vocabulary of what can exist in this domain.

### BodyTemperature

```php
// src/Semantic/BodyTemperature.php

/**
 * Below 30°C or above 45°C, a human cannot survive.
 * Such values are rejected at the semantic level.
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
 * Below 20 or above 250 bpm indicates cardiac arrest or lethal arrhythmia.
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

These aren't just validation rules. They define your domain ontology—the vocabulary of what can exist. This declarative foundation serves as documentation that both humans and AI can read to understand your domain. (See [Semantic Variables](./06-semantic-variables.html) for details.)

## Step 2: Define Exceptions

When vital signs indicate non-survivable conditions, the patient's existence is rejected:

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

## Step 3: Define the Reason (Transcendence)

The JTASProtocol (Japan Triage and Acuity Scale) is not a programmer's arbitrary rule. It represents transcendent medical wisdom—objective knowledge that exists independently in the world. In Be Framework, such domain logic becomes a **first-class citizen**: injectable, testable, and explicitly visible.

```php
// src/Reason/JTASProtocol.php

/**
 * JTAS (Japan Triage and Acuity Scale) Protocol
 *
 * A transcendent medical wisdom that exists independently
 * of any individual patient or programmer.
 *
 * Note: Simplified. Real JTAS has 5 levels.
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

This is the **Reason**—the external force that enables metamorphosis. Just as a caterpillar needs environmental conditions to become a butterfly, our data needs the JTASProtocol to become a triaged patient.

## Step 4: Create Input Class

The starting point—raw vital signs at the moment of arrival:

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

The `#[Be]` attribute declares destiny: this arrival WILL BECOME a TriageAssessment.

## Step 5: Create Destiny Markers

These types represent the two possible destinies:

```php
// src/Reason/Emergency.php
final readonly class Emergency {}

// src/Reason/Observation.php
final readonly class Observation {}
```

These aren't empty classes—they ARE the distinction. An `Emergency` is fundamentally different from an `Observation`. The type itself carries meaning.

## Step 6: Create Being Class

This is where metamorphosis happens. The patient is in a liminal state—their final form not yet determined:

```php
// src/Being/TriageAssessment.php

/**
 * Raw vital signs meet the JTAS Protocol (transcendent wisdom)
 * and the patient's destiny is determined.
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

`#[Inject]` brings in the JTASProtocol—transcendent wisdom from outside. The `$being` property (Union type) determines which Final class receives the transformation. We don't "set status"—the patient BECOMES their destiny.

## Step 7: Create Final Classes

The final forms—each with unique capabilities:

### EmergencyCase

```php
// src/Final/EmergencyCase.php

/**
 * A patient who EXISTS as highest priority.
 * This is not just a status flag. This patient IS an emergency.
 * Their type grants them capabilities that others don't have.
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
     * Only an EmergencyCase can demand ER assignment
     */
    public function assignER(): string
    {
        return "Secure ER Room 1 immediately. Summon emergency physician.";
    }
}
```

### ObservationCase

```php
// src/Final/ObservationCase.php

/**
 * A patient who EXISTS as stable.
 * They can safely wait while emergency cases are handled.
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
     * Observation cases are assigned to waiting area
     */
    public function assignWaitingArea(): string
    {
        return "Move to waiting area. Monitor vitals every 30 minutes.";
    }
}
```

Each type has different methods. `EmergencyCase` can `assignER()`, while `ObservationCase` can `assignWaitingArea()`. Type determines capability—you cannot assign an ER room to an observation patient.

## Step 8: Execute the Metamorphosis

```php
// bin/app.php

use Be\App\Input\PatientArrival;
use Be\App\Module\AppModule;
use Be\Framework\Becoming;
use Ray\Di\Injector;

$injector = new Injector(new AppModule());
$becoming = new Becoming($injector, 'Be\\App\\Semantic');

// High fever patient
$patient = new PatientArrival(bodyTemperature: 39.5, heartRate: 90);
$result = $becoming($patient);

echo $result->priority;     // "IMMEDIATE"
echo $result->color;        // "RED"
echo $result->assignER();   // "Secure ER Room 1 immediately..."
```

## The Complete Flow

```
PatientArrival(39.5°C, 90 bpm)
    ↓ #[Be([TriageAssessment::class])]
TriageAssessment
    ├─ JTASProtocol->assess() returns 'emergency'
    └─ $being = Emergency
    ↓ #[Be([EmergencyCase::class, ObservationCase::class])]
EmergencyCase (because $being is Emergency)
    → priority: IMMEDIATE
    → color: RED
    → assignER(): "Secure ER Room 1..."
```

## Handling Non-Survivable Existence

```php
// Temperature outside survivable range
$invalid = new PatientArrival(bodyTemperature: 50.0, heartRate: 80);

try {
    $becoming($invalid);
} catch (SemanticVariableException $e) {
    echo $e->getErrors()->getMessages('en')[0];
    // "Vital signs indicate non-survivable conditions."
}
```

The metamorphosis is **rejected**. A patient with lethal vital signs cannot exist in our system.

## Why This Matters

### Traditional Approach (Doing)

```php
$patient = new Patient($temp, $hr);
if ($triageService->isEmergency($patient)) {
    $patient->setStatus('emergency');
    $this->erService->assign($patient);
}
```

Problems:
- Patient can exist in invalid state
- Status can be changed at any time
- `erService->assign()` can be called on any patient

### Be Framework Approach (Being)

```php
$patient = new PatientArrival($temp, $hr);
$result = $becoming($patient);

// $result IS an EmergencyCase or ObservationCase
// Only EmergencyCase has assignER() method
$result->assignER();  // Type-safe: only possible for EmergencyCase
```

Benefits:
- Non-survivable states cannot exist
- Type IS the status (immutable)
- Capabilities belong to existence

## Project Structure

```
src/
├── Being/
│   └── TriageAssessment.php    # Intermediate stage
├── Exception/
│   └── LethalVitalException.php
├── Input/
│   └── PatientArrival.php      # Raw data
├── Module/
│   └── AppModule.php           # DI configuration
├── Final/
│   ├── EmergencyCase.php       # Final form: emergency
│   └── ObservationCase.php     # Final form: observation
├── Reason/
│   ├── Emergency.php           # Destiny marker
│   ├── JTASProtocol.php        # Transcendent wisdom
│   └── Observation.php         # Destiny marker
└── Semantic/
    ├── BodyTemperature.php     # What CAN exist
    └── HeartRate.php
```

## Key Insights

1. The patient doesn't "get triaged"—they BECOME a triaged state
2. `EmergencyCase` and `ObservationCase` are different types with different capabilities
3. Once transformed, status cannot change without new metamorphosis

## Metamorphosis in Other Domains

The same pattern applies everywhere:

| Domain | Input | Being | Final | Reason |
|--------|-------|-------|---------|--------|
| **Triage** | PatientArrival | TriageAssessment | Emergency/Observation | JTASProtocol |
| **Brewing** | RawMaterials | Fermentation | PremiumSake/Vinegar | YeastCulture |
| **Immigration** | VisaApplication | ConsularReview | Resident/Visitor | ImmigrationLaw |
| **Justice** | Evidence | Trial | Guilty/Acquitted | PenalCode |
| **Stellar** | GasCloud | Protostar | Star/BlackHole | PhysicsLaws |

Every domain has its metamorphosis. Every existence has its reason.

## Next Steps

- [Semantic Variables](./06-semantic-variables.html) - Deep dive into semantic validation
- [Type-Driven Metamorphosis](./07-type-driven-metamorphosis.html) - Advanced branching patterns
- [Reason Layer](./08-reason-layer.html) - Understanding transcendence
