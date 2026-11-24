---
name: git-gardening
description: REQUIRED whenever asked to restructure, rebase, or clean up a branch's commit history.
license: MPL-2.0
---
<!--
Copyright (c) 2026 Joseph Hale
SPDX-License-Identifier: MPL-2.0
-->

# Git Gardening

Restructure a messy commit history into a clear, pedagogical narrative that shows
the progression from current state to desired state.

## Philosophy

### Expand → Enhance → Contract

1. **Expand (Refactor)**: Modify existing code to make desired changes easy,
   preserving all existing functionality. Ask: "What would make the next change
   trivial?"

2. **Enhance (Feature)**: Add new functionality. Bundle styling, fixes, and
    improvements that are tightly coupled to the feature. Don't separate them.

3. **Contract (Cleanup)**: Remove code that's now obsolete or unnecessary.

This sequence shows pedagogical progression: prepare the system, improve it,
clean up.

## Key Principles

- **Source of truth**: The diff, not commit messages. Use commit messages as hints
    about intent, but trust what the code actually changed.

- **Independent deployability**: Each commit should be releasable. Tests pass at
    every step. No commit depends on unstated assumptions from later commits.

- **Pedagogical order**: Order commits to show a clear learning narrative, not
    temporal order. A future reader should understand *why* changes were made in
    this sequence.

- **High-level commits for git blame**: When someone runs `git blame` on a line,
    they want to see the broader feature/goal it belonged to, along with related
    changes. This provides context about *why* a line exists in its current form.

- **Strip development artifacts**: The final history should read as intentional
    narrative. Reverts, fixup commits, planning files (e.g. `tasks/todo.md`),
    and development-only comments must not appear in the gardened history.

- **Exception**: If a source commit contains extensive reasoning about *why* a
    change differs from standard practice, consider keeping it as a separate commit
    rather than burying it in a larger feature commit. The pedagogical value of
    that explanation may justify the extra commit.

## Agent Workflow

### Phase 1: Analysis & Proposal (Checkpoint)

1. **Create safety net**
    - Run `start-gardening.sh` to create a `<branch>-backup` branch
    - This allows restoration if anything goes wrong during gardening

2. **Verify the starting state**
    - Confirm working directory is clean (no uncommitted changes except the changeset)
    - Identify the merge-base with the upstream branch
    - If in an intermediate state (partially rebased), ask user before proceeding

3. **Analyze the changeset**
    - Read all commit messages in the original history as intent hints
    - Extract explicit co-authors using `git log --pretty=format:"%h %s%n%b" |
      grep -i "co-authored"`
    - Identify all commit authors using `git log --pretty=format:"%h %an %s"` to
      capture contributors whose commits are being consolidated
    - Apply diff to branch, starting from merge-base
    - Verify against actual diffs (trust the code, not the message)
    - Identify logical groupings using Expand→Enhance→Contract lens
    - Look for commits with extensive reasoning (candidates for keeping separate)

4. **Consider simplification**
    - For large changesets (15+ commits), consider proposing squashing
        similar commits to make planning easier
    - Note: We'll do multiple passes of refinement if needed

5. **Propose structure**
    - Skip this step and the next if the user has already named a specific
      structure, such as "squash to one commit" or "split into these three".
      That counts as approval. "Clean this up" names no structure
    - Apply system prompt atomic work decomposition philosophy, e.g. features,
      bug fixes, refactoring, documentation, and configuration must be separate
      commits even if logically related
    - Check each proposed title for an "and". It usually joins two changes that
      belong in separate commits, unless it joins the parts of a single thing
    - Present as **one-liners only** at this stage
    - For each proposed commit: title + one-line description + type (feat/fix/refactor)
    - Use Expand→Enhance→Contract lens to order commits pedagogically
    - Include a **recommendation** (which structure you think is best)
    - Include **2-3 alternatives** with pros/cons for each
    - Ask clarifying questions if the intent of the changeset is unclear

