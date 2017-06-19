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

# Load other config
source "$DOTFILES/config/bash/shell_utils.bash"
source "$DOTFILES/config/bash/helpers.bash"
