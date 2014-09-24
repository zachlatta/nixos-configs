# Go
set -x GOPATH $HOME/go
set PATH $PATH $HOME/go/bin

# Go App Engine
set -x PATH $PATH /opt/google-appengine-go

# Rbenv
set PATH $PATH $HOME/.rbenv/bin
status --is-interactive; and . (rbenv init -|psub)

# Mac specific config
if [ (uname) = 'Darwin' ]
  # Docker
  set -x DOCKER_HOST tcp://

  # Go App Engine
  set -x PATH $PATH $HOME/go_appengine

  # Haxe
  set -x HAXE_STD_PATH /usr/local/lib/haxe/std
end

# Linux specific config
if [ (uname) = 'Linux' ]
  # Go App Engine
  set -x PATH $PATH $HOME/dev/go_appengine

  # Fix vim color woes
  set -x TERM xterm-256color
end

# Misc config
set -x EDITOR vim

. $HOME/.config/fish/aliases.fish
. $HOME/.config/fish/solarized.fish
. $HOME/.config/fish/themes/robbyrussell.fish
