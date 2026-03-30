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
# Remote setup: ./setup.sh --remote <host>
# ============================================================================
if [[ "${1:-}" == "--remote" ]]; then
    HOST="${2:?Usage: setup.sh --remote <host>}"
    info "Setting up remote host: $HOST"

    info "Syncing dotfiles..."
    rsync -az "$DOTFILES/.zshrc" "$DOTFILES/.zshenv" "$DOTFILES/.tmux.conf" "$HOST":~/
    ssh "$HOST" 'mkdir -p ~/.config ~/.config/bat'
    rsync -az "$DOTFILES/.config/starship.toml" "$HOST":~/.config/
    rsync -az "$DOTFILES/.config/bat/config" "$HOST":~/.config/bat/
    rsync -az --delete \
        --exclude '.git' \
        --exclude 'lazy-lock.json' \
        "$DOTFILES/.config/nvim/" "$HOST":~/.config/nvim/

    # Linux .zprofile — no brew/rbenv
    ssh "$HOST" 'printf "# remote — no platform-specific login setup\n" > ~/.zprofile'

    info "Installing tools on $HOST..."
    ssh -t "$HOST" 'bash -s' <<'REMOTE'
set -euo pipefail
LOCAL_BIN="$HOME/.local/bin"
PLUGINS="$HOME/.zsh"
mkdir -p "$LOCAL_BIN" "$PLUGINS"
export PATH="$LOCAL_BIN:$HOME/.cargo/bin:$PATH"

log() { printf '\033[1;34m==> %s\033[0m\n' "$1"; }
ok()  { printf '\033[1;32m  ✓ %s\033[0m\n' "$1"; }

# Rust toolchain
if command -v cargo &>/dev/null; then ok "cargo"
else
    log "Installing cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    . "$HOME/.cargo/env"
fi

# Cargo packages
for spec in eza:eza bat:bat fd:fd-find zoxide:zoxide; do
    cmd="${spec%%:*}" pkg="${spec##*:}"
    command -v "$cmd" &>/dev/null && ok "$cmd" && continue
    log "cargo install $pkg"; cargo install "$pkg"
done

# Standalone binaries
if ! command -v fzf &>/dev/null; then
    log "Installing fzf..."
    v=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | sed 's/^v//')
    curl -Lo /tmp/fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${v}/fzf-${v}-linux_amd64.tar.gz"
    tar -xzf /tmp/fzf.tar.gz -C "$LOCAL_BIN" && rm /tmp/fzf.tar.gz
else ok "fzf"; fi

if ! command -v starship &>/dev/null; then
    log "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$LOCAL_BIN"
else ok "starship"; fi

if ! command -v nvim &>/dev/null; then
    log "Installing nvim..."
    curl -Lo /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
    tar -xzf /tmp/nvim.tar.gz -C /tmp
    cp /tmp/nvim-linux-x86_64/bin/nvim "$LOCAL_BIN/" && rm -rf /tmp/nvim.tar.gz /tmp/nvim-linux-x86_64
else ok "nvim"; fi

# Zsh plugins
for repo in zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting kutsan/zsh-system-clipboard Aloxaf/fzf-tab; do
    name="${repo##*/}"
    [ -d "$PLUGINS/$name" ] && ok "$name" && continue
    log "Cloning $name..."; git clone --depth 1 "https://github.com/$repo.git" "$PLUGINS/$name"
done

# Stubs
[ -f "$LOCAL_BIN/env" ] || printf '#!/bin/sh\n# stub for uv/rye\n' > "$LOCAL_BIN/env"

# Wire bash → zsh (fallback when chsh unavailable)
if [ -f "$HOME/.bashrc" ] && ! grep -q 'exec zsh' "$HOME/.bashrc"; then
    log "Adding zsh exec to .bashrc..."
    printf '\n# Interactive sessions use zsh\nif command -v zsh &>/dev/null && [[ $- == *i* ]]; then exec zsh; fi\n' >> "$HOME/.bashrc"
fi

# Bootstrap nvim plugins
log "Bootstrapping nvim plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

log "Done — kill stale tmux sessions and reconnect."
REMOTE

    echo ""
    echo -e "${BOLD}${GREEN}Remote setup complete: $HOST${RESET}"
    exit 0
fi

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
info "Done installing Claude plugins"
rtk init -g
info "Done initializing rtk for Claude"

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
