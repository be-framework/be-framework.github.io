---
layout: docs-en
title: "4. Final Objects"
category: Manual
permalink: /manuals/1.0/en/04-final-objects.html
---

# Final Objects

> "You are not me. How do you know that I do not know the feelings of a fish?"
>
> —Zhuangzi's response when asked "You are not a fish. How do you know the feelings of a fish?" ('Zhuangzi', 4th Century BC)

## The Destination

Final Objects are the destination of the journey of metamorphosis.
They are the complete and final existence where the value users seek and the result the application wants to deliver are embodied.

This is the final form achieved after the Immanence that started from the Input Class met various Transcendence and underwent natural metamorphosis. It embodies the Entelechy spoken of by Aristotle—the state where potentiality is completely actualized.

## Characteristics of Final Objects

**Completeness (Entelechy)**: A completely actualized existence that requires no further metamorphosis.

**Realization of User Value**: Expresses what the user truly needs, meaningful data, or the successful result of an operation.

**Rich State**: In contrast to Input Classes, Final Objects completely express the richness of the domain.

## Completeness of Temporal Being

Here is an interesting question. What if there was an object so complete that it didn't need tests?

In Be Framework, we capture the temporal existence of objects on two axes:

- **`#[Be]`**: The self you want to become, the destination (Direction towards the future)
- **`$been`**: The self that has completed (Self-proof of past perfect)

In traditional programming, we verify whether an object has been processed correctly with external tests. But what if the object itself contained the proof of completion? Instead of external verification, immanent self-proof becomes possible.

## Examples

### Result with Immanent Self-Proof
```php
final readonly class SuccessfulOrder
{
    public string $orderId;
    public string $confirmationCode;
    public DateTimeImmutable $timestamp;
    public string $message;
    public BeenProcessed $been;          // Self-proof
    
    public function __construct(
        #[Input] Money $total,                    // Immanence
        #[Input] CreditCard $card,                // Immanence
        #[Inject] OrderIdGenerator $generator,    // Transcendence
        #[Inject] Receipt $receipt                // Transcendence
    ) {
        $this->orderId = $generator->generate();              // New Immanence
        $this->confirmationCode = $receipt->generate($total); // New Immanence
        $this->timestamp = new DateTimeImmutable();           // New Immanence
        $this->message = "Order Confirmed: {$this->orderId}"; // New Immanence
        
        // Self-proof of completion
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

This object does not need external tests. This is because the `$been` property contains complete evidence of completion.

### Self-Proof of Error State
```php
final readonly class FailedOrder
{
    public string $errorCode;
    public string $message;
    public DateTimeImmutable $timestamp;
    public BeenRejected $been;          // Self-proof of failure
    
    public function __construct(
        #[Input] array $errors,                   // Immanence
        #[Inject] Logger $logger,                 // Transcendence
        #[Inject] ErrorCodeGenerator $generator   // Transcendence
    ) {
        $this->errorCode = $generator->generate();
        $this->message = "Order Failed: " . implode(', ', $errors);
        $this->timestamp = new DateTimeImmutable();
        
        // Self-proof of failure
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

Both success and failure have self-proof of completion. Instead of external tests, the object itself holds a complete record of what happened.

## Final Objects vs Input Classes

| Input Class | Final Object |
|-----------|-----------------|
| Pure Identity | Rich Transformed State |
| Starting Point of Metamorphosis | Destination of Metamorphosis |
| What User Provides | What User Receives |
| Simple Structure | Completely Realized Function |

## Multiple Final Destinies

Objects can have multiple possible final forms determined by their nature:

```php
// From Being property of OrderValidation:
public SuccessfulOrder|FailedOrder $being;

// Usage:
$order = $becoming(new OrderInput($items, $card));

if ($order->being instanceof SuccessfulOrder) {
    echo $order->being->confirmationCode;
} else {
    echo $order->being->message;  // Error message
}
```

## A Completed Journey

The path from Input to Final Object represents a complete journey of metamorphosis:

1. **Input Class**: Pure Identity ("This is me")
2. **Being Class**: Stage of Metamorphosis ("This is how I change")
3. **Final Object**: Complete Result ("This is what I have become")

Users are primarily interested in Input (what they provide) and Final Object (what they receive). The Being Class in between is our responsibility as designers. To bridge the gap between intention and result, it is important to understand the temporal metamorphosis of the domain well and design the mechanism of that metamorphosis.

## Completion of Metamorphosis

The Final Object expresses the state of Entelechy (Full Realization). It is a completely realized existence that no longer needs metamorphosis.

It is the completed form reached after the Immanence started from the Input Class met various Transcendence and underwent natural metamorphosis. Here, there is no longer any effort to "try to become" or intention to "try to change". Everything is complete, and the value the user truly sought is realized here. This is the essential value of our system.

This is exactly the destination of programming that Be Framework aims for—an existence that embodies "What It Is" rather than "What To Do".

---

There is not just one way. Learn various paths in [Metamorphosis](./05-metamorphosis-patterns.html) ➡️
