---
layout: docs-en
title: "FAQ"
category: Manual
permalink: /manuals/1.0/en/faq.html
---

# Be Framework FAQ

> Last updated: 2025-09-13

## 0) TL;DR

**Q. Is this a new "programming paradigm"?**
A. **Yes (as a design paradigm)**. Built on top of OOP/FP/DDD, it's an **ontological programming model** that makes "whether something can exist (WHETHER?)" and "type = temporal state" first-class citizens. It's an orthogonal extension, not a replacement.

---

## 1) Paradigm & Concepts

**Q1. How is this different from MVC or DDD?**  
A. MVC is a **structural pattern** for responsibility separation, DDD is a modeling **methodology**.  
Be is a **design paradigm** centered on "existence conditions and temporal transformation," where flow **self-organizes** through `#[Be]` and `$being`.

**Q2. Is this OOP or FP?**  
A. It works with both. It emphasizes **immutability and referential transparency** while realizing **one-time complete transformation in constructors** (entelecheia) using OOP containers.

**Q3. What's the benefit of defining "BEING (what something is)" first?**  
A. It makes invalid states **impossible to generate** upfront (drastically reducing defensive if/guard statements).  
**Type = reachable state** becomes API specification.

**Q4. What does "type = temporal state" mean?**  
A. Types like `ValidatedUser` / `SavedUser` / `DeletedUser` express the **"when" in progress**.  
Time and domain are inseparable (details: [Metamorphosis](./05-metamorphosis.html)).

---

## 2) Core Features

**Q5. What does `#[Be]` do?**  
A. It declares **destiny (what to become next)**.  
Given single/multiple candidates, the continuation is **automatically selected** at runtime by the type of `$being`.  
(Reference: [Type-Driven Metamorphosis](./07-type-driven-metamorphosis.html))

**Q6. What's the role of the `$being` property?**
A. It holds the **next existence** that the current existence leads to. Union types **explicitly show all possibilities** of results.

**Q6.5. Are `$being` and `$been` specially treated properties?**
A. No. These are not magically interpreted by the framework—they are mere conventions.

`becoming()` doesn't read property names, but looks at the **types declared on properties** to select the next class.

Therefore, the names `$being` / `$been` are not required. `public Success|Failure $result;` works the same way with different names.

However, using these names according to documentation, samples, and design philosophy provides the benefit of immediately recognizing **"transformation destination (being)"** and **"completion evidence (been)"**.

**Actual behavior**:
- `$being`: Conventional property name for holding "which type it transformed to next"
- `$been`: Conventional property name for holding "completion self-proof" (past perfect meaning)

**Q8. What are "Semantic Variables"?**  
A. Variable name = **meaning + constraints**. `$email` must be a "valid Email" to **exist**.  
It **integrates into types** validations that tend to scatter (controller/validator/docs).  
([Semantic Variables](./06-semantic-variables.html))

**Q9. What is the "Reason Layer"?**  
A. It injects **the foundation = tool set** that enables a certain existence state as objects.  
It **bundles related tools meaningfully** from traditional individual DI, improving testability.  
([Reason Layer](./08-reason-layer.html))

**Q10. What is `$been` (self-proof) for?**  
A. It **internally contains** the trail of that existence's **completion** (who, when, what).  
It aligns well with external tests and audit logs.  
([Final Objects](./04-final-objects.html))

---

## 3) Design & Implementation

**Q11. Where do side effects occur?**
A. Principally **completed by delegating to Reason within constructors**. This eliminates the need for external orchestrators and huge service layers.

**Q12. How are exceptions handled?**
A. Using **semantic exceptions** that hold failures as collections (supporting multilingual messages). "Partial success/partial failure" can also be expressed as **valid existence** of **Invalid~**. ([Error Handling](./09-error-handling.html))

**Q13. What's the testing strategy?**
A. Verify each existence (type) **individually**. Preconditions = `#[Input]`, postconditions = `public` properties. Use cases can be kept sufficiently thin with **`#[Be]` chain** smoke tests.

