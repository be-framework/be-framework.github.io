---
layout: docs-en
title: "5. Becoming"
category: Manual
permalink: /manuals/1.0/en/04a-becoming.html
---

# Becoming

> "Being passes into nothing, and nothing passes into being. This movement is becoming."
>
> —G.W.F. Hegel, Science of Logic (1812)

## Triggering Metamorphosis

In chapters 2–4, we saw the structure of input classes, being classes, and final objects. The `#[Be()]` attribute declares "what to become," but declaration alone does nothing. `Becoming` sets that declaration in motion:

```php
$finalObject = $becoming(new EmailInput($name, $email));
```

`EmailInput` → `EmailValidation` → `UserCreation` → `WelcomeMessage`. The chain executes automatically, following each class's `#[Be()]` declaration. Each object is born, handed over to the next existence, and ceases to be. Being becomes nothing, and from that nothing the next being emerges—this movement continues until the chain reaches its end.

## Obtaining Becoming

`Becoming` is injected from the DI container:

```php
final readonly class UserRegistrationPage
{
    public function __construct(
        private BecomingInterface $becoming
    ) {}

    public function __invoke(string $name, string $email): WelcomeMessage
    {
        return ($this->becoming)(new EmailInput($name, $email));
    }
}
```

The caller only knows what goes in and what comes out. The metamorphosis in between is determined by `#[Be()]` declarations.

## Nested Becoming

By using `Becoming` within a being class, one becoming can contain another:

```php
final readonly class OrderProcessing
{
    public PaymentResult $payment;
    public ShippingResult $shipping;

    public function __construct(
        #[Input] Order $order,                    // Immanence
        #[Inject] Becoming $becoming              // Transcendence
    ) {
        $this->payment = $becoming(new PaymentInput($order->getPayment()));
        $this->shipping = $becoming(new ShippingInput($order->getAddress()));
    }
}
```

Since `Becoming` is injected as transcendence, metamorphosis chains can be triggered from within being classes as well. A diamond pattern that converges branched results into a single object is also possible.

---

There is not just one way. Learn various paths in [Metamorphosis](./05-metamorphosis.html) ➡️
