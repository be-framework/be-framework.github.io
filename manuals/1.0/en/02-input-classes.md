---
layout: docs-en
title: "2. Input Classes"
category: Manual
permalink: /manuals/1.0/en/02-input-classes.html
---

# Input Classes

> "We begin from conditions we did not choose, and from there we build our existence."
> 
> —From Heidegger's concept of Geworfenheit (thrownness) in 'Being and Time' (1927)

## The Beginning

Input Classes are the starting point of every transformation in Be Framework.

They contain only what the object itself possesses—no external dependencies. Think of it as the object's identity. These elements exist within the object, forming what we call the object's **Immanent Nature**.

## Basic Structure

```php
#[Be(UserProfile::class)]  // The object's destiny
final readonly class UserInput
{
    public function __construct(
        public string $name,     // Immanent Nature
        public string $email     // Immanent Nature
    ) {}
}
```

## Key Characteristics

**Pure Identity**: Input Classes contain only what the object fundamentally *is*—no external dependencies, no complex logic.

**Metamorphosis Destiny**: The `#[Be()]` attribute declares what this input will become.

**Readonly Properties**: All data is immutable, representing fixed identity that will transform, not mutate.

## Examples

### Simple Data Input
```php
#[Be(OrderCalculation::class)]
final readonly class OrderInput
{
    public function __construct(
        public array $items,        // Immanent Nature
        public string $currency     // Immanent Nature
    ) {}
}
```

### Complex Structured Input
```php
#[Be(PaymentProcessing::class)]
final readonly class PaymentInput
{
    public function __construct(
        public Money $amount,           // Immanent Nature
        public CreditCard $card,        // Immanent Nature
        public Address $billing         // Immanent Nature
    ) {}
}
```

## The Role of Immanent Nature

Input Classes contain only **Immanent Nature** elements. These are the object's own data, independent of external dependencies.

**Transcendent Forces** (powers that the object cannot achieve by itself) are not included here. They appear in Being Classes, which we'll learn about next.

Input Classes represent the starting point of transformation—the object's initial form.

---

Input Classes meet the outside world and begin their transformation. We'll see this process in [Being Classes]({{ '/manuals/1.0/en/03-being-classes.html' | relative_url }}) ➡️
