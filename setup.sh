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
else
    info "Rust already installed"
fi
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# ============================================================================
# uv
# ============================================================================
if ! command -v uv &>/dev/null; then
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    info "uv already installed"
fi
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# ============================================================================
# Brewfile
# ============================================================================
info "Installing Brewfile packages..."
brew bundle install --file="$DOTFILES/Brewfile"

# tdf is not published to crates.io, so Brewfile's cargo integration cannot
# install it by package name.
if ! command -v tdf &>/dev/null; then
    info "Installing tdf..."
    cargo install --git https://github.com/itsjunetime/tdf.git
else
    info "tdf already installed"
fi

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

configs=(bat gh ghostty git k9s karabiner md-to-pdf nvim tridactyl yazi zed)
for dir in "${configs[@]}"; do
    copy_dir "$DOTFILES/.config/$dir" "$HOME/.config/$dir"
done

# Standalone config files
copy_file "$DOTFILES/.config/starship.toml" "$HOME/.config/starship.toml"

# macOS key bindings
copy_file "$DOTFILES/.config/KeyBindings/DefaultKeyBinding.dict" "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"

# ============================================================================
# Firefox (installed by the Brewfile cask)
# ============================================================================
FF_APP="/Applications/Firefox.app"
FF_ROOT="$HOME/Library/Application Support/Firefox"
FF_STEPS=()

# compatibility.ini is rewritten on every launch, so the newest one marks the
# profile in use (profiles.ini lists one per install, often stale)
latest_ff_profile() {
    local f
    f="$(ls -t "$FF_ROOT"/Profiles/*/compatibility.ini 2>/dev/null | head -1 || true)"
    [[ -n "$f" ]] && dirname "$f" || true
}

if [[ -d "$FF_APP" ]]; then
    # Extensions + URL bar search keywords. Lives inside the app bundle, so
    # Firefox updates can wipe it: re-run setup.sh after updating Firefox.
    if mkdir -p "$FF_APP/Contents/Resources/distribution" 2>/dev/null &&
        cp "$DOTFILES/firefox/policies.json" "$FF_APP/Contents/Resources/distribution/policies.json" 2>/dev/null; then
        info "Copied Firefox policies.json"
    else
        warn "Could not write into $FF_APP"
        FF_STEPS+=("Give your terminal 'App Management' access (System Settings > Privacy & Security > App Management), then re-run setup.sh.")
    fi

    # Fresh install: let Firefox create its default profile with a headless run
    if [[ -z "$(latest_ff_profile)" ]] && ! pgrep -xq firefox; then
        info "Creating Firefox profile (headless first run)..."
        "$FF_APP/Contents/MacOS/firefox" --headless >/dev/null 2>&1 &
        ff_pid=$!
        for _ in $(seq 30); do
            [[ -n "$(latest_ff_profile)" ]] && break
            sleep 1
        done
        sleep 5 # ponytail: fixed grace period for first-run writes; extensions finish installing on the next real launch anyway
        kill "$ff_pid" 2>/dev/null || true
        wait "$ff_pid" 2>/dev/null || true
    fi

    FF_PROFILE="$(latest_ff_profile)"
    if [[ -d "$FF_ROOT" ]] && ! ls "$FF_ROOT" >/dev/null 2>&1; then
        # macOS blocks terminals from other apps' data without Full Disk Access
        warn "macOS blocked access to $FF_ROOT"
        FF_STEPS+=("Give your terminal 'Full Disk Access' (System Settings > Privacy & Security > Full Disk Access), quit and reopen the terminal, then re-run setup.sh.")
    elif [[ -n "$FF_PROFILE" ]]; then
        copy_file "$DOTFILES/firefox/user.js" "$FF_PROFILE/user.js"
        copy_dir "$DOTFILES/firefox/chrome" "$FF_PROFILE/chrome"
        copy_file "$DOTFILES/custom_background.jpg" "$FF_PROFILE/chrome/wallpaper.jpg"
        if pgrep -xq firefox; then
            FF_STEPS+=("Quit Firefox completely (Cmd+Q) and reopen it so it loads user.js and the theme.")
        fi
    else
        warn "No Firefox profile found"
        FF_STEPS+=("Open Firefox once, quit it, then re-run setup.sh to apply the theme and settings.")
    fi

    # Tridactyl native messenger: lets Tridactyl read ~/.config/tridactyl and open nvim
    if [[ ! -f "$HOME/Library/Application Support/Mozilla/NativeMessagingHosts/tridactyl.json" ]]; then
        info "Installing Tridactyl native messenger..."
        curl -fsSL https://raw.githubusercontent.com/tridactyl/native_messenger/master/installers/install.sh | sh ||
            warn "Tridactyl native messenger install failed (run :nativeinstall inside Firefox)"
    else
        info "Tridactyl native messenger already installed"
    fi

    # Catppuccin userstyles for Stylus: Stylus keeps styles in its own
    # database, so the import itself has to be done by hand
    ctp_json="$HOME/Downloads/catppuccin-userstyles.json"
    if curl -fsSL -o "$ctp_json" https://github.com/catppuccin/userstyles/releases/download/all-userstyles-export/import.json; then
        info "Downloaded $ctp_json"
    else
        warn "Could not download Catppuccin userstyles"
    fi

    FF_STEPS+=("On the next Firefox launch, Tridactyl, Stylus and Refined GitHub install themselves within a few seconds. If Firefox asks about Tridactyl changing your new tab page, click 'Keep changes'.")
    stylus_uuid=""
    [[ -n "$FF_PROFILE" ]] && stylus_uuid="$(grep -o '{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}\\":\\"[0-9a-f-]*' "$FF_PROFILE/prefs.js" 2>/dev/null | grep -oE '[0-9a-f-]{36}$' || true)"
    if [[ -n "$stylus_uuid" ]]; then
        FF_STEPS+=("Open the Stylus manager: paste moz-extension://$stylus_uuid/manage.html into the address bar.")
    else
        FF_STEPS+=("Open the Stylus manager: click the puzzle-piece icon (top right) > Stylus > Manage.")
    fi
    FF_STEPS+=("In the Stylus manager's left column, scroll to Backup, click Import, pick ~/Downloads/catppuccin-userstyles.json, and confirm.")
    FF_STEPS+=("Optional: sign in to Firefox Sync for bookmarks, passwords and pinned sites (not stored in dotfiles).")
