#!/bin/bash

export DOTFILES=$HOME/.dotfiles

# Set 256 color profile where possible
if [[ $COLORTERM == gnome-* && $TERM == xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
  export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM=xterm-256color
fi

# bash-completion
if [[ $PS1 && -f /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
else
  echo "bash-completion is not installed, not everything may work as expected!"
fi

# Sensible Bash (https://github.com/mrzool/bash-sensible)
source $DOTFILES/lib/bash-sensible/sensible.bash

# Solarized dircolors
eval $(dircolors $DOTFILES/lib/dircolors-solarized/dircolors.ansi-universal)
alias ls='ls -F --color'

# Put local/bin into the PATH
export PATH=$PATH:$HOME/.local/bin

# Go
export GOPATH=$HOME/.local/share/go
export PATH=$PATH:$GOPATH/bin

# Stream Machine
export STREAM_MACHINE_ID=i-49f7b28b
export STREAM_MACHINE_ZONE=us-west-1

# SSH Agent
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Editor setup
export EDITOR="e"

# Aliases galore!
alias markcop='docker pull hackclub/markcop:latest && docker run -v $(pwd):/app hackclub/markcop:latest'
alias dokku='ssh dokku@apps.zachlatta.com'
