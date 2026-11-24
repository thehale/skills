<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Commands and queries

A method that does something is named with a verb, even when it returns a
result. A method that only reports what a value holds is named with a noun for
what it reports. A name that does neither leaves the reader unable to tell
whether a call acts or answers.

## Why it costs the reader

A reader decides from the name alone whether a call is safe to repeat, reorder
or drop. A verb says the call does something, so it matters when and how often
it runs. A noun says it returns something, so it can be called anywhere. A
command named like a query hides an effect the reader will miss, and a query
named like a command makes the reader look for an effect that isn't there.

## How to spot it

- A method named as a noun that writes, sends, mutates or deletes.
- A method that only reports what its receiver holds or can derive from
  itself, named with a verb of making or fetching, such as get, compute or
  build.
- A lone past participle or adjective as a name. It doesn't say whether the
  thing was done or is being asked for, so the reader can't tell a command
  from a query. Local variables count too.
- A conjunction or preposition as a name for an operation that has an
  established name, such as combining two collections.
- A method that both changes state and returns information about the world,
  so that no name can be honest about both.

## The move

- **An action takes a verb or verb phrase.** A method that does work, such as
  reading the world, gathering things or judging them, keeps its verb even
  when it returns a result, since what it returns is the outcome of acting.
  A function that transforms its input, such as sorting or rendering it, is
  an action too. The variable that receives its result names the result.
- **A report takes a noun or noun phrase** for what it returns, when the
  method only reports what a value already holds or can derive from itself.
  A predicate is a query too, and `predicate-names.md` says how to phrase one.
- **A method that does both splits** into a query and a command, so each can
  take an honest name.
- **An operation keeps one name at every level,** such as on the whole, on a
  collection and on one part.
- **An operation with an established name takes it,** such as union or
  intersection for combining sets, from mathematics or the domain.
- **The language's conventions stay,** such as the names its standard library
  gives constructors and conversions, as its readers know them. A convention
  is what the language's style guide asks of all code, not one standard
  library name that reads like a participle.

Rename with a refactoring tool where the language has one, so a sweep of a
hundred names stays safe. A rename the tool refuses because it would shadow a
name in scope usually means the new name is too generic. A rename by text
search also changes the word inside strings and comments, which matters most
for short, common words, so check the diff for changed literals and prose
before committing one.

## Example

Before, a query named with a verb, a noun that empties the cart, and a lone
participle:

```text
cart.calculateTotal() -> Money
cart.items() -> List of Item    // and empties the cart
checked(order) -> List of Problem
```

After:

```text
cart.total() -> Money
cart.items() -> List of Item
cart.clear()
check(order) -> List of Problem
cart.isEmpty() -> Boolean
```

## Sources

- Clean Code, chapter 3, "Command Query Separation" and "Verbs and Keywords",
  and chapter 2, "Class Names" and "Method Names".
