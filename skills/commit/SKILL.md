---
name: commit
description: REQUIRED whenever writing a commit message or making a commit.
license: MPL-2.0
---
<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Commit

Commit messages describe the human benefit goal, not a technical outcome.

Read the diff before drafting. The diff says what changed; the message says why
it was worth doing.

Most commits are a title and at most a short paragraph.

## Rules

Two rules sit above the rest.

- **Clarity outranks the framing.** Be clear and obvious. When following a rule
  leaves the reader unable to tell what changed, say plainly what changed
  instead. A snapshot of stock config or a dependency upgrade takes a plain
  title, because that is what it is. A fix reads as a fix. Restoring intended
  behavior is not a new benefit, and a title promising one hides that anything
  was ever broken.
- **A commit that snapshots external content cites its source.** The URL in the
  body, under a plain title, is the whole message, and the rules below have
  nothing left to decide.

The rest run in order of reach. What each one settles is what the rules under it
have left to choose.

1. **Write plainly.** Short declarative sentences. No em dashes, no headings, no
   rhetorical construction or antithesis or parallel clauses. Every sentence
   stays grammatically complete. Compression that leaves a fragment has gone too
   far. Title and body each stand alone, with no pronoun in the body pointing
   back at the title.
2. **The title is the todolist item that would have asked for this work.** A verb
   and its object, short enough to jot down. Imagine the request, never a reason
   behind it.
   - **The item asks for something to happen.** A title describing the state the
     code is now in has stopped being one, though naming the tool or the file is
     fine when that is what was wanted.
   - **The item leaves out the audience.** No one writes the audience on their
     own list, so a title opening on a frame or built around a beneficiary spends
     its words on what the repository already implies.
   - **The item points precisely.** Make it specific enough that ticking it off
     means this commit. Naming the standard, attribute, number, or file kind the
     work turns on is what makes the benefit clear to someone skimming the log.
     Write each term in full and no narrower than the work.
   - **The item asks for one change.** A title that needs an "and" usually
     holds two items, and the commit should be split. An "and" joining the
     parts of a single thing is still one item.
3. **The body explains why, and the why is what a person can now do.** What the
   previous behavior lacked is still mechanics, as is how a framework or
   language feature works. One sentence may name what was added, so the body
   stands alone. Beyond that the diff covers it.
4. **Say nothing the diff or a config file already says.** Numbers, thresholds,
   ordering rules, and the reasoning behind them are all visible there, as are
   function names, flags, and call sites. Restatement is what makes a message
   long, not the count of paragraphs, so cutting until the distinction that
   justifies the change goes with it has cut the wrong thing. Filler goes for a
   second reason: a sentence that only introduces the next one makes the next
   one read as a summary rather than a claim, and unchecked assertions hide
   there.
5. **Claim only what is true and what shipped.** Give the real reason, never a
   rationale invented while drafting. Leave out the improvement you hope follows
   from the change. State a trade-off only when a real cost was knowingly
   accepted, and then say why it is the right call. A title carried over from an
   earlier draft can name a design that review has since removed, so read it
   again when the work is amended.

## A body with more than one part

Read `references/argument.md` before drafting a body that carries several
causes, several parallel cases, or prior commits to cite. Arranging those is a
separate problem, and the rules above still govern the result.
