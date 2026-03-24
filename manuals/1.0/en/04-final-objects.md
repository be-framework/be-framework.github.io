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

For users, only Input and Final Objects are visible. The journey that began with an Input Class arrives as a Final Object—this is the destination of metamorphosis.

## Basic Structure

```php
final readonly class SuccessfulOrder
{
    public string $orderId;
    public string $confirmationCode;
    public DateTimeImmutable $timestamp;
    public string $message;
    public BeenConfirmed $been;          // Evidence of completion

    public function __construct(
        #[Input] Money $total,                    // Immanence
        #[Input] CreditCard $card,                // Immanence
        #[Inject] OrderIdGenerator $generator,    // Transcendence
        #[Inject] Receipt $receipt                // Transcendence
    ) {
        $this->orderId = $generator->generate();
        $this->confirmationCode = $receipt->generate($total);
        $this->timestamp = new DateTimeImmutable();
        $this->message = "Order Confirmed: {$this->orderId}";

        $this->been = new BeenConfirmed(
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

The `$been` class is application-defined with a domain-specific name. `SuccessfulOrder` has `BeenConfirmed`, `FailedOrder` has `BeenRejected`, a `DeletedUser` might have `BeenDeleted`. What counts as "evidence of completion" depends on the domain—you design the class to capture whatever your domain requires as proof.

In contrast to Input Classes, Final Objects fully express the richness of the domain. Immanence has met Transcendence, undergone transformation, and reached a complete state that requires no further change.

## Completeness of Temporal Being

In Be Framework, we capture the temporal existence of objects on two axes:

- **`#[Be]`**: The self you want to become, the destination (Direction towards the future)
- **`$been`**: The self that has completed (Evidence of past perfect)

Essential values like `$orderId` and `$confirmationCode` are public properties. `$been` is different—it records the evidence of completion: who, when, and on what basis the process completed.

## Completeness from Within

In traditional programming, external tests judge whether an object has been processed correctly. But a Final Object holds what it is as its own structure. What was input, what happened, and what it became—all contained within a single existence, serving as evidence of completion.

## Comparison with Input Classes

| Input Class | Final Object |
|-----------|-----------------|
| Starting Point of Metamorphosis | Destination of Metamorphosis |
| What User Provides | What User Receives |
| Simple Structure | Rich and Complete State |

## Multiple Final Destinies

Objects can have multiple possible final forms determined by their nature. Here `$becoming` triggers the metamorphosis chain—this mechanism is explained in the [next chapter](./04a-becoming.html):

```php
$order = $becoming(new OrderInput($items, $card));

if ($order instanceof SuccessfulOrder) {
    echo $order->confirmationCode;
} else {
    echo $order->message;  // Error message
}
```

## The Designer's Work

Designing the mechanism of transformation between Input and Final Object—that is the designer's responsibility. Users touch only the two ends, but the Being Classes in between form the backbone of the system.

The Final Object knows that it is complete, from within.

---

How does declared metamorphosis come to life? On to [Becoming](./04a-becoming.html) ➡️
