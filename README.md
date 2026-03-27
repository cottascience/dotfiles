# dotfiles

Personal macOS development environment configuration.

## Install

```sh
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The script handles everything automatically:

1. Installs Homebrew (if missing)
2. Installs Rust via rustup (if missing)
3. Installs uv (if missing)
4. Runs `brew bundle install` (all brew, cask, cargo, npm, and uv packages)
5. Installs Claude Code via npm (if missing)
6. Symlinks all dotfiles and XDG configs to `$HOME`
7. Bootstraps Neovim plugins headlessly

Existing files at link targets are backed up to `<path>.bak`.

## Manual (optional)

These are not automated because they require interactive setup or are environment-specific:

- **Anaconda/Miniconda**: `.zshrc` has a lazy-loaded conda wrapper expecting `/opt/anaconda3`
- **MacTeX**: `/Library/TeX/texbin` is on PATH for LaTeX workflows

## What's inside

| Component | Location                | Notes                                       |
| --------- | ----------------------- | ------------------------------------------- |
| Neovim    | `.config/nvim/`         | LazyVim-based, self-bootstrapping           |
| Zed       | `.config/zed/`          | Settings synced with Neovim                 |
| Ghostty   | `.config/ghostty/`      | Terminal emulator                           |
| Starship  | `.config/starship.toml` | Shell prompt                                |
| Karabiner | `.config/karabiner/`    | ISO keyboard # / £ swap                     |
| Brewfile  | `Brewfile`              | All brew, cask, cargo, npm, and uv packages |

Theme: Catppuccin Mocha with custom background `#1a1a24`, applied across all tools.
