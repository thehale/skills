<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Entangled values

Each value read out of a mixed source has a reader of its own. When two
values arrive together, reading one as whatever is left once the other is
removed ties them to each other, though nothing in the domain does.

## Why it costs the reader

To learn how one value is read, the reader has to learn how the other is read
first, since the first is defined by what the second leaves behind. A change
to one reader quietly changes the other value. Checks on either value end up
spread across both readers, so the rule for one value has no single place to
live.

## How to spot it

- A value computed as the input with another value taken out.
- A reader for one value that calls the reader for another first.
- A check on one value that is written in terms of the other.

## The move

Give the mixed source one reader per value, each finding its own value
directly and independent of the others. Checks on a value then ask its own
reader, such as asking whether it has one by reading it, so each rule lives
in one place.

## Example

Before, a contact line's email is whatever the name leaves:

```text
type ContactLine { text: Text }

function name(line) -> Text
    return text before the first "<", trimmed
function email(line) -> Text
    return line.text without name(line), stripped of "<" and ">"
function hasEmail(line) -> Boolean
    return name(line) != line.text
```

After, each value has its own reader, and the check asks its reader:

```text
type ContactLine {
    name() -> Text      // text before the first "<", trimmed
    email() -> Text     // text between "<" and ">"
    hasEmail() -> Boolean
        return email() is not empty
}
```

## Sources

- Clean Code, chapter 17, G22, "Make Logical Dependencies Physical", read the
  other way round: a dependency the domain doesn't have shouldn't be built in.
- [Inappropriate Intimacy](https://refactoring.guru/smells/inappropriate-intimacy).
