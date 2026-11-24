---
name: refine
description: |
  REQUIRED once new or restructured code passes its tests, before handing it
  over, and whenever the operator states an architectural principle or points
  at one design smell.

  Triggers:
  - "refine the implementation"
  - "walk through <implementation>"
  - "are there other examples of <code smell>?"
license: MPL-2.0
---
<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Refine

Refine working code into the shape its domain already has. Take one refinement
at a time from `refinements/`, find every place the code breaks it, apply the
move, and check that the code came out simpler. Then take the next.

Run the loop yourself. Working code is not finished code, and the shape it was
written in is rarely the one it should keep, so refine before handing over
without waiting to be asked. Stop after modelling the domain, to agree the
model and the public interface with the operator. When the operator states a
principle or points at one smell, that is the start of a refinement, not a
single fix: apply it everywhere it reaches.

Refinement starts once the tests pass. They are the oracle that lets a
restructuring claim to keep behavior, so a branch with red tests isn't ready
for this.

## What a refinement changes

A refinement is defined by the principle it serves, not by its size. It can
move a responsibility from one module to another, change a type, delete one of
two things, or rename a single variable. Each one that breaks a principle here
is a refinement to make, however small the change.

## Principles

These are what a refinement measures the code against. Start from them, add
any the operator has stated, and drop any the project plainly holds otherwise.
Name the set in the report at the end, so the operator can correct it.

- **Each concept has one home and one name, and each home one concept.** A
  reader who learns where a concept lives and what it is called should not
  find a second copy elsewhere, under the same name or another, since every
  copy is a place the next change can miss. A home that holds two concepts
  couples them by placement alone, so the reader who opens it for one has to
  read past the other.
- **Say it in the code.** What a value is, when a field applies and which
  behavior a call picks belong in types, names and functions, where the
  compiler and every reader meet them. A comment or a convention says it once,
  on the declaration, and nothing holds the rest of the code to it.
- **Decide at the edges.** Input is converted, validated and dispatched once,
  where it enters. Inside, values are already the right kind and variants
  already chosen, so the core never asks again. What the caller gave
  explicitly is taken as given, and work such as inferring it is done only
  when the caller leaves it out.
- **Grow by adding.** A new case should be a new entry, such as a pattern, a
  strategy or a module, and not an edit to every place that knows the cases.
  When each case needs its own patch, the design is missing the abstraction
  the cases share.
- **Depend inward.** Interfaces depend on the core, and the core on nothing
  outside it. A caller uses the layer next to it and nothing behind that, so
  each layer can change without its callers' callers noticing.
- **Every level reads alike.** At each level a reader descends to, the code
  speaks the domain's words, does one thing from its caller's point of view,
  hides the level below behind a clear interface, and keeps its steps at one
  level. A reader can then stop at any depth with a true picture, and each
  step down adds one thing to attend to. This is why each layer gets the same
  refinements as the one above it.
- **Simpler is the evidence.** A right refinement makes the code shorter and
  its callers plainer. When a move adds casts, helpers or noise at the call
  site, it is one level off, however principled it looked.
- **Follow the ecosystem's conventions.** Where a language has a settled layout
  or idiom, follow it even over a better-argued alternative. A reader brings the
  convention with them, and a departure costs them more than it saves.

## The loop

Refinement is a loop. Each pass runs three stages in order: model the domain,
then refine the architecture, then refine the implementation. Each stage
settles what the next one builds on. The domain model names what the
architecture arranges, and the architecture decides where the implementation's
code lives, so working out of order polishes code that a later decision
renames, relocates or deletes.

One pass rarely finishes the job, since refining exposes what the old shape
hid. A cleaner implementation shows a concept the model is missing, and a
cleaner architecture shows a module that holds two. When a stage turns up a
refinement that belongs to an earlier stage, finish the current refinement,
then go back to that stage and pass forward through the rest again. Agree
with the operator again only when the model or the public interface changes.
Stop when a whole pass, with every refinement checked at every level, turns up
nothing.

### 1. Model the domain

Work out the nouns and verbs of the system: the objects it is about, and how
they act on one another. Take them as the operator states them, or as the
domain's own sources give them, and map each to the types that exist today.
Note every difference: a term used for another concept, one type covering two
terms, a term with no type.

From the model, define the public interface, which is what a caller outside
the system can use without going through a front end. When the only way in is
a front end, such as a command line, a screen or a request handler, there is
no public interface yet, and this stage defines one.

- **Write it as usage examples,** in the order a caller would learn them:
  first the one call most callers need, then the parts beneath it for those
  who want finer control.
- **Spell each call in the model's nouns and verbs,** so the examples read the
  way the domain does and are easy to follow.
- **Add an operation only when a caller needs it,** not because it fits the
  model. Name one the model suggests but nothing calls as a possibility, and
  leave it out.

Verify the model and the usage examples with the operator before going on.
This is the stage the operator settles, since every caller depends on the
public interface. When the operator sketches the flow themselves, that sketch
is the target, so refine toward it rather than toward a cleverer one.

### 2. Refine the architecture

Architectural refinements decide which modules exist, what each one owns, and
which way they depend on each other. Take the architecture as a whole, across
every module, and refine it toward the agreed interface until the usage
examples work as written.

