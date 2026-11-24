<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Errors that break the chain

Failure is handled once, where a result is produced. When each step of a
sequence handles its own failure, the steps can't be written as one
expression, and the sequence the caller cares about disappears among the
checks.

## Why it costs the reader

The reader wades through intermediate names and checks that exist only to carry
a failure to the end. Every caller repeats the same plumbing, and an example in
the documentation grows a line per step.

## How to spot it

- Three or more statements in a row, each taking the last one's value and
  checking or collecting its failure.
- Failures gathered at the end that no one inspected on the way.
- Intermediate values named for the failure they carry rather than for what
  they hold.
- A usage example longer than the idea it shows.

## The move

Let the value carry its failure. A step that can fail returns a value that holds
the failure inside it, and each later step passes it along untouched. The last
step, the one that produces a result, reports everything that went wrong.
Whether the language spells this as a result type, a builder or an error kept
on the object, calls then chain, and the caller handles failure once, where it
has a result to handle it with. Keep this for steps that build up a value. A
step whose failure should stop everything still has to stop at once.

## Example

Before, a check after every step from a URL to a response:

```text
url = parseUrl(text)
if url failed, return its error
request = Request.to(url)
if request failed, return its error
request = request.withHeader("Accept", "text/html")
if request failed, return its error
response = request.send()
```

After, the request holds the first failure, and sending reports it:

```text
response = Request.to(text).withHeader("Accept", "text/html").send()
```

## Sources

- Clean Code, chapter 7, "Extract Try/Catch Blocks" and "Define the Normal
  Flow": keep error handling apart from the logic it guards.
- [Message Chains](https://refactoring.guru/smells/message-chains) is the
  limit: chain the steps of one value, never a walk through other objects.
