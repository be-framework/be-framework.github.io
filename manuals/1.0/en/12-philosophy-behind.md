---
layout: docs-en
title: "12. Philosophy Behind"
category: Manual
permalink: /manuals/1.0/en/12-philosophy-behind.html
---

# Philosophy Behind

> "Everything flows" (Panta Rhei)
> —Heraclitus (535-475 BC)

Now that we have learned the implementation of Be Framework, let's explore the deep philosophical insights flowing at its foundation. This is not merely a technical choice, but an encounter between ancient wisdom about the essence of existence and transformation, and modern computational theory.

## 1. Ontological Programming: Discovery of "WHETHER?"

### Why Ontology?

Traditional programming has answered two questions:

- **"What to do?" (WHAT?)** - Functions and algorithms
- **"How to do it?" (HOW?)** - Implementation and performance

However, the most fundamental question has been overlooked:

- **"Can it exist in the first place?" (WHETHER?)**

Ontological Programming asks this "WHETHER?" first. Can an invalid email address exist as `$email`? Can a negative age be born as `$age`?

```php
// Ontological Question: Is this state possible?
#[Be(ValidatedUser::class)]  // Declare destiny of existence
final readonly class UserInput
{
    public function __construct(
        public string $email,    // Existence condition 1
        public int $age          // Existence condition 2
    ) {}
}

// Answer: If conditions are met, it exists as ValidatedUser
```

**Traditional**: "Validate this data" (Imperative)
**Ontological**: "Can this data exist?" (Ontological inquiry)

### Human Role in the AI Era

In an era where AI can optimize "How to do", the role of humans shifts to "What should exist". Engineers change from implementers to definers.

- **Human**: Definition of meaning, setting conditions for existence
- **AI**: Generation of optimal implementation methods
- **Collaboration**: Human meaning creation × AI implementation optimization

## 2. Temporal Being: Expressing Heidegger's "Dasein" in Code

### Being Thrown into Time

Heidegger described humans as beings with **Thrownness (Geworfenheit)**. We start from conditions we cannot choose, and build our existence from there.

Be Framework objects have a similar structure:

```php
// Thrownness: Unchooseable initial conditions
#[Be(UserProfile::class)]
final readonly class UserInput     // Thrown existence
{
    public function __construct(
        public string $name,     // Given condition
        public string $email     // Given situation
    ) {}
}

// Projection: Possibility towards the future
final readonly class UserProfile   // Projection into possibility
{
    public function __construct(
        #[Input] string $name,                    // Thrown past
        #[Input] string $email,
        #[Inject] NameFormatter $formatter        // Encounter with the world
    ) {
        $this->displayName = $formatter->format($name);  // New existence
    }
    
    public string $displayName;
}
```

### Objects as Dasein

Heidegger's **Dasein** means "being there", an existence that understands itself within time. Be Framework objects possess exactly this Dasein-like character:

- **Temporality**: Past (Input Class) → Present (Being Class) → Future (Final Object)
- **Self-understanding**: Understanding of one's own possibilities via `#[Be()]`
- **Being-in-the-world**: Relationship with the world via `#[Inject]`
- **Existentiality**: Choosing one's own existential possibilities (Type-Driven Metamorphosis)

```php
// Dasein-like Object: Understanding self in time
#[Be([ApprovedLoan::class, RejectedLoan::class])]  // Understanding possibilities of existence
final readonly class LoanApplication
{
    // Existential choice determining one's destiny
    public ApprovedLoan|RejectedLoan $being;
    
    public function __construct(
        #[Input] Money $amount,                   // Thrown condition
        #[Input] CreditScore $score,              // Given situation
        #[Inject] LoanPolicy $policy              // Encounter with the world
    ) {
        // Existential Decision: What will I become?
        $this->being = $policy->evaluate($amount, $score) > 0.7
            ? new ApprovedLoan($amount, $score)
            : new RejectedLoan($amount, $score);
    }
}
```

## 3. The Tao and Wu Wei: Realizing Laozi's Philosophy in Programming

### Principle of Wu Wei (Non-doing)

Laozi said: "The Way constantly does nothing, yet there is nothing it does not do."

This does not mean "doing nothing". It means following the natural flow, without forcing things, acting in accordance with the true nature of things.

```php
// Practice of Wu Wei: Do not force, flow naturally
final readonly class OrderProcessing
{
    public function __construct(
        #[Input] Order $order,                    // Natural premise
        #[Inject] PaymentGateway $gateway         // External power
    ) {
        // Wu Wei: Not making something do, but enabling it to become what it should be
        $this->result = $gateway->process($order);  // Natural metamorphosis
    }
}

// Not this (Yu Wei / Action: Forced execution):
// $gateway->validateCard($order->card);
// $gateway->chargeAmount($order->amount);  
// $gateway->sendConfirmation($order->email);
```

