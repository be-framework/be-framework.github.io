---
layout: docs-en
title: "FAQ"
category: Manual
permalink: /manuals/1.0/en/faq.html
---

# Be Framework FAQ

## 0) TL;DR

### Q. Is this a new "programming paradigm"?

A. Yes. Be Framework makes temporal existence first-class citizens and designs based on "what something is" rather than "what it does."

While it's a significant paradigm shift philosophically, implementation-wise it coexists with OOP/FP/DDD and doesn't require replacing existing styles.

---

## 1) Paradigm & Concepts

### Q1. How is this different from MVC or DDD?

A. They operate at different layers and can coexist.

Web MVC effectively functions as input/output responsibility separation, and DDD is a domain modeling methodology. Be Framework is a design paradigm that organizes object creation through "existence conditions and temporal transformation" — it can be called from an MVC Controller or used inside a DDD aggregate.

Interestingly, what MVC originally aimed for — "projecting mental models" — and what DDD aimed for — "coding in business language" — are naturally realized in Be Framework through existence types and semantic variables.

### Q1-a. How does this relate to CQRS?

A. The separation of "decision-making" and "data retrieval" that CQRS achieves through external structure is naturally inherent within a single existence type in Be.

The constructor is decision-making (Command), and public properties are data retrieval (Query). Business decisions that tend to get buried in generic methods like `updateUser()` are expressed as type names like `DeactivatedUser`, so intent is never lost from the code.

### Q2. Is this OOP or FP?

A. It incorporates elements of both, but the relationship with OOP is more fundamental.

OOP originally envisioned a world where autonomous objects cooperate through messages. In practice, however, service layers issue instructions while objects become obedient data containers. In Be, objects declare their own destiny through `#[Be]` and self-organize without external orchestrators. This is a recovery of the autonomy that OOP originally intended.

### Q2-a. How are FP elements utilized?

A. Existence types are immutable once transformation is complete.

Side effects are localized to the constructor, and completed objects can be referenced as pure data. With clear preconditions (`#[Input]`) and postconditions (public properties), each existence type can be tested independently, and results are always predictable.

