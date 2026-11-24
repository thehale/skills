<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Foreign comments

A comment speaks only for the code it sits on. A claim about another type, or
about what callers do with this one, can't be checked where it is written, and
it goes stale the first time the other code changes.

## Why it costs the reader

The reader takes a comment as true of the code beside it, so a claim about
somewhere else reads as a rule this code enforces when it doesn't. Nothing
links the claim to the code it describes, so a change there leaves the
comment wrong with no sign of it. The reader of the other code never sees the
claim at all.

## How to spot it

- A doc comment that names another type, module or caller.
- A comment that says how a value is shown, stored or used elsewhere.
- A comment on a type that describes a rule the type itself doesn't apply.

## The move

Say only what the code itself is and does. Move a claim about other code to
the code it is about, where it sits beside what makes it true, or make the
claim unnecessary by giving that code a name or a type that states it. When a
claim has no true home, it was describing behavior nothing guarantees, and it
should go.

## Example

Before, an amount's comment speaks for the invoices that use it:

```text
// An Amount is a sum of money. Invoices round it to whole cents.
type Amount { value: Decimal }
```

After, each comment speaks for its own type:

```text
// An Amount is a sum of money.
type Amount { value: Decimal }

// An Invoice states each amount rounded to whole cents.
type Invoice { lines: List of Line }
```

## Sources

- Clean Code, chapter 4, "Nonlocal Information" and "Misleading Comments".
- [Comments](https://refactoring.guru/smells/comments).
