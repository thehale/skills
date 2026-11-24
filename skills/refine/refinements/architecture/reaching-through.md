<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Reaching through

A caller uses the interface next to it and nothing behind it. A caller that
goes past that interface, into the layer or the object graph beyond, depends
on more than it should.

## Why it costs the reader

The caller now depends on two layers, and the reader can't tell which one
actually decides. The inner layer can't change without breaking a caller it
never meant to have. When the caller is a front end, the module it skipped is
also missing whatever the front end reached for, so the next front end has to
reach for it too.

## How to spot it

- A front end that imports or calls anything besides the modules it serves.
- A chain of three or more accessors across types.
- A caller that assembles a value from another type's parts before using it.
- The question of why a caller still needs to know about a layer it shouldn't
  see.

## The move

Give the near interface the operation the caller wanted, and have the caller
use only that. When a front end reaches into the internals, the missing
operation belongs in the public interface of the module it skipped. Stop
short of a layer that only forwards calls, since a pass-through teaches the
reader nothing.

## Example

Before, a report screen sums rows out of the storage layer that the sales
module uses:

```text
module reportScreen
    rows = storage.query("select * from sales where month = ?", month)
    total = sum(row.amount for row in rows)
```

After, sales offers the operation, and the screen asks for it:

```text
module reportScreen
    total = sales.totalFor(month)
```

## Sources

- Clean Code, chapter 6, "The Law of Demeter" and "Train Wrecks", and chapter
  17, G36.
- [Message Chains](https://refactoring.guru/smells/message-chains),
  [Inappropriate Intimacy](https://refactoring.guru/smells/inappropriate-intimacy)
  and, for where to stop, [Middle Man](https://refactoring.guru/smells/middle-man).
