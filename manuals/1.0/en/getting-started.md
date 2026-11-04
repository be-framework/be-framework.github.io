---
layout: docs-en
title: "Getting Started"
category: Manual
permalink: /manuals/1.0/en/getting-started.html
---

# Getting Started

> Now that you've learned the concepts, let's put them into practice.

## Requirements

- PHP 8.4+
- Composer

## Installation

```bash
composer create-project be-framework/skeleton my-project --stability dev
cd my-project
```

## Run the Example

```bash
composer dev
```

Output:

```txt
Hello World
```

That's it! Let's look at the code.

## Project Structure

```
bin/
└── be.php                  # CLI entrypoint
src/
├── Input/
│   └── HelloInput.php      # Starting point
├── Final/
│   └── Hello.php           # Destination
├── Reason/
│   └── Greeting.php        # Transcendent capability
├── Semantic/
│   └── Name.php            # Semantic variables
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

The `#[Be]` attribute declares the **destiny**—what this input will become. It accepts a single class or an array of candidates; the array form is used here so that adding a second destiny later is a one-line change.

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
$becoming = $injector->getInstance(BecomingInterface::class);

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

`composer dev` runs `php bin/be.php 'hello?name=World'`. Pass an empty name this time:

```bash
php bin/be.php 'hello?name='
```

Output:

```txt
名前は空にできません。
```

`Semantic/Name.php` declares that a `$name` cannot be empty, so `HelloInput('')` never comes into existence. The message comes from the `#[Message]` attribute on `EmptyNameException`; `bin/be.php` prints its Japanese version.

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
- [Semantic Variables](./06-semantic-variables.html) - Domain ontology
