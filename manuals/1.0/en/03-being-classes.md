---
layout: docs-en
title: "3. Being Classes"
category: Manual
permalink: /manuals/1.0/en/03-being-classes.html
---

# Being Classes

> "The Tao does nothing, yet nothing is left undone."
> 
> —Laozi, Tao Te Ching, Chapter 37 (6th century BC)

## Immanence Meets Transcendence

Being Classes are where transformation actually occurs.

The object's own nature (**Immanent Nature**) meets forces provided from the outside (**Transcendent Forces**), and a new being is born.

For example, a `UserInput` with email and name (immanence) meets an email validation service and formatter (transcendence), creating a "validated user profile" as a new being. The original data remains immutable; by meeting validation—a transcendent force the object doesn't possess—a new being emerges.

If Input Classes are the "beginning," Being Classes express the "moment of change."

## Basic Structure

```php
final readonly class UserProfile
{
    public string $displayName;
    public bool $isValid;
    
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

It's like cooking. Ingredients (immanent nature) combined with fire and seasoning (transcendent forces) create a dish (new immanent nature). Flour alone isn't bread; with yeast and an oven's power, it becomes bread. The ingredients persist, yet their form becomes something new.

- **Immanent factors**: What the object inherits from its previous form
- **Transcendent factors**: External capabilities and context provided by the world
- **New Immanent**: The transformed being that emerges from this interaction

This pattern appears everywhere in nature. A seed (immanent) meets soil, water, and sunlight (transcendent) to become a flower. A student (immanent) meets teachers and materials (transcendent) to become an expert. All growth, all learning, all change follows this pattern. The Be Framework expresses this universal law of transformation in code.

The programming world is the same. `$cartItems` (immanent) meets tax calculation services (transcendent) to become billing amounts. `$zipCode` (immanent) meets address lookup APIs (transcendent) to become complete addresses. `$rawImage` (immanent) meets image processing engines (transcendent) to become thumbnails. Data cannot change by itself. Only by borrowing external forces can it become something new.

## Entelecheia - Becoming Who You're Meant to Be

The constructor is where a new self is born. To become the intended self, **Immanent Nature** meets **Transcendent Forces** that the self doesn't possess, and transformation logic unfolds.

```php
final readonly class OrderCalculation
{
    public Money $subtotal;
    public Money $tax;
    public Money $total;
    
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

Entelecheia (ἐντελέχεια) is a philosophical concept proposed by Aristotle, meaning "having purpose within." An acorn is born to become an oak tree, an egg exists to become a bird. Each harbors its "intended self" within. The egg as potentiality becomes the bird as actuality. In other words, the egg exists for the entelecheia of becoming a bird.

The Be Framework is the same. This constructor transformation process is precisely the realization of entelecheia. `OrderCalculation` wants to become a calculated order. `ValidatedUser` wants to become a verified user. Each class becomes its "intended self" through the constructor. The Be Framework focuses not on actions (DOING) but on being (BEING). Actions are not the purpose—they are the means to become the intended being.

Life is the same. Reading books is to become "a person with deep insight," practicing instruments is to become "a person who moves hearts through music." Actions are means; being is the purpose. Focusing not on "what to do" but "what to become"—the Be Framework expresses this way of thinking in code.

## Bridging to Final Objects

Being Classes often serve as bridges, preparing data for final transformation:

```php
#[Be([SuccessfulOrder::class, FailedOrder::class])]  // Multiple destinies
final readonly class OrderValidation
{
    public bool $isValid;
    public array $errors;
    public SuccessfulOrder|FailedOrder $being;  // Being Property
    
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

Being Classes don't "do" things. What they possess (immanence) meets forces given from outside (transcendence), naturally transforming into what they should be. This is the same as Laozi's teaching at the beginning: "The Tao does nothing, yet nothing is left undone"—without forcing, everything is accomplished in the natural flow. They don't change other things; they transform themselves.

---

Where transformation leads, to [Final Objects](./04-final-objects.html) ➡️
