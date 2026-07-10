## AGENTS.md

# AGENTS.md

This document outlines the conventions and commands for agents operating within this
repository. **Write the simplest possible code that works.**

## Core Philosophy: Simplicity First

Inspired by practitioners who value clarity and minimalism:

- **Fewer Lines Win**: The best code is code you don't write. Before adding
  functionality, ask if it's necessary.
- **Flat is Better**: Write procedural, C-like code. Avoid deep nesting, abstraction
  layers, and unnecessary indirection.
- **Read Top to Bottom**: Code should be understandable by reading it sequentially,
  like a script.
- **No Clever Code**: If you have to choose between a clever one-liner and a clear
  multi-line equivalent, always choose clarity.
- **Self-Contained**: Prefer copying a small function over adding a dependency. Avoid
  framework magic at all costs.

## When to Use Classes

Use a class **only** when you need to bundle state with methods that operate on that
state (e.g., `Model`, `Dataset`, `Optimizer`, `Config`). Otherwise, use functions.

**No**: Helper classes, utility classes, static method containers, manager classes.

**Yes**: A neural network model with parameters and a forward pass.

## Build, Lint, and Test Commands

- **Build**: `uv run python setup.py build`
- **Lint**: `uv run ruff check .`
- **Test**: `uv run pytest -vvs`
- **Run Single Test**: `uv run pytest -vvs path/to/test_file.py::test_function`

## Code Style Guidelines

### Imports

Organize imports alphabetically: standard library first, then third-party, then local.

```python
import os
import sys

import numpy as np
import torch

from .module import helper
```

### Formatting

- **Line Length**: Max 80 characters.
- **Function Length**: Keep functions under 50 statements. If longer, break into
  helpers.
- **No Magic Numbers**: Use named constants. `MIN_SAMPLES = 3` not `if n < 3:`.

### Types

- Use type hints for all function arguments and return values.
- Use modern built-in types: `list[int]`, `dict[str, float]`, not `List`, `Dict`.
- **No `Any`**: Use specific types or unions: `int | float | np.ndarray`.
- Annotate tensor shapes in comments:

```python
def forward(x: np.ndarray) -> np.ndarray:  # [batch, features] -> [batch, logits]
    ...
```

### Naming Conventions

- **Variables/Functions**: `snake_case`
- **Classes**: `PascalCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Tech Terms**: Prefer direct concatenation: `word2vec`, `dataloader`, not
  `word_to_vec`, `data_loader`.
- **Avoid Ambiguity**: Never use `l` (looks like 1) or `O` (looks like 0).
- **Internal Use**: Prefix with `_` for non-public functions.

### Logging, Not Printing

Never use `print()` for debugging or output. Use the `logging` module.

### Docstrings

- **Module-Level**: Every `.py` file starts with a one-line docstring ending in a
  period.
- **Public Functions**: Require a concise one-line docstring ending in a period.
- **Internal Functions** (`_`-prefixed): No docstring required.

```python
"""Simple neural network implementation."""

def train(model, data):
    """Trains the model on the provided data."""
    ...
```

### Error Handling

Use standard Python exceptions with clear messages. Use `try...except` for operations
that may fail, but don't catch exceptions you can't handle.

## Cursor and Copilot Rules

- Check for Cursor rules in `.cursor/rules/` or `.cursorrules`.
- Check for Copilot rules in `.github/copilot-instructions.md`.

## General Agent Guidelines

- Always use absolute paths when interacting with the file system.
- Prioritize using provided tools over executing arbitrary shell commands.
- Ensure all code changes are accompanied by relevant tests.
- **Before writing code, ask**: Can I do this in fewer lines? Can I remove
  abstraction?
