# dotfiles

```sh
git clone git@github.com:cottascience/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh                      # push configs to a new local machine (full setup)
./setup.sh --remote [HOST_NAME] # push configs to a new remote machine (minimal non-sudo setup)
./pull.sh                       # pull configs from a running machine into the repo
```

neovim, zed, ghostty, starship, karabiner, lazygit, yazi, bat, k9s, paneru,
claude code (+ rtk, osgrep, caveman, ponytail), codex. catppuccin mocha
everywhere, `#1a1a24` background.

## Not tracked (public repo)

- `~/.zshenv.local` — machine-specific env, sourced by `.zshenv` if present.
- `~/.ssh` keys, credentials, auth state (`gh auth login`, `claude` login).
