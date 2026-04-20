---
layout: docs-en
title: "Be Framework Directory Layout"
category: Convention
permalink: /manuals/1.0/en/convention/directory-layout.html
---

# Be Framework Directory Layout

> "The facts in logical space are the world."
>
> —Ludwig Wittgenstein (*Tractatus Logico-Philosophicus*, 1.13, 1921)

## Source map

| dir | role | manual |
|---|---|---|
| `src/Input/`      | Pipeline entry. Declares `#[Be(...)]`.                                   | [Input Classes](../02-input-classes.html) |
| `src/Final/`      | Terminus. `#[Input]` data + `#[Inject]` services.                        | [Final Objects](../04-final-objects.html) |
| `src/Semantic/`   | Semantic variables. Class name = parameter name.                         | [Semantic Variables](../06-semantic-variables.html) |
| `src/Exception/`  | Semantic-validation exceptions with `#[Message]` for i18n.               | [Error Handling](../09-error-handling.html) |
| `src/Reason/`     | Raison d'être — related services bundled as one mode of existence.        | [Reason Layer](../08-reason-layer.html) |
| `src/Module/`     | Ray.Di modules. `MODULE=<name>` env switches the active module.          | [Ray.Di Manual](https://ray-di.github.io/manuals/1.0/en/index.html) |
| `src/Becoming/`   | Framework wiring — `BecomingInterface` implementations/decorators.        | [Becoming](../04a-becoming.html) |
| `src/Being/`      | Branching — `$being` discriminator + `#[Be([A, B])]`.                     | [Being Classes](../03-being-classes.html) |
| `src/LogContext/` | Semantic-log event classes attached to `Been`.                            | [Semantic Logging](../10-semantic-logging.html) |
| `src/Moment/`     | Moment — holds a Potential from Reason, realized via `be()`.              | [Metamorphosis Patterns](../05-metamorphosis-patterns.html) |

## `src/Input/`

```php
#[Be(HelloFinal::class)]
final readonly class HelloInput
{
    public function __construct(
        #[Input] public string $name,
    ) {}
}
```

An Input carries not just data but the declaration of what it becomes. `#[Be(...)]` is the hand-off to the next form.

→ [Input Classes](../02-input-classes.html)

## `src/Final/`

```php
final readonly class HelloFinal
{
    public string $message;

    public function __construct(
        #[Input] string $name,
        #[Inject] Greeting $greeting,
    ) {
        $this->message = $greeting->say($name);
    }
}
```

No `#[Be(...)]` — this is the terminus. `#[Input]` is immanence (what came from the previous form); `#[Inject]` is transcendence (services from outside). Evidence of completion is recorded via `#[Inject] Been`.

→ [Final Objects](../04-final-objects.html)

## `src/Semantic/`

```php
final class Email
{
    #[Validate]
    public function validate(string $email): void
    {
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new InvalidEmailException();
        }
    }
}
```

Class name *is* the parameter name. `#[Validate]` auto-applies to every argument named `$email`, anywhere in the app — define once, enforced everywhere.

→ [Semantic Variables](../06-semantic-variables.html)

## `src/Exception/`

```php
#[Message(
    en: 'Invalid email: {email}',
    ja: '不正なメールアドレス: {email}',
)]
final class InvalidEmailException extends \DomainException {}
```

`#[Message]` `en`/`ja` are the unit of i18n. Placeholders like `{email}` are filled from the exception's properties at throw time.

→ [Error Handling](../09-error-handling.html)

## `src/Reason/`

```php
final readonly class ExpressShipping
{
    public function __construct(
        private PriorityCarrier $carrier,
        private RealTimeTracker $tracker,
    ) {}

    public function calculateFee(Weight $weight): Fee
    {
        return $this->carrier->expressFee($weight);
    }
}
```

One object answers "what's needed to exist as `ExpressDelivery`?" — carrier + tracker bundled together. Used as `#[Inject]` to provide capabilities, or as `$being` to let the type decide the next form.

→ [Reason Layer](../08-reason-layer.html)

## `src/Module/`

```php
final class AppModule extends AbstractModule
{
    protected function configure(): void
    {
        $this->bind(PriorityCarrier::class)->to(FedExPriority::class);
        $this->bind(RealTimeTracker::class)->to(FedExTracker::class);
    }
}
```

Swapped via `MODULE=Dev` (or similar env). An alternate module can use `override` to substitute implementations without touching production wiring.

→ [Ray.Di Manual](https://ray-di.github.io/manuals/1.0/en/index.html)

## `src/Becoming/`

```php
final readonly class LoggingBecoming implements BecomingInterface
{
    public function __construct(
        private Becoming $inner,
        private LoggerInterface $logger,
    ) {}

    public function __invoke(object $input): object
    {
        $this->logger->info('becoming', ['input' => $input::class]);
        return ($this->inner)($input);
    }
}
```

Touched rarely — only when you need to instrument metamorphosis itself (logging, tracing, timing). Everyday domain code never lands here.

→ [Becoming](../04a-becoming.html)

## `src/Being/`

```php
#[Be([Approved::class, Rejected::class])]
final readonly class ApplicationReview
{
    public Approved|Rejected $being;

    public function __construct(
        #[Input] LoanApplication $app,
        #[Inject] CreditCheck $check,
    ) {
        $this->being = $check->evaluate($app);
    }
}
```

The runtime type of `$being` picks which `#[Be([...])]` candidate comes next. The name can be anything — only the union type matters — but `$being` signals "branching point" at a glance.

→ [Being Classes](../03-being-classes.html)

## `src/LogContext/`

```php
final class EmailFormatAssertedContext extends AbstractContext
{
    public const string TYPE = 'email_format_asserted';
    public const string SCHEMA_URL = 'https://example.com/schemas/email-format-asserted.json';

    public function __construct(
        public readonly string $email,
    ) {}
}
```

`TYPE` is the event name that lands in the log; `SCHEMA_URL` links to the external schema. Attached via `$been->with(new EmailFormatAssertedContext(...))` inside a Final.

→ [Semantic Logging](../10-semantic-logging.html)

## `src/Moment/`

```php
final readonly class PaymentCompleted implements MomentInterface
{
    public PaymentCapture $capture;

    public function __construct(
        #[Input] string $cardNumber,
        #[Input] int $amount,
        #[Inject] PaymentGateway $gateway,
    ) {
        $this->capture = $gateway->authorize($cardNumber, $amount);
    }

    public function be(): void
    {
        $this->capture->be();
    }
}
```

The constructor completes `authorize()` (the Potential), but not `capture()`. Only a Final that could construct *every* Moment then calls `be()` on each — so partial commits never happen.

→ [Metamorphosis Patterns](../05-metamorphosis-patterns.html)

---

Three directories — `Being/`, `LogContext/`, `Moment/` — ship empty. The skeleton's default is a linear `Input → Final` pipeline; branching, semantic logging, and the Diamond pattern are opt-in. Leaving them empty keeps static analysis and coverage clean until the project needs them.
