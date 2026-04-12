---
layout: docs-en
title: "Semantic Exceptions"
category: Manual
permalink: /manuals/1.0/en/09-error-handling.html
---

# Semantic Exceptions

> "I have not failed. I've just found 10,000 ways that won't work"
>
> 　　—Thomas Edison (1847-1931)

## Meaningful Failures

Generic exceptions tell **what happened**:

```php
catch (Exception $e) {
    echo $e->getMessage();  // "Validation failed"
}
```

In contrast, semantic exceptions tell **why existence is impossible**:

```php
catch (SemanticVariableException $e) {
    foreach ($e->getErrors()->exceptions as $exception) {
        echo get_class($exception) . ": " . $exception->getMessage();
        // EmptyNameException: Name cannot be empty
        // InvalidEmailException: Invalid email format
    }
}
```

## Domain Exception Classes

All exceptions extend PHP's `\DomainException`. Technical exceptions (`RuntimeException`, `InvalidArgumentException`, etc.) are not used. Failures are always expressed as **failures with domain meaning**:

```php
final readonly class EmptyNameException extends \DomainException {}

final readonly class InvalidEmailException extends \DomainException
{
    public function __construct(public string $invalidEmail)
    {
        parent::__construct("Invalid email format: {$invalidEmail}");
    }
}

// Age-related existence failures
abstract class AgeException extends \DomainException {}
final readonly class NegativeAgeException extends AgeException {}
final readonly class AgeTooHighException extends AgeException {}
```

Domain exceptions hold not just messages but **structured data**. From the `$invalidEmail` property, programs can access the invalid email address value—for display, API responses, logging, and more:

```php
catch (InvalidEmailException $e) {
    $logData = [
        'invalid_email' => $e->invalidEmail,    // Programmatically accessible
        'user_ip' => $request->getClientIp(),
        'timestamp' => now()
    ];
    Logger::warning('Invalid email attempt', $logData);
}
```

## Multilingual Messages

The `#[Message]` attribute lets exceptions speak in the user's language:

```php
#[Message([
    'en' => 'Name cannot be empty.',
    'ja' => '名前は空にできません。',
    'es' => 'El nombre no puede estar vacío.'
])]
final readonly class EmptyNameException extends \DomainException {}

#[Message([
    'en' => 'Age must be at least {min} years.',
    'ja' => '年齢は最低{min}歳でなければなりません。'
])]
final readonly class AgeTooYoungException extends \DomainException
{
    public function __construct(public int $min = 13) {}
}
```

## Error Collection

The framework does not stop at the first error—it collects **all validation errors**:

```php
try {
    $user = $becoming(new UserInput('', 'invalid-email', 10));
} catch (SemanticVariableException $e) {
    // Three errors collected simultaneously:
    // - EmptyNameException
    // - InvalidEmailException
    // - AgeTooYoungException

    $messages = $e->getErrors()->getMessages('en');
    // ["Name cannot be empty", "Invalid email format", "Age must be at least 13"]
}
```

Rather than "fail fast"—**understand all problems at once**.

## Errors as Existence

Error states can be treated as valid metamorphosis results:

```php
#[Be([ValidUser::class, InvalidUser::class])]
final readonly class UserValidation
{
    public ValidUser|InvalidUser $being;

    public function __construct(#[Input] string $data)
    {
        try {
            $this->being = new ValidUser($data);
        } catch (ValidationException $e) {
            $this->being = new InvalidUser($e->getErrors());
        }
    }
}
```

Rather than halting execution with exceptions, errors are expressed as types. Failure, like success, is a legitimate result of transformation.

---

For the full picture, see [Reference](./11-reference-resources.html) ➡️
