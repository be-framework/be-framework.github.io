---
layout: docs-en
title: "FAQ"
category: Manual
permalink: /manuals/1.0/en/faq.html
---

# Be Framework FAQ

> Last updated: 2025-09-13

## 0) TL;DR

### Q. Is this a new "programming paradigm"?A. Yes. Be Framework proposes BE-oriented programming ("Whether?" = can this state exist?) in contrast to traditional DO-oriented approaches (Imperative = "How?", OOP = "Who?", FP = "What?").

It makes temporal existence first-class citizens and designs based on "what something is" rather than "what it does." While it's a significant paradigm shift philosophically, implementation-wise it coexists with OOP/FP/DDD and doesn't require replacing existing styles.

---

## 1) Paradigm & Concepts

### Q1. How is this different from MVC or DDD?**  
A. MVC is a structural pattern for responsibility separation, DDD is a modeling methodology.  
Be Framework is a design paradigm centered on "existence conditions and temporal transformation," where flow self-organizes through `#[Be]` and `$being`.

### Q2. Is this OOP or FP?**  
A. It works with both. It emphasizes immutability and referential transparency while realizing one-time complete transformation in constructors (entelecheia) using OOP containers.

### Q3. What's the benefit of defining "BEING (what something is)" first?**  
A. It makes invalid states impossible to generate upfront (drastically reducing defensive if/guard statements).  
Type = reachable state becomes API specification.

### Q4. What does "type = temporal state" mean?**  
A. Types like `ValidatedUser`, `SavedUser`, `DeletedUser` express the "when" in progress.  
Time and domain are inseparable (details: [Metamorphosis](./05-metamorphosis.html)).

---

## 2) Core Features

### Q5. What does `#[Be]` do?**  
A. It declares destiny (what to become next).  
Given single/multiple candidates, the continuation is automatically selected at runtime by the type of `$being`.  
(Reference: [Type-Driven Metamorphosis](./07-type-driven-metamorphosis.html))

### Q6. What's the role of the `$being` property?A. It holds the next existence that the current existence leads to. Union types explicitly show all possibilities of results.

### Q6.5. Are `$being` and `$been` specially treated properties?A. No. These are not magically interpreted by the framework—they are mere conventions.

`becoming()` doesn't read property names, but looks at the types declared on properties to select the next class.

Therefore, the names `$being` / `$been` are not required. `public Success|Failure $result;` works the same way with different names.

However, using these names according to documentation, samples, and design philosophy provides the benefit of immediately recognizing "transformation destination (being)" and "completion evidence (been)".

### Q7. How is the metamorphosis chain controlled?

A. Through the chain of `#[Be]` attributes, the next transformation is automatically determined.

When multiple transformation destinations are possible, they are expressed as union types in the `$being` property, and the next transformation destination is determined by the type actually assigned. This mechanism allows complex business logic to be expressed declaratively.

### Q8. What are "Semantic Variables"?**  
A. Variable name = meaning + constraints. `$email` must be a "valid Email" to exist.  
It integrates into types validations that tend to scatter (controller/validator/docs).  
([Semantic Variables](./06-semantic-variables.html))

### Q8.5. How do you handle variables with different meanings but same constraints (`$userId`, `$authorId`, etc.)?A. Share constraints through common base classes or traits while separating meaning through inheritance.

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

### Q9. What is the "Reason Layer"?**  
A. It injects **the foundation = tool set** that enables a certain existence state as objects.  
It **bundles related tools meaningfully** from traditional individual DI, improving testability.  
([Reason Layer](./08-reason-layer.html))

### Q10. What is `$been` (self-proof) for?**  
A. It **internally contains** the trail of that existence's **completion** (who, when, what).  
It aligns well with external tests and audit logs.  
([Final Objects](./04-final-objects.html))

---

## 3) Design & Implementation

### Q11. Where do side effects occur?A. Principally **completed by delegating to Reason within constructors**. This eliminates the need for external orchestrators and huge service layers.

### Q12. How are exceptions handled?A. Using **semantic exceptions** that hold failures as collections (supporting multilingual messages). "Partial success/partial failure" can also be expressed as **valid existence** of **Invalid~**. ([Error Handling](./09-error-handling.html))

### Q13. What's the testing strategy?

A. Verify each existence (type) individually. Preconditions = `#[Input]`, postconditions = `public` properties. Use cases can be kept sufficiently thin with `#[Be]` chain smoke tests.

