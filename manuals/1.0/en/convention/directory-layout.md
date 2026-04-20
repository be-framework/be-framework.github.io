---
layout: docs-en
title: "Be Framework Directory Layout"
category: Convention
permalink: /manuals/1.0/en/convention/directory-layout.html
---

# Be Framework Directory Layout

> Ten `src/<dir>/` slots, each with a single responsibility

Every Be Framework application uses the same set of `src/<dir>/` slots. Some are mandatory from day one; others stay empty until the pattern that needs them appears. The [skeleton](https://github.com/be-framework/skeleton) ships them all so you can drop code into the right place without guessing.

## Source map

| dir | role | manual |
|---|---|---|
| `src/Input/`      | Pipeline entry. Declares `#[Be([Target::class])]`.                                  | [Input Classes](../02-input-classes.html) |
| `src/Final/`      | Terminus. Receives `#[Input]` data + `#[Inject]` services.                          | [Final Objects](../04-final-objects.html) |
| `src/Semantic/`   | Semantic variables (validators). Class name = parameter name (camelCase).           | [Semantic Variables](../06-semantic-variables.html) |
| `src/Exception/`  | Semantic-validation exceptions with `#[Message]` for i18n.                          | [Error Handling](../09-error-handling.html) |
| `src/Reason/`     | "What makes existence possible" — Entity, Media (Command/Query), policies, guards.  | [Reason Layer](../08-reason-layer.html) |
| `src/Module/`     | Ray.Di modules. `MODULE=<name>` env switches the active module.                     | (skeleton-specific) |
| `src/Becoming/`   | Framework wiring layer. Not user code.                                              | [Becoming](../04a-becoming.html) |
| `src/Being/`      | *(empty)* Branching intermediate with `$being` discriminator + `#[Be([FinalA, ...])]`. | [Being Classes](../03-being-classes.html) |
| `src/LogContext/` | *(empty)* Semantic-log event classes attached to `Been`.                            | [Semantic Logging](../10-semantic-logging.html) |
| `src/Moment/`     | *(empty)* Diamond parts — `implements MomentInterface`, `be()` realizes potential.  | [Metamorphosis Patterns](../05-metamorphosis-patterns.html) |

## Per-directory reference

### `src/Input/`

**Role**: The starting point of every metamorphosis pipeline.
**Put here**: Final-readonly classes named `<Domain>Input` that declare `#[Be([Target::class])]` to nominate their next form.
**Don't put here**: Validation, services, or business logic — Input is pure data + a forward-looking declaration.
**Skeleton example**: `HelloInput.php`
**Deep dive**: [Input Classes](../02-input-classes.html)

### `src/Final/`

**Role**: The terminus of a pipeline — the form an Input becomes.
**Put here**: Final-readonly classes that take `#[Input]` data + `#[Inject]` services in the constructor and freeze the resulting state.
**Don't put here**: `#[Be(...)]` declarations — once you reach Final, the pipeline ends.
**Skeleton example**: `HelloFinal.php`
**Deep dive**: [Final Objects](../04-final-objects.html)

### `src/Semantic/`

**Role**: Type-level meaning for parameters. The class name *is* the parameter name.
**Put here**: Validator classes (e.g. `EmailAddress`, `CustomerId`) whose constructor enforces the constraint and throws on violation.
**Don't put here**: Generic value objects — Semantic variables are anchored to a specific parameter name.
**Skeleton example**: `Name.php`
**Deep dive**: [Semantic Variables](../06-semantic-variables.html)

### `src/Exception/`

**Role**: Semantic-validation failures with i18n-ready messages.
**Put here**: Exception classes annotated with `#[Message(en: "...", ja: "...")]` and thrown from `src/Semantic/` constructors.
**Don't put here**: General runtime errors — those are framework concerns, not domain semantics.
**Skeleton example**: `InvalidNameException.php`
**Deep dive**: [Error Handling](../09-error-handling.html)

### `src/Reason/`

**Role**: "What makes existence possible." Houses Entities, Media (Command/Query interfaces via Ray.MediaQuery), policies, and guards.
**Put here**: Repository interfaces, Ray.MediaQuery interfaces, policy classes, and the entities they read or write.
**Don't put here**: Concrete service implementations belong in modules — Reason holds the contracts and rules.
**Skeleton example**: `Hello/HelloEntity.php`, `Hello/SayHelloInterface.php`
**Deep dive**: [Reason Layer](../08-reason-layer.html)

### `src/Module/`

**Role**: Dependency wiring. Each module is a Ray.Di module class.
**Put here**: `AppModule` (production wiring) plus alternates like `DevModule`, `TestModule`. The `MODULE=<name>` env var picks one.
**Don't put here**: Application logic — modules only bind interfaces to implementations.
**Skeleton example**: `AppModule.php`, `DevModule.php`
**Deep dive**: skeleton-specific (see the skeleton's `CLAUDE.md`).

### `src/Becoming/`

**Role**: Framework wiring layer — adapters around `Becoming` itself.
**Put here**: Decorators or alternate `BecomingInterface` implementations (e.g. one that writes a semantic log on every run).
**Don't put here**: Application code. If it isn't about how the framework runs, it doesn't go here.
**Skeleton example**: `DevBecoming.php`
**Deep dive**: [Becoming](../04a-becoming.html)

### `src/Being/` *(empty by default)*

**Role**: Branching intermediates. A class that holds a `$being` discriminator and declares `#[Be([FinalA::class, FinalB::class])]` so the framework picks the next form at runtime.
**Put here**: One file per branching point — `<Domain>Being.php` returning a union type for `$being`.
**Don't put here**: Linear pipelines — those go straight from Input to Final without an intermediate.
**Skeleton example**: *(empty by default)*
**Deep dive**: [Being Classes](../03-being-classes.html)

### `src/LogContext/` *(empty by default)*

**Role**: Semantic-log event classes that attach to `Been` to describe what happened in the pipeline.
**Put here**: `AbstractContext` subclasses named after the event (e.g. `OrderFinalizedContext`).
**Don't put here**: Plain DTOs — these classes are read by `koriym/semantic-logger` and rendered into the tree.
**Skeleton example**: *(empty by default)*
**Deep dive**: [Semantic Logging](../10-semantic-logging.html)

### `src/Moment/` *(empty by default)*

**Role**: Diamond-pattern parts. A `MomentInterface` implementation that holds a *potential* and realizes it via `be()`.
**Put here**: Classes named after the moment they capture (`PaymentCapture`, `InventoryReservation`) with a `realize` callable wired in by the surrounding pipeline.
**Don't put here**: One-shot operations — Moments are for the diamond convergence pattern, not linear steps.
**Skeleton example**: *(empty by default)*
**Deep dive**: [Metamorphosis Patterns](../05-metamorphosis-patterns.html)

## Why three directories are empty by default

`src/Being/`, `src/LogContext/`, and `src/Moment/` ship as `.gitkeep` placeholders. They correspond to optional patterns (Branching, Semantic Logging, Diamond convergence) that not every application needs.

Keeping them empty means:

- **Static analysis stays clean** — no example classes to confuse PHPStan or psalm.
- **Coverage reports stay honest** — no boilerplate inflating or deflating the percentage.
- **The shape of the project signals intent** — a file in `src/Being/` means *this app uses branching*, not *this is what the skeleton happened to ship with*.

When you adopt one of these patterns, drop the first real class into the matching directory and the slot is no longer empty.
