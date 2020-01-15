#!/bin/zsh

# Neovim setup
export VISUAL="nvim"
export EDITOR="$VISUAL"
alias e="$VISUAL"

# Other constants setup
export INBOX="$HOME/dev/inbox"

# Add my scripts to PATH
export PATH="$HOME/.local/bin:$PATH"

# Add Cargo bin directory to PATH to configure Rust toolchain
export PATH="$HOME/.cargo/bin:$PATH"

# (macOS only) add gnubin to PATH to make GNU sed the default sed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# (requires starship installed) init starship
eval "$(starship init zsh)"

# check for files present in inbox
inbox-notifier --dir "$INBOX"
