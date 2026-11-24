<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Near-duplicate names

Distinct concepts have distinct names, and one concept has one declaration.
Two types that share a name, or differ only by case or by the module they sit
in, leave the reader unable to tell which of the two they are looking at.

## Why it costs the reader

The reader has to work out whether the two are one concept or two, and the
names give no help either way. When they are one concept, the code keeps two
declarations in step and converts between them at every crossing. When they
are two, each deserves a name that says how it differs.

## How to spot it

- Two names that differ only by case.
- One type name declared in two modules.
- A function whose only job is to copy one such type into the other.
- The question of what the difference between the two is.

## The move

First settle whether they are one concept or two.

- **One concept:** declare it once, in the module that owns it, and have the
  others use or re-export it. The converting function goes.
- **Two concepts:** rename each for what it is, so the names say how they
  differ. This holds for any name, methods and predicates included, even
  across modules. When a new name takes a word another concept already uses,
  rename whichever one has a more specific true statement available. A
  predicate can spell out the whole question it answers.

Two names that read as synonyms usually name one concept, so finish with one
word for it and remove the other. Give each its own level of the model, such
as a single issue and the unit that owns its issues, only when both concepts
really exist.

Then search the rest of the layer for the same pairing, since one usually means
more.

## Example

Before, two invoices and a copy between them:

```text
module billing
    type Invoice { number: Text, total: Money }

module reports
    type Invoice { number: Text, total: Money }
    function fromBilling(invoice: billing.Invoice) -> Invoice
```

After, one invoice, declared where it is made:

```text
module billing
    type Invoice { number: Text, total: Money }

module reports
    uses billing.Invoice
```

Had the two been different concepts, such as an invoice that was sent and one
still being edited, the move would have named them `Invoice` and
`InvoiceDraft` instead.

## Sources

- Clean Code, chapter 2, "Make Meaningful Distinctions", and chapter 17, N4.
- [Duplicate Code](https://refactoring.guru/smells/duplicate-code).
