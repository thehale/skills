<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Patch per case

Behavior follows from a rule, not from a list of cases. When each new
counterexample gets its own fix, the design is missing the model the cases
share, and the next counterexample will break something again.

## Why it costs the reader

The reader can't learn the rule, because there isn't one, only a list of cases
someone has met so far. Each patch interacts with the others, so a fix for one
case breaks another, and the tests become the only description of the
behavior. The cost of the next case keeps rising, since it has to fit around
every patch before it.

## How to spot it

- Test cases named for one-off inputs, and a branch for each.
- The same condition on a kind repeated in several places.
- A check and a fix that each compare input against expectations in their own
  way.
- Counterexamples that keep arriving after the last one was "fixed".

## The move

Put a model in the middle.

1. **Read every recognized input form into one domain model,** through a
   sequence of registered patterns rather than one function that knows them
   all.
2. **Render the model back out in a single canonical form.**
3. **Check by rendering:** a check is "the rendering differs from the input",
   and a fix is "write the rendering".

A new input form then becomes one more pattern, and a new output detail
changes the renderer once.

- **Recognize every form, render one.** Be opinionated wherever the domain
  allows several equivalent spellings, such as the order of alternatives. A fix
  that unifies leaves the reader one form to learn, and a second run has
  nothing left to do.
- **Each variant carries its own behavior,** as a strategy, so at most one
  place picks the variant.

## Example

Before, each way of writing a phone number is a branch:

```text
function normalize(phone: Text) -> Text
    if phone starts with "("
        …strip parentheses, keep the area code…
    else if phone contains "."
        …replace dots, guess the area code…
    else if phone starts with "+"
        …drop the country code, unless it isn't 1…
```

After, every form is read into one model, and output has one shape:

```text
patterns = [Parenthesized, Dotted, International, Plain]

function normalize(phone: Text) -> Text
    return first match of patterns on phone, as PhoneNumber, formatted

function isNormal(phone: Text) -> Boolean
    return normalize(phone) == phone
```

## Sources

- Clean Code, chapter 17, G23 and G27, and chapter 3, "Switch Statements".
- [Switch Statements](https://refactoring.guru/smells/switch-statements).
