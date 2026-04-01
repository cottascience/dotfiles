# ============================================================================
# PERFORMANCE OPTIMIZATIONS
# ============================================================================

DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# ============================================================================
# CACHE CONFIGURATION
# ============================================================================

# Completion caching (GNU stat syntax for Linux)
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -c '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

# ============================================================================
# PACKAGE MANAGER INITIALIZATION
# ============================================================================

# >>> conda initialize (lazy) >>>
# TODO: update path if you install miniconda/anaconda
if [ -x "$HOME/miniconda3/bin/conda" ]; then
    conda() {
        eval "$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2>/dev/null)"
        conda "$@"
    }
fi
# <<< conda initialize <<<

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"

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
        for key in ~/.ssh/id_*; do
            [[ "$key" == *.pub ]] && continue
            ssh-add "$key" 2>/dev/null
        done
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

ZSH_PLUGINS="$HOME/.zsh"

# fzf-tab (must be sourced before other completions)
[ -f "$ZSH_PLUGINS/fzf-tab/fzf-tab.plugin.zsh" ] && \
    source "$ZSH_PLUGINS/fzf-tab/fzf-tab.plugin.zsh"

# Auto-suggestions
[ -f "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax highlighting
[ -f "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# System clipboard (vi-mode yank/paste — needs a display server)
if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
    [ -f "$ZSH_PLUGINS/zsh-system-clipboard/zsh-system-clipboard.zsh" ] && \
        source "$ZSH_PLUGINS/zsh-system-clipboard/zsh-system-clipboard.zsh"
fi

# Prompt theme
eval "$(starship init zsh)"

# Smarter cd navigation
eval "$(zoxide init zsh)"

# Fuzzy finder shell integration (fzf 0.48+)
eval "$(fzf --zsh)"

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
if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
    alias -g C='| xclip -selection clipboard'
fi

# Easier rm -rf
alias rrm='rm -rf'

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
export CLAUDE_CODE_SYNTAX_HIGHLIGHT="Catppuccin Mocha"
