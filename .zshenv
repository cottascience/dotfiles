export XDG_CONFIG_HOME=$HOME/.config
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Machine/work-specific env (secrets, internal hosts) — kept out of the repo
[ -f "$HOME/.zshenv.local" ] && . "$HOME/.zshenv.local"
