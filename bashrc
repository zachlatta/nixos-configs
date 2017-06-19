#!/bin/bash

export DOTFILES=$HOME/.dotfiles

# bash-completion
if [[ $PS1 && -f /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
else
  echo "bash-completion is not installed, not everything may work as
  expected!"
fi

# Solarized dircolors
eval $(dircolors $DOTFILES/lib/dircolors-solarized/dircolors.ansi-universal)
alias ls='ls -F --color'

# Editor setup
export EDITOR="vim"

# Put local/bin into the PATH
export PATH=$PATH:$HOME/.local/bin

# Go
export GOPATH=$HOME/.local/share/go
export PATH=$PATH:$GOPATH/bin

# Use user directory for Ruby gems
export GEM_HOME=$(ruby -e 'print Gem.user_dir')
export GEM_PATH=$GEM_HOME
export PATH=$PATH:$PATH:$GEM_HOME/bin

# Aliases galore!
alias markcop='docker pull hackclub/markcop:latest && docker run --rm -v $(pwd):/app hackclub/markcop:latest'
alias dokku='ssh dokku@apps.zachlatta.com'

if [ "$(uname)" == "Darwin" ]; then
  . "$DOTFILES/bashrc_darwin"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  . "$DOTFILES/bashrc_linux"
fi
