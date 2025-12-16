---
layout: docs-en
title: "3. Being Classes"
category: Manual
permalink: /manuals/1.0/en/03-being-classes.html
---

# Being Classes

> "The Way constantly does nothing, yet there is nothing it does not do."
>
> —Laozi, 'Tao Te Ching', Chapter 37 (6th Century BC)

## Immanence and Transcendence

Being Classes are where metamorphosis actually happens.

The properties that the object itself possesses (**Immanence**) meet the powers provided from the outside (**Transcendence**), and a new Being is born.

For example, the email address and name (Immanence) held by `UserInput` meet the email validation service or formatter (Transcendence), and a new being called "Validated User Profile" is born. The original data remains unchanged, but through the encounter with the transcendent power of validation that it does not possess, a new existence arises.

If Input Classes are the "Beginning", Being Classes express the "Moment of Change".

## Objects as Temporal Beings

In Be Framework, objects are not treated as static data structures, but as "Life" living in time.

### Lifecycle: Birth, Life, and "Becoming the self you want to be"

1.  **Birth (Constructor)**:
    *   The constructor is where objects are born. Here, Immanence and Transcendence meet, and new Immanence is born.
    *   The moment it is born, the object's identity and state are determined and become Immutable.
2.  **Life (Being)**:
    *   The object exposes its "form as it should be" to the world as `public readonly` properties. But no one touches those properties except its future self.
    *   This state is the crystallization of the encounter between Immanence and Transcendence.
3.  **Becoming the self you want to be**:
    *   All transformations are journeys to become the final "Self you want to be (Final Object)".
    *   The Transcendence encountered influences the new Immanence and disappears. Like a childhood friend, they shape me and become part of me, but as a **temporal being only at that moment**, they are no longer there.
    *   The life of an object in Be Framework exists for this self-realization (Entelechy).

> "Becoming the self you want to be"
> Objects are reborn into the self they want to be, according to their own will (type definition). Code is the story of this "Self-realization".

## Basic Structure

```php
final readonly class UserProfile
{
    public string $displayName;
    public bool $isValid;
    
    public function __construct(
        #[Input] string $name,                    // Immanence
        #[Input] string $email,                   // Immanence
        #[Inject] NameFormatter $formatter,       // Transcendence
        #[Inject] EmailValidator $validator       // Transcendence
    ) {
        $this->displayName = $formatter->format($name);     // New Immanence
        $this->isValid = $validator->validate($email);      // New Immanence
    }
}
```

## Metamorphosis Pattern

All Being Classes follow the same flow of transformation:

Immanence (`#[Input]`) + Transcendence (`#[Inject]`) → New Immanence

It's like cooking. By adding fire and seasoning (Transcendence) to ingredients (Immanence), a dish (New Immanence) is created. Flour alone does not become bread, but with the help of yeast and an oven, it becomes bread. Even if the ingredients are the same, it becomes a completely new existence.

- **Immanent Factor**: What the object inherits from its previous form
- **Transcendent Factor**: External capabilities and context provided by the world
- **New Immanence**: Transformed existence born from this interaction

This pattern is found everywhere in the natural world. A seed (Immanence) meets soil, water, and sun (Transcendence) to become a flower. A student (Immanence) meets a teacher and textbooks (Transcendence) to become an expert. All growth, all learning, all change follows this pattern. Be Framework expresses this universal law of transformation in code.

It is the same in the world of programming. `$cartItems` (Immanence) meets tax calculation service (Transcendence) to become a billing amount. `$zipCode` (Immanence) meets address search API (Transcendence) to become a complete address. `$rawImage` (Immanence) meets image processing engine (Transcendence) to become a thumbnail. Data cannot change on its own. It borrows external power to finally become a new existence.

## Entelechy - Becoming the self you want to be

The constructor is a special place where a new self is born. To become the self it should be, Immanence meets Transcendence given by the world (which it does not possess itself), and the logic of transformation works.

```php
final readonly class OrderCalculation
{
    public Money $subtotal;
    public Money $tax;
    public Money $total;
    
    public function __construct(
        #[Input] array $items,                    // Immanence
        #[Input] string $currency,                // Immanence
        #[Inject] PriceCalculator $calculator,    // Transcendence
        #[Inject] TaxService $taxService          // Transcendence
    ) {
        $this->subtotal = $calculator->calculateSubtotal($items, $currency);
        $this->tax = $taxService->calculateTax($this->subtotal);
        $this->total = $this->subtotal->add($this->tax);     // New Immanence
    }
}
```

1. Properties inherited from the previous class become constructor arguments and meet injected external capabilities.
2. They interact, and transformation logic works.
3. A new existence is born by assigning properties.

Entelechy (entelecheia) is a philosophical concept proposed by Aristotle, meaning "having the end within itself". An acorn is born to become an oak tree, and an egg exists to become a bird. Each holds the "self it wants to be" within.

In Be Framework, this transformation process in the constructor is exactly the realization of Entelechy. `OrderCalculation` wants to become a calculated order. `ValidatedUser` wants to become a validated user. Each class becomes the "self it wants to be" in the constructor. In Be Framework, we think centering on BEING (existence), not DOING (action).

It's the same in life. You read books to become a "person with deep insight", and practice instruments to become a "person who moves hearts with music". Action is the means, and existence is the purpose. Focusing on "What you want to become" rather than "What you do"—Be Framework expresses this way of thinking in code.

## Bridge to Final Object

Being classes often serve as bridges, preparing data for final transformation:

```php
#[Be([SuccessfulOrder::class, FailedOrder::class])]  // Multiple destinies
final readonly class OrderValidation
{
    public bool $isValid;
    public array $errors;
    public SuccessfulOrder|FailedOrder $being;  // Being property
    
    public function __construct(
        #[Input] Money $total,                    // Immanence
        #[Input] CreditCard $card,                // Immanence
        #[Inject] PaymentGateway $gateway         // Transcendence
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

Being classes do not "do" anything. By meeting what they have (Immanence) and power given from outside (Transcendence), they naturally transform into the form they should be. This is the same as Laozi's teaching at the beginning, "The Way constantly does nothing, yet there is nothing it does not do"—everything is accomplished in the natural flow without forcing power. It does not change something else, but changes itself.

---

To the destination of transformation, [Final Objects](./04-final-objects.html) ➡️
