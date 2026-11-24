<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Constant results

A function returns only what can differ from one call to the next. A part of
the result that comes out the same for every call on a given receiver is a
property of the receiver, and it is decided once.

## Why it costs the reader

Every caller has to receive the extra value, and the reader of each call site
has to work out whether it matters there. Since it never varies between calls,
callers check it again and again, or ignore it in some places and not others,
and the reader can't tell which is right. The signature also suggests the
value depends on the arguments, which sends the reader looking for how.

## How to spot it

- A returned flag or status whose value depends only on the receiver's
  configuration or state, not on the arguments.
- Callers that check the same returned value after every call.
- Callers that discard part of a result most of the time.

## The move

Take the constant part out of the result. Decide it once, where the receiver
is made, and make it a property of the receiver, or let the receiver's type
say it. When it changes which behavior the receiver has, choose the behavior
then, so later calls don't ask.

## Example

Before, every lookup reports whether the provider is live:

```text
function rate(provider: Provider, currency: Currency) -> (Rate, isLive: Boolean)

(rate, isLive) = rate(provider, euro)
if not isLive, warn("rates may be stale")
```

After, the provider is live or cached from the start, and a lookup returns only
the rate:

```text
provider = LiveRates(feed) or CachedRates(file)
if provider is CachedRates, warn("rates may be stale")

rate = provider.rate(euro)
```

## Sources

- Clean Code, chapter 3, "Function Arguments", on what a signature tells its
  reader, and chapter 17, G8.
- [Speculative Generality](https://refactoring.guru/smells/speculative-generality),
  for results that answer a question no call asks.
