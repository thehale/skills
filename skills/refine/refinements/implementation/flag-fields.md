<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Flag fields

A value's kind is its type, not a field on it. A field that says which kind a
value is, whether a boolean, an enum or a code, is a flag argument stored on
the data, and it costs every reader what a flag argument costs every caller.

## Why it costs the reader

Every reader of the value has to branch on the field before doing anything
else, and each branch reads only some of the other fields, so the reader also
has to learn which fields belong to which kind. The branches repeat wherever
the value is used, and a new kind means finding all of them. Nothing stops a
value from carrying the fields of a kind it isn't.

## How to spot it

- A field that says which kind of value this is, beside fields that mean
  something only for some kinds.
- The same condition or switch on that field in several places.
- A collection whose members each carry a flag that every caller filters on.

## The move

- **Give each kind its own type** behind one interface, with only the fields
  that kind uses.
- **Move the behavior that branched on the kind into each type,** so a caller
  asks the value and no longer asks what it is.
- **Split a flagged collection** into one collection per kind, each named for
  what it holds, when callers keep filtering it on the flag.

See `flag-arguments.md` for the same smell passed as a parameter.

## Example

Before, a payment carries its method as a field, and every use switches on it:

```text
type Payment {
    method: Card | Transfer | Cash
    cardNumber: Text      // card only
    iban: Text            // transfer only
    amount: Money
}

function fee(payment: Payment) -> Money
    switch payment.method
        Card: return payment.amount * 0.02
        Transfer: return Money(0.30)
        Cash: return Money.zero
```

After, each method is a type that knows its own fee:

```text
interface Payment
    fee() -> Money

type CardPayment { cardNumber: Text, amount: Money }
type TransferPayment { iban: Text, amount: Money }
type CashPayment { amount: Money }
```

## Sources

- Clean Code, chapter 17, G23, "Prefer Polymorphism to If/Else or
  Switch/Case".
- [Switch Statements](https://refactoring.guru/smells/switch-statements),
  through Replace Type Code with Subclasses.
