<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Named fields

A value is named where it is given. When a function takes several values by
position, especially of one type, the call site holds values whose meaning only
the definition knows.

## Why it costs the reader

The reader has to open the definition to learn the order, and a swapped pair
still runs. An empty value or a bare literal in a slot means something only the
definition knows. The same group of values then tends to travel together
through other signatures, each repeating the order.

## How to spot it

- Two or more parameters of one type in a row.
- Empty values or literals passed to mean "not given" or to pick an option.
- The same three or four values passed together to several functions.
- A constructor that only copies its arguments into fields and validates them.

## The move

Gather the values into one type with named fields, and let the caller name each
one where it is given, through named arguments, a record literal or a parameter
object, whichever the language offers. An absent value is left out, and
validation becomes a method the caller runs when it wants the errors. The group
gets a name, and functions that took the group take that.

## Example

Before, three strings and a boolean, and no hint of which is which:

```text
user = createUser("Ada", "ada@example.com", "", true)
```

After:

```text
user = User { name: "Ada", email: "ada@example.com", admin: true }
problems = user.problems()
```

## Sources

- Clean Code, chapter 3, "Function Arguments", and chapter 17, F1.
- [Long Parameter List](https://refactoring.guru/smells/long-parameter-list)
  and [Data Clumps](https://refactoring.guru/smells/data-clumps), through
  Introduce Parameter Object.
