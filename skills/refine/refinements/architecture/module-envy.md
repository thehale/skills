<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Module envy

Each piece of knowledge lives in the module that owns its concept, and other
modules ask that module for it. A module holding a copy of a neighbor's rules,
or one concept spread across several modules, breaks that.

## Why it costs the reader

A reader who wants to know how a concept works has to find every place it
lives, and can't tell whether the copies agree. When the owner changes, the
copies don't, and the bug turns up far from the change. A reader also learns a
module from what it holds, so a module holding a neighbor's rules teaches the
wrong boundary.

## How to spot it

- A pattern, constant or format that matches one declared in another module.
- A function that mostly reads another type's fields, or another module's
  values, to work something out about them.
- A change to one concept that touches several modules.
- Callers that build patterns or values in a format's own notation, which says
  the format's particulars have leaked out of the module that owns it.
- A free function whose first argument is the type it works on, which wants to
  be a method on it.
- A function that takes as a parameter data that some type already holds, so
  the caller fetches the data only to hand it back.
- A value's module that also edits the text around its values, which is the
  caller's concern leaking into it.
- A type whose methods live apart from its declaration and work mostly on
  another type's data. They belong to the type whose data they use, which often
  means the plain record they were on is passed in instead.

## The move

Move the knowledge to the module that owns the concept, and have the others
ask it.

- **A check on a value becomes a method on that value.**
- **A format written in several places gets one writer.**
- **A format several modules need keeps its particulars in one module,** such
  as a template notation, which answers questions about it in the domain's
  terms rather than handing out its parsed form.
- **Duplicate names often resolve too,** since the rest of the system then uses
  one declaration.

The opposite smell, one module holding several concepts, is
`divergent-change.md`.

## Example

Before, signup checks email addresses with a pattern of its own, beside the
email module that already defines one:

```text
module signup
    emailPattern = "^[^@ ]+@[^@ ]+\.[a-z]+$"

    if not matches(emailPattern, form.email)
        reject("invalid email")
```

After, an email address knows when it is valid:

```text
module signup
    if not Email(form.email).isValid()
        reject("invalid email")
```

## Sources

- Clean Code, chapter 17, G14, G17 and G22.
- [Feature Envy](https://refactoring.guru/smells/feature-envy) and
  [Shotgun Surgery](https://refactoring.guru/smells/shotgun-surgery).
