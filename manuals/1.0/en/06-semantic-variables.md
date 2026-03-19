---
layout: docs-en
title: "7. Semantic Variables"
category: Manual
permalink: /manuals/1.0/en/06-semantic-variables.html
---

# Semantic Variables

> "What exists necessarily exists, and what does not exist necessarily does not exist"
>
> —Spinoza, *Ethics*, Part I, Proposition 29 (1677)

## Meaning and Constraints

`$email` is not just a string. A semantic variable is an identifier of information—it expresses meaning and carries constraints as a complete information model:

```php
final class Email
{
    #[Validate]
    public function validate(string $email): void
    {
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new InvalidEmailException();
        }
    }
}

// Automatically applied to any constructor argument named $email
public function __construct(string $email) {}
```

Define it once, and it automatically applies to every constructor parameter named `$email`. The value in `$email` is not correct by accident—it is correct by necessity. What cannot be correct simply cannot exist.

## Decorating Names

Adding attributes to the same name refines the conditions for existence. When a `#[Validate]` method has an attribute on its parameter, it only executes when the constructor argument has a matching attribute:

```php
// Basic $age constraint (0–150 years)
final readonly class Age
{
    #[Validate]
    public function validate(int $age): void
    {
        if ($age < 0 || $age > 150) {
            throw new InvalidAgeException();
        }
    }

    // Only executed when #[Teen] attribute is present
    #[Validate]
    public function validateTeen(#[Teen] int $age): void
    {
        if ($age < 13 || $age > 19) {
            throw new InvalidTeenAgeException();
        }
    }
}
```

```php
// Only basic Age validation applied
public function __construct(int $age) {}

// Both Age + Teen validation applied
public function __construct(#[Teen] int $age) {}
```

The same `$age` gets different existential conditions depending on its attributes.

## Names as Relations

Semantic variables hold not only individual constraints but also relationships between variables. When a `#[Validate]` method's parameter names partially match a constructor's parameter names, the corresponding values are automatically passed:

```php
// Email address confirmation match
final readonly class EmailConfirmation
{
    #[Validate]
    public function validate(string $email, string $confirmEmail): void
    {
        if ($email !== $confirmEmail) {
            throw new EmailMismatchException();
        }
    }
}
```

```php
// Start date must be before end date
final readonly class DateRange
{
    #[Validate]
    public function validate(string $startDate, string $endDate): void
    {
        if ($startDate > $endDate) {
            throw new InvalidDateRangeException();
        }
    }
}
```

```php
// Minimum must not exceed maximum
final readonly class MinMax
{
    #[Validate]
    public function validate(int $min, int $max): void
    {
        if ($min > $max) {
            throw new MinExceedsMaxException();
        }
    }
}
```

Define once, and they are automatically applied to any constructor whose argument names match:

```php
// EmailConfirmation + MinMax auto-applied
public function __construct(
    string $email,
    string $confirmEmail,
    int $min,
    int $max,
) {}
```

```php
// DateRange auto-applied
public function __construct(
    string $startDate,
    string $endDate,
) {}
```

## Constraints Dwell in Names

The power of names extends beyond format validation:

```php
public function __construct(
    public string $email,          // Format constraint
    public float $bodyTemperature, // Value range constraint
    public string $inStockItemId,  // Business rule constraint
) {}
```

From formats to value ranges to business rules—names define the conditions for existence.

## The Meaning of Failure

When existence fails, the reason must carry meaning:

```php
#[Message([
    'en' => '{email} is not a valid email address.',
    'ja' => '{email}は有効なメールアドレスではありません。'
])]
final readonly class InvalidEmailException extends DomainException
{
    public function __construct(public readonly string $email) {}
}
```

The framework does not stop at the first exception—it collects **all validation errors**:

```php
try {
    $becoming(new UserRegistrationInput(
        name: '',           // EmptyNameException
        email: 'invalid',   // InvalidEmailException
        age: -1             // InvalidAgeException
    ));
} catch (SemanticVariableException $e) {
    $e->getErrors()->getMessages('ja');
    // ['名前は空にできません。', '無効なメールアドレスです。', '無効な年齢です。']
}
```

The complete reason why existence is impossible becomes clear, in the user's language.

In Japan, there is a concept called *kotodama*—the belief that words hold a spiritual power to define reality. Semantic variables are exactly this: the meaning embedded in names supports the integrity of the entire system.

---

Objects know their own next transformation. The mechanism, [Type-Driven Metamorphosis](./07-type-driven-metamorphosis.html) ➡️
