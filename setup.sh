#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

info() { echo -e "${GREEN}[+]${RESET} $1"; }
warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
error() { echo -e "${RED}[x]${RESET} $1"; }

copy_file() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    info "Copied $dst"
}

copy_dir() {
    local src="$1" dst="$2"
    mkdir -p "$dst"
    rsync -a "$src/" "$dst/"
    info "Synced $dst/"
}

# ============================================================================
# Homebrew
# ============================================================================
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    info "Homebrew already installed"
fi

# ============================================================================
# Rust
# ============================================================================
if ! command -v rustup &>/dev/null; then
    info "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    . "$HOME/.cargo/env"
else
    info "Rust already installed"
fi

# ============================================================================
# uv
# ============================================================================
if ! command -v uv &>/dev/null; then
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    info "uv already installed"
fi

# ============================================================================
# Brewfile
# ============================================================================
info "Installing Brewfile packages..."
brew bundle install --file="$DOTFILES/Brewfile"

# ============================================================================
# npm packages (requires node from Brewfile)
# ============================================================================
info "Installing npm packages..."
npm install -g osgrep pnpm

# ============================================================================
# Claude Code (requires node from Brewfile)
# ============================================================================
if ! command -v claude &>/dev/null; then
    info "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    info "Claude Code already installed"
fi

# ============================================================================
# FFF
info "Installing FFF..."
curl -L https://dmtrkovalenko.dev/install-fff-mcp.sh | bash

# ============================================================================
# Shell dotfiles
# ============================================================================
info "Copying shell dotfiles..."
for f in .zshrc .zshenv .zprofile .fzf.zsh .gitconfig; do
    copy_file "$DOTFILES/$f" "$HOME/$f"
done

# ============================================================================
# XDG config dirs
# ============================================================================
info "Copying XDG configs..."
mkdir -p "$HOME/.config"

configs=(bat gh ghostty git karabiner lazygit marimo nvim yazi zed)
for dir in "${configs[@]}"; do
    copy_dir "$DOTFILES/.config/$dir" "$HOME/.config/$dir"
done

# Standalone config files
copy_file "$DOTFILES/.config/starship.toml" "$HOME/.config/starship.toml"

# macOS key bindings
copy_file "$DOTFILES/.config/KeyBindings/DefaultKeyBinding.dict" "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"

# ============================================================================
# Claude Code config
# ============================================================================
CLAUDE_REPO="$DOTFILES/.claude"
CLAUDE_DIR="$HOME/.claude"

info "Pushing Claude config from repo -> $CLAUDE_DIR"
for f in CLAUDE.md settings.json trim-superpowers.sh; do
    [[ -f "$CLAUDE_REPO/$f" ]] && copy_file "$CLAUDE_REPO/$f" "$CLAUDE_DIR/$f"
done
[[ -d "$CLAUDE_REPO/commands" ]] && copy_dir "$CLAUDE_REPO/commands" "$CLAUDE_DIR/commands"
[[ -f "$CLAUDE_DIR/trim-superpowers.sh" ]] && chmod +x "$CLAUDE_DIR/trim-superpowers.sh"

# Install plugins
if [[ -f "$CLAUDE_REPO/plugins.txt" ]]; then
    info "Installing Claude plugins from plugins.txt"
    while IFS=' ' read -r name version; do
        [[ -z "$name" || "$name" == "#"* ]] && continue
        info "  installing $name (v$version)..."
        claude plugin install "$name" 2>/dev/null || warn "  failed to install $name"
    done <"$CLAUDE_REPO/plugins.txt"
fi

# ============================================================================
# Neovim bootstrap
# ============================================================================
info "Bootstrapping Neovim plugins (headless)..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || warn "Neovim plugin sync had warnings (run nvim manually to check)"

# ============================================================================
# Done
# ============================================================================
echo ""
echo -e "${BOLD}${GREEN}Setup complete.${RESET}"
echo ""
echo "Optional manual installs:"
echo "  - Anaconda/Miniconda → https://docs.conda.io/en/latest/miniconda.html"
echo "  - MacTeX             → https://tug.org/mactex/"
echo ""
echo "Open a new terminal to load the shell config."
