Description: Remove AI code slop
argument-hint:
────

Remove all AI generated slop from recent changes.

## Find changes to review

If in a git repo, check diffs in order: `git diff --cached`, `git diff`, then `git diff main..HEAD`. Otherwise, review files modified this conversation.

## What counts as AI slop

- Extra comments that a human wouldn't add or is inconsistent with the rest of the file.
- Extra defensive checks or try/catch blocks that are abnormal for that area of the codebase (especially if called by trusted / validated codepaths).
- Variables or functions that are only used a single time right after declaration, prefer inlining the rhs/function.
- Redundant checks/casts inside a function that the caller also already takes care of.
- Any other style that is inconsistent with the file, including using types when the file doesn't.
- Inconsistency with AGENTS.md requirements.
- Typing errors and warnings given by basedpyright. Fix them if possible, if not, ask the user to fix them. Prefer adding type assertions over additional, implicitt, unused or redundant type annotations.
- If pre-commit is installed in the environment, run it on the files you modified after doing `git add`. If pre-commit fails, fix the errors or ask the user to fix them.
- Imports that are not module-level imports, prefer relative imports.
- Unnecessary class inheritance, prefer composition over inheritance.
- Classes that could be functions, namedtuples, or dataclasses.

Report at the end with only a 1-3 sentence summary of what you changed.
