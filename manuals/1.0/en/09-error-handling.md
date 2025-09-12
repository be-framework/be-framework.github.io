---
layout: docs-en
title: "9. Error Handling"
category: Manual
permalink: /manuals/1.0/en/09-error-handling.html
---

# Error Handling

> "I have not failed. I've just found 10,000 ways that won't work"
>
> 　　—Thomas Edison (1847-1931)

## Meaningful Failures

In Be Framework, errors are not mere "failures" but **specific reasons why existence is impossible**. We use semantic exceptions instead of generic ones:

```php
// Traditional generic error
catch (Exception $e) {
    echo $e->getMessage();  // "Validation failed"
}

// Semantic exceptions
catch (SemanticVariableException $e) {
    foreach ($e->getErrors()->exceptions as $exception) {
        echo get_class($exception) . ": " . $exception->getMessage();
        // EmptyNameException: Name cannot be empty
        // InvalidEmailException: Invalid email format
    }
}
```

## Domain Exception Classes

In Be Framework, all exceptions inherit from `DomainException`:

```php
abstract class DomainException extends Exception {}

final class EmptyNameException extends DomainException {}

final class InvalidEmailException extends DomainException
{
    public function __construct(public readonly string $invalidEmail)
    {
        parent::__construct("Invalid email format: {$invalidEmail}");
    }
}

final class AgeTooYoungException extends DomainException
{
    public function __construct(public readonly int $age, public readonly int $min = 13)
    {
        parent::__construct("Age insufficient: {$age} years (minimum {$min} years)");
    }
}
```

Since all exceptions are domain exceptions, technical exceptions (`RuntimeException`, `InvalidArgumentException`, etc.) are not used. Failures are always expressed as **failures with domain meaning**.

Domain exceptions hold not just messages but **structured data**. From the `$invalidEmail` property, programs can access the invalid email address value and utilize it for various purposes: human-readable display, API JSON responses, AI analysis, etc.

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

## Multilingual Error Messages

The `#[Message]` attribute enables multilingual error messages:

```php
#[Message([
    'en' => 'Name cannot be empty.',
    'ja' => '名前は空にできません。',
    'es' => 'El nombre no puede estar vacío.'
])]
final class EmptyNameException extends DomainException {}

#[Message([
    'en' => 'Age must be at least {min} years.',
    'ja' => '年齢は最低{min}歳でなければなりません。'
])]
final class AgeTooYoungException extends DomainException
{
    public function __construct(public readonly int $min = 13) {}
}
```

## Automatic Collection of All Errors

The framework collects **all validation errors** before throwing an exception:

```php
try {
    $user = $becoming(new UserInput('', 'invalid-email', 10));
} catch (SemanticVariableException $e) {
    // Three errors are collected simultaneously:
    // - EmptyNameException
    // - InvalidEmailException  
    // - AgeTooYoungException
    
    $messages = $e->getErrors()->getMessages('en');
    // ["Name cannot be empty", "Invalid email format", "Age must be at least 13"]
}
```

Rather than "stop at first error", you can **understand all problems at once**.

## Metamorphosis Including Errors

Error states can also be treated as valid metamorphosis results:

```php
#[Be([ValidUser::class, InvalidUser::class])]
final class UserValidation
{
    public readonly ValidUser|InvalidUser $being;
    
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

Errors can be expressed as types rather than stopping execution with exceptions.

Semantic exceptions make failure reasons clear, enabling users to understand specific correction methods. Error handling changes from problem reporting to **guidance toward problem resolution**.

---

**Next**: Learn about the evolution of programming paradigms in [From Doing to Being](10-from-doing-to-being-final.html).

*"Semantic exceptions specifically teach us why existence is impossible."*