### 3. Refine the implementation

Implementation refinements shape the code inside a module: its types, its
names and its control flow. Refine one layer at a time. Start with the public
interface, then go one layer deeper, into each module in turn, and run the same
refinements again there. Each layer's fixes change what the next layer needs,
so a single sweep of the whole codebase refines code that is about to move. The
smells come back one layer lower, in the internals that held up the old
interface.

## Each refinement

In the architecture, and then in each layer, check every refinement on every
pass. Take the refinements in the order the index below lists them: those in
`refinements/architecture/` for the architecture, and those in
`refinements/implementation/` for each layer. Check one a previous pass
cleared again too, since the refinements made since may have created new
instances of it. For each:

1. **Draw how it works now.** Sketch the system or the layer as a small ASCII
   diagram and state it against the principles. Where the drawing is awkward
   to make, the design usually is too, and that is the first refinement.
2. **Take the next refinement in the list.** When the operator has pointed at
   one instance ("why does Order keep both a total and a totalCents?"),
   answer the question asked first, then take that refinement before the
   rest.
3. **Find every instance in scope,** using its "How to spot it" list. A refinement
   with no instances is done for this pass. One instance spotted means more
   unspotted. Search the whole system for an architectural refinement, and the
   whole layer for an implementation one, so the refinement is applied
   consistently and not only where it happened to be noticed.
4. **Apply it.** Make the move at every instance. Stop and ask first only when
   it would change behavior the tests don't pin down, or an interface someone
   outside the repository depends on.
5. **Check it came out simpler.** Run the tests. Then read the diff for the
   sign that the refinement was right: the code got shorter, casts and
   converting loops fell away, and callers read more plainly. When callers, or
   the tests, got noisier, the move is one level off. Fix that before going on.
6. **Commit the refinement on its own.** One commit per refinement, titled for
   the shape the code now has, such as "an Order holds one total and formats
   it on request". The commits are the review: the operator reads each one as
   a step and can keep or revert any of them. Check that the commit itself
   builds and passes, since a file that a split deleted or added is easy to
   leave out of it. Read the whole diff first: a file the operator edited
   since you last wrote it carries their intent, such as a usage example to
   build toward.
7. **Next.** Take the next refinement in the list. When every architectural
   refinement has been checked, start on the public interface. When every
   implementation refinement has been checked in a layer, go one layer deeper.
   When a refinement belongs to an earlier stage, go back to it, as the loop
   describes.

Then report the principles used, the commits, each with the principle it came
from, the refinements checked that found nothing, and a diagram of the shape
the code ended in.

## Review

The operator reviews the commits, and may keep some instances and refuse
others ("the list is fine as it is", "the new type is excellent"). Revert what
was refused, without arguing it again, and carry the reason into the rest of
the pass. A refusal is a principle the project holds, so it reaches the instances
not yet refined too.

When the operator asks for a proposal, or to refine together, propose each
refinement before applying it: the instances, the move, and the principle it
comes from. Recommend one move rather than surveying several, keep it short
enough to approve line by line, and apply what the operator takes.

## Refinements

Each file under `refinements/` states one principle, then why breaking it costs
the reader, how to spot where the code breaks it, the move that fixes it, and
an example. The examples are contrived and written in
pseudocode, since each illustrates a principle rather than one language's
idiom.

Architecture, in `refinements/architecture/`:

- `module-envy.md`: a module holds knowledge another module owns.
- `divergent-change.md`: one module changes for several unrelated reasons.
- `reaching-through.md`: a caller goes past its interface into what's behind.
- `inner-conversions.md`: values change type away from the edges.
- `shared-files.md`: one file holds two cohesive things.
- `patch-per-case.md`: each counterexample gets its own fix, not a model.
- `logic-in-the-interface.md`: a front end holds the domain's logic.
- `combined-variants.md`: two axes of variation multiply into a file per pair.
- `template-methods.md`: a variant is spread across a base and its hooks.
- `buried-expectations.md`: a test's expected output is assembled in code.

Implementation, in `refinements/implementation/`. Data that has the wrong
shape:

- `similar-attributes.md`: two fields hold two views of one value.
- `entangled-values.md`: one value is read as what another leaves behind.
- `conditional-fields.md`: a field means something only when another says so.
- `flag-fields.md`: a field says which kind of value this is.
- `named-fields.md`: a constructor takes several same-typed values by position.
- `comments-for-types.md`: a comment says what a type could.
- `collection-types.md`: a collection lacks, or misuses, a type of its own.
- `foreign-comments.md`: a comment makes claims about other code.
- `constant-results.md`: part of a result never varies between calls.

Names that don't tell concepts apart:

- `domain-names.md`: a concept is named for a step, not the domain's term.
- `near-duplicate-names.md`: two types share a name or differ only by case.
- `commands-and-queries.md`: a method's name hides whether it acts or answers.
- `predicate-names.md`: a yes-or-no method isn't named as a question.

Functions that read unevenly or branch where a type could:

- `mixed-levels.md`: a function mixes named steps with one step's details.
- `flag-arguments.md`: a parameter picks which of two things a function does.
- `chained-errors.md`: errors returned at each step keep calls from chaining.
