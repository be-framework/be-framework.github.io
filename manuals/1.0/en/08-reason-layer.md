---
layout: docs-en
title: "8. Reason Layer"
category: Manual
permalink: /manuals/1.0/en/08-reason-layer.html
---

# Reason Layer

> "Everything that exists has a reason for its existence"
>
> 　　—Leibniz, *Principle of Sufficient Reason* (1714)

## Reason for Existence

`ExpressDelivery` can exist as such because it has express shipping capabilities. `StandardDelivery` can exist as such because it has standard shipping capabilities. This foundation for "why it can be in that existence" is the **raison d'être**.

The Reason Layer is a design pattern that expresses this raison d'être as a single object.

```php
final readonly class ExpressDelivery
{
    public Fee $fee;

    public function __construct(
        #[Input] OrderData $order,             // Immanence
        #[Inject] ExpressShipping $reason      // Reason for existence
    ) {
        $this->fee = $reason->calculateFee($order->weight);
    }
}
```

`ExpressShipping` is the raison d'être of `ExpressDelivery`. It provides the complete tool set needed for express delivery.

## Reason as $being

When a reason object is passed as `$being`, it takes on an additional role. Its **type** serves as the basis for determining the transformation destination, while simultaneously providing the methods specific to that mode of existence.

```php
final readonly class ExpressDelivery
{
    public Fee $fee;

    public function __construct(
        #[Input] OrderData $order,
        #[Input] ExpressShipping $being    // Type determines transformation and provides express-specific methods
    ) {
        $this->fee = $being->calculateFee($order->weight);
    }
}

final readonly class StandardDelivery
{
    public Fee $fee;

    public function __construct(
        #[Input] OrderData $order,
        #[Input] StandardShipping $being   // Type determines transformation and provides standard-specific methods
    ) {
        $this->fee = $being->calculateFee($order->weight);
    }
}
```

The type `ExpressShipping $being` itself is the reason why it becomes `ExpressDelivery`. The framework reads this type and automatically selects the corresponding transformation destination.

Any Reason object can serve as either `#[Inject]` (providing transcendent capabilities) or `$being` (determining destiny). The difference is not in the object itself, but in how it is used. A `JTASProtocol` that evaluates patients as `#[Inject]` in one context could determine destiny as `$being` in another.

## Defining Reason Classes

Reason classes bundle the services necessary to realize a specific mode of existence:

```php
namespace App\Reason;

final readonly class ExpressShipping
{
    public function __construct(
        private PriorityCarrier $carrier,
        private RealTimeTracker $tracker,
    ) {}

    public function calculateFee(Weight $weight): Fee        // Express rate
    {
        return $this->carrier->expressFee($weight);
    }

    public function guaranteeDeliveryBy(Address $address): \DateTimeImmutable  // Guaranteed delivery date
    {
        return $this->carrier->guaranteedDate($address);
    }

    public function realTimeTrack(TrackingId $id): TrackingStatus  // Real-time tracking
    {
        return $this->tracker->realTimeStatus($id);
    }
}
```

```php
final readonly class StandardShipping
{
    public function __construct(
        private RegularCarrier $carrier,
        private BatchTracker $tracker,
    ) {}

    public function calculateFee(Weight $weight): Fee        // Standard rate
    {
        return $this->carrier->standardFee($weight);
    }

    public function estimateDeliveryWindow(Address $address): DateRange  // Estimated delivery window
    {
        return $this->carrier->estimateWindow($address);
    }
}
```

## Difference from Individual Injection

The Reason Layer uses `#[Inject]`. So how does it differ from using multiple `#[Inject]` attributes separately?

**Individual injection**:
```php
public function __construct(
    #[Input] OrderData $order,
    #[Inject] PriorityCarrier $carrier,
    #[Inject] RealTimeTracker $tracker,
    #[Inject] InsuranceService $insurance,
    #[Inject] DeliveryScheduler $scheduler
) {
    // Using scattered tools individually
}
```

**Reason Layer**:
```php
public function __construct(
    #[Input] OrderData $order,
    #[Inject] ExpressShipping $reason    // Related tools bundled as reason for existence
) {
    $this->fee = $reason->calculateFee($order->weight);
}
```

"What is needed to become ExpressDelivery?" — a single reason object answers that question. Objects themselves declare "what to become", while reason objects realize "how to achieve that state".

---

The inability to exist is itself an existence. Learn how to handle this in [Validation and Error Handling](./09-error-handling.html) ➡️
