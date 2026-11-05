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
| `src/Reason/`     | Raison d'être — capabilities an existence requires, gathered into one.    | [Reason Layer](../08-reason-layer.html) |
| `src/Module/`     | Ray.Di modules. `MODULE=<name>` env switches the active module.          | [Ray.Di Manual](https://ray-di.github.io/manuals/1.0/en/index.html) |
| `src/Becoming/`   | Framework wiring — `BecomingInterface` implementations/decorators.        | [Becoming](../04a-becoming.html) |
| `src/Being/`      | Branching — `$being` discriminator + `#[Be([A, B])]`.                     | [Being Classes](../03-being-classes.html) |
| `src/LogContext/` | Semantic-log event classes attached to `Been`.                            | [Semantic Logging](../10-semantic-logging.html) |
| `src/Moment/`     | Moment — holds a Potential from Reason, realized via `be()`.              | [Reason Layer](../08-reason-layer.html) |

## `src/Input/`

```php
#[Be(HelloFinal::class)]
final readonly class HelloInput
{
    public function __construct(
        public string $name,
    ) {}
}
```

An Input is the first domain class, built from data handed in from outside. `#[Be(...)]` declares what it becomes next — one candidate, or several.

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

The terminus of metamorphosis. No `#[Be(...)]`. `#[Input]` is immanence (what came from the previous form); `#[Inject]` is transcendence (services from outside). Evidence of completion is recorded via `#[Inject] Been`.

→ [Final Objects](../04-final-objects.html)

## `src/Semantic/`

```php
final class Email
{
    #[Validate]
    public function validate(string $email): void
    {
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new InvalidEmailException($email);
        }
    }
}
```

The class name becomes the parameter name. `#[Validate]` auto-applies to every argument named `$email`, anywhere in the app — define once, enforced everywhere.

→ [Semantic Variables](../06-semantic-variables.html)

## `src/Exception/`

```php
#[Message([
    'en' => 'Invalid email: {email}',
    'ja' => '不正なメールアドレス: {email}',
])]
final class InvalidEmailException extends \DomainException
{
    public function __construct(public string $email) {}
}
```

`#[Message]` takes one array keyed by language code (`en`, `ja`, …). Placeholders like `{email}` are assigned from the exception's properties at throw time.

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

"What does it take to exist as `ExpressDelivery`?" — `ExpressShipping` is the answer. It gathers the capabilities that existence requires into one class, usable as `#[Inject]` to provide capabilities, or as the type of `$being` to decide the next form.

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

DI bindings swapped via an env var like `MODULE=Dev`. A `DevModule` or `TestModule` substitutes implementations without touching the production `AppModule`.

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

Touched rarely — only when you need to instrument metamorphosis itself (logging, tracing, timing).

→ [Becoming](../04a-becoming.html)

## `src/Being/`

```php
#[Be([ApprovalNotification::class, RejectionNotification::class])]
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

The union-typed `$being` holds a Reason object (`Approved` or `Rejected`), and its type decides which `#[Be([...])]` candidate comes next: `ApprovalNotification` declares `#[Input] Approved $being`, `RejectionNotification` declares `#[Input] Rejected $being`. The framework picks the first candidate whose constructor arguments can be satisfied (see [Matching Rules](../05-metamorphosis.html#matching-rules)).

→ [Being Classes](../03-being-classes.html)

## `src/LogContext/`

```php
final class EmailFormatAssertedContext extends AbstractContext
{
    public const string TYPE = 'email_format_asserted';
    public const string SCHEMA_URL = '../schemas/email-format-asserted.json';

    public function __construct(
        public readonly string $email,
    ) {}
}
```

`TYPE` is the event name that lands in the log; `SCHEMA_URL` links to the schema. Inside a Final, `$been->with(new EmailFormatAssertedContext(...))` records the evidence that the object was established.

→ [Semantic Logging](../10-semantic-logging.html)

## `src/Moment/`

```php
final readonly class PaymentCompleted implements MomentInterface
{
    public PaymentCapture $capture;

    public function __construct(
        #[CardNumber] string $cardNumber,   // DI qualifier attribute
        #[Amount] int $amount,              // DI qualifier attribute
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

A Moment is built by the DI container, not from a previous object, so its values arrive through application-defined qualifier attributes (`#[CardNumber]`, `#[Amount]`) bound in the module. The constructor completes `authorize()` (the Potential), but not `capture()`. Only a Final that could construct *every* Moment then calls `be()` on each — a failed preparation commits nothing. The `be()` calls run in order, so if a later one fails the earlier commits remain; compensating for that is the Reason's job.

→ [Reason Layer](../08-reason-layer.html)

---

Three directories — `Being/`, `LogContext/`, `Moment/` — ship empty. Add classes as the project needs them.
