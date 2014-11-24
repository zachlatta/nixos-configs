# Go
set -x GOROOT /opt/go
set -x PATH $PATH $GOROOT/bin
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin

# Go App Engine
set -x PATH $PATH /opt/google-appengine-go

# Rbenv
set PATH $PATH $HOME/.rbenv/bin
status --is-interactive; and . (rbenv init -|psub)

# Go App Engine
set -x PATH $PATH $HOME/dev/go_appengine

# Fix vim color woes
set -x TERM xterm-256color

# Misc config
set -x EDITOR vim

. $HOME/.config/fish/aliases.fish
. $HOME/.config/fish/solarized.fish
. $HOME/.config/fish/themes/robbyrussell.fish
