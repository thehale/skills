<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Mixed levels

Every step of a function sits one level below the function's name, and the
function does one thing from its caller's point of view. A function that
mixes named steps with the details of one of them makes the reader change
altitude in the middle of a read.

## Why it costs the reader

A reader takes in a function by reading its steps as a summary. When one step
is spelled out in detail beside steps that are only named, the summary breaks:
the reader has to work out what the detailed lines amount to before reading
on, and can no longer stop at this level with a true picture of what happens.
Going down a level should add one thing to attend to. A mixed function adds
several at once.

## How to spot it

- A function where some lines call named steps and others index, loop or
  compute inline.
- A step left inline because it is short, beside siblings that were extracted.
- A function whose name covers less than its body does, so a caller would be
  surprised by part of what it does.
- An operation with an opposite, such as adding and removing, whose two halves
  have different shapes or live at different levels.

## The move

Extract each step that is spelled out into a function named for what it does,
until every line of the function sits at the same level.

- **Extract a step even when it is a single line,** if its siblings are named
  steps, since the evenness is what lets the function read as a summary.
- **Make the name cover the body.** When the body does more than its name
  says, either name it for the whole or move the extra work to the caller that
  wants it.
- **Give counterparts one shape.** An operation's opposite takes the same
  shape, so a reader who knows one already knows the other, and sibling
  operations return the same kind of result.

Each extracted step is then a function at the next level down, and the same
refinement applies to it in turn.

## Example

Before, two steps are named and one is spelled out:

```text
function checkout(order: Order)
    charge(order)
    for line in order.lines
        stock[line.product] = stock[line.product] - line.quantity
    sendReceipt(order)
```

After, every step is named, and reserving stock has an opposite of the same
shape:

```text
function checkout(order: Order)
    charge(order)
    reserveStock(order)
    sendReceipt(order)

function cancel(order: Order)
    refund(order)
    releaseStock(order)
    sendCancellation(order)
```

## Sources

- Jorge Manrubia, [Fractal
  Journeys](https://dev.37signals.com/fractal-journeys/): symmetry and
  cohesiveness, among the qualities good code repeats at every level.
- Clean Code, chapter 3, "One Level of Abstraction per Function" and "Reading
  Code from Top to Bottom: The Stepdown Rule", and chapter 17, G34.
- [Long Method](https://refactoring.guru/smells/long-method), through Extract
  Method.
