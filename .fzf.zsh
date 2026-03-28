# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/lcotta/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/lcotta/.fzf/bin"
fi

source <(fzf --zsh)
