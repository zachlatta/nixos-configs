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

# Maven
set -x M2_HOME /opt/maven

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

  # Set path to Chrome for Karma
  set -x CHROME_BIN (which google-chrome-stable)
end

# Misc config
set -x EDITOR vim

. $HOME/.config/fish/aliases.fish
. $HOME/.config/fish/solarized.fish
. $HOME/.config/fish/themes/robbyrussell.fish
