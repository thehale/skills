<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Collection types

A collection gets a type of its own only when it carries operations on the
whole of it, and then it holds only the members its name promises. Until then,
a plain list of its members says more than a plural type name.

## Why it costs the reader

A plural type name makes the reader look for behavior behind it, and a plain
list would have told them there is none. Without a type, the opposite
happens: each caller that needs to ask something of every member writes the
same loop or free function, and the question has no home. A collection whose
name promises one kind of member but holds another misleads every caller that
trusts the name, and one that gathers everything when it is made does work
the caller may never need.

## How to spot it

- A named collection type with no operations of its own.
- A free function that asks each member's question of a whole collection.
- A collection that holds a kind of thing its name doesn't cover.
- A collection that gathers all its members when it is made, though callers
  usually narrow it to a few.
- A type that unites two domain objects only because they share methods.

## The move

Keep a plain list until the collection has operations of its own. When a
caller asks each member's question of the whole collection, use the language's
general way to ask it of every member, such as any or all. Where the language
has none, give the collection that question as a method of its own, so asking
it of the collection reads like asking it of one member. That is when the
collection earns its type.

Keep the type to the members its name says it holds, and gather them when the
collection is used, so narrowing it to one member never gathers them all. Don't
unite two domain objects under one type because they share methods. Keep them
apart, and let the caller use each, unless the domain names the union.

## Example

Before, a free function asks every order's question:

```text
function anyOverdue(orders: List of Order) -> Boolean
    for order in orders
        if order.isOverdue(), return true
    return false
```

After, the orders carry the question themselves:

```text
type Orders {
    isAnyOverdue() -> Boolean
        return any order in this is overdue
}

if customer.orders().isAnyOverdue(), remind(customer)
```

## Sources

- Clean Code, chapter 17, G14, on moving behavior to the data it uses.
- [Lazy Class](https://refactoring.guru/smells/lazy-class), for a collection
  type with nothing of its own, and
  [Speculative Generality](https://refactoring.guru/smells/speculative-generality),
  for a union nothing in the domain names.
