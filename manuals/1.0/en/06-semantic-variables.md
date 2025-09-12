---
layout: docs-en
title: "6. Semantic Variables"
category: Manual
permalink: /manuals/1.0/en/06-semantic-variables.html
---

# Semantic Variables

> "What exists necessarily exists, and what does not exist necessarily does not exist"
>
> 　　—Spinoza, *Ethics*, Part I, Proposition 29 (1677)

Where should data validity be guaranteed? Controller? Model? Validator?

Be Framework's answer is clear: **names themselves should carry constraints**.
`$email` should not be just a string—it should be a **valid email address**. `$age` cannot have negative values.

Semantic Variables are identifiers of information that express meaning and hold constraints—they are **complete information models**.

## The Problem: Scattered Incompleteness

Traditional approaches scatter the definition of meaning across multiple locations:

```php
// Controllers/models/validators...
if (empty($name)) throw new Exception("error.name.empty");
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) throw new Exception("error.email.invalid");

// messages/en.yml
error.name.empty: "Name is required"
error.email.invalid: "Please enter a valid email address"

// README.md
// "Name must be 1-100 characters, whitespace-only not allowed..."
```

The following problems occur:
- **Validation**: Scattered across controllers
- **Error messages**: Managed in separate files
- **Constraint rules**: Duplicated in multiple places
- **Meaning definition**: Exists only in documentation

There is no central place to see the meanings that the system handles.

## The Solution: Semantic Completeness

Be Framework integrates scattered definitions into **complete information models**. Constructor arguments and class properties can only use registered **semantic variables**.

## Defining Existence

Semantic variables are defined as classes in dedicated folders:

```php
final class Name
{
    #[Validate]
    public function validate(string $name): void
    {
        if (empty(trim($name))) {
            throw new EmptyNameException();
        }
    }
}
```

## Validation Contexts

Different business contexts may require different rules. Semantic variables naturally support multiple validation contexts:

```php
final class ProductCode
{
    #[Validate]
    public function validate(string $code): void 
    { 
        // Standard product code validation (e.g., 8-digit alphanumeric)
        if (!preg_match('/^[A-Z0-9]{8}$/', $code)) {
            throw new InvalidProductCodeException();
        }
    }

    #[Validate] 
    public function validateLegacy(#[Legacy] string $code): void 
    { 
        // Relaxed validation for legacy systems (e.g., 6-10 digit alphanumeric)
        if (!preg_match('/^[A-Z0-9]{6,10}$/', $code)) {
            throw new InvalidLegacyProductCodeException();
        }
    }

    #[Validate]
    public function validatePremium(#[Premium] string $code): void 
    { 
        // Strict validation for premium products (e.g., specific prefix required)
        if (!preg_match('/^PREM[A-Z0-9]{4}$/', $code)) {
            throw new InvalidPremiumProductCodeException();
        }
    }
}
```

## The Meaning of Failure

When existence fails, the meaning of failure must be preserved:

```php
#[Message([
    'en' => 'Name cannot be empty.',
    'ja' => '名前は空にできません。'
])]
final class EmptyNameException extends DomainException {}
```

The framework collects not just the first thrown exception but **all validation errors** as a collection of exceptions, creating complete understanding of why existence is impossible.

## Natural Integration

Semantic variables work automatically in constructors:

```php
final readonly class UserProfile
{
    public function __construct(
        #[Input] #[English] public string $name,    // Auto-validated as English name
        #[Input] string $emailAddress,              // Auto-validated as email address
        #[Inject] NameFormatter $formatter
    ) {
        // At this point, all inputs are guaranteed valid
    }
}
```

The variable name `$name` is automatically associated with the `Name` semantic variable class, and `$emailAddress` with the `EmailAddress` semantic variable class.

## Hierarchical Validation

Semantic variables can build upon other semantic variables. This is a powerful technique for expressing the natural hierarchical structure of business rules in the type system.

```php
final class TeenAge  
{
    #[Validate]
    public function validate(#[Teen] int $age): void
    {
        // First, basic Age validation is executed (automatically called via #[Teen])
        // Then, teen-specific rules are added
        if ($age < 13) throw new TeenAgeTooYoungException();
        if ($age > 19) throw new TeenAgeTooOldException();
    }
}
```

