# Go
set -x GOROOT $HOME/dev/go
set PATH $PATH $HOME/dev/go/bin
set -x GOPATH $HOME/go
set PATH $PATH $HOME/go/bin

# Mac specific config
if [ (uname) = 'Darwin' ]
  # Docker
  set -x DOCKER_HOST tcp://

  # Go App Engine
  set -x PATH $PATH $HOME/go_appengine

  # Haxe
  set -x HAXEPATH /usr/local/Cellar/haxe/3.1.0
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
