#!/bin/bash

export DOTFILES=$HOME/.dotfiles

# Editor setup
export EDITOR="vim"

# Load local/bin into the PATH
export PATH=$PATH:$HOME/.local/bin

# Go
export GOPATH=$HOME/.local/share/go
export PATH=$PATH:$GOPATH/bin

# Ruby (use user directory for gems)
export GEM_HOME=$(ruby -e 'print Gem.user_dir')
export GEM_PATH=$GEM_HOME
export PATH=$PATH:$PATH:$GEM_HOME/bin

# If there's a file called .bashrc in the current directory and we're not in the
# home directory, execute it!
if [ ! "$(pwd)" == "$HOME" ]; then
  if [ -f .bashrc ]; then
    source .bashrc
  fi
fi

# Load other config
source "$DOTFILES/config/bash/helpers.bash"
