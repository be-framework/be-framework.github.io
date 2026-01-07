---
layout: docs-en
title: "Getting Started"
category: Manual
permalink: /manuals/1.0/en/getting-started.html
---

# Getting Started

> Now that you understand the philosophy, let's put it into practice.

## Requirements

- PHP 8.4+
- Composer

## Installation

```bash
git clone https://github.com/be-framework/app my-project
cd my-project
rm -rf .git
composer install
```

## Run the Example

```bash
php bin/app.php
```

Output:

```txt
Hello World
```

That's it! Let's look at the code.

## Project Structure

```
src/
├── Input/
│   └── HelloInput.php      # Starting point
├── Final/
│   └── Hello.php           # Destination
├── Reason/
│   └── Greeting.php        # Transcendent capability
├── Semantic/
│   └── Name.php            # What can exist
├── Exception/
│   └── EmptyNameException.php
└── Module/
    └── AppModule.php       # DI configuration
```

## The Code

### Input Class

```php
#[Be([Hello::class])]
final readonly class HelloInput
{
    public function __construct(
        public string $name
    ) {}
}
```

The `#[Be]` attribute declares the **destiny**—what this input will become.

### Final Class

```php
final readonly class Hello
{
    public string $greeting;

    public function __construct(
        #[Input] string $name,
        #[Inject] Greeting $greeting,
    ) {
        $this->greeting = "{$greeting->greeting} {$name}";
    }
}
```

- `#[Input]` receives data from the previous stage (HelloInput)
- `#[Inject]` receives **Transcendence** (capability from outside)

### Reason Class

```php
final class Greeting
{
    public string $greeting = 'Hello';
}
```

The Greeting provides the **transcendent capability**—the power to greet.

### Executing Metamorphosis

```php
$injector = new Injector(new AppModule());
$becoming = new Becoming($injector, 'Be\\App\\Semantic');

$input = new HelloInput('World');
$hello = $becoming($input);

echo $hello->greeting;  // "Hello World"
```

## What Just Happened?

```
HelloInput('World')
    ↓ Becoming executes
Hello (with Greeting injected)
    → "Hello World"
```

The input didn't "do" anything—it **became** Hello through metamorphosis.

## Try Semantic Validation

Edit `bin/app.php` to pass an empty name:

```php
$input = new HelloInput('');
```

Run again:

```bash
php bin/app.php
```

You'll see an error message because `Semantic/Name.php` validates that name cannot be empty.

## Key Concepts Demonstrated

| Concept | In This Example |
|---------|-----------------|
| **Immanence** | `$name` in HelloInput |
| **Transcendence** | `Greeting` injected via `#[Inject]` |
| **Metamorphosis** | HelloInput → Hello transformation |
| **Semantic Validation** | Name.php validates input |

## Next Steps

Ready for a more complete example with Being classes and branching? Continue to [Tutorial](./tutorial.html) →

Or revisit the concepts:
- [Input Classes](./02-input-classes.html) - Starting points
- [Final Objects](./04-final-objects.html) - Destinations
- [Semantic Variables](./06-semantic-variables.html) - Validation
