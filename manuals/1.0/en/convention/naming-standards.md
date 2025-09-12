# Be Framework Naming Standards

> Code as philosophy: names that reflect existence, not actions

This document establishes naming conventions that align with Be Framework's ontological programming principles, ensuring code that expresses **being** rather than **doing**.

## Core Philosophy

**"Objects don't do things—they become what they are meant to be"**

Our naming reflects this fundamental shift from imperative to existential thinking:
- From **action-oriented** names → **existence-oriented** names
- From **what it does** → **what it is**
- From **controlling** → **being**

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
final readonly class UserCommand       // Imperative thinking
```

### Being Classes
**Pattern**: `Being{Domain}` or `{Domain}Being`
**Purpose**: Intermediate transformation stages where objects discover their nature

```php
// ✅ Correct - Being prefix (recommended)
final readonly class BeingUser
final readonly class BeingOrder
final readonly class BeingData
final readonly class BeingPayment

// ✅ Acceptable - Being suffix
final readonly class UserBeing
final readonly class OrderBeing

// ❌ Avoid
final readonly class UserValidator     // Action-oriented
final readonly class OrderProcessor    // What it does, not what it is
final readonly class DataTransformer   // Imperative thinking
```

### Final Objects
**Pattern**: Domain-specific result names expressing final state
**Purpose**: Complete transformed beings representing successful completion

```php
// ✅ Correct - State of being
final readonly class ValidatedUser
final readonly class ProcessedOrder
final readonly class Success
final readonly class Failure
final readonly class ApprovedLoan
final readonly class RejectedApplication

// ❌ Avoid  
final readonly class UserResponse      // Implementation detail
final readonly class OrderResult       // Generic
final readonly class ProcessingOutput  // Action-oriented
```

## Property Naming

### Being Property
**Pattern**: `public {Type1}|{Type2} $being;`
**Purpose**: Carries the object's destiny through union types

```php
// ✅ Correct
public Success|Failure $being;
public ValidUser|InvalidUser $being;
public ApprovedLoan|RejectedLoan $being;

// ❌ Avoid
public mixed $result;      // Not type-specific
public object $outcome;    // Too generic
public array $data;        // Action-oriented
```

### Immanent Properties
**Pattern**: Descriptive names reflecting inherent identity
**Purpose**: What the object already is

```php
// ✅ Correct
public string $email;
public Money $amount;
public UserId $userId;
public \DateTimeImmutable $timestamp;

// ❌ Avoid
public string $inputEmail;    // Redundant prefix
public Money $requestAmount;  // Action-oriented
```

## Parameter Naming

### Constructor Parameters
**Pattern**: Match property names for Immanent, descriptive for Transcendent

```php
// ✅ Correct
public function __construct(
    #[Input] string $email,              // Immanent - matches property
    #[Input] Money $amount,              // Immanent - matches property  
    #[Inject] EmailValidator $validator, // Transcendent - capability
    #[Inject] PaymentGateway $gateway    // Transcendent - external service
) {}

// ❌ Avoid
public function __construct(
    #[Input] string $userEmail,          // Different from property name
    #[Input] Money $inputAmount,         // Redundant prefix
    #[Inject] object $emailChecker,      // Not descriptive
    #[Inject] mixed $paymentService      // Not type-specific
) {}
```

## Attribute Usage

### Be Attribute
**Pattern**: `#[Be(DestinyClass::class)]` or `#[Be([Option1::class, Option2::class])]`

```php
// ✅ Single destiny
#[Be(BeingUser::class)]
final readonly class UserInput

// ✅ Multiple destinies  
#[Be([ValidatedUser::class, InvalidUser::class])]
final readonly class BeingUser

// ❌ Avoid
#[Be(UserProcessor::class)]    // Action-oriented
#[Be(HandleUser::class)]       // Imperative
```

### Input/Inject Comments
**Pattern**: Always include philosophical comments

```php
// ✅ Correct
public function __construct(
    #[Input] string $email,                // Immanent
    #[Inject] EmailValidator $validator    // Transcendent
) {}

// ❌ Missing philosophy
public function __construct(
    #[Input] string $email,
    #[Inject] EmailValidator $validator
) {}
```

## Domain-Specific Examples

### E-commerce Domain
```php
// Input → Being → Final
ProductInput → BeingProduct → [ValidProduct, InvalidProduct]
OrderInput → BeingOrder → [ProcessedOrder, FailedOrder]  
PaymentInput → BeingPayment → [SuccessfulPayment, DeclinedPayment]
```

### User Management Domain
```php
// Input → Being → Final  
UserInput → BeingUser → [RegisteredUser, ConflictingUser]
LoginInput → BeingLogin → [AuthenticatedUser, FailedAuthentication]
ProfileInput → BeingProfile → [UpdatedProfile, InvalidProfile]
```

### Data Processing Domain
```php
// Input → Being → Final
DataInput → BeingData → [ProcessedData, CorruptedData]
FileInput → BeingFile → [ValidatedFile, InvalidFile]
ConfigInput → BeingConfig → [LoadedConfig, MalformedConfig]
```

## Anti-Patterns to Avoid

### Imperative Naming
```php
// ❌ Action-oriented
ProcessUser, ValidateOrder, TransformData
CreatePayment, HandleRequest, ExecuteCommand

// ✅ Being-oriented  
BeingUser, BeingOrder, BeingData
BeingPayment, BeingRequest, BeingCommand
```

### Generic Naming
```php
// ❌ Too generic
Handler, Processor, Manager, Service, Util

// ✅ Specific and meaningful
BeingUser, ValidatedOrder, ProcessedPayment
```

### Technical Implementation Details
```php
// ❌ Implementation-focused
UserDTO, OrderVO, PaymentPOJO, DataObject

// ✅ Domain-focused
UserInput, BeingOrder, ProcessedPayment
```

## Naming Checklist

Before naming any class, ask:

1. **Existence Question**: "What does this object *be* rather than *do*?"
2. **Stage Question**: "What stage of metamorphosis does this represent?"
3. **Philosophy Question**: "Does this name reflect ontological thinking?"
4. **Clarity Question**: "Will developers understand the object's nature?"
5. **Consistency Question**: "Does this follow our established patterns?"

## Evolution of Names

As your understanding of the domain deepens, names may evolve:

```php
// Initial understanding
UserValidator → 

// Deeper understanding  
BeingUser →

// Full ontological clarity
BeingUser // with clear Immanent/Transcendent distinction
```

---

*"In Be Framework, names are not labels—they are declarations of existence. Choose them as carefully as you would choose words in poetry, for they shape how we think about the reality we create."*