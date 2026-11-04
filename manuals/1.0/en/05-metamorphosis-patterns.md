---
layout: docs-en
title: "Metamorphosis"
category: Manual
permalink: /manuals/1.0/en/05-metamorphosis.html
---

# Metamorphosis

> "Space and time cannot be defined independently of each other."
>
> —Albert Einstein, The Foundation of the General Theory of Relativity (1916)

## Time and Domain Are Inseparable

Just as Einstein discovered the inseparability of time and space, the Be Framework considers time and domain as a single entity that cannot be divided. Approval processes have their approval time, payments have their payment time, and transformation naturally emerges along the unique temporal axis that each domain logic possesses.

## Irreversible Flow of Time

Object metamorphosis follows the arrow of time in a unidirectional flow. There is no returning to the past, no remaining in the same moment:

```php
// Time T0: Birth of input
#[Be(EmailValidation::class)]
final readonly class EmailInput { /* ... */ }

// Time T1: First metamorphosis (T0 is already past)
#[Be(UserCreation::class)]
final readonly class EmailValidation { /* ... */ }

// Time T2: Second metamorphosis (T1 becomes memory)
#[Be(WelcomeMessage::class)]
final readonly class UserCreation { /* ... */ }

// Time T3: Final existence (encompassing all past)
final readonly class WelcomeMessage { /* ... */ }
```

Each moment never returns, and new existence preserves previous forms as memory within itself. Like a river flowing, time moves only in one direction.

## Self-Determination of Destiny

Like living beings in reality, objects determine their own destiny through the interaction between immanence and transcendence. This is not following a predetermined route, but natural metamorphosis responding to the circumstances of that moment:

```php
#[Be([ApprovalNotification::class, RejectionNotification::class])]
final readonly class ApplicationReview
{
    public Approved|Rejected $being;

    public function __construct(
        #[Input] string $email,                    // Immanence
        #[Input] array $documents,                 // Immanence
        #[Inject] ReviewService $reviewer          // Transcendence
    ) {
        $result = $reviewer->evaluate($documents);

        // Destiny is decided at this very moment
        $this->being = $result->isApproved()
            ? new Approved($email, $result->getScore())
            : new Rejected($email, $result->getReasons());
    }
}
```

`Approved` and `Rejected` are Reason objects—like `Emergency` and `Observation` in the triage tutorial. The Reason determines the destiny: it carries the decision and its basis, and when assigned to `$being`, its type decides which class comes next. Decision logic that completes within the constructor belongs in the Reason layer. When deferred behavior is needed—methods to be called after construction, like `assignER()` in the triage example—those capabilities belong on the Final class.

## Type-Based Continuation

Among the candidate classes specified in `#[Be()]`, the framework automatically selects the one whose constructor `#[Input]` parameter can be satisfied by the current object's public properties:

```php
// ApplicationReview's $being is of type Approved,
// so this class is selected because #[Input] Approved matches
final readonly class ApprovalNotification
{
    public function __construct(
        #[Input] Approved $approval,
        #[Inject] Mailer $mailer
    ) {
        $mailer->send($approval->email, 'Approved! Score: ' . $approval->score);
    }
}
```

`$being` is a conventional property name often used for this self-determination pattern, but it is not a name required by the framework. Any public property participates in matching.

## Matching Rules {#matching-rules}

When `#[Be()]` lists several candidates, the framework checks them in the order written and picks the first one it can bring into existence:

1. Every constructor parameter that is not `#[Inject]` must have a public property of the same **name** on the current object.
2. The property's value must be compatible with the parameter's declared **type**. This is where `Approved|Rejected $being` decides the route: `#[Input] Approved $being` matches only when `$being` holds an `Approved`.
3. `#[Inject]` parameters are ignored during matching; they are resolved by the DI container afterwards.
4. If a matching candidate throws `UnbecomingException` from its constructor ("I am not this"), the next candidate is tried. If no candidate matches, `BeMatchException` is thrown.

When `#[Be()]` names a single class, no matching is performed—the object simply becomes that class.

## Choosing the Shape {#choosing-the-shape}

Three shapes cover most domains:

| Shape | When | How |
|-------|------|-----|
| **Linear** | Each step depends on the previous one | `#[Be(Next::class)]` on every class |
| **Branching** | Outcomes are mutually exclusive | `#[Be([A::class, B::class])]` plus a union-typed `$being` holding a Reason |
| **Nested** | Independent sub-processes must converge | Inject `BecomingInterface` and run inner chains (see [Becoming](./04a-becoming.html)) |

When in doubt, start linear. Introduce a branch only when a Reason actually produces exclusive outcomes, and nesting only when independent results must be combined.

## Self-Organizing Pipelines

Like UNIX pipes that combine simple commands to create powerful systems, Be Framework combines typed objects to create natural transformation flows.

```bash
# UNIX: Text flows through externally controlled pipelines
cat access.log | grep "404" | awk '{print $7}' | sort | uniq -c
```

In UNIX, the shell controls the pipeline. In Be Framework, objects declare their own destiny with `#[Be()]`—no controller or orchestrator controls the flow.

Heraclitus said "the flowing is the river." Just as it is not that a river flows, but that the flowing itself is the river, domains in the Be Framework are temporal existence that never rest until they reach their end.

---

Variable names that carry constraints and contracts, [Semantic Variables](./06-semantic-variables.html) ➡️
