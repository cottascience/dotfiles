# ============================================================================
# PERFORMANCE OPTIMIZATIONS
# ============================================================================

DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# ============================================================================
# COMPLETION PATH
# ============================================================================

fpath=($(brew --prefix)/share/zsh/site-functions $fpath)

# ============================================================================
# CACHE CONFIGURATION
# ============================================================================

# Completion caching
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

# ============================================================================
# PACKAGE MANAGER INITIALIZATION
# ============================================================================

# >>> conda initialize >>>
conda() {
      eval "$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
      conda "$@"
}
# <<< conda initialize <<<

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

. "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/Library/TeX/texbin:$PATH"

# ============================================================================
# CUSTOM FUNCTIONS
# ============================================================================

# Create a new directory and enter it
mc () {
  if [ $# -ne 1 ]; then
    echo 'usage: mc <dir-name>'
    return 137
  fi
  local dir_name="$1"
  mkdir -p "$dir_name" && cd "$dir_name"
}

# Clean Python cache and compiled files
pyclean () {
  # Cleans py[cod] and cache dirs in the current tree:
  fd -I -H \
    '(__pycache__|\.(pytest_|mypy_)?cache|\.hypothesis\.py[cod]$)' \
  | xargs rm -rf
}

# Auto-list directory contents on directory change
chpwd() {
  ls
}

# Lazy load SSH agent
function _load_ssh_agent() {
    if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)" > /dev/null
        ssh-add ~/.ssh/id_github_sign_and_auth 2>/dev/null
    fi
}
autoload -U add-zsh-hook
add-zsh-hook precmd _load_ssh_agent

# ============================================================================
# VI MODE & KEYBINDINGS
# ============================================================================

# Enable vi key bindings
bindkey -v

# Vi-style command-line editing
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Cursor shape: block=normal, beam=insert
function zle-keymap-select {
  case $KEYMAP in
    vicmd)      printf '\e[2 q' ;;
    viins|main) printf '\e[6 q' ;;
  esac
}
zle -N zle-keymap-select

function zle-line-init { printf '\e[6 q' }
zle -N zle-line-init

# ============================================================================
# SHELL PLUGINS & INTEGRATIONS
# ============================================================================

# Replace completion with fzf
source $(brew --prefix)/share/fzf-tab/fzf-tab.zsh

# Auto-suggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# System clipboard
source /opt/homebrew/share/zsh-system-clipboard/zsh-system-clipboard.zsh

# Prompt theme
eval "$(starship init zsh)"

# Smarter cd navigation
eval "$(zoxide init zsh)"

# Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ============================================================================
# EDITOR CONFIGURATION
# ============================================================================

export EDITOR=nvim
export VISUAL=nvim

# ============================================================================
# TERMINAL CONFIGURATION
# ============================================================================

export TERM=xterm-256color

# ============================================================================
# ALIASES
# ============================================================================

# Directory listing with eza
alias ls="eza --icons"
alias ll="eza -l --icons"
alias la="eza -la --icons"

# Prettier commands
alias cat="bat"

# Global alias for piping to clipboard
alias -g C='| pbcopy'

# Easier rm -rf
alias rrm='rm -rf'

# md-to-pdf; --raw disables the Octarine [[wikilink]]/.attachments handling.
# Serves the target file's git repo root as basedir so relative image paths that
# climb above the md file (../../assets/x.png) still resolve; explicit --basedir wins.
md-to-pdf() {
  local raw=0 basedir_set=0 args=()
  local a; for a in "$@"; do
    case "$a" in
      --raw) raw=1 ;;
      --basedir|--basedir=*) basedir_set=1; args+=("$a") ;;
      *) args+=("$a") ;;
    esac
  done
  local extra=()
  if (( ! basedir_set )); then
    local target="${args[-1]:-}" ctx=.
    [[ -f "$target" ]] && ctx=$(dirname "$target")
    local root; root=$(git -C "$ctx" rev-parse --show-toplevel 2>/dev/null) && extra=(--basedir "$root")
  fi
  MD_TO_PDF_RAW=$raw command md-to-pdf --config-file "$HOME/.config/md-to-pdf/config.js" --launch-options '{ "args": ["--allow-file-access-from-files"] }' "${extra[@]}" "${args[@]}"
}

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
export CLAUDE_CODE_SYNTAX_HIGHLIGHT="Catppuccin Mocha"
export RAY_ADDRESS=http://localhost:8265
