---
layout: docs-en
title: "Semantic Logging"
category: Manual
permalink: /manuals/1.0/en/10-semantic-logging.html
---

# Semantic Logging

> "What we record becomes memory; what we remember becomes truth"
>
> —Adapted from Orwell's concept in *1984* (1949)

## Overview

Traditional logs:

```
[INFO] User registered: alice@example.com
[INFO] Verification passed
[INFO] Insert into users table
```

Semantic logs:

```json
{
  "open": { "from": "UnverifiedEmail", "to": "RegisteredUser" },
  "events": [
    { "type": "email_format_asserted", "context": { "email": "alice@example.com" } },
    { "type": "user_inserted", "context": { "userId": 42, "email": "alice@example.com" } }
  ],
  "close": { "properties": { "userId": 42, "value": "alice@example.com" } }
}
```

Traditional logs are just lines of text arranged chronologically — the reader is left to guess which lines belong to the same operation.

With semantic logging, one metamorphosis fits in one JSON. Source and destination, intermediate events, final properties — "what became what, and why" is recorded as typed, structured data and can be validated with JSON Schema.

Be Framework provides two semantic recording mechanisms:

- **`$been`** — Proof that the Final object carries its own history (proof)
- **`SemanticLoggerInterface`** — A log that records hierarchical operations (log)

|              | log                    | `$been`                     |
|--------------|------------------------|-----------------------------|
| Nature       | descriptive            | constitutive                |
| Perspective  | third-person (observer)| first-person                |
| Question     | What happened?         | Why am I what I am now?     |
| Grammar      | doing                  | being                       |
| Role         | record                 | proof                       |

## `$been` — Proof of Existence

Inject `Been` into the Final object's constructor and record events with `with()`. This becomes proof of why the object is in its current state.

```php
final class RegisteredUser
{
    public readonly int $userId;
    public readonly Been $been;

    public function __construct(
        #[Input] string $value,
        #[Inject] EmailVerifier $verifier,
        #[Inject] UserRepository $users,
        #[Inject] Been $been,
    ) {
        if (! $verifier->check($value)) {
            throw new UnbecomingException('email format failed');
        }

        $this->userId = $users->insert(['email' => $value]);
        $this->been = $been
            ->with(new EmailFormatAssertedContext(
                email: $value,
            ))
            ->with(new UserInsertedContext(
                userId: $this->userId,
                email: $value,
            ));
    }
}
```

`Been` is received from the DI container via `#[Inject]`. The received `Been` already contains the source and destination information recorded by the framework at the start of metamorphosis. The developer appends events that only the Final object's internals can know — email was verified, user was inserted — using `with()`.

## Event Context

Events passed to `Been` are subclasses of `AbstractContext`.

```php
final class EmailFormatAssertedContext extends AbstractContext
{
    public const string TYPE = 'email_format_asserted';
    public const string SCHEMA_URL = 'https://myvendor.example.com/schemas/email-format-asserted.json';

    public function __construct(
        public readonly string $email,
    ) {}
}
```

`TYPE` is the event type in the log, and `SCHEMA_URL` points to the JSON Schema for that event. Constructor properties become the JSON `context` field as-is.

These are domain events in DDD terms — objects representing "what happened" in business terms. Define the facts that the Final object experienced on its way to completion as application-specific event contexts.

## SemanticLogger — Hierarchical Operation Recording

When hierarchical operation recording is needed, inject `SemanticLoggerInterface` directly.

```php
final class RegisteredUser
{
    public function __construct(
        #[Input] string $value,
        #[Inject] UserRepository $users,
        #[Inject] SemanticLoggerInterface $logger,
    ) {
        // Declare intent (open)
        $id = $logger->open(new DbTransactionContext(table: 'users'));

        // Record intermediate events (event)
        $this->userId = $users->insert(['email' => $value]);
        $logger->event(new RowInsertedContext(userId: $this->userId));

        // Record result (close)
        $logger->close(new TransactionResultContext(committed: true), $id);
    }
}
```

open/event/close uses the hierarchical structure of [Koriym.SemanticLogger](https://github.com/koriym/Koriym.SemanticLogger) directly. Intent → occurrences → result — these three layers record a cohesive operation.

`$been` is proof of what the Final object is. `SemanticLoggerInterface` is a detailed record of intermediate steps, closer to traditional logging. Usually `$been` is sufficient.

## Automatic Metamorphosis Recording

Separate from `$been` and `SemanticLoggerInterface`, the framework automatically records the metamorphosis itself with open/close. Developers do not need to write this recording code.

Here is the full JSON output:

```json
{
  "open": {
    "type": "metamorphosis_open",
    "context": {
      "fromClass": "MyVendor\\MyApp\\UnverifiedEmail",
      "beAttribute": "#[Be(RegisteredUser::class)]",
      "immanentSources": {
        "value": "MyVendor\\MyApp\\UnverifiedEmail::value"
      },
      "transcendentSources": {
        "verifier": "MyVendor\\MyApp\\EmailVerifier",
        "users": "MyVendor\\MyApp\\UserRepository",
        "been": "Be\\Framework\\SemanticLog\\Been"
      }
    }
  },
  "events": [
    {
      "type": "email_format_asserted",
      "context": { "email": "alice@example.com" }
    },
    {
      "type": "user_inserted",
      "context": { "userId": 42, "email": "alice@example.com" }
    }
  ],
  "close": {
    "type": "metamorphosis_close",
    "context": {
      "properties": { "userId": 42, "value": "alice@example.com" },
      "be": { "finalClass": "MyVendor\\MyApp\\RegisteredUser" }
    }
  }
}
```

open records the intent of metamorphosis (what to what, with which materials), events record the occurrences from `$been->with()`, and close records the result (final properties and destination).

## From Logs to DSL

Traditional logs are records of execution. They are born after code runs, used for debugging, and eventually discarded.

This JSON is different. It is simultaneously a record of execution, a specification of metamorphosis, and a proof of existence. Where it came from, what it became, what it is. "`UnverifiedEmail` becomes `RegisteredUser` through `email_format_asserted` and `user_inserted`" — this reads as both a description of past fact and a declaration of future expectation. Moreover, as typed structured data, it functions as a DSL that AI can read and write.

Record, specification, proof, DSL. When these four converge in the same JSON, rigorous validation on par with tests through JSON Schema, and a cycle of generating code from logs and logs from code, become possible.

---

Technical foundation: [Koriym.SemanticLogger](https://github.com/koriym/Koriym.SemanticLogger)

For the full framework overview, see [Reference](./11-reference-resources.html) ➡️
