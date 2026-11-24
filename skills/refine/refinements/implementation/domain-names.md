<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Domain names

Each concept takes the name its domain already gives it, and keeps that one
name everywhere it appears. A name for the step that made a concept, a word
the code invented, or two names for one concept all stand between the reader
and the domain.

## Why it costs the reader

A reader who knows the domain already has its words, and every invented word is
one more to learn and map back. A name for a step ties the concept to how it is
made today, and stops being true when that changes. Two names for one concept
make the reader prove they are the same. One name for two concepts makes them
prove they differ.

## How to spot it

- A type or module named with a past participle, or for a pipeline stage.
- A concept the domain's standards or experts name differently.
- The same thing called one word in the public interface and another inside.
- Two verbs for one operation, or one verb for two operations.
- A name that repeats its module's name, or leaves the module's name to say
  what the thing is.
- A name narrower than what it holds, such as a parameter named for one kind
  of thing that also accepts another.
- A name for a value's general category where a name for where it applies
  would tell the reader more.
- A name that only says where a thing sits, such as a step, an item or an
  entry, rather than what it is.
- An index or position named with a preposition or a bare letter, which says
  neither what it indexes nor what kind of value it is.
- A name whose everyday meaning promises behavior the thing doesn't have.
- A metaphor that drifts into another domain's vocabulary, or a themed name
  chosen for wit.
- A helper reused because it happens to do the right thing, so that the call
  site speaks of a concept the caller doesn't have.
- A rename that would let a doc comment go, because the name now says it.

## The move

Name each concept with the domain's own term, and use that one term everywhere
the concept appears, from the public interface to the internals.

- **Look the term up.** Read the standard or the manual the domain comes from,
  since it usually settled the name already. Where the domain has no term,
  choose the word a user would say and keep to it.
- **Say where it applies.** Prefer a name that says where a value is used or
  matched over one that names its general category, since a category fits
  many things and the reader needs to know which.
- **Keep the more telling name.** When two names for one concept are unified,
  choose the more telling of the two, not whichever is public. A public name
  may be left over from an earlier change rather than chosen.
- **Keep a theme plain.** Where the code keeps a theme, keep its tone in plain
  words, since a clever name has to be decoded before it can be read.
- **Make every call site read true.** When a reused helper's name doesn't fit
  a caller, extract the part they share under a name of its own.
- **Rename the variables too.** A local variable is named for the concept it
  holds, not for the line that produced it. When a concept is renamed, the
  variables that hold it are renamed with it, so no old name is left
  describing the new concept.

## Example

Before, a step's name for what an accountant calls a posting, and two words
for the person who pays:

```text
function process(row: Row) -> ProcessedEntry

client = billing.client(id)
customer = support.customer(id)
```

After:

```text
function post(row: Row) -> Posting

customer = billing.customer(id)
customer = support.customer(id)
```

## Sources

- Clean Code, chapter 2, "Use Solution Domain Names" and "Use Problem Domain
  Names", and chapter 17, N3 and G11.
- [Alternative Classes with Different
  Interfaces](https://refactoring.guru/smells/alternative-classes-with-different-interfaces).
