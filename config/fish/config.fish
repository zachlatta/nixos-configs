# Go
set -x GOROOT $HOME/dev/go
set -x GOPATH $HOME/go
set PATH $PATH $HOME/go/bin

# Mac specific config
if [ (uname) = 'Darwin' ]
  # Docker
  set -x DOCKER_HOST tcp://

  # Go App Engine
  set -x PATH $PATH $HOME/go_appengine
end

. $HOME/.config/fish/aliases.fish
. $HOME/.config/fish/solarized.fish
. $HOME/.config/fish/themes/robbyrussell.fish