This hierarchical approach builds rich semantic hierarchies:

- `Email` → `CorporateEmail` (corporate domain required) → `ExecutiveEmail` (executive-level constraints)
- `Price` → `DiscountPrice` (discount rate limits) → `MemberPrice` (member pricing rules)
- `Password` → `AdminPassword` (admin requirements) → `SystemPassword` (strict system admin requirements)
- `Address` → `ShippingAddress` (deliverable regions) → `InternationalAddress` (international shipping support)

Each layer inherits constraints from the previous layer and adds its own unique constraints. Nothing that fails basic `Email` validation can ever exist as `ExecutiveEmail`. This is not merely a combination of validations—it is the **natural refinement of concepts**.

## Relationship Constraints

Semantic variables exist not only in isolation but can also hold relationships with other semantic variables as constraints. What's remarkable is **how easy this is to describe**:

```php
final readonly class UserRegistration
{
    public function __construct(
        #[Input] string $email,
        #[Input] string $confirmEmail,
        #[Input] string $password,
        #[Input] string $confirmPassword,
    ) {
        // Nothing needs to be written here!
        // The framework automatically validates relationships
    }
}
```

The framework automatically discovers and applies validation classes that **partially match** the target constructor's signature.

```php
// If this exists...
final class EmailConfirmation
{
    #[Validate]
    public function validate(string $email, string $confirmEmail): void
    {
        if ($email !== $confirmEmail) {
            throw new EmailMismatchException();
        }
    }
}

// It's automatically applied to any constructor with $email, $confirmEmail!
```

Examples of relationship constraints:
- `$startDate` and `$endDate`: Start date must be before end date
- `$minPrice` and `$maxPrice`: Minimum price must be less than or equal to maximum price
- `$email` and `$confirmEmail`: Email address confirmation match required
- `$currentPassword` and `$newPassword`: New password must differ from current one

Developers define business rules once, and they're automatically applied to all objects with matching signatures. These constraints function as **preconditions** for object existence. Unless preconditions are met, that object cannot even exist.

## Error Handling

Multilingual error messages adapt automatically:

```php
try {
    $userProfile = $becoming(new UserRegistrationInput($data));
} catch (SemanticVariableException $e) {
    $englishMessages = $e->getErrors()->getMessages('en');
    $japaneseMessages = $e->getErrors()->getMessages('ja');
}
```

## What Meaning Brings

**Names are identifiers of meaning and constraints.** This simple principle alone realizes a world rich enough to be called a framework.

Semantic Variables make **impossible states impossible**. Invalid email addresses cannot exist as `$email`, negative ages cannot be born as `$age`. Out-of-stock products cannot be ordered as `$orderId`, and addresses outside delivery zones cannot be specified as `$shippingAddress`.

The type system itself becomes a **domain language**, where each type speaks of what can exist in your business domain.

## Design by Contract

Constructor arguments reveal preconditions. Properties reveal postconditions:

```php
final class ProcessedOrder
{
    public function __construct(
        #[Input] string $productCode,    // Precondition: valid product code
        #[Input] int $paymentAmount,     // Precondition: positive amount
        #[Input] int $customerAge        // Precondition: valid age
    ) {
        // Can only exist when preconditions are satisfied
        $this->orderNumber = $this->generateOrderNumber();
        $this->processedAt = new DateTime();
    }
    
    public readonly string $orderNumber;    // Postcondition: order number always exists
    public readonly DateTime $processedAt;  // Postcondition: processed time always exists
}
```

Constructor arguments express **preconditions** (conditions that must be satisfied for this object to exist), while `public readonly` properties express **postconditions** (states this object guarantees).

Defensive programming becomes unnecessary. Argument validation, null checks, range verification, inventory confirmation, geographic constraints—semantic variables guarantee all of these. Code can focus on its true purpose: implementing business logic.

What began as a simple naming convention evolves into hierarchical validation, relationship constraints, external resource integration, building a complete domain guarantee system. **The meaning embedded in names supports the integrity of the entire system.**

---

**Next**: Learn about [Type-Driven Metamorphosis](07-type-driven-metamorphosis.html) where objects discover their own nature.

*"Semantic Variables don't just validate data—they ensure only meaningful beings can exist."*
