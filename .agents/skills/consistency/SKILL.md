---
name: consistency
title: Consistency
description: >-
  The durable record of this project's major design choices, and the
  principles behind them. Use before changing anything a person using the
  project sees or relies on.
license: MPL-2.0
---
<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

Keep every choice recorded here true. If your change needs to break one, stop
and ask the operator. Where the code disagrees with a choice, the choice is the
intent, so raise the gap rather than copying the code.

## Principles

A principle is a governing idea that applies across the whole project.

- **<The principle, stated as a rule.>** <Why it holds, and what it asks of
  a change.> See `<commit>`.

## Where to look

Read the files that cover what your change touches.

- [features.md](features.md): the parts a person using the project meets by
  name, such as a component, a command or a mode.
- [glossary.md](glossary.md): the project's domain language.
- [history.md](history.md): how changes land as commits.

## Updating this skill

Change this skill only when the operator settles a lasting choice in their own
words, whether it's new or replaces one recorded here. A commit isn't their
words, even one they wrote or merged, since code can hold a shortcut meant to
be cleaned up later.

Write each choice as a rule in force, in plain words and the project's
spelling, without exceptions, history, or how the code carries it out. Call
each thing by the operator's name for it, and give the code's name as a synonym
where it differs. Where commits on the default branch settled the choice, end
with them, written as `abcdef12`.

Put each choice in the file that covers it, and follow that file's own Updating
this skill section if it has one. A choice that reaches across features gets a
top-level `<subject>.md`, listed under Where to look, and each of its kinds a
`<subject>/<kind>.md`.
