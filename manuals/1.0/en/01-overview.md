---
layout: docs-en
title: "1. Overview"
category: Manual
permalink: /manuals/1.0/en/01-overview.html
---
# Overview

> "The real voyage of discovery consists not in seeking new landscapes, but in having new eyes."
> 
> —Marcel Proust, 'The Prisoner' (In Search of Lost Time, Volume 5) 1923

## A Different Way to Think About Code

First, Look at This.

```php
// Traditional way to delete a user
$user = User::find($id);
$user->delete();

// A different way to delete a user
$activeUser = User::find($id);
$deletedUser = new DeletedUser($activeUser);
```

**`DeletedUser`?** What is that?

This question is your doorway into a new world of programming—one that invites you to think in **a completely different way**.

## From What to Do to What to Be

Traditional programming focuses on **DOING (actions)**:
```php
$user->validate();
$user->save();
$user->notify();
```

Be Framework focuses on **BEING (existence)**:
```php
$rawData = new UserInput($_POST);
$validatedUser = new ValidatedUser($rawData);
$savedUser = new SavedUser($validatedUser);
```

One tells objects what to DO.
The other defines what they can BE.

## Why This Matters

When you focus on DOING:
- You constantly check if actions are allowed
- You handle endless error cases
- You fight against invalid states

When you focus on BEING:
- Invalid states cannot exist in the first place
- Objects carry their own validity just by existing
- You can only focus on what's actually possible at that moment

The difference is in the types themselves:
```php
// Traditional: general User type
function processUser(User $user) { }

// Be Framework: specific states of being
function processUser(ValidatedUser $user) { }
function saveUser(SavedUser $user) { }
function archiveUser(DeletedUser $user) { }
```

Each type represents a specific stage of existence, not just data. The type system captures the temporal evolution of objects—you cannot delete what does not exist.

## What You'll Learn

This manual will show you how to:

1. **Design "what objects are"** instead of "what they should do"
2. **Make invalid states impossible to create** instead of checking for them
3. **Express natural transformation (self-metamorphosis)** instead of forcing changes
4. **Trust correct states** instead of defending against errors

## Ready?

Let's start with the foundation. Everything begins with [Input Classes]({% link manuals/1.0/en/02-input-classes.md %}) →

You'll build your first Being—and discover why `DeletedUser` makes perfect sense.
