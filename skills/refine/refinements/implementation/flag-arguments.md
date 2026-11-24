<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Flag arguments

A function does one thing. A parameter that picks which of two things it does,
whether a boolean or an option with more cases, is two functions sharing a
name.

## Why it costs the reader

The call site passes a bare value, and the reader has to open the function to
learn what it means. Inside, both behaviors share one body, so each branch has
to be read past the other, and the result type has to carry what both can
return. The flag usually leaks outward too, into comments on the result about
which fields one mode fills.

## How to spot it

- A boolean parameter, especially one named for a mode.
- A condition on a parameter that splits the function into two halves.
- Call sites passing a literal true or false.
- A result type that one value of the flag fills differently from the other.
- A flag or mode passed down through several layers, so the branch happens far
  from the caller that made the choice.

## The move

Split the function into one per behavior, named for what each does. When the
two share a first step, make that step its own function, and have it return a
value that each behavior takes from there. Each function then returns only
what it produces, which often splits the result type too (see
`comments-for-types.md`).

Split at the top, where the choice is made. When the flag runs through several
layers, the shared work is everything below the choice: it runs once, without
knowing which behavior follows, and returns a value that describes the
outcome, such as what is wrong and what would fix it. Each behavior then acts
on that value. Replacing the flag with an enum, a mode object or a strategy
that the shared work still consults is not this move. Every layer still
carries the choice and still asks it what to do, so the flag has only changed
type.

See `flag-fields.md` for the same smell stored on the data.

## Example

Before, a flag runs from the top of a batch down to each invoice:

```text
function sendInvoices(invoices: List of Invoice, byEmail: Boolean)
    for invoice in invoices
        sendInvoice(invoice, byEmail)

function sendInvoice(invoice: Invoice, byEmail: Boolean)
    document = layout(invoice)
    if byEmail, email(document) else print(document)
```

Not this, which only gives the flag another type, still carried down and
still asked at every step:

```text
function sendInvoice(invoice: Invoice, delivery: Delivery)
    document = delivery.layout(invoice)
    if invoice.isOverdue, document = delivery.withReminder(document)
    delivery.send(document)
```

After, the documents, reminders included, are worked out once without knowing
how they will be sent, and each way of sending them is its own function:

```text
function documents(invoices: List of Invoice) -> List of Document

documents(invoices).print()
documents(invoices).email(to: customer.address)
```

## Sources

- Clean Code, chapter 3, "Flag Arguments", and chapter 17, F3 and G15.
- [Switch Statements](https://refactoring.guru/smells/switch-statements),
  through Replace Parameter with Explicit Methods.
