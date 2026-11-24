<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Template methods

A variant carries its whole behavior in one place. One algorithm in a shared
base that calls out to hooks for each variant splits every variant in two, and
grows a branch for each variant the hooks can't describe.

## Why it costs the reader

Reading one variant means reading the base and the hooks together and running
the algorithm in your head to see what comes out. When a variant doesn't fit
the template, it gets an empty hook or a flag on the base, and the base grows
a branch for it. The variant's behavior ends up in two places, and the second
is shared by every other variant.

## How to spot it

- A base type or a record of optional hooks that one shared function
  interprets.
- Hooks that most variants leave empty.
- A shared function with branches on which variant it was given.
- A new variant that needs a change to the base before it fits.

## The move

Make each kind of variant a strategy: a type behind one interface, carrying
its whole behavior. The interface names what callers need. Keep the
configuration declarative, so each variant is still one readable value, but
let the value's type decide how it behaves. A variant that doesn't fit becomes
a new strategy rather than a branch in a shared one.

## Example

Before, a notifier with hooks, and an SMS channel that refuses most of them:

```text
base Notifier
    send(user, text)
        message = subject() + greeting(user) + text + signature()
        if this is Sms, message = text truncated to 160
        deliver(message)

Sms extends Notifier
    subject() -> ""
    greeting(user) -> ""
    signature() -> ""
```

After, each channel is a strategy, declared as plainly as before:

```text
interface Channel
    send(user, text)

email = Email { subject: "News", signature: "The team" }
sms = Sms { limit: 160 }
```

## Sources

- Clean Code, chapter 17, G23.
- [Refused Bequest](https://refactoring.guru/smells/refused-bequest), for
  variants that leave the hooks empty, and [Switch
  Statements](https://refactoring.guru/smells/switch-statements), for the
  branches the base grows.
