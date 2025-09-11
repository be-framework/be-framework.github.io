---
layout: docs-en
title: "2. Input Classes"
category: Manual
permalink: /manuals/1.0/en/02-input-classes.html
---

# Input Classes

Input Classes are the starting point of every metamorphosis in Be Framework.

They contain only what the object itself possesses—no external dependencies. Think of it as the object's identity. Since these elements exist within the object, we call this **Immanent** nature.

## Basic Structure

```php
#[Be(UserProfile::class)]  // The object's destiny
final class UserInput
{
    public function __construct(
        public readonly string $name,     // Immanent
        public readonly string $email     // Immanent
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
final class OrderInput
{
    public function __construct(
        public readonly array $items,        // Immanent
        public readonly string $currency     // Immanent
    ) {}
}
```

### Complex Structured Input
```php
#[Be(PaymentProcessing::class)]
final class PaymentInput
{
    public function __construct(
        public readonly Money $amount,           // Immanent
        public readonly CreditCard $card,        // Immanent
        public readonly Address $billing         // Immanent
    ) {}
}
```

## The Role of Immanent

Input Classes contain only **Immanent** elements. These are the object's own data, independent of external dependencies.

**Transcendent** elements (powers that the object cannot achieve by itself) are not included here. They appear in Being Classes, which we'll learn about next.

Input Classes represent the starting point of metamorphosis—the object's initial form.