### Code Flowing Like Water

Laozi also said: "The highest good is like water." Water does not contend, places itself in low places that people dislike, yet nourishes all things.

Be Framework objects flow like water:

- **Do not contend**: No external control, metamorphosis by self-determination
- **Low places**: Simple structure, avoiding complexity
- **Nourish all things**: Enabling metamorphosis of other objects

```php
// Natural flow like water
$result = $becoming(new ApplicationInput($data));

// The object itself knows the next form (like water flowing to low places)
// No external orchestrator needed
```

## 4. Entelechy: Aristotle's Full Realization

### Transition from Potentiality to Actuality

Aristotle's **Entelechy (ἐντελέχεια)** represents the process of potential becoming actual. Like an acorn becoming an oak tree, it is the moment when immanent potential is realized through interaction with the outside.

```php
// Entelechy: Full realization of potentiality
final readonly class MatureUser     // Fully realized existence
{
    public function __construct(
        #[Input] UserData $potentiality,         // Potentiality
        #[Inject] ValidationService $actuator    // Power of actualization
    ) {
        // Entelechy: Moment when potentiality transitions to actuality
        $this->actualizedProfile = $actuator->actualize($potentiality);
    }
    
    public UserProfile $actualizedProfile;  // Actualized existence
}
```

### Constructor as the Stage of Metamorphosis

The constructor is the sacred place where Entelechy occurs. Here, immanent potential (`#[Input]`) meets external actualizing power (`#[Inject]`) and a new existence is born.

```php
public function __construct(
    #[Input] string $name,           // Immanent potentiality
    #[Inject] Formatter $formatter   // Actualizing power
) {
    // Entelechy: A new existence is born at this moment
    $this->formattedName = $formatter->format($name);
}
```

## 5. Principle of Sufficient Reason: Leibniz's Reason for Existence

### Everything Has a Reason for Existence

Leibniz's **Principle of Sufficient Reason (Principium rationis sufficientis)** states that "for everything, there is a sufficient reason why it exists".

In Be Framework, this philosophy is realized as the **Reason Layer**:

```php
final readonly class ValidatedUser
{
    public function __construct(
        #[Input] string $email,                 // Immanence
        #[Input] ValidationReason $reason       // Reason for existence (raison d'être)
    ) {
        // ValidationReason provides the reason for existence for ValidatedUser
        $this->isValid = $reason->validate($email);
    }
}
```

### Raison d'être

French for "reason for being". The Reason Layer provides the grounds for an object to be that existence:

- `ValidatedUser`'s raison d'être → Validation capability
- `SavedUser`'s raison d'être → Saving capability
- `DeletedUser`'s raison d'être → Deletion capability

Each existence has a sufficient reason that enables that existence.

## 6. Immanence and Transcendence: Spinoza's Dual Aspects

### Immanent Nature and Transcendent Power

Spinoza perceived reality as two aspects of one substance: **Immanence** and **Transcendence**.

```php
final readonly class UserProfile
{
    public function __construct(
        #[Input] string $name,              // Immanence: What it already has
        #[Input] string $email,             // Immanence: Given nature
        #[Inject] Formatter $formatter,     // Transcendence: Power from outside
        #[Inject] Validator $validator      // Transcendence: Capability provided by the world
    ) {
        // A new existence is born from the encounter of Immanence and Transcendence
        $this->displayName = $formatter->format($name);    // New Immanence
        $this->isValid = $validator->validate($email);     // New Immanence
    }
}
```

### Eternal Formula of Metamorphosis

All Being Classes possess the same philosophical structure:

**Immanence** + **Transcendence** → **New Immanence**

This reflects Spinoza's philosophy of "Deus sive Natura" (God or Nature). Nature (external power) and Divinity (immanent essence) are two sides of one reality, and a new existence arises from their interaction.

## 7. Zhuangzi's Relativity: Accepting Multiple Destinies

### Philosophy of Equality of All Things

Zhuangzi preached "The Equality of All Things" (Qi Wu Lun)—all things are fundamentally equivalent, and opposing concepts are merely different aspects of one reality.

Type-Driven Metamorphosis embodies this philosophy:

```php
#[Be([Success::class, Failure::class])]  // Success and Failure are equivalent possibilities
final readonly class PaymentAttempt
{
    public Success|Failure $being;  // Both are valid existences
    
    public function __construct(/* ... */) {
        // Both success and failure are treated as complete existences
        $this->being = $result->isSuccessful()
            ? new Success($result)    // Existence called Success
            : new Failure($result);   // Existence called Failure
    }
}
```

