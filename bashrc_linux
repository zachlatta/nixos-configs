#!/bin/bash
#
# Any Linux specific config goes here.

# Start a ssh-agent session if there isn't already one running and save its output.
#
# If there is already a session running, load its cached output to set the
# required environment variables for it to work.
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-cache
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh-agent-cache)"
fi
