#!/bin/bash

# laod main config
source "$HOME/.config/bash/main.bash"

# load os-specific config
if [ "$(uname)" == "Darwin" ]; then
  . "$HOME/.config/bash/main_darwin.bash"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  . "$HOME/.config/bash/main_linux.bash"
fi
