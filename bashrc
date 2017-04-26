#!/bin/bash

export DOTFILES=$HOME/.dotfiles

# Editor setup
export EDITOR="e"

# Put local/bin into the PATH
export PATH=$PATH:$HOME/.local/bin

# Go
export GOPATH=$HOME/.local/share/go
export PATH=$PATH:$GOPATH/bin

# Aliases galore!
alias markcop='docker pull hackclub/markcop:latest && docker run --rm -v $(pwd):/app hackclub/markcop:latest'
alias dokku='ssh dokku@apps.zachlatta.com'

if [ "$(uname)" == "Darwin" ]; then
  . "$DOTFILES/bashrc_darwin"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  . "$DOTFILES/bashrc_linux"
fi