**Q14. What about performance?**
A. Philosophy of **composing** immutable, fine-grained existences. While there's DI cost, it's net positive through **side effect localization** and **bug reduction**. Hot paths can be optimized in Reason implementations.

**Q15. When to choose "linear," "branching," or "nested"?**
A. Procedure-dependent = **linear** / Results exclusive by conditions = **branching** / Convergence of independent processes = **nested**. When in doubt, start with **minimal linear**. ([Implementation Guidelines](./05-metamorphosis.html))

---

## 4) Integration with Existing Assets

**Q16. Can this be introduced to existing MVC apps?**
A. Yes. Replace the **Use Case layer** with Be, and just call `becoming(new …Input)` from Controllers. Gradually organize into **immanent/transcendent**.

**Q17. Where do you use DB or external APIs?**
A. In **Reason**. Storage and transmission means are consolidated in Reason, **separated** from existence (state) definition.

**Q18. Framework dependencies?**
A. Core uses PHP standard + DI (e.g., Ray.Di). Integration with Laravel/Symfony etc. is possible via **adapters**.

**Q19. Do static analysis and IDE completion work?**
A. **Very well** since types are "states." Branching is made explicit with union types, and completion is safe too.

---

## 5) Operations, Logging & Auditing

**Q20. How are logs recorded?**
A. **Semantic logging** is recommended (Koriym.SemanticLogger integration). Record transformation (from/to/reason/evidence) as **structured JSON**. ([Semantic Logging](./10-semantic-logging.html))

**Q21. Audit compliance?**
A. `$been` (self-proof) + semantic logging can provide **complete audit trails**. Personal information follows **minimum privilege** principles at the Reason layer.

---

## 6) Modeling Guidelines & Anti-patterns

**Q22. Common pitfalls?**

* Dumping everything into Reason (bloating)
* Mixing external dependencies into `Input` (polluting immanence)  
* "Ambiguous state names" with unclear temporality (ambiguous words like `Processed?`)

**Q23. When not to use Be?**
A. For one-off scripts / ultra-lightweight CRUD where **temporality and existence conditions are thin**, traditional approaches may be faster.

---

## 7) Migration

**Q24. Migration steps for existing code? (Minimal steps)**

1. Choose one representative use case
2. Extract input as `…Input` (immanent only)
3. Design transformation target as `…` (existence), add `#[Be]`
4. Consolidate external dependencies into Reason
5. Call `becoming(new …Input)` from Controller
6. Migrate validation to semantic variables / replace exceptions semantically
7. Introduce semantic logging

---

## 8) Future Features

**Q25. What about `#[Accept]` (Extended Decision Making)?**
A. Conceptual stage. Plans to **delegate undeterminable decisions to experts or AI**, handling certainty and uncertainty in one framework. ([Type-Driven Metamorphosis](./07-type-driven-metamorphosis.html) end note)

---

## 9) Examples & Snippets

**Q26. Minimal example of typical flow?**

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
```

---

## 10) Quick Term Index

* **Being-oriented / Ontological**: Design perspective making existence possibility and time primary abstractions.
* **Immanence / Transcendence**: Intrinsic properties / Forces provided from outside.
* **Entelecheia**: The "moment of transformation" when potential moves to actual.
* **Reason Layer**: Foundation (tool set) for state establishment.
* **Semantic Variables**: Name = meaning = constraints.
* **Semantic Exceptions / Semantic Logging**: Holding failures and history with meaning.

---

## 11) Related Chapter Links

* **[Overview](./01-overview.html)**: First encounter with being-oriented programming
* **[Metamorphosis](./05-metamorphosis.html)**: Inseparability of time and domain
* **[Semantic Variables](./06-semantic-variables.html)**: Domain-specific validation and type safety
* **[Type-Driven Metamorphosis](./07-type-driven-metamorphosis.html)**: Self-determining objects
* **[Reason Layer](./08-reason-layer.html)**: Raison d'être and object existence foundations
* **[Error Handling](./09-error-handling.html)**: Semantic exceptions and multilingual messages
* **[Semantic Logging](./10-semantic-logging.html)**: Structured recording and audit trails