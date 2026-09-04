---
name: techdebt
description: Find and fix duplicated code, dead code, outdated patterns, code smells, and missing best practices.
disable-model-invocation: true
argument-hint: "[path]"
---

# Technical debt cleanup

Audit `$ARGUMENTS` when provided; otherwise audit the repository.

Look for:

- Duplicated logic that can be consolidated without obscuring intent.
- Dead imports, functions, branches, and commented-out code.
- Deprecated APIs and patterns that are outdated for the local toolchain.
- Excessive function size, parameters, nesting, or conditional complexity.
- Hardcoded configuration, missing error handling, and important test gaps.

Report findings with severity and file locations. Fix high-impact and safe
issues first while preserving behavior. Do not create commits unless asked.
Run the repository's relevant linters, type checks, and tests after editing.

Summarize what was found, fixed, and deliberately left for later.
