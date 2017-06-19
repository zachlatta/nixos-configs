#!/bin/bash
#
# Any installation or configuration of shell-specific utilities (things like a
# customized prompt or auto-completion) go here.

# Get some sweet auto-complete!
source "$DOTFILES/lib/bash-completion/bash_completion"

# Make ls nice and pretty
eval $(dircolors $DOTFILES/lib/dircolors-solarized/dircolors.ansi-universal)
alias ls='ls -F --color'
