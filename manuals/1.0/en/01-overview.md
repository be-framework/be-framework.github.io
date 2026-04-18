---
layout: docs-en
title: "Overview"
category: Manual
permalink: /manuals/1.0/en/01-overview.html
---

# Overview

> "Becoming the self you want to be"
> Be Framework is a framework for objects to transform into the self they want to be, by their own will.

Marcel Proust said:
> The real voyage of discovery consists not in seeking new landscapes, but in having new eyes.
>
> —Marcel Proust, 'The Prisoner' (In Search of Lost Time, Volume 5) 1923

## From Doing to Being

First, look at this:

```php
// Traditional way to delete a user
$user = User::find($id);
$user->delete();

// A different way to delete a user
$activeUser = User::find($id);
$deletedUser = new DeletedUser($activeUser);
```

You might think, "DeletedUser? What is that?"

This question is the entrance to a new world of programming. Let's think about programming in a way you have never thought of before.

## From 'What to Do' to 'What to Be'

Traditional programming focuses on DOING (what to do):
```php
$user->validate();
$user->save();
$user->notify();
```

Be Framework focuses on BEING (what to be):
```php
$userInput = new UserInput($name, $email);
$validatedUser = new ValidatedUser($userInput);
$savedUser = new SavedUser($validatedUser);
```

The former instructs objects "what to do".
The latter expresses "what state the object will become".

## Why This Matters

When focusing on DOING:
- You need to check "Is this action possible?" every time before execution
- You have to deal with various error cases
- Processing to prevent invalid states is always necessary

When focusing on BEING:
- Invalid state objects simply do not exist from the beginning
- The existence of the object itself becomes the proof of "correct state"
- You can focus only on what you can do at that time. What you cannot do is simply not executable

The difference lies in the type itself:
```php
// Traditional: Generic type
function processUser(User $user) { }

// Be Framework: Specific state of being
function processUser(ValidatedUser $user) { }
function saveUser(SavedUser $user) { }
function archiveUser(DeletedUser $user) { }
```

Each type is not just data, but expresses a specific state of the object. In other words, the temporal change of the object is represented by the type, and you can only do what is possible at that time. For example, you cannot order a non-existent object to be deleted.

## Why Not a "Controller"?

The "Controller" in traditional MVC frameworks aims for "control and domination" as its name suggests. However, as systems become complex, this "approach of trying to control everything" becomes difficult.

A Controller has "omnipotent freedom" to access all models and components, but having no constraints means implicitly bearing "infinite responsibility" to control and maintain consistency for every procedure in the system by itself.

Be Framework adopts a different approach. Rather than operations creating the target data, simple input objects like seeds meet other objects, grow naturally, and "transform themselves (Metamorphosis)" into the target final objects.

### Commander to Gardener:
* The Commander orders subordinates (objects) to "Move!". But it is impossible to keep ordering all complex autonomous movements.
* The Gardener does not order plants. They only prepare the environment like water and light.

Plants care only about their own transformation. They do not try to change others, but accept the environment and transform themselves autonomously (Metamorphosis) to become what they should be. Be Framework also prepares an environment where, once given input, objects become final objects by themselves. Let go of control and entrust to autonomous transformation. This is the core concept of Be Framework.

## What You Will Learn in This Manual

You can acquire the following new programming methods:

1. Design "what to be" instead of "what to do"
2. Make it impossible to create invalid states from the beginning instead of checking them
3. Express natural transformation (self-metamorphosis) instead of forcing objects to change
4. Trust the correct state instead of preventing errors

## So Why "DeletedUser"?

Now back to the opening question. `new DeletedUser($activeUser)` is not an action—it is a transformation. The user is not "being deleted"; a new existence called `DeletedUser` is born from `$activeUser`. The type itself proves that deletion has occurred. There is no need to check a `$status` flag, no risk of calling methods on an already-deleted user. This is the essence of Be Framework: **express state transitions as new types, not as actions on existing objects.**

## Let's Get Started

**Want to try it first?** Jump to the [Getting Started]({{ '/manuals/1.0/en/getting-started.html' | relative_url }}) guide for a hands-on Hello World, or the [Tutorial]({{ '/manuals/1.0/en/tutorial.html' | relative_url }}) for a real-world example.

**Want to understand the concepts?** Continue to [Input Classes]({{ '/manuals/1.0/en/02-input-classes.html' | relative_url }}) to learn the foundations step by step →