### Q15. When to choose "linear," "branching," or "nested"?
A. Procedure-dependent = **linear** / Results exclusive by conditions = **branching** / Convergence of independent processes = **nested**. When in doubt, start with **minimal linear**. ([Implementation Guidelines](./05-metamorphosis.html))

---

## 4) Integration with Existing Assets

### Q16. Can this be introduced to existing MVC apps?A. Yes. Replace the **Use Case layer** with Be, and just call `becoming(new …Input)` from Controllers. Gradually organize into **immanent/transcendent**.

### Q17. Where do you use DB or external APIs?A. In **Reason**. Storage and transmission means are consolidated in Reason, **separated** from existence (state) definition.

### Q18. Framework dependencies?A. Core uses PHP standard + DI (e.g., Ray.Di). Integration with Laravel/Symfony etc. is possible via **adapters**.

### Q19. Do static analysis and IDE completion work?A. **Very well** since types are "states." Branching is made explicit with union types, and completion is safe too.

---

## 5) Operations, Logging & Auditing

### Q20. How are logs recorded?A. **Semantic logging** is recommended (Koriym.SemanticLogger integration). Record transformation (from/to/reason/evidence) as **structured JSON**. ([Semantic Logging](./10-semantic-logging.html))

### Q21. Audit compliance?A. `$been` (self-proof) + semantic logging can provide **complete audit trails**. Personal information follows **minimum privilege** principles at the Reason layer.

---

## 7) Migration

### Q24. Migration steps for existing code? (Minimal steps)
1. Choose one representative use case
2. Extract input as `…Input` (immanent only)
3. Design transformation target as `…` (existence), add `#[Be]`
4. Consolidate external dependencies into Reason
5. Call `becoming(new …Input)` from Controller
6. Migrate validation to semantic variables / replace exceptions semantically
7. Introduce semantic logging

---

## 8) Future Features

### Q25. What about `#[Accept]` (Extended Decision Making)?A. Conceptual stage. Plans to **delegate undeterminable decisions to experts or AI**, handling certainty and uncertainty in one framework. ([Type-Driven Metamorphosis](./07-type-driven-metamorphosis.html) end note)

---

## 9) Examples & Snippets

### Q26. Minimal example of typical flow?
```php
// 1) Input (immanent only)
#[Be(UserProfile::class)]
final readonly class UserInput {
    public function __construct(public string $name, public string $email) {}
}

// 2) Being (moment of transformation)
final readonly class UserProfile {
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
$profile = $becoming(new UserInput($name, $email));

// Result: UserProfile object
// $profile->display: "Formatted name"
// $profile->isValid: true (for valid email)
```

---

## 10) Detailed Term Explanations

### Being-oriented / Ontological
A design philosophy that treats existence possibility and time as primary abstractions. It's a way of thinking that centers on "what can exist" rather than the traditional "what to do," understanding program states as temporal existence.

### Immanence / Transcendence
Immanence refers to the intrinsic properties and information that an object naturally possesses. Transcendence refers to capabilities and information provided by the external environment or dependencies. In Be Framework, new existence emerges from the combination of these two.

### Entelecheia
A concept derived from Aristotelian philosophy, representing the "moment of transformation" when potentiality moves to actuality. In Be Framework, it refers to the moment when immanence and transcendence meet in the constructor to complete a new existence.

### Reason Layer
An aggregation of the foundation and tool set necessary for establishing a certain existence state as objects. It enhances testability and maintainability by meaningfully bundling traditional DI (Dependency Injection).

### Semantic Variables
A concept where variable names themselves express meaning and constraints. For example, `$validEmail` expresses the constraint that it must be a "valid Email" to exist, integrating scattered validation logic at the type level.

### Semantic Exceptions / Semantic Logging
A mechanism for holding failures and history not as simple strings, but as structured data with meaning. It supports multilingual compatibility and audit requirements, making system behavior traceable at the semantic level.

---

## 11) Related Chapter Links

* **[Overview](./01-overview.html)**: First encounter with being-oriented programming
* **[Metamorphosis](./05-metamorphosis.html)**: Inseparability of time and domain
* **[Semantic Variables](./06-semantic-variables.html)**: Domain-specific validation and type safety
* **[Type-Driven Metamorphosis](./07-type-driven-metamorphosis.html)**: Self-determining objects
* **[Reason Layer](./08-reason-layer.html)**: Raison d'être and object existence foundations
* **[Error Handling](./09-error-handling.html)**: Semantic exceptions and multilingual messages
* **[Semantic Logging](./10-semantic-logging.html)**: Structured recording and audit trails
