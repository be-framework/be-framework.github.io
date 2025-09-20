---
layout: docs-en
title: "7. Type-Driven Metamorphosis"
category: Manual
permalink: /manuals/1.0/en/07-type-driven-metamorphosis.html
---

# Type-Driven Metamorphosis

> "The Tao gives birth to one, one gives birth to two, two gives birth to three, three gives birth to all things"
>
> 　　—Laozi, *Tao Te Ching*, Chapter 42 (6th century BCE)

Type-driven metamorphosis enables objects to choose from multiple possible types based on conditions. Multiple classes are declared as arrays using the `#[Be()]` attribute, with the selection expressed through the being property:

```php
#[Be([Success::class, Failure::class])]
final readonly class PaymentAttempt
{
    public Success|Failure $being;
    
    public function __construct(
        #[Input] Money $amount,
        #[Input] CreditCard $card,
        #[Inject] PaymentGateway $gateway
    ) {
        $result = $gateway->process($amount, $card);
        
        // Branching based on results
        $this->being = $result->isSuccessful() 
            ? new Success($result)
            : new Failure($result->getError());
    }
}
```

## The Being Property

The `$being` property indicates the next transformation destination:

```php
public Success|Failure|Pending $being;
```

Classes are chosen when this type signature matches the constructor of the next class.
For example, if `$being` is of type `Success`, a class with the following constructor would be selected:

```php
class NextStep {
    public function __construct(#[Input] Success $being) {
```

`#[Be]` completely expresses all possibilities of an object. Types become the specification for workflows and use cases.

## Multiple Type Selection Example

```php
#[Be([VIPUser::class, RegularUser::class, SuspendedUser::class])]
final readonly class UserClassification
{
    public VIPUser|RegularUser|SuspendedUser $being;
    
    public function __construct(
        #[Input] UserActivity $activity,
        #[Input] array $violations,
        #[Inject] UserPolicy $policy
    ) {
        $this->being = match (true) {
            $policy->shouldSuspend($violations) => new SuspendedUser($violations),
            $activity->qualifiesForVIP() => new VIPUser($activity),
            default => new RegularUser($activity)
        };
    }
}
```

## Continuation Processing Mechanism

The advantage of type-driven processing lies in automatic continuation processing:

```php
$evaluation = $becoming(new UserInput($data));
$notification = $becoming($evaluation);  // $evaluation->being is automatically selected
```

The framework detects the `$being` property and performs the next processing based on its type. External conditional branching becomes unnecessary.

## Extended Decision-Making Prospects

⚠️ **Note**: AMD (Advanced Decision-Making) is currently an unimplemented future concept.

Beyond deterministic judgment, a new paradigm that embraces uncertainty is being prepared:

```php
// Future concept
#[Accept]  // Unimplemented: delegation to experts
#[Be([Approved::class, Rejected::class, Undetermined::class])]
final readonly class ComplexDecision
{
    public Approved|Rejected|Undetermined $being;
    
    // Extended decision-making through AI-human collaboration
}
```

A decision system where determinable things are decided by types, and indeterminate things are delegated to experts.

## Elimination of Control Structures

Be Framework eliminates traditional "complex control structures within methods". The framework follows flows declared with `#[Be]` and selects the next class through type matching.

Traditional complex conditional branching:

```php
if ($score > 800) {
    return new Approved($amount);
} elseif ($score < 400) {
    return new Rejected("Low score");
} else {
    return new Review($amount);
}
```

In type-driven metamorphosis, these are expressed as union types:

```php
public Approved|Rejected|Review $being;
```

## Integration with Type System

Type-driven metamorphosis integrates complex decision logic into the type system. Union types make possible results explicit, while constructors handle the actual branching. This makes decision logic understandable and maintainable code.

From the simple principle "if types match, proceed to the next", a rich workflow system that handles real-world complexity is constructed.

---

No existence exists without reason. Let's explore the [Reason Layer](./08-reason-layer.html) ➡️
