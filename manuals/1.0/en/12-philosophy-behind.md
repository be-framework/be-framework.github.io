---
layout: docs-en
title: "12. Philosophy Behind"
category: Manual
permalink: /manuals/1.0/en/12-philosophy-behind.html
---

# Philosophy Behind

> "Everything flows" (Panta Rhei)
> —Heraclitus (535-475 BC)

## Why Read This?

You've learned how Be Framework works. This chapter explores **why** it works this way—the philosophical ideas that shaped its design.

These connections between ancient philosophy and modern code aren't meant to impress. They're offered because understanding them may help you see familiar problems differently, and perhaps find the patterns more intuitive.

---

## 1. From "Tell" to "Be"

### A Different Emphasis

**1967: Tell, Don't Ask**

> "Don't ask an object for data, tell it what to do"

This principle guided OOP for decades. But notice—we were still *commanding* objects.

**2025: Be, Don't Do**

> "Don't tell an object what to do, let it become what it is"

```php
// Tell, Don't Ask (imperative)
$user->validate();
$user->save();

// Be, Don't Do (declarative)
$user = $becoming(new UserInput($data));
```

### A Question Worth Considering

Alan Kay envisioned objects as autonomous cells communicating through messages. What emerged in practice often looks more like controllers commanding passive data structures.

One way to see Be Framework: an attempt to move closer to that original vision—objects that participate in determining their own transformation.

---

## 2. The Question of "WHETHER?"

### Three Questions

| Question     | Focus          | Paradigm    |
|--------------|----------------|-------------|
| **HOW?**     | Implementation | Imperative  |
| **WHAT?**    | Transformation | Functional  |
| **WHETHER?** | Existence      | Ontological |

Traditional programming asks "How to validate?" or "What to transform?"

Ontological Programming suggests asking first: "Can this exist at all?"

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

If conditions are met, `ValidatedUser` exists. If not, it simply doesn't.

---

## 3. Designing for Impossibility

### Two Approaches

**Defensive approach:**

```txt
"What if an error occurs?"
→ Add checks, handle exceptions
```

**Existence approach:**

```txt
"Can invalid states exist?"
→ Design so they cannot
```

```php
// Defensive
function processUser(User $user) {
    if (!$user->isValid()) { throw new Exception(); }
    if (!$user->hasEmail()) { throw new Exception(); }
    // ...
}

// Existence-based
function processUser(ValidatedUser $user) {
    // ValidatedUser exists, so it's valid by construction
}
```

The idea: rather than handling errors, make certain errors impossible to represent.

---

## 4. Heraclitus: Everything Flows

### Objects in Time

Heraclitus observed that you cannot step into the same river twice.

Traditional objects often exist outside of time:

```php
$user->age = 5;
$user->age = 50;   // Same object, different age
$user->delete();
$user->getName();  // After deletion?
```

### Temporal Sequence

One observation: domain concepts often have natural temporal order.

```php
// Types can express this order:
UserInput → RegisteredUser → ActiveUser → DeletedUser
```

Each stage is distinct. A `DeletedUser` type cannot become `ActiveUser`—the type system reflects this constraint.

```txt
Time T0: EmailInput       — initial state
    ↓
Time T1: ValidatedEmail   — after validation
    ↓
Time T2: RegisteredUser   — after registration
```

Each stage represents a complete state, not a partial one.

---

## 5. Aristotle's Dynamis: Potentiality

Aristotle distinguished **Dynamis** (potentiality) from **Energeia** (actuality). An acorn has the potential to become an oak tree.

Union types can express this idea:

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

The type `ApprovedLoan|RejectedLoan` declares the possible outcomes from the start. The object carries its potential futures.

---

## 6. Wu Wei: Non-Forcing

Laozi wrote:

> "The Tao does nothing, yet nothing is left undone."

This suggests acting in accordance with natural flow rather than forcing outcomes.

```php
// Forcing
$controller->forceUserToValidate();
$controller->forceUserToSave();

// Enabling
#[Be(ValidatedUser::class)]
#[Be(SavedUser::class)]
$user = $becoming(new UserInput($data));
```

The second approach doesn't force—it declares what the object can become and lets the transformation happen.

---

## 7. Buddhist Dependent Origination

### Pratītyasamutpāda

Buddhist philosophy teaches:

> "When this exists, that comes to be."

This describes interdependent arising—things don't exist in isolation.

