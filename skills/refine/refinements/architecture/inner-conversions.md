<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Inner conversions

A value takes its type where it enters the system and keeps it inside.
Conversions in the middle of the code are a symptom: a type sits one level off
from where the values live.

## Why it costs the reader

Each conversion is a line that says nothing about the domain, and the reader
has to check that it loses nothing. A value that has one type on one line and
another on the next has no settled meaning, so the type stops vouching for it.
When the noise reaches the callers and their tests, the interface has started
asking them to do its work.

## How to spot it

- Casts, parses and converting helpers anywhere but where input enters: a
  file, a request, a database row, the command line.
- A loop whose only job is to copy one collection into a collection of
  another type.
- A change of type that made callers longer.
- Tests that got noisier with the change that typed the interface.

## The move

Make values the right type where they are born, and keep them in it. Carry the
type down to where the outside world is called, and give it the operations its
callers kept converting to reach. Convert once, at the edge where the value
arrives. When a type forces conversions however it is placed, it says nothing
its plain type didn't, and it should go.

## Example

Before, a date travels as text and every function parses it again:

```text
function isWeekend(order: Order) -> Boolean
    return parseDate(order.placedOn).weekday() in [Saturday, Sunday]

function isLate(order: Order) -> Boolean
    return parseDate(order.placedOn) < today() - 7 days
```

After, the date is parsed once, where the order is read:

```text
order = Order { placedOn: parseDate(row.placed_on), … }

function isWeekend(order: Order) -> Boolean
    return order.placedOn.weekday() in [Saturday, Sunday]
```

## Sources

- Clean Code, chapter 8, "Using Third-Party Code": wrap a foreign type at the
  boundary and use the owned type inside.
- [Primitive Obsession](https://refactoring.guru/smells/primitive-obsession),
  read the other way round too: a type with no home is as costly as a missing
  one.
