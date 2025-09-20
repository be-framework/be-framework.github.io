---
layout: docs-en
title: "5. Metamorphosis"
category: Manual
permalink: /manuals/1.0/en/05-metamorphosis.html
---

# Metamorphosis

> "Space and time cannot be defined independently of each other."
> 
> —Albert Einstein, The Foundation of the General Theory of Relativity (1916)  
> *Analogy applying spacetime concepts to programming

## Time and Domain Are Inseparable

Just as Einstein discovered the inseparability of time and space, the Be Framework considers time and domain as a single entity that cannot be divided. Approval processes have their approval time, payments have their payment time, and transformation naturally emerges along the unique temporal axis that each domain logic possesses.

## Irreversible Flow of Time

Object metamorphosis follows the arrow of time in a unidirectional flow. There is no returning to the past, no remaining in the same moment:

```php
// Time T0: Birth of input
#[Be(EmailValidation::class)]
final readonly class EmailInput { /* ... */ }

// Time T1: First metamorphosis (T0 is already past)
#[Be(UserCreation::class)]
final readonly class EmailValidation { /* ... */ }

// Time T2: Second metamorphosis (T1 becomes memory)
#[Be(WelcomeMessage::class)]
final readonly class UserCreation { /* ... */ }

// Time T3: Final existence (encompassing all past)
final readonly class WelcomeMessage { /* ... */ }
```

Each moment never returns, and new existence preserves previous forms as memory within itself. Like a river flowing, time moves only in one direction.

## Self-Determination of Destiny

Like living beings in reality, objects determine their own destiny through the interaction between intrinsic nature and external environment. This is not following a predetermined route, but natural metamorphosis responding to the circumstances of that moment:

```php
#[Be([ApprovedApplication::class, RejectedApplication::class])]
final readonly class ApplicationReview
{
    public ApprovedApplication|RejectedApplication $being;
    
    public function __construct(
        #[Input] array $documents,                // Intrinsic nature
        #[Inject] ReviewService $reviewer         // External environment
    ) {
        $result = $reviewer->evaluate($documents);
        
        // Destiny is decided at this very moment
        $this->being = $result->isApproved()
            ? new ApprovedApplication($documents, $result->getScore())
            : new RejectedApplication($result->getReasons());
    }
}
```



## Nested Metamorphosis

Complex objects can contain their own transformation chains:

```php
final readonly class OrderProcessing
{
    public PaymentResult $payment;
    public ShippingResult $shipping;
    
    public function __construct(
        #[Input] Order $order,                    // Intrinsic nature
        #[Inject] Becoming $becoming              // External environment
    ) {
        // Nested transformations
        $this->payment = $becoming(new PaymentInput($order->getPayment()));
        $this->shipping = $becoming(new ShippingInput($order->getAddress()));
    }
}
```

## Self-Organizing Pipelines

The beauty of these patterns is that they're **self-organizing**. Like UNIX pipes that combine simple commands to create powerful systems, Be Framework combines typed objects to create natural transformation flows.

### Comparison with UNIX Pipes

```bash
# UNIX: Text flows through externally controlled pipelines
cat access.log | grep "404" | awk '{print $7}' | sort | uniq -c
```

```php
// Be Framework: Rich objects flow through intrinsically controlled pipelines
$finalObject = $becoming(new ApplicationInput($documents));
// Objects themselves know their next transformation destination
```

Key evolution:
- **UNIX**: External shell controls the pipeline
- **Be Framework**: Objects declare their own destiny with `#[Be()]`

### Self-Organization in Action

```php
// No controllers, no orchestrators—just natural flow
$finalObject = $becoming(new ApplicationInput($documents));

// The object has become what it was meant to be
match (true) {
    $finalObject->being instanceof ApprovedApplication => $this->sendApprovalEmail($finalObject->being),
    $finalObject->being instanceof RejectedApplication => $this->sendRejectionEmail($finalObject->being),
};
```

This self-organization provides:
- No external orchestration needed
- Type safety maintained
- Capabilities provided through dependency injection
- Testable independent components

## Implementation Guidelines

### When to Choose Linear Metamorphosis

For sequential processing where each stage prepares the data needed for the next:

```php
User Registration → Email Verification → Account Activation → Welcome Notification
```

This is suitable when failure at any stage should halt the entire process.

### When to Choose Conditional Branching

When the same input branches into different results based on nature or permissions:

```php
// Implementation example: Feature differentiation by payment capability
#[Be([FullAccess::class, LimitedAccess::class, ReadOnlyAccess::class])]
final readonly class AccessDetermination
{
    public FullAccess|LimitedAccess|ReadOnlyAccess $being;
    
    public function __construct(
        #[Input] User $user,
        #[Inject] PaymentStatus $payment
    ) {
        $this->being = match($payment->getStatus()) {
            'premium' => new FullAccess($user, $payment->getFeatures()),
            'basic' => new LimitedAccess($user, $payment->getLimits()),
            default => new ReadOnlyAccess($user)
        };
    }
}
```

### When to Choose Nested Metamorphosis

When executing multiple independent processes in parallel and aggregating their results:

```php
final readonly class OrderCompletion
{
    public function __construct(
        #[Input] OrderData $order,
        #[Inject] Becoming $becoming
    ) {
        // Independent parallel processing
        $this->inventory = $becoming(new InventoryCheck($order->items));
        $this->payment = $becoming(new PaymentProcess($order->payment));
        $this->shipping = $becoming(new ShippingArrange($order->address));
    }
}
```

## Design Principles

Choose metamorphosis patterns according to the natural flow of domain logic:

- **Don't Force**: Don't force into artificial patterns
- **Keep Simple**: Choose the most simple and understandable form
- **Testable**: Each metamorphosis stage can be tested independently
- **Type Safe**: Next type is guaranteed by `#[Be()]`

Objects govern their own metamorphosis.

Heraclitus said "the river flows" is not correct, but rather "the flowing is the river." He believed that existence cannot be separated from change. Be Framework likewise believes that to capture essence, domain and time cannot be separated.
Domains are temporal existence. There are possibilities and being at each moment. Capturing how input classes, being classes, and final objects naturally metamorphose along the flow of time is the core of the Be Framework.

---

Variable names that carry constraints and contracts, [Semantic Variables](./06-semantic-variables.html) ➡️
