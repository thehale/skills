<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Shared files

Each cohesive thing lives in a file of its own, decoupled from other concepts.
A file that holds two things couples them by placement, even when nothing in
the code ties them together.

## Why it costs the reader

A reader opens a file for one thing and has to read past another to find it,
or to be sure there's nothing more of it below. The file's name can only
describe one of the two, or something vague enough to cover both, so neither
is where a reader would look. Changes to one land beside the other, and over
time the two start to borrow from each other because they're close at hand.

## How to spot it

- A file whose name is a category or a conjunction rather than a thing.
- A file with two groups of declarations that never refer to each other.
- A file holding several types that each carry behavior of their own.
- A type declared in one file with its methods in another.
- Two sets of tests for one file, with no case that uses both.
- A file whose history changes for two unrelated reasons.

## The move

Split the file, one per cohesive thing, each named for what it holds. Move each
part's helpers with it, and share only what both genuinely use, in a home of
its own. A small thing still gets its own file rather than an appendix to a
neighbor's.

Split by concept, not by declaration:

- **A type and all of its methods live in one file.** When a boundary would
  split them, such as reading in one file and rendering in another, the type
  is too big. Model each side as a type of its own, each in its own file.
- **A type with several methods is a strong candidate for its own file,** but
  methods alone don't make a concept. A type that exists only as another's
  checked or derived form stays in that type's file, methods and all.
- **A rename stays where it is read.** A name that only renames another, such
  as a type alias, stays in the files that use it, since moving it away puts
  the renaming out of sight of the code it is meant to make readable.
- **A plain record with no behavior stays with the code it serves.**

## Example

Before, a file named for a category holds three unrelated things:

```text
util
    function formatPrice(amount: Money) -> Text
    function slug(title: Text) -> Text
    function withRetries(operation, attempts: Integer)
```

After, each thing has a file named for it, beside the code that uses it:

```text
money/price
    function formatPrice(amount: Money) -> Text

articles/slug
    function slug(title: Text) -> Text

retry
    function withRetries(operation, attempts: Integer)
```

## Sources

- Clean Code, chapter 10, "Cohesion" and "The Single Responsibility
  Principle".
- [Divergent Change](https://refactoring.guru/smells/divergent-change).
