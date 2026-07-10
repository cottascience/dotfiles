# dotfiles

```sh
git clone git@github.com:cottascience/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh                      # push configs to a new local machine (full setup)
```

neovim, zed, ghostty, starship, karabiner, lazygit, yazi, bat, k9s, paneru,
claude code (+ rtk, osgrep, caveman, ponytail), codex. catppuccin mocha
everywhere, `#1a1a24` background.

## Not tracked, do it yourself

- `~/.zshenv.local` — machine-specific env, sourced by `.zshenv` if present.
- `~/.ssh` keys, credentials, auth state (`gh auth login`, `claude` login).
