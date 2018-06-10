#!/bin/bash
#
# Any Linux specific config goes here.

# Override the terminal emulator's default TERM for backwards compatibility
# (termite has a habit of setting this to xterm-termite).
export TERM=xterm-256color

# Start a ssh-agent session if there isn't already one running and save its
# output.
#
# If there is already a session running, load its cached output to set the
# required environment variables for it to work.
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  # the head-n-1 removes the last line from ssh-agent's output, which is an echo
  # statement saying something like "Agent pid 22408". try running ssh-agent and
  # looking at the raw output to see what i mean.
  ssh-agent | head -n-1> ~/.ssh-agent-cache
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh-agent-cache)"
fi

# Get some sweet auto-complete!
source "$DOTFILES/lib/bash-completion/bash_completion"

# Make ls nice and pretty
eval $(dircolors $DOTFILES/lib/dircolors-solarized/dircolors.ansi-universal)
alias ls='ls -F --color'

# Assumes the z package is installed on Arch - needed to include it in shell
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
