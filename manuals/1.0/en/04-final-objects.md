---
layout: docs-en
title: "4. Final Objects"
category: Manual
permalink: /manuals/1.0/en/04-final-objects.html
---

# Final Objects

> "You are not me. How can you know that I don't know the feelings of fish?"
> 
> —Zhuangzi's reply when asked "You are not a fish. How can you know the feelings of fish?" (Zhuangzi, 4th century BC)

## The Destination

Final Objects represent the destination of metamorphosis—complete, transformed beings that embody the user's actual interest. These are what the application ultimately cares about.

## Characteristics of Final Objects

**Complete Beings**: Final Objects are fully formed entities that need no further transformation for their intended purpose.

**User-Focused**: They represent what users actually want—successful operations, meaningful data, actionable results.

**Rich State**: Unlike Input Classes, Final Objects contain the full richness of transformed data.

## Temporal Completeness

Here's an intriguing question: What if objects had such completeness that they needed no external testing?

The Be Framework captures the temporal existence of objects along two axes:

- **`#[Be]`**: The intended self, the destination (future directionality)
- **`$been`**: The completed self (past perfect self-evidence)

Traditional programming verifies whether objects have been processed correctly through external tests. But what if objects themselves contained evidence of their completion? Instead of external verification, intrinsic self-evidence becomes possible.

## Examples

### Intrinsic Self-Evidence
```php
final class SuccessfulOrder
{
    public readonly string $orderId;
    public readonly string $confirmationCode;
    public readonly DateTimeImmutable $timestamp;
    public readonly string $message;
    public readonly BeenProcessed $been;          // Self-evidence
    
    public function __construct(
        #[Input] Money $total,                    // Immanent nature
        #[Input] CreditCard $card,                // Immanent nature
        #[Inject] OrderIdGenerator $generator,    // Transcendent force
        #[Inject] Receipt $receipt                // Transcendent force
    ) {
        $this->orderId = $generator->generate();              // New immanent nature
        $this->confirmationCode = $receipt->generate($total); // New immanent nature
        $this->timestamp = new DateTimeImmutable();           // New immanent nature
        $this->message = "Order confirmed: {$this->orderId}"; // New immanent nature
        
        // Self-evidence of completion
        $this->been = new BeenProcessed(
            actor: $card->getHolderName(),
            timestamp: $this->timestamp,
            evidence: [
                'total' => $total->getAmount(),
                'payment_method' => $card->getType(),
                'confirmation' => $this->confirmationCode
            ]
        );
    }
}
```

This object requires no external testing. The `$been` property contains complete evidence of completion.

### Error States with Self-Evidence
```php
final class FailedOrder
{
    public readonly string $errorCode;
    public readonly string $message;
    public readonly DateTimeImmutable $timestamp;
    public readonly BeenRejected $been;          // Self-evidence of failure
    
    public function __construct(
        #[Input] array $errors,                   // Immanent nature
        #[Inject] Logger $logger,                 // Transcendent force
        #[Inject] ErrorCodeGenerator $generator   // Transcendent force
    ) {
        $this->errorCode = $generator->generate();
        $this->message = "Order failed: " . implode(', ', $errors);
        $this->timestamp = new DateTimeImmutable();
        
        // Self-evidence of failure
        $this->been = new BeenRejected(
            reason: 'validation_failed',
            timestamp: $this->timestamp,
            evidence: [
                'error_count' => count($errors),
                'error_types' => array_keys($errors),
                'error_code' => $this->errorCode
            ]
        );
        
        $logger->logOrderFailure($this->errorCode, $errors);  // Side effect
    }
}
```

Both success and failure carry their own self-evidence of completion. Instead of external tests, the objects themselves maintain complete records of what occurred.

## Final Objects vs Input Classes

| Input Classes | Final Objects |
|---------------|---------------|
| Pure identity | Rich, transformed state |
| Starting point | Destination |
| What user provides | What user receives |
| Simple structure | Complete functionality |

## Multiple Final Destinies

Objects can have multiple possible final forms, determined by their nature:

```php
// From OrderValidation's being property:
public readonly SuccessfulOrder|FailedOrder $being;

// Usage:
$order = $becoming(new OrderInput($items, $card));

if ($order->being instanceof SuccessfulOrder) {
    echo $order->being->confirmationCode;
} else {
    echo $order->being->message;  // Error message
}
```

## The Journey Complete

The path from Input to Final Object represents a complete transformation journey:

1. **Input Class**: Pure identity ("Here's what I am")
2. **Being Classes**: Transformation stages ("Here's how I change")  
3. **Final Object**: Complete result ("Here's what I became")

Users primarily care about Input (what they provide) and Final Objects (what they get back). The Being Classes in between are our responsibility as designers. It's crucial to understand the temporal transformation of the domain well and design the mechanisms of that transformation to bridge intention and result.

## Transformation Complete

Final Objects express the state of entelecheia (complete realization). They are fully realized beings that no longer need transformation.

The immanent nature that began with Input Classes, through encounters with various transcendent forces and natural transformation, finally reaches this completed form. There is no more "trying to become" or "intending to change." Everything is complete, and the value that users truly sought is realized here. This is the essential value of our system.

This is the destination that Be Framework aims for in programming—existence that embodies not "what to do" but "what to be."