else
    warn "Firefox not installed, skipping Firefox config"
    FF_STEPS+=("Install Firefox (brew install --cask firefox), then re-run setup.sh.")
fi

# ============================================================================
# Claude Code config
# ============================================================================
CLAUDE_REPO="$DOTFILES/.claude"
CLAUDE_DIR="$HOME/.claude"

info "Pushing Claude config from repo -> $CLAUDE_DIR"
for f in CLAUDE.md settings.json; do
    [[ -f "$CLAUDE_REPO/$f" ]] && copy_file "$CLAUDE_REPO/$f" "$CLAUDE_DIR/$f"
done
[[ -d "$CLAUDE_REPO/skills" ]] && copy_dir "$CLAUDE_REPO/skills" "$CLAUDE_DIR/skills"

# Install marketplaces and plugins declared in settings.json
info "Configuring Claude plugin marketplaces"
while IFS=$'\t' read -r name source; do
    marketplaces="$(claude plugin marketplace list 2>/dev/null || true)"
    if grep -q "$name" <<<"$marketplaces"; then
        info "  marketplace $name already configured"
    else
        info "  adding marketplace $name..."
        claude plugin marketplace add "$source" || warn "  failed to add marketplace $name"
    fi
done < <(
    jq -r '
        .extraKnownMarketplaces // {}
        | to_entries[]
        | select(.value.source.source == "github")
        | [.key, .value.source.repo]
        | @tsv
    ' "$CLAUDE_REPO/settings.json"
)

info "Installing enabled Claude plugins"
while IFS= read -r plugin; do
    info "  installing $plugin..."
    claude plugin install "$plugin" || warn "  failed to install $plugin"
done < <(
    jq -r '
        .enabledPlugins // {}
        | to_entries[]
        | select(.value == true)
        | .key
    ' "$CLAUDE_REPO/settings.json"
)
info "Done installing Claude plugins"
rtk init -g --auto-patch
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
echo ""
echo "Manual steps (not tracked in this public repo):"
echo "  - Copy ~/.ssh keys and any ~/.zshenv.local (machine-specific env)"
echo "  - Authenticate: gh auth login, claude login"
echo ""
echo "Firefox (in order):"
for i in "${!FF_STEPS[@]}"; do
    echo "  $((i + 1)). ${FF_STEPS[$i]}"
done
echo ""
echo "Open a new terminal to load the shell config."
