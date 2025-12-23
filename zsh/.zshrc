autoload -U colors && colors
PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b "

# History in cache directory:
HISTFILE=~/.cache/zsh/history
HISTSIZE=10000
SAVEHIST=10000

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

bindkey -e
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

alias nv="/usr/local/bin/nvim-macos-arm64/bin/nvim"
alias lz="lazygit"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export BUN_INSTALL="$HOME/.bun"
export PATH="/opt/anaconda3/bin:$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/Users/trieule/.bun/_bun" ] && source "/Users/trieule/.bun/_bun"