6. **Wait for feedback**
    - Do not proceed to Phase 2 until you receive approval or corrections
    - Iterate on proposal based on feedback

### Phase 2: Execution

1. **Execute the rebase**
    - Apply changes in the proposed order
    - Write each message with the `/commit` skill, carrying rationale over from
      the source commits and listing all co-authors: both explicit
      "Co-Authored-By" lines AND authors of consolidated commits
    - Read each carried-over title again, since a source commit's title can
      name a design the branch later removed
    - Run tests and linting at each step
    - Fix any issues that arise

2. **Verify and clean up**
    - Run `finish-gardening.sh` to verify all changes were preserved
    - This compares diffs against the backup branch and removes it on success
    - Run full test suite
    - Show final commit log

### Phase 3: Skill Refinement (Post-Mortem)

After the gardening task is complete, always engage in a brief post-mortem to
refine this skill for future use.

 1. **Reflect on the process**
    - "When did the user correct my approach/philosophy? Why?"
    - "Did the Expand→Enhance→Contract framework fit this changeset well?"
    - "Were there any edge cases or decisions this skill didn't account for?"
    - "Did the final commit structure achieve the right level of pedagogical granularity?"
    - "Were there moments where you had to deviate from the skill's guidance?"

 2. **Propose specific updates to the skill**
    - Based on the reflection, suggest concrete edits to the skill's philosophy,
      principles, or workflow.
    - Example: "Based on our conversation, I'd like to update the skill to
      clarify that [specific change]"

## Decision Framework

### When to Squash/Regroup Commits

- **Squash if**: Commits are tightly interdependent (one doesn't work without
  the other)
- **Squash if**: Commit messages are vague or don't add narrative value
- **Squash if**: Changes are in the same few files and form a cohesive unit
- **Keep separate if**: Commits show distinct pedagogical steps in the sequence
- **Keep separate if**: A commit has substantial reasoning that enriches the history
- **Split if**: A commit mixes concerns that belong in different phases
    (e.g., refactoring + feature + cleanup together)
- **Reorder if**: Temporal order inhibits clear pedagogical order (prefer pedagogical)

### How to Detect Pedagogical Progression

A sequence has good pedagogical progression when:

- Early commits explain *why* later commits are possible
- Each commit is understandable without reading ahead
- The sequence answers: "Why refactor first? Why add this feature? Why remove
  this code?"
- Temporal order and pedagogical order align *most of the time* (but prefer pedagogy)

### How to Preserve Rationale and Attribution

- Search source commits for extensive explanations (multi-paragraph messages)
- Extract the "why" and integrate it into your new commit message
- Preserve all co-authors from source commits, even if different commits have
    different author lists (some commits may have subsets of contributors)
- If a rationale is too specific/long to naturally fit in the new commit, that
    might indicate the commit should stay separate (exception case)
- Link back to original commit hashes in parentheses if helpful for traceability
  - NOTE: Never include the pre-rewrite hashes of the branch being gardened. Those
      evaporate on rebase, so they belong only in plans and approval requests.
  - A commit already on the default branch is durable and checkable, and citing
      one is the fastest way to make a regression traceable.

## Quality Checks

Each commit must:

- Have a message written per the `/commit` skill
- Include all relevant co-author attribution
- Pass the project's relevant linting/ci type checks at that commit
- Pass tests at that commit
- Include tests with the code they validate (not separate commits)
- Be independently deployable

## Questions to Ask the User

During analysis, if unclear:

- "What was the primary goal of this changeset?" (helps identify Enhance step)
- "What changes made this feature easier to implement?" (helps identify Expand step)
- "What code became unnecessary once this feature was complete?" (helps identify
  Contract step)
- "Are there commits with rationale that should be preserved separately?"
- "Should I start with a basic squash to make planning easier?"
- "Who should be credited as co-authors for the new commits?"
