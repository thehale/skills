<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Buried expectations

A test shows its input and its expected output as plainly as the domain
allows. A test that assembles them in code hides the behavior under test from
any reader not fluent in the implementation.

## Why it costs the reader

The reader can't check the test without running the code in their head, so a
wrong expectation passes review as easily as a right one. Each test case is
also a piece of code, so adding one costs a function, and cases stay few.
Tests written against the implementation's types break when those types are
refined, which makes every refinement look riskier than it is.

## How to spot it

- Expected output built by concatenation or a builder.
- Test helpers that exist to construct inputs.
- Assertions on internal fields rather than on what the user would see.
- A refinement that changed only names but had to rewrite many tests.

## The move

Where the domain allows, make each case a pair of plain-text fixtures: the
input, and beside it the output expected from it, both named for the case.

- **One test runs them all.** It reads every fixture, runs it, and compares,
  so a new case is a new pair of files.
- **A reader checks a case by reading it,** whatever language the code is in.
- **Group the fixtures the way a reader looks for them,** such as a folder per
  kind of input, rather than in one table that every case shares.
- **Assert on the outward behavior only,** so the implementation can be
  refined beneath the fixtures without touching them.

## Example

Before, a Markdown converter's test:

```text
input = "# Title" + newline + newline + "Some *emphasis*."
expected = "<h1>Title</h1>" + newline + "<p>Some <em>emphasis</em>.</p>"
assert convert(input) == expected
```

After, `fixtures/emphasis-in-a-paragraph.md`:

```text
# Title

Some *emphasis*.
```

and beside it, `fixtures/emphasis-in-a-paragraph.html`:

```text
<h1>Title</h1>
<p>Some <em>emphasis</em>.</p>
```

## Sources

- Clean Code, chapter 9, "Clean Tests": readability is what makes a test
  worth keeping.
- [Duplicate Code](https://refactoring.guru/smells/duplicate-code), in the
  setup that every coded case repeats.
