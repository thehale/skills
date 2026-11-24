<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Predicate names

A predicate is named as a question about a concrete property of its value.
It opens with is, or with has for whether something contains a thing, or ends
in a question mark where the language allows one in a name.

## Why it costs the reader

A reader meets a predicate inside a condition, and the name is all they have
to tell what is being asked. A bare verb can read as easily as a plural noun
in English, so the reader can't tell a question from a collection. A name
that speaks of confidence, such as convincing or certain, describes how sure
the caller can feel rather than what the check looks at, so the reader has to
open it to learn what makes it true.

## How to spot it

- A predicate named with a bare verb, which reads as easily as a plural noun.
- A predicate named for the reader's confidence rather than the value's
  property.
- A predicate named as a lone past participle or adjective.

## The move

Open the name with is, or with has when it asks whether something contains a
thing, or end it in a question mark where the language allows one. The is or
has form can read more awkwardly than a bare verb, but where the name can't
end in a question mark it is the one that reads unambiguously as a question.
Name the property the check tests, such as whether a value has every part it
needs, rather than how sure a caller can be. A participle inside a longer
phrase reads fine, since the phrase around it says what it is.

## Example

Before, a bare verb and a word of confidence:

```text
if coupon.applies(order) and payment.isReliable()
    ship(order)
```

After, two questions about properties:

```text
if coupon.isValidFor(order) and payment.isSettled()
    ship(order)
```

## Sources

- Clean Code, chapter 2, "Method Names", on predicates that open with is.
