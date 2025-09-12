---
layout: docs-en
title: "10. Semantic Logging"
category: Manual
permalink: /manuals/1.0/en/10-semantic-logging.html
---

# Semantic Logging

## Overview

Be Framework implements **semantic logging** functionality that automatically records object metamorphosis processes as structured logs.

### Basic Concept

**Traditional Logs**: Fragmented event records  
**Semantic Logs**: Complete metamorphosis story records of objects

```php
// Object metamorphosis...
#[Be(RegisteredUser::class)]
final class UserInput { /* ... */ }

final class RegisteredUser { /* ... */ }

// Automatically recorded as structured logs
{
  "metamorphosis": {
    "from": "UserInput",
    "to": "RegisteredUser",
    // Complete metamorphosis information...
  }
}
```

## Technical Foundation

Integrated with [Koriym.SemanticLogger](https://github.com/koriym/Koriym.SemanticLogger):

- **Type-safe structured logging**
- **Open/Event/Close pattern**
- **JSON schema validation**
- **Hierarchical operation tracking**

## Value Provided

### Development & Debugging
Complete tracking of object metamorphosis makes it easy to understand complex processing flows and identify problems.

### Audit & Compliance
Since all metamorphoses are recorded as structured data, complete audit trails can be provided.

### System Analysis
Analysis of object growth patterns and processing efficiency becomes possible.

---

**Detailed usage methods, configuration examples, and practical samples will be documented at a later date.**