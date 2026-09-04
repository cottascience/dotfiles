---
name: deslop
description: Remove AI-generated artifacts and make recent changes consistent with the surrounding codebase.
disable-model-invocation: true
argument-hint: "[path]"
---

# Deslop recent changes

Review `$ARGUMENTS` when provided. Otherwise, in a Git repository, inspect
changes in this order: staged, unstaged, then the current branch against its
base. Outside a Git repository, inspect files changed in this conversation.

Remove:

- Comments that restate the code or do not match the surrounding style.
- Unnecessary defensive checks, exception handling, casts, and abstractions.
- One-use variables or helpers that obscure straightforward code.
- Redundant validation already guaranteed by callers.
- Style drift, typing errors, warnings, and violations of repository guidance.

Preserve behavior. Prefer module-level imports, existing local idioms, and
composition over unnecessary inheritance. Run relevant focused checks after
editing, including pre-commit when the repository uses it.

End with a one-to-three-sentence summary of what changed.