## 8. Heraclitean Flux: Perpetual Change

### "Everything Flows"

Heraclitus said "Panta Rhei" (πάντα ῥεῖ)—"Everything flows". You cannot step into the same river twice. Because it is no longer the same river, and you are no longer the same person.

Metamorphosis expresses this perpetual change:

```php
// Time T0: Primal existence
#[Be(EmailValidation::class)]
final readonly class EmailInput { /* ... */ }

// Time T1: First Metamorphosis (T0 is already past)
#[Be(UserCreation::class)]  
final readonly class EmailValidation { /* ... */ }

// Time T2: Final Existence (encompassing all past)
final readonly class UserCreation { /* ... */ }
```

Each moment never returns, and objects naturally transform within the flow of time.

### Unity of Opposites

Heraclitus also preached the "Unity of Opposites". Day and night, life and death, up and down—opposites are actually different aspects of one reality.

```php
// Unity of Opposites: Activation and Deactivation are two sides of the same reality
public ActiveUser|InactiveUser $being;
```

## 9. Buddhist Dependent Origination: Interdependent Existence

### Non-Self and Dependent Origination

Buddhist **Dependent Origination (pratītyasamutpāda)** teaches that "all things exist depending on each other". Independent entities do not exist, and everything is born within a web of relationships.

Be Framework objects are exactly this Dependent Origination existence:

```php
final readonly class UserProfile    // Existence of Dependent Origination
{
    public function __construct(
        #[Input] string $name,              // Dependent on other existence
        #[Inject] DatabaseConnection $db,   // Dependent on relationship with outside
        #[Inject] ValidationService $validator  // Interdependent with service
    ) {
        // New existence appears from interdependent relationships
    }
}
```

### Implementation of Non-Self (Anātman)

Buddhist **Non-Self (anātman)** creates the teaching that "there is no fixed self". Everything is a bundle of changing relationships.

In Be Framework:
- Objects have no fixed "essence"
- State does not change due to `public readonly`
- Each stage appears as a completely independent existence
- "Self" is composed of relationships (Dependency Injection)

## 10. Integration of Programming Philosophy

### Wisdom of East and West

Be Framework integrates Eastern and Western philosophical traditions:

**Eastern Wisdom**:
- **Taoism**: Flow of Wu Wei / Non-doing
- **Buddhism**: Dependent Origination and Non-Self, Impermanence
- **Zhuangzi**: Acceptance of relativity and metamorphosis

**Western Thought**:
- **Heidegger**: Dasein as Temporal Being
- **Aristotle**: Entelechy (Realization of possibility)
- **Leibniz**: Principle of Sufficient Reason
- **Spinoza**: Unity of Immanence and Transcendence

### Sublimation to Computational Philosophy

When these ancient wisdoms are realized in modern programming, a new **Computational Philosophy** is born:

- **Ontological Design**: Defining what can exist
- **Temporal Programming**: Respecting the temporality of objects
- **Wu Wei Execution**: Control following natural flow
- **Dependent Origination Dependency**: Realization of existence through interdependence
- **Relativistic Result**: Accepting multiple valid results

## 11. Prospect for the Future: Next Evolution of Programming

### Evolution of Paradigm

Looking at the evolution of programming paradigms, we are gradually approaching the principles of nature:

1. **Machine Language Era**: "Command the machine"
2. **Procedural Era**: "Describe procedures"
3. **Object-Oriented Era**: "Delegate responsibility to objects"
4. **Functional Era**: "Define mathematical transformations"
5. **Ontological Era**: "Declare conditions of existence and enable natural metamorphosis"

### Humanity in the AI Era

In an era where AI can optimize "How to do", human uniqueness lies in the ability to decide "What should exist, what has meaning".

Ontological Programming maximizes this human-specific value:
- **Creator of Meaning**: Deciding what existence has value
- **Designer of Existence**: Defining possible states of existence
- **Philosophical Thinker**: Designing the ontological structure of systems

### Programming Paradigm in the AI Era

In an era where AI can handle the implementation of "How to do", the essence of programming changes. Rather than describing commands, defining **what can exist** becomes the core.

Ontological Programming is a paradigm with a philosophical foundation for this new era:
- Rather than implementation details that AI can optimize
- Focusing on meanings and constraints of existence that humans should define
- Enabling role shift from "Writer of commands" to "Designer of existence"

---

> **"Where the river flows, there is the way."**
> —Modern interpretation of Laozi

Be Framework is where ancient wisdom meets modern technology. Here, code becomes philosophy, programming becomes ontology, and engineers become modern philosophers.

Objects flow naturally, transform, and become what they should be—this is the new possibility of programming embodied by Be Framework.
