# Claude Code dotfiles

This directory contains the durable, user-level Claude Code configuration that
`setup.sh` installs into `~/.claude`:

- `CLAUDE.md` contains global instructions.
- `settings.json` is the source of truth for settings, marketplaces, and plugins.
- `skills/` contains personal skills.

Runtime state under `~/.claude`—credentials, history, caches, downloaded
marketplaces, project memory, backups, and local settings—does not belong here.
In particular, `.claude/settings.local.json` is intentionally ignored by Git.
