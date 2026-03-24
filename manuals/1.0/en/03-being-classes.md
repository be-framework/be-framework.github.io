---
layout: docs-en
title: "Being Classes"
category: Manual
permalink: /manuals/1.0/en/03-being-classes.html
---

# Being Classes

> "The Way constantly does nothing, yet there is nothing it does not do."
>
> —Laozi, 'Tao Te Ching', Chapter 37 (6th Century BC)

## Immanence and Transcendence

If Input Classes are the "Beginning", Being Classes express the "Transformed Being".

The public properties of the Input Class are inherited by the Being Class constructor. These inherited values are called **Immanence**—they preserve identity through transformation. In the constructor, external powers—**Transcendence**—are injected and transform the Immanence.

## Basic Structure

```php
final readonly class ValidatedUser
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

`#[Input]` parameters automatically receive values from the previous class's public properties by matching names. `UserInput`'s `public string $name` maps to `ValidatedUser`'s `#[Input] string $name`. `#[Inject]` parameters receive external dependencies from the DI container. The detailed rules of this automatic matching are explained in [Chapter 5: Metamorphosis](./05-metamorphosis-patterns.html).

## Objects as Temporal Beings

In Be Framework, objects are not treated as static data structures, but as temporal beings that exist only within a specific moment in time.

### Birth (Constructor)

The constructor is where objects are born. All Being Classes follow the same flow of transformation:

**Immanence** (`#[Input]`) + **Transcendence** (`#[Inject]`) → **New Immanence**

Immanence meets Transcendence, the logic of transformation takes effect, and new Immanence is born through property assignment. The moment it is born, the object's identity and state are determined and become Immutable.

### Life (Being)

The object exposes its "form as it should be" to the world as `public readonly` properties. The framework reads these properties and passes them as `#[Input]` to the next class in the chain. The object then vanishes, making way for the next.

### Becoming the Self You Want to Be

All transformations are journeys to become the final "self you want to be, the self you are meant to be (Final Object)".

The Transcendence encountered influences the new Immanence and disappears. Like a childhood friend, they shape me and become part of me, but as a temporal being only at that moment, they are no longer there.

## Example of Transformation

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

`OrderCalculation` wants to become a calculated order. `ValidatedUser` wants to become a validated user. Each class becomes the "self it wants to be" in the constructor. In Be Framework, we think centering on BEING (existence), not DOING (action).

## Reflection on Transformation

Immanence alone cannot change. No matter how rich the data, it cannot become a new existence by its own power. Transformation always requires an encounter with Transcendence—a power outside itself. And the Transcendence that was encountered changes the Immanence and then disappears. This pattern of "meeting, changing, and vanishing" is not limited to code. Flour meets yeast and heat to become bread; grapes meet yeast and time to become wine; a seed meets soil, water, and light to become a flower. Transformation in every domain follows this pattern.

## Natural Flow

Being classes do not "do" anything. By the meeting of what they have (Immanence) and powers given from outside (Transcendence), they naturally transform into the form they should be. Nothing orchestrates this flow. Each object is simply passed to the next.

---

To the destination of transformation, [Final Objects](./04-final-objects.html) ➡️
