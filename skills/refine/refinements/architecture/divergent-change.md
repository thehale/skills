<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Divergent change

A module changes for one reason. When it has to change for several unrelated
reasons, it holds several concepts, and each wants a module of its own.

## Why it costs the reader

A reader who comes to a module for one concern has to read past the others to
find it, and can't tell which parts touch which. Every change for one reason
lands beside code that serves another, so a change to one concern risks the
rest. Over time the concerns borrow each other's helpers because they're close
at hand, and the module becomes harder to split the longer it waits.

## How to spot it

- A module whose history changes for reasons that have nothing to do with
  each other.
- A module whose parts would each be described with a different noun.
- Two related objects in one module, such as one built from the other, that
  change for different reasons.
- Groups of functions in one module that never call each other or share data.
- A change for one reason that keeps needing a reviewer who knows another.

## The move

Split the module along its reasons to change, one module per concept, each
named for what it holds. Move each concept's helpers and data with it, and
share only what both genuinely use, in a home of its own. Each new module then
changes for one reason, and a reader who comes for one concern finds only it.

Related isn't the same as one concept. Two objects can belong together in the
domain, one built from the other, and still change for different reasons, and
then each takes its own module, with one depending on the other.

This is the opposite of `module-envy.md`, where one concept is spread across
several modules. Splitting too eagerly creates that smell, so split along
reasons to change that really exist, not ones that might.

## Example

Before, one module holds an order and the invoice made from it. The order
changes when ordering rules change, and the invoice when billing and tax
rules do:

```text
module orders
    type Order
        addLine(product, quantity)
        cancel()
    type Invoice
        from(order) -> Invoice
        tax() -> Money
        dueDate() -> Date
```

After, each object has a module of its own, and invoicing depends on orders:

```text
module orders
    type Order
        addLine(product, quantity)
        cancel()

module invoicing
    uses orders.Order
    type Invoice
        from(order) -> Invoice
        tax() -> Money
        dueDate() -> Date
```

## Sources

- [Divergent Change](https://refactoring.guru/smells/divergent-change), and
  its counterpart [Shotgun Surgery](https://refactoring.guru/smells/shotgun-surgery).
- Clean Code, chapter 10, "The Single Responsibility Principle".
