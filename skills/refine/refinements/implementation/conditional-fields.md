<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Conditional fields

Every field of a type means something whenever the type exists. A field that
matters only when another field says so, or only during one phase of the
object's life, makes room for states that can't happen.

## Why it costs the reader

The reader has to learn which combinations of fields are real. Every use of the
field carries a guard on its partner, and a use that forgets the guard reads an
empty value as if it were data. A flag named for an event also says little,
since it doesn't say what the event was about.

## How to spot it

- A boolean beside the value it qualifies, saying whether that value is there.
- A field read only inside a condition on another field.
- A field set in one method and read in one other, with the object carrying it
  between them.
- A field that is empty for most of the object's life.
- Fields that must agree with each other, kept in step by hand wherever the
  type is built. Asking where a field gets set is a quick probe: an answer of
  several places, each kept right by convention, is this smell.

## The move

Let the value say whether it is there. An optional type, an empty collection or
a value that means "none" stands for absence, and the guarding flag goes. When
the field belongs to one phase, give that phase its own type, or pass the value
as an argument instead of parking it on the object.

When fields must agree, give the type one constructor per valid shape, so no
caller can build one where they disagree. The impossible states then can't be
written down.

## Example

Before, a flag guards the discount:

```text
type Order {
    discount: Money
    hasDiscount: Boolean
}

if order.hasDiscount
    total = total - order.discount
```

After, the discount is there or it isn't:

```text
type Order {
    discount: Optional Money
}

total = total - order.discount.or(Money.zero)
```

## Sources

- [Temporary Field](https://refactoring.guru/smells/temporary-field).
- Clean Code, chapter 6, "Hybrids": a type that is half record and half object
  pays the costs of both.
