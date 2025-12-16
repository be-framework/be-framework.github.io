---
layout: docs-en
title: "2. Input Classes"
category: Manual
permalink: /manuals/1.0/en/02-input-classes.html
---

# Input Classes

> "We begin from conditions we cannot choose, and build our existence from there."
>
> —From Heidegger's concept of Thrownness (Geworfenheit) ('Being and Time', 1927)

## The Starting Point

Input Classes are the starting point of all transformations in the Be Framework.

This contains only the elements that the object itself possesses, with no external dependencies. It is, so to speak, the identity of the object. Since it is inside the object, we call this **Immanence**.

## Basic Structure

```php
#[Be(UserProfile::class)]  // Destiny of Metamorphosis
final readonly class UserInput
{
    public function __construct(
        public string $name,     // Immanent
        public string $email     // Immanent
    ) {}
}
```

## Key Characteristics

**Pure Identity**: Input Classes contain only *what the object fundamentally is*—no external dependencies or complex logic.

**Destination (Object's Destiny)**: The `#[Be()]` attribute declares what this input will become.

**Read-only Properties**: All data is immutable, representing a fixed identity that transforms rather than mutates.

## Examples

### Simple Data Input
```php
#[Be(OrderCalculation::class)]
final readonly class OrderInput
{
    public function __construct(
        public array $items,        // Immanent
        public string $currency     // Immanent
    ) {}
}
```

### Complex Structured Input
```php
#[Be(PaymentProcessing::class)]
final readonly class PaymentInput
{
    public function __construct(
        public Money $amount,           // Immanent
        public CreditCard $card,        // Immanent
        public Address $billing         // Immanent
    ) {}
}
```

## The Role of Immanence

In Input Classes, everything is **Immanence**. There is no **Transcendence (transcendent power)** here. Transcendence explains powers provided from the outside that cannot be realized by oneself, and they appear later in **Being Classes**.

For example, the `UserInput` class holds only raw data like email address and name. The power to validate if this email is valid, the power to save to the database, the power to send notifications—these are all Transcendence and do not exist in the Input Class. The Input Class simply declares "I am this kind of data".

Input Classes are the starting point of transformation. They represent the first form that meets something beyond itself and changes into something new.

---

The Input Class meets the outside world and begins transformation. We will see that process in [Being Classes](./03-being-classes.html) ➡️
