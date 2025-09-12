---
layout: docs-en
title: "5. Metamorphosis Patterns"
category: Manual
permalink: /manuals/1.0/en/05-metamorphosis-patterns.html
---

# Metamorphosis Patterns

> "No man ever steps in the same river twice."
> 
> —Heraclitus, Fragments (c. 500 BC)

## Patterns of Change

Be Framework supports various patterns of transformation, from simple linear chains to complex branching. Understanding these patterns helps you design natural transformation flows.

## Linear Metamorphic Chain

The simplest pattern: A → B → C → D

```php
// Input
#[Be(EmailValidation::class)]
final class EmailInput { /* ... */ }

// First transformation
#[Be(UserCreation::class)]
final class EmailValidation { /* ... */ }

// Second transformation  
#[Be(WelcomeMessage::class)]
final class UserCreation { /* ... */ }

// Final result
final class WelcomeMessage { /* ... */ }
```

Each stage naturally leads to the next, like a river flowing to the sea.

## Conditional Branching Pattern

Objects can have multiple possible futures based on their nature. This is natural transformation that branches into different types based on conditions:

```php
#[Be([ApprovedApplication::class, RejectedApplication::class])]
final class ApplicationReview
{
    public readonly ApprovedApplication|RejectedApplication $being;
    
    public function __construct(
        #[Input] array $documents,                // Immanent
        #[Inject] ReviewService $reviewer         // Transcendent
    ) {
        $result = $reviewer->evaluate($documents);
        
        $this->being = $result->isApproved()
            ? new ApprovedApplication($documents, $result->getScore())
            : new RejectedApplication($result->getReasons());
    }
}
```

### Other Conditional Branching Examples

Feature levels and permissions follow the same pattern:

```php
#[Be([PremiumFeatures::class, BasicFeatures::class])]
final class FeatureActivation
{
    public readonly PremiumFeatures|BasicFeatures $being;
    
    public function __construct(
        #[Input] User $user,                      // Immanent
        #[Inject] SubscriptionService $service    // Transcendent
    ) {
        $subscription = $service->getSubscription($user);
        
        $this->being = $subscription->isPremium()
            ? new PremiumFeatures($user, $subscription)
            : new BasicFeatures($user);
    }
}
```

The object determines its own destiny through **Type-Driven Metamorphosis**.



## Nested Metamorphosis

Complex objects can contain their own transformation chains:

```php
final class OrderProcessing
{
    public readonly PaymentResult $payment;
    public readonly ShippingResult $shipping;
    
    public function __construct(
        #[Input] Order $order,                    // Immanent
        #[Inject] Becoming $becoming              // Transcendent
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

## Pattern Selection

Choose patterns based on your domain's natural flow:

- **Linear**: Sequential processes (validation → processing → completion)
- **Conditional Branching**: Decision points (approve/reject, success/failure, permission levels)
- **Nested**: Complex operations with sub-processes

The key is to let transformation emerge naturally from the domain's flow, not force it into artificial patterns.
