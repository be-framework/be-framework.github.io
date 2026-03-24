---
layout: docs-en
title: "Semantic Variables"
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
// Format validation — email address confirmation match
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
// Ordering — start date must be before end date
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
// External service — zip code and prefecture consistency
final readonly class ZipPrefecture
{
    public function __construct(
        private ZipResolver $resolver   // Injected via DI
    ) {}

    #[Validate]
    public function validate(string $zipCode, string $prefecture): void
    {
        if (!$this->resolver->matches($zipCode, $prefecture)) {
            throw new ZipPrefectureMismatchException();
        }
    }
}
```

Define once, and they are automatically applied to any constructor whose argument names match:

```php
// EmailConfirmation + DateRange auto-applied
public function __construct(
    string $email,
    string $confirmEmail,
    string $startDate,
    string $endDate,
) {}
```

```php
// ZipPrefecture auto-applied
public function __construct(
    string $zipCode,
    string $prefecture,
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

When constraints dwelling in names are violated, existence fails. Learn how to handle this in [Semantic Exceptions](./09-error-handling.html).

---

No existence exists without reason. [Reason Layer](./08-reason-layer.html) ➡️