```php
final readonly class ValidatedEmail
{
    public function __construct(
        #[Input] string $value,              // Prior existence
        #[Inject] EmailValidator $validator  // Enabling condition
    ) {
        // ValidatedEmail arises from these conditions
    }
}
```

### What Persists, What Falls Away

This also suggests thinking about what continues through transformation versus what enables it:

```php
#[Be(Adult::class)]
final readonly class Child
{
    public function __construct(
        #[Input] string $name,           // Continues: identity
        #[Input] array $memories,        // Continues: experiences
        #[Inject] SchoolService $school  // Enables, then releases
    ) {
        $this->wisdom = $school->learn($memories);
    }
}
```

- `#[Input]` — what carries forward
- `#[Inject]` — what enables transformation but doesn't persist

---

## 8. Immanence and Transcendence

### Becoming Through Encounter

Spinoza saw reality as interplay between what something already is (immanence) and what comes from beyond (transcendence).

```php
final readonly class UserProfile
{
    public function __construct(
        #[Input] string $name,           // What it already has
        #[Input] string $email,          // Given nature
        #[Inject] Formatter $formatter,  // External capability
        #[Inject] Validator $validator   // World's contribution
    ) {
        $this->displayName = $formatter->format($name);
        $this->isValid = $validator->validate($email);
    }
}
```

The pattern: **Given nature** + **External capability** → **New state**

This resembles how people develop—not through internal properties alone, but through encounters with others, culture, and environment.

---

## 9. Three Kinds of Transparency

Be Framework aims for clarity at three levels:

**1. Structural**

```php
UserInput → ValidatedUser → SavedUser → ActiveUser
```

The transformation path is visible in the types.

**2. Semantic**

```php
string $email     // Name suggests Email validation
string $password  // Name suggests Password validation
```

Names carry meaning.

**3. Execution**

```json
{
  "metamorphosis": "UserInput → ValidatedUser",
  "inputs": { "email": "user@example.com" },
  "validations": ["email.format: passed"],
  "result": "ValidatedUser created"
}
```

Logs record what happened.

When these align, the code can serve as its own documentation.

---

## 10. AI Collaboration

Some decisions don't fit deterministic rules well. The `#[Accept]` pattern acknowledges this:

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

This suggests a division of concerns:

- Humans define what states can exist and what they mean
- AI can help determine which state applies

---

## 11. Connections

These philosophical ideas share common themes:

| Source     | Concept                 | Expression in BOP        |
|------------|-------------------------|--------------------------|
| Heraclitus | Flow                    | `Input → Being → Final`  |
| Aristotle  | Potentiality            | `Success|Failure $being` |
| Laozi      | Non-forcing             | `#[Be]` declaration      |
| Buddhism   | Interdependence         | `#[Input]` + `#[Inject]` |
| Spinoza    | Immanence/Transcendence | Input/Inject distinction |
| Leibniz    | Sufficient reason       | Reason Layer*            |

*See [Chapter 8: Reason Layer](./08-reason-layer.html) for details.*

These aren't forced mappings—the patterns emerged and the philosophical parallels became apparent afterward.

---

## 12. Shifting Perspective

### Different Questions

| Era         | Typical Question               |
|-------------|--------------------------------|
| Assembly    | "How to instruct the machine?" |
| Procedural  | "What steps to execute?"       |
| OOP         | "Who is responsible?"          |
| Functional  | "What becomes what?"           |
| Ontological | "What can exist?"              |

### A Different Role

This framing suggests the programmer's work includes:

- Deciding what states are meaningful
- Defining what existence is possible
- Designing the structure of valid states

---

## Where to Go from Here

To explore further:

1. **Re-read earlier chapters** — the patterns may look different now
2. **Notice your habits** — when do you control vs. enable?
3. **Experiment** — try asking "What should this become?" instead of "What should this do?"

---

## Conclusion

Be Framework draws on old ideas: flow, potentiality, interdependence, natural transformation. These aren't decorations—they shaped the design.

Whether these philosophical connections resonate with you or not, the practical patterns remain: immutable objects, type-driven transformation, constructor-based metamorphosis.

Ancient philosophers and modern programmers ask similar questions in different languages. A different paradigm offers a different way to see. And how we see shapes what we can build.

---

*Next: Return to [Overview](./01-overview.html) or see [Reference](./11-reference-resources.html) for additional resources.*
