<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Similar attributes

A value is stored once. When two fields hold two views of the same value, they
become one field of a type that offers each view on request.

## Why it costs the reader

The reader has to learn that the two fields are one value, and then trust that
every writer kept them in step. Nothing enforces that. Each caller also picks
one of the two, so the code splits into readers of one view and readers of the
other, and a change to the value has to find both.

## How to spot it

- Fields whose names share a stem, one singular and one plural, or one raw and
  one parsed.
- A constructor or setter that sets both fields from one argument.
- A single item kept beside a list that could hold it as a list of one.
- The question of whether one of the two alone would do.

## The move

Make the value one type that holds what it was made from and offers each view
on request. A single item becomes a list of one. The two fields become one, and
the reader learns one name.

## Example

Before, a reading is stored twice:

```text
type Reading {
    celsius: Number
    fahrenheit: Number
}
```

After, one temperature with two views:

```text
type Reading {
    temperature: Temperature
}

type Temperature {
    celsius(): Number
    fahrenheit(): Number
}
```

## Sources

- Clean Code, chapter 6, "Data Abstraction": expose the concept rather than how
  it is stored.
- [Duplicate Code](https://refactoring.guru/smells/duplicate-code), in its data
  form.
