<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Comments a type could replace

What a value is, and when a field applies, belongs in its type. A comment that
says either one is doing a type's job without a type's reach.

## Why it costs the reader

The comment sits on the declaration, and the reader meets the value somewhere
else. A type travels with the value to every place it is used, and the
compiler or the runtime holds callers to it. A comment holds no one, and it
drifts the first time the code changes without it.

## How to spot it

- Field comments that say which mode or caller fills the field.
- A result type that one path fills half of and another path fills the other
  half.
- Comments that give a plain number or string a unit or a format.
- A wish to drop the comments for a more expressive type.

## The move

When a comment says when a field applies, split the type, one per case, each
with only the fields that case fills. When a comment gives a value a unit or a
format, name it as a type and use that type everywhere the value appears. Then
delete the comment.

Give a type only as much as it means. A type that states a unit or a rule the
plain value beside it doesn't earns its place. One that wraps a value and holds
no rule only repeats the field name, and makes the reader look for structure
behind it that isn't there.

## Example

Before, one shipment type serves two ways of handing over an order:

```text
type Shipment {
    // Set only when the order is delivered.
    trackingNumber: Text
    // Set only when the customer collects the order.
    pickupCode: Text
    // Grams.
    weight: Integer
}
```

After, each way has its own type, and the weight says its unit:

```text
type Delivery {
    trackingNumber: Text
    weight: Weight
}

type Pickup {
    pickupCode: Text
    weight: Weight
}
```

## Sources

- Clean Code, chapter 4, "Explain Yourself in Code", and chapter 17, G28.
- [Comments](https://refactoring.guru/smells/comments) and
  [Primitive Obsession](https://refactoring.guru/smells/primitive-obsession).
