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
