#!/usr/bin/env bash
# Pull local configs into this dotfiles repo.
#
# Usage:
#   ./pull.sh

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

info() { echo -e "${GREEN}[+]${RESET} $1"; }
warn() { echo -e "${YELLOW}[!]${RESET} $1"; }

copy_file() {
    local src="$1" dst="$2"
    if [[ -f "$src" ]]; then
        mkdir -p "$(dirname "$dst")"
        cp "$src" "$dst"
        info "copied $src"
    else
        warn "skip $src (not found)"
    fi
}

sync_dir() {
    local src="$1" dst="$2"
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        # exclude machine-local noise (zed prompt db, karabiner backups, empty theme dirs)
        rsync -a --delete \
            --exclude 'automatic_backups/' \
            --exclude 'prompts/' \
            --exclude 'themes/' \
            "$src/" "$dst/"
        info "synced $src/"
    else
        warn "skip $src/ (not found)"
    fi
}

# ============================================================================
# Shell dotfiles
# ============================================================================
echo "Shell dotfiles"
for f in .zshrc .zshenv .zprofile .fzf.zsh .gitconfig; do
    copy_file "$HOME/$f" "$DOTFILES/$f"
done
echo ""

# ============================================================================
# XDG config dirs
# ============================================================================
echo "XDG configs"
configs=(bat gh ghostty git k9s karabiner lazygit marimo md-to-pdf nvim paneru yazi zed)
for dir in "${configs[@]}"; do
    sync_dir "$HOME/.config/$dir" "$DOTFILES/.config/$dir"
done

# Standalone config files
copy_file "$HOME/.config/starship.toml" "$DOTFILES/.config/starship.toml"

# macOS key bindings
copy_file "$HOME/Library/KeyBindings/DefaultKeyBinding.dict" "$DOTFILES/.config/KeyBindings/DefaultKeyBinding.dict"
echo ""

# ============================================================================
# Claude Code
# ============================================================================
echo "Claude config"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_REPO="$DOTFILES/.claude"

for f in CLAUDE.md RTK.md settings.json; do
    copy_file "$CLAUDE_DIR/$f" "$CLAUDE_REPO/$f"
done

sync_dir "$CLAUDE_DIR/commands" "$CLAUDE_REPO/commands"

# Extract plugin list for reproducibility
installed="$CLAUDE_DIR/plugins/installed_plugins.json"
if [[ -f "$installed" ]]; then
    jq -r '.plugins | to_entries[] | "\(.key) \(.value[0].version)"' "$installed" \
        >"$CLAUDE_REPO/plugins.txt"
    info "generated plugins.txt"
fi
echo ""

# ============================================================================
# Brewfile
# ============================================================================
echo "Brewfile"
# brew bundle dump captures tap/brew/cask/cargo/uv/npm — merge with any manual
# entries it can't know about (tools not installed via brew)
brewfile="$DOTFILES/Brewfile"
tmpfile="$(mktemp)"
brew bundle dump --file="$tmpfile"
if [[ -f "$brewfile" ]]; then
    grep -vE '^(tap |brew |cask |#)' "$brewfile" >>"$tmpfile" || true
fi
# drop exact duplicates, keep first occurrence (dump now emits cargo/uv/npm too)
awk '!seen[$0]++' "$tmpfile" >"$brewfile"
rm -f "$tmpfile"
info "dumped Brewfile (preserved manual entries, deduped)"
echo ""

echo "Done. Review changes with: git diff"
