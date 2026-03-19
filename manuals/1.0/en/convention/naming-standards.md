---
layout: docs-en
title: "Be Framework Naming Standards"
category: Convention
permalink: /manuals/1.0/en/convention/naming-standards.html
---

# Be Framework Naming Standards

> Code as philosophy: names that reflect existence, not actions

This document establishes naming conventions that align with Be Framework's ontological programming principles, ensuring code that expresses **being** rather than **doing**.

## Core Philosophy

Names express **what it is**, not **what it does**.

## Class Naming Patterns

### Input Classes
**Pattern**: `{Domain}Input`
**Purpose**: Pure data containers representing the starting point of metamorphosis

```php
// ✅ Correct
final readonly class UserInput
final readonly class OrderInput
final readonly class DataInput
final readonly class PaymentInput

// ❌ Avoid
final readonly class UserData          // Too generic
final readonly class CreateUserRequest // Action-oriented
final readonly class UserDto           // Technical-oriented
```

### Being Classes
**Pattern**: `{State}{Domain}`
**Purpose**: Intermediate transformation stages

```php
// ✅ Correct
final readonly class ValidatedUser
final readonly class AuthenticatedUser
final readonly class ProcessedOrder
final readonly class VerifiedPayment

// ❌ Avoid
final readonly class UserValidator     // Service-oriented
final readonly class OrderProcessor    // Action-oriented
```

### Final Objects
**Pattern**: `{CompletedState}`
**Purpose**: The destination of metamorphosis

```php
// ✅ Correct
final readonly class RegisteredUser
final readonly class CompletedOrder
final readonly class SuccessfulPayment
final readonly class PublishedArticle

// ❌ Avoid
final readonly class UserEntity       // Technical-oriented
final readonly class OrderResult      // Result-oriented
```

## Property Naming

### Properties as Semantic Variables
Property names are automatically linked to the semantic variable system:

```php
// Property names automatically map to semantic variable classes
#[Input] string $emailAddress    // → EmailAddress semantic variable
#[Input] string $userName        // → UserName semantic variable
#[Input] int $age               // → Age semantic variable
```

### Being Property
**Pattern**: `$being`
**Purpose**: Represents the object's next existential state

```php
public SuccessfulPayment|FailedPayment $being;
public ActiveUser|SuspendedUser $being;
```

## Method Naming Principles

### Traditional methods do not exist in Be Framework

```php
// ❌ Traditional OOP style (avoid)
class User {
    public function validate() { }
    public function save() { }
    public function delete() { }
}

// ✅ Be Framework style
final readonly class ValidatedUser {
    public function __construct(UserInput $input) {
        // Validation is executed as a precondition for existence
    }
}
```

## Variable Naming

### Local Variables
Use names that reflect existential state:

```php
// ✅ Correct
$validatedInput = new ValidatedUserInput($rawInput);
$authenticatedUser = new AuthenticatedUser($validatedInput);
$finalUser = $authenticatedUser->being;

// ❌ Avoid
$result = validateUser($input);     // Action-oriented
$data = processInput($rawInput);    // Too generic
```

### Dependency Injection
**Pattern**: `{InterfaceName}` (no Service suffix)

```php
final readonly class AuthenticatedUser {
    public function __construct(
        #[Input] UserInput $input,
        #[Inject] PasswordHasher $hasher,        // ✅ As capability
        #[Inject] UserRepository $repository     // ✅ As repository
    ) {}
}
```

## File and Directory Structure

### Semantic Variables
**Location**: `src/Domain/SemanticVariable/`
**Naming**: Word combinations, PascalCase

```txt
src/Domain/SemanticVariable/
├── EmailAddress.php
├── UserName.php
├── ProductCode.php
└── PaymentAmount.php
```

### Domain Objects
**Location**: `src/Domain/`
**Naming**: Reflects existential state

```txt
src/Domain/
├── User/
│   ├── UserInput.php
│   ├── ValidatedUser.php
│   └── RegisteredUser.php
└── Order/
    ├── OrderInput.php
    ├── ProcessedOrder.php
    └── CompletedOrder.php
```

## Philosophical Naming Principles

### 1. Existence First
```php
// Express existence, not action
final readonly class DeletedUser    // ✅ Existence of deleted state
final readonly class UserDeleter    // ❌ Action of deleting
```

### 2. Temporal Direction
```php
// Express the natural flow of metamorphosis
$input → $validated → $authenticated → $registered
```

### 3. Semantic Completeness
```php
// Names carry constraints
string $emailAddress      // Must be a valid email address
int $age                 // Negative values cannot exist
```
