#!/bin/zsh

# Constants #
#############

export INBOX="$HOME/dev/inbox"

# Neovim setup
export VISUAL="nvim"
export EDITOR="$VISUAL"
alias e="$VISUAL"

## Rust Setup ##
################

# Add Cargo bin directory to PATH to configure Rust toolchain
export PATH="$HOME/.cargo/bin:$PATH"

## Go Setup ##
##############

export GOPATH="$HOME/.local/share/go"
export PATH="$GOPATH/bin:$PATH"

# Shell Setup #
###############

# Add my scripts to PATH
export PATH="$HOME/.local/bin:$PATH"

# (macOS only) add gnubin to PATH to make GNU sed the default sed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# (macOS only) add gnubin to PATH to make GNU coreutils default
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# ls with color
alias ls='ls --color=auto'

# z command
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# vim mode in zsh
bindkey -v
bindkey "^?" backward-delete-char # fix vim weirdness

# Ctrl+R to search through history
bindkey '^R' history-incremental-pattern-search-backward

# Make Ctrl+A and Ctrl+E work while zsh is in vim mode
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# (requires starship installed) init starship
eval "$(starship init zsh)"

# check for files present in inbox
inbox-notifier --dir "$INBOX"