Public properties are considered taboo in traditional OOP, but in practice objects circulate as typed values, and in tests postconditions can be verified directly. (For concrete testing approaches, see [Q13](#q13-whats-the-testing-strategy).)

### Q3. What's the benefit of defining "BEING (what something is)" first?

A. Invalid states become inexpressible altogether.

The defensive if statements scattered throughout traditional code are necessary because invalid states are representable as types. In Be, types are existence conditions themselves, so there are no types representing invalid states, and the guard statements disappear with them. Type = reachable state becomes the API specification directly.

### Q4. What are "temporal existence types"?

A. Types like `ValidatedUser`, `SavedUser`, `DeletedUser` express the "when" in progress.

Time and domain are inseparable (details: [Metamorphosis](./05-metamorphosis.html)).

---

## 2) Core Features

### Q5. What does the `#[Be]` attribute do?

A. It declares an object's destiny (what it will become next).

You can specify single or multiple transformation candidates, and the framework automatically selects the continuation at runtime based on the type of the `$being` property.

For details, see [Metamorphosis](./05-metamorphosis.html).

### Q6. What's the role of the `$being` property?

A. It holds the next existence that the current existence leads to.

Union types explicitly show all possible outcomes.

### Q6.5. Are `$being` and `$been` special properties?

A. No, they are not special properties.

`becoming()` doesn't read property names, but looks at the types declared on properties to select the next class.

Therefore, the names `$being` / `$been` are not required. `public Success|Failure $result;` works the same way with different names.

However, using these names according to documentation, samples, and design philosophy provides the benefit of immediately recognizing "transformation destination (being)" and "completion evidence (been)".

### Q7. How is the metamorphosis chain controlled?

A. Through the chain of `#[Be]` attributes, the next transformation is automatically determined.

When multiple transformation destinations are possible, they are expressed as union types in the `$being` property, and the next transformation destination is determined by the type actually assigned. This mechanism allows complex business logic to be expressed declaratively.

### Q8. What are "Semantic Variables"?

A. Variable name = meaning + constraints. `$email` must be a "valid Email" to exist.

It integrates scattered validations (controller/validator/docs) into types.

See [Semantic Variables](./06-semantic-variables.html) for details.

### Q8.5. How do you handle variables with different meanings but same constraints (`$userId`, `$authorId`, etc.)?

A. Share constraints through common base classes or traits while separating meaning through inheritance.

```php
// src/Semantic/Abstract/Id.php - Common constraint base class
namespace App\Semantic\Abstract;

abstract readonly class Id {
    public function __construct(public string $value) {
        if (!preg_match('/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}/', $value)) {
            throw new InvalidIdException();
        }
    }
}

// src/Semantic/UserId.php - Semantic variables through inheritance
readonly class UserId extends \App\Semantic\Abstract\Id {}
readonly class AuthorId extends \App\Semantic\Abstract\Id {}

// Usage: variable names carry semantic meaning
function updateArticle(UserId $userId, AuthorId $authorId) {
    // $userId and $authorId cannot be confused
}
```

### Q9. What is the "Reason Layer"?

A. It gathers the foundation — the complete tool set — for an existence to come into being, into a single object.

In traditional DI, dependencies are injected individually and scattered, making it hard to see "what are the preconditions for this existence?" Reason bundles the grounds for existence by meaning, so in tests you can swap out the entire set of preconditions at once.

See [Reason Layer](./08-reason-layer.html) for details.

### Q10. What is `$been` (self-proof) for?

A. It internally contains the trail of that existence's completion (who, when, what).

It aligns well with external tests and audit logs.

See [Final Objects](./04-final-objects.html) for details.

---

## 3) Design & Implementation

### Q11. Where do side effects occur?

A. Inside the constructor, delegated to Reason and completed there.

Traditional service layers operate on objects from the outside — "save this," "notify that." In Be, the object itself completes side effects in its constructor. This is the autonomy described in [Q2](#q2-is-this-oop-or-fp) in action — no external orchestrator needed.

### Q12. How are exceptions handled?

A. Using semantic exceptions that hold failures as collections (supporting multilingual messages). "Partial success/partial failure" can also be expressed as valid existence of Invalid~.

See [Semantic Exceptions](./09-error-handling.html) for details.

### Q13. What's the testing strategy?

A. Verify each existence (type) independently.

As described in [Q2-a](#q2-a-how-are-fp-elements-utilized), preconditions (`#[Input]`) and postconditions (public properties) are explicit, making the test interface self-evident. No getters or reflection needed — assert public properties directly.

Use case-level tests can be kept sufficiently thin with `#[Be]` chain smoke tests. DI has costs, but localized side effects and reduced bugs make it a net positive.

### Q14. When to choose "linear," "branching," or "nested"?

A. Procedure-dependent = linear / Results exclusive by conditions = branching / Convergence of independent processes = nested. When in doubt, start with minimal linear.

See [Implementation Guidelines](./05-metamorphosis.html) for details.

---

## 4) Integration with Existing Assets

### Q15. Can this be introduced to existing MVC apps?

A. Yes. Replace the Use Case layer with Be, and just call `becoming(new …Input)` from Controllers. Gradually organize into immanent/transcendent.

### Q16. Where do you use DB or external APIs?

A. Confined to Reason.

Persistence and external communication are implementation details, not user concerns. By consolidating them in Reason, existence types are freed from database schemas and API constraints — the definition of existence is separated from technical means.

### Q17. What are the framework dependencies?

A. Core uses PHP standard + DI (e.g., Ray.Di). Integration with Laravel/Symfony etc. is possible via adapters.

### Q18. Do static analysis and IDE completion work?

A. Very well since types are "states." Branching is made explicit with union types, and completion is safe too.

---

## 5) Operations & Auditing

### Q19. How are logs recorded?

A. Recording transformations (from/to/reason/evidence) as structured JSON is recommended.

The semantic logging mechanism is at the conceptual stage.

### Q20. How does audit compliance work?

A. `$been` (self-proof) provides the foundation for audit trails.

Personal information follows minimum privilege principles at the Reason layer.

---

## 6) Migration

### Q21. What are the migration steps for existing code? (Minimal steps)

A.
1. Choose one representative use case
2. Extract input as `…Input` (immanent only)
3. Design transformation target as `…` (existence), add `#[Be]`
4. Consolidate external dependencies into Reason
5. Call `becoming(new …Input)` from Controller
6. Migrate validation to semantic variables / replace exceptions semantically

---

## 7) Future Features

### Q22. What about `#[Accept]` (Extended Decision Making)?

A. Conceptual stage. Plans to delegate undeterminable decisions to experts or AI, handling certainty and uncertainty in one framework.

---

## 8) Examples & Snippets

### Q23. What's a minimal example of typical flow?

A.
```php
// 1) Input (immanent only)
#[Be(ValidatedUser::class)]
final readonly class UserInput {
    public function __construct(public string $name, public string $email) {}
}

// 2) Being (moment of transformation)
final readonly class ValidatedUser {
    public function __construct(
        #[Input] string $name,
        #[Input] string $email,
        #[Inject] NameFormatter $fmt,
        #[Inject] EmailValidator $v
    ) {
        $this->display = $fmt->format($name);
        $this->isValid = $v->validate($email);
    }
    public string $display;
    public bool $isValid;
}

// 3) Execution (self-organization)
$user = $becoming(new UserInput($name, $email));

// Result: ValidatedUser object
// $user->display: "Formatted name"
// $user->isValid: true (for valid email)
```

---

## 9) Detailed Term Explanations

### Being-oriented / Ontological
A design philosophy that centers on "what can exist" rather than "what to do." It treats existence possibility and time as primary abstractions, understanding program states as temporal existence. As a result, states that cannot exist are never represented as types, so invalid states are naturally eliminated.

### Immanence / Transcendence
Immanence (`#[Input]`) is the intrinsic properties an object possesses; transcendence (`#[Inject]`) is the power provided from outside. Transformation always follows the formula: immanence + transcendence → new immanence. Transcendence transforms the immanent and then vanishes.

### Reason Layer
An object that gathers the foundation and tool set necessary for an existence to come into being. See [Q9](#q9-what-is-the-reason-layer) for details.

### Semantic Variables
A concept where variable names themselves express meaning and constraints. For example, `$email` expresses its meaning through the name, and as a type, carries the constraint that it must be a valid email to exist. It integrates scattered validation logic at the type level.

### Semantic Exceptions
A mechanism for holding failures not as simple strings, but as structured data with meaning. It supports multilingual compatibility and audit requirements, making system behavior traceable at the semantic level.
