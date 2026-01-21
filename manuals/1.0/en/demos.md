---
layout: docs-en
title: "Demos"
category: Manual
permalink: /manuals/1.0/en/demos.html
---

# Demos

Working examples demonstrating Be Framework concepts in action.

## Hello World Demo

The simplest transformation. An Input with a name becomes a Final with a greeting.

```text
HelloInput  →  Hello
(name)         (greeting)
```

### Input (Potentiality)

```php
#[Be([Hello::class])]
final readonly class HelloInput
{
    public function __construct(
        public string $name,
    ) {}
}
```

The `#[Be]` attribute declares what this Input *can become*.

### Final (Actuality)

```php
final readonly class Hello
{
    public string $greeting;

    public function __construct(
        #[Input] string $name,        // From HelloInput
        #[Inject] Greeting $greeting, // From DI container
    ) {
        $this->greeting = "{$greeting->greeting} {$name}";
    }
}
```

### Reason (Raison d'être)

```php
final class Greeting
{
    public string $greeting = 'Hello';
}
```

The name becomes a greeting by borrowing the external force of Reason. Here, Greeting provides 'Hello'.

### Usage

```php
$input = new HelloInput(name: 'World');
$final = ($becoming)($input);

echo $final->greeting; // "Hello World"
```

### Links

- [Source Code](https://github.com/be-framework/demos/tree/1.x/demos/hello-world)

---

## Order Processing Demo

The Order Processing demo showcases the **Diamond Metamorphosis** pattern - where multiple parallel pipelines converge into a single Final state.

```text
                OrderInput
                    │
        ┌───────────┼───────────┐
        ↓           ↓           ↓
   [inventory]  [payment]  [shipping]
        ↓           ↓           ↓
   InventoryReserved PaymentCompleted ShippingArranged
        │           │           │
        └───────────┼───────────┘
                    ↓
              OrderConfirmed
```

### Key Concepts Demonstrated

#### Moment (契機)

> **Note**: Moment is an evolving concept. The ideas presented here represent our current understanding and may be refined based on practical experience and feedback.

A Moment has three aspects:

- **Dynamis (δύναμις)** - Realizable potential, becomes actuality through `be()`
- **Essential Aspect** - An indispensable element constituting the whole
- **Part of Self** - Not external, but an inner part of Final

```php
final readonly class PaymentCompleted implements MomentInterface
{
    public PaymentCapture $capture;

    public function __construct(
        #[CardNumber] public string $cardNumber,
        #[Amount] public int $amount,
        #[Inject] PaymentGatewayInterface $gateway,
    ) {
        $this->capture = $gateway->authorize($cardNumber, $amount);
    }

    public function be(): void
    {
        $this->capture->be();  // Realize the potential
    }
}
```

#### Reason (存在理由)

Reason is **where immanence meets transcendence** - the stateless gateway connecting internal data to external systems or domain rules.

```php
final class PaymentGateway implements PaymentGatewayInterface
{
    public function authorize(string $cardNumber, int $amount): PaymentCapture
    {
        $authCode = $this->api->authorize($cardNumber, $amount);

        return new PaymentCapture(
            $authCode,
            $amount,
            fn () => $this->capture($authCode, $amount),
        );
    }
}
```

#### Final (ἐνέργεια)

The convergence point where all Moments are realized through self-completion:

```php
final readonly class OrderConfirmed
{
    public function __construct(
        #[Inject] public InventoryReserved $inventory,
        #[Inject] public PaymentCompleted $payment,
        #[Inject] public ShippingArranged $shipping,
    ) {
        // Self-completion: realize all parts
        $this->inventory->be();
        $this->payment->be();
        $this->shipping->be();
    }
}
```

### Philosophical Foundations

| Directory | Concept | Philosopher | Meaning |
|-----------|---------|-------------|---------|
| `Input/` | δύναμις | Aristotle | Potentiality |
| `Being/` | Dasein | Heidegger | Being-in-becoming |
| `Moment/` | Moment | Hegel | Essential aspect of whole |
| `Final/` | ἐνέργεια | Aristotle | Actuality |
| `Semantic/` | Sinn | Frege | Meaning with power |
| `Reason/` | Sufficient Reason | Leibniz | Raison d'être |

### Links

- [Demo Site](https://be-framework.github.io/demos/) - Interactive ALPS state diagram
- [Source Code](https://github.com/be-framework/demos/tree/1.x/demos/order-processing) - Full implementation
- [ALPS Profile](https://be-framework.github.io/demos/alps.html) - Semantic ontology

---

*"Be, Don't Do"*