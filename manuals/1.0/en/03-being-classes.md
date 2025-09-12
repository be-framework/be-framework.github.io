---
layout: docs-en
title: "3. Being Classes"
category: Manual
permalink: /manuals/1.0/en/03-being-classes.html
---

# Being Classes

Being Classes are where transformation actually occurs.

The object's own nature (**Immanent Nature**) meets forces provided from the outside (**Transcendent Forces**), and a new being is born. If Input Classes are the "beginning," Being Classes express the "moment of change."

## Basic Structure

```php
final class UserProfile
{
    public readonly string $displayName;
    public readonly bool $isValid;
    
    public function __construct(
        #[Input] string $name,                    // Immanent
        #[Input] string $email,                   // Immanent
        #[Inject] NameFormatter $formatter,       // Transcendent
        #[Inject] EmailValidator $validator       // Transcendent
    ) {
        $this->displayName = $formatter->format($name);     // New Immanent
        $this->isValid = $validator->validate($email);      // New Immanent
    }
}
```

## The Transformation Pattern

Every Being Class follows the same flow of transformation:

**Immanent Nature** (`#[Input]`) + **Transcendent Forces** (`#[Inject]`) → **New Immanent Nature**

- **Immanent factors**: What the object inherits from its previous form
- **Transcendent factors**: External capabilities and context provided by the world
- **New Immanent**: The transformed being that emerges from this interaction

## Entelecheia - Becoming Who You're Meant to Be

The constructor is where a new self is born. To become the intended self, **Immanent Nature** meets **Transcendent Forces** that the self doesn't possess, and transformation logic unfolds.

```php
final class OrderCalculation
{
    public readonly Money $subtotal;
    public readonly Money $tax;
    public readonly Money $total;
    
    public function __construct(
        #[Input] array $items,                    // Immanent
        #[Input] string $currency,                // Immanent
        #[Inject] PriceCalculator $calculator,    // Transcendent
        #[Inject] TaxService $taxService          // Transcendent
    ) {
        $this->subtotal = $calculator->calculateSubtotal($items, $currency);
        $this->tax = $taxService->calculateTax($this->subtotal);
        $this->total = $this->subtotal->add($this->tax);     // New Immanent
    }
}
```

1. Properties inherited from previous classes become constructor arguments and meet injected external capabilities.
2. They interact, and the transformation logic unfolds.
3. Through property assignment, a new being is born.

Entelecheia is a philosophical concept proposed by Aristotle, representing the process by which potentiality transitions to actuality. It's the moment when an object's possibilities are realized through interaction with external forces. In the Be Framework, this transformation process in the constructor is considered the realization of entelecheia.

## Bridging to Final Objects

Being Classes often serve as bridges, preparing data for final transformation:

```php
#[Be([SuccessfulOrder::class, FailedOrder::class])]  // Multiple destinies
final class OrderValidation
{
    public readonly bool $isValid;
    public readonly array $errors;
    public readonly SuccessfulOrder|FailedOrder $being;  // Being Property
    
    public function __construct(
        #[Input] Money $total,                    // Immanent
        #[Input] CreditCard $card,                // Immanent
        #[Inject] PaymentGateway $gateway         // Transcendent
    ) {
        $result = $gateway->validate($card, $total);
        $this->isValid = $result->isValid();
        $this->errors = $result->getErrors();
        
        // Self-determination of destiny
        $this->being = $this->isValid 
            ? new SuccessfulOrder($total, $card)
            : new FailedOrder($this->errors);
    }
}
```

## Natural Flow

Being Classes don't "do" things—they naturally become what they're meant to be through the interaction of their **Immanent Nature** with **Transcendent Forces** provided by the world. This is the principle of wu wei (無為) from Taoist philosophy. They don't change other things; they transform themselves.
