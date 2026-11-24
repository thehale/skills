<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Logic in the interface

The domain's logic is a library: a public interface that any caller can use on
its own, with every front end a thin interface to it. A front end that holds
the logic, or that is the only code allowed to reach it, traps that logic where
nothing else can use it.

## Why it costs the reader

The logic can only be reached through the front end, so a second front end
can't reuse it, and its tests have to go through the front end's input to
reach it. The reader also has to tell two kinds of code apart in one place:
the parts that decide what the domain means, and the parts that read input and
present output. A change to the presentation risks the rules, and a change to
the rules risks the presentation.

## How to spot it

- A handler, command or controller longer than the module it calls.
- Domain types declared inside the front end.
- A front end that imports several of the system's modules and decides itself
  which runs after which.
- Domain modules marked private or internal, so that only the front end may
  import them, and no public interface in front of them.
- Tests of domain behavior that build requests or command lines.
- A second front end, or a wish for one, that would have to copy code.

## The move

Make the library the product, and the front end an interface to it.

- **The library is public.** It takes domain values and returns domain values,
  and any caller can use it without the front end. Code that only the front
  end can reach is still the front end's, however many modules it is split
  into, so moving logic into a private module is not yet this move.
- **The front end imports the library alone.** It turns its input into domain
  values, makes one call, and presents what comes back.
- **The library owns the order of the steps,** behind its interface, along
  with the modules that carry them out.
- **A choice a second front end would make the same way belongs in the
  library.** A front end's own choices, such as what to show next, stay with
  it.
- **Grouping results for display is the presentation's job.** The domain
  models the unit it works in, one at a time. When a grouping the presentation
  needs doesn't hold, such as every result for one unit appearing together,
  look for an invariant the domain is missing, such as a set that holds each
  unit once.

## Example

Before, a request handler wires private modules together itself:

```text
handle POST /invoices
    uses private/pricing, private/tax, private/discounts

    subtotal = pricing.subtotal(request.lines)
    tax = tax.for(request.customer.region, subtotal)
    discount = discounts.best(request.customer, subtotal)
    respond 201 with { total: subtotal + tax - discount }
```

After, the handler uses one public library, which owns the steps:

```text
handle POST /invoices
    uses invoicing

    invoice = invoicing.invoice(order(request))
    respond 201 with invoice.summary()
```

## Sources

- Clean Code, chapter 11, "Separate Constructing a System from Using It", and
  chapter 8, "Clean Boundaries".
- [Divergent Change](https://refactoring.guru/smells/divergent-change): a front
  end that changes for both presentation and rules holds two concerns.
