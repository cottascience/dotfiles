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

link() {
    local src="$1" dst="$2"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        warn "Backing up existing $dst → ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    ln -sf "$src" "$dst"
    info "Linked $dst"
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
brew bundle install --file="$DOTFILES/Brewfile" --no-lock

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
info "Linking shell dotfiles..."
link "$DOTFILES/.zshrc" "$HOME/.zshrc"
link "$DOTFILES/.zshenv" "$HOME/.zshenv"
link "$DOTFILES/.zprofile" "$HOME/.zprofile"
link "$DOTFILES/.fzf.zsh" "$HOME/.fzf.zsh"
link "$DOTFILES/.gitconfig" "$HOME/.gitconfig"

# ============================================================================
# XDG config dirs
# ============================================================================
info "Linking XDG configs..."
mkdir -p "$HOME/.config"

configs=(
    bat
    gh
    ghostty
    git
    karabiner
    lazygit
    marimo
    nvim
    yazi
    zed
)

for dir in "${configs[@]}"; do
    link "$DOTFILES/.config/$dir" "$HOME/.config/$dir"
done

# Standalone config files
link "$DOTFILES/.config/starship.toml" "$HOME/.config/starship.toml"

# macOS key bindings
mkdir -p "$HOME/Library/KeyBindings"
link "$DOTFILES/.config/KeyBindings/DefaultKeyBinding.dict" "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"

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
