---
layout: docs-en
title: "8. Reason Layer"
category: Manual
permalink: /manuals/1.0/en/08-reason-layer.html
---

# Reason Layer

> "Everything that exists has a reason for its existence"
>
> 　　—Leibniz, *Principle of Sufficient Reason* (1714)

## Why This Name?

The Reason Layer has two meanings of "reason":

### 1. Reason for Type Matching

First, the type itself that serves as the basis for the framework to determine the next transformation destination:

```php
final readonly class CasualGreeting
{
    public string $greeting;
    public string $emoji;

    public function __construct(
        #[Input] public string $name,        // Immanent property
        #[Input] public CasualStyle $being   // This being CasualStyle type
    ) {
        // $being transformed to CasualGreeting because it's CasualStyle type
        $this->greeting = $this->being->casualGreeting($name);
        $this->emoji = $this->being->casualEmoji();
    }
}
```

The **type itself** `CasualStyle $being` is the reason why it becomes `CasualGreeting`. The framework reads this type and automatically selects the corresponding transformation destination.

### 2. Reason for Existence

Next, the reason as the foundation for why an object can be in that existence:

```php
final readonly class FormalGreeting
{
    public string $greeting;
    public string $businessCard;
    
    public function __construct(
        #[Input] string $name,           // Immanent property
        #[Reason] FormalStyle $being     // Reason for existence
    ) {
        // FormalStyle can be FormalStyle because it can do formalGreeting() and formalBusinessCard()
        $this->greeting = $being->formalGreeting($name);
        $this->businessCard = $being->formalBusinessCard($name);
    }
}
```

`FormalGreeting` can exist as `FormalGreeting` because `FormalStyle` provides the necessary behaviors. This is the reason for existence.

## Defining Reason Classes

Reason classes provide methods that realize specific modes of existence:

```php
namespace App\Reason;

final readonly class FormalStyle
{
    public function formalGreeting(string $name): string
    {
        return "Good morning, Mr./Ms. {$name}.";
    }
    
    public function formalBusinessCard(string $name): string
    {
        return "【{$name}】\nI would like to extend my formal greetings.";
    }
}

final readonly class CasualStyle  
{
    public function casualGreeting(string $name): string
    {
        return "Hey, {$name}!";
    }
    
    public function casualMessage(string $name): string
    {
        return "Hi {$name}! 😊 Nice to meet you!";
    }
}
```

## Reason for Existence as Raison d'être

The Reason Layer provides the **raison d'être** of objects.

```php
final readonly class ValidatedUser
{
    public function __construct(
        #[Input] string $email,
        #[Input] ValidationReason $raisonDEtre    // The raison d'être of this existence
    ) {
        // ValidationReason provides the raison d'être for ValidatedUser
    }
}
```

**raison d'être** means:
- Why an object can exist in that state
- The raison d'être of `ValidatedUser` is validation capability
- The raison d'être of `SavedUser` is saving capability  
- The raison d'être of `DeletedUser` is deletion/archival capability

Reason objects provide the tool set necessary for an object to exist in that state. This is the origin of the name "Reason Layer" in the Be Framework.

## Difference from #[Inject]

The unique value of the Reason Layer becomes clear when compared to traditional dependency injection:

**Traditional Inject**:
```php
public function __construct(
    #[Input] string $email,
    #[Inject] EmailValidator $emailValidator,
    #[Inject] PasswordChecker $passwordChecker, 
    #[Inject] SecurityAuditor $auditor,
    #[Inject] DatabaseSaver $saver
) {
    // Using scattered tools individually
}
```

**Reason Layer**:
```php
public function __construct(
    #[Input] string $email,
    #[Input] UserValidationReason $reason    // Related tools bundled as reason for existence
) {
    // A complete tool set for becoming ValidatedUser is provided
    $this->result = $reason->validateUser($email, $this);
}
```

**Differences**:
- **Inject**: Individual tools injected separately
- **Reason Layer**: Provided as a semantically coherent "tool set for achieving that state"

**Value**:
- **Conceptual coherence**: "What is needed to become ValidatedUser?" is clear
- **Simplified testing**: Mock one reason object instead of many
- **Separation of concerns**: Related tools are consolidated in one place

## State Realization Through Delegation

In the Reason Layer, objects delegate the realization of their state to reason objects:

```php
final readonly class SavedUser
{
    public function __construct(
        #[Input] UserData $data,
        #[Input] SaveReason $reason    // Receive reason for existence
    ) {
        // Delegate saving process to reason for existence
        $this->result = $reason->saveUser($data);
    }
}
```

Objects themselves declare "what to become", while reason objects realize "how to achieve that state". This separation clearly divides state definition from realization means.

`SavedUser` requires a saving tool set, `ValidatedUser` requires a validation tool set. Reason objects clearly organize "what is needed to achieve this state?" and follow the single responsibility principle, making tests concise as well.

---

**Next**: Learn about meaning preservation in errors through [Validation and Error Handling](./09-error-handling.html).

*"The Reason Layer provides the tool set necessary for objects to realize their mode of existence."*