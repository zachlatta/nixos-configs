#!/bin/zsh

# Neovim setup
export VISUAL="nvim"
export EDITOR="$VISUAL"
alias e="$VISUAL"

# Other constants setup
export INBOX="$HOME/dev/inbox"

# Add my scripts to PATH
export PATH="$HOME/.local/bin:$PATH"

# (macOS only) add gnubin to PATH to make GNU sed the default sed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# (macOS only) add gnubin to PATH to make GNU coreutils default
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

## Rust Setup ##

# Add Cargo bin directory to PATH to configure Rust toolchain
export PATH="$HOME/.cargo/bin:$PATH"

## Go Setup ##
export GOPATH="$HOME/.local/share/go"
export PATH="$GOPATH/bin:$PATH"

# ls with color
alias ls='ls --color=auto'

# (requires starship installed) init starship
eval "$(starship init zsh)"

# check for files present in inbox
inbox-notifier --dir "$INBOX"
