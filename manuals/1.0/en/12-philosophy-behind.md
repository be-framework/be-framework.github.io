---
layout: docs-en
title: "12. Philosophy Behind"
category: Manual
permalink: /manuals/1.0/en/12-philosophy-behind.html
---

# Philosophy Behind

> "Everything flows" (Panta Rhei)
> —Heraclitus (535-475 BC)

## Everything is Existence

Be—Being is Everything. This framework is built on the premise that everything is existence.

As we deepened our questions about domains, we arrived at questions of existence. What makes existence possible? How does existence transform? What does it mean to not exist?

For 2,500 years, Eastern thinkers and Western philosophers have deepened their questions about existence. Yet this framework did not adopt philosophy as design principles. Rather, by deepening questions about domains, their teachings came to feel like testimony.

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

Procedural programming asks HOW?—how to do it. OOP asks WHAT?—what is it. Ontological programming asks first, WHETHER?—can it even exist.

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

Sartre wrote "Existence precedes essence"—we exist first, then define ourselves. In Be Framework: Existence precedes action—what you ARE determines what you CAN DO.

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

### Momentariness

Buddhism has another teaching: kṣaṇa-vāda, momentariness. Every existence lasts only an instant, then immediately ceases.

```php
$final = $becoming(new OrderInput($items, $customer, $payment));
// OrderInput is born and immediately ceases
// ValidOrder is born, and it too ceases
// InStockOrder is born, and it too ceases
// ...only the final object remains
```

From a distance, a flow of transformation. Up close, a series of cessation and arising. Each object exists for only a moment, passes forward to the next, and vanishes. What has transformed does not return to what it was before.

---

## 8. Two Kinds of Transparency

### Structural

```php
UserInput → ValidatedUser → SavedUser → ActiveUser
```

The transformation path is visible in the types.

### Semantic

```php
string $email     // Name suggests Email validation
string $password  // Name suggests Password validation
```

Names carry meaning.

When both structure and semantics are transparent, code serves as its own documentation.

---

## 9. Resonance

These philosophies resonate with Be Framework.

| Source | Concept | Expression in Be |
|---|---|---|
| Heraclitus | Everything flows | `Input → Being → Final` |
| Aristotle | Potentiality | `Success\|Failure $being` |
| Laozi | Non-forcing | `#[Be]` declaration |
| Spinoza | Necessary existence | Semantic variables |
| Husserl | Transcendence in immanence | `#[Input]` + `#[Inject]` |
| Zhuangzi | Self-testimony | `$been` |
| Heidegger | Language is the house of Being | Class names construct the world |
| Buddhism | Momentariness | Cessation and arising |

---

