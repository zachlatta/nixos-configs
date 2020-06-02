#!/bin/zsh

# Constants #
#############

export INBOX="$HOME/dev/inbox"

export BROWSER="firefox"

# Neovim setup
export VISUAL="nvim"
export EDITOR="$VISUAL"

## Rust Setup ##
################

# Add Cargo bin directory to PATH to configure Rust toolchain
export PATH="$HOME/.cargo/bin:$PATH"

## Go Setup ##
##############

export GOPATH="$HOME/.local/share/go"
export PATH="$GOPATH/bin:$PATH"

# Shell Setup #
###############

# Add Python Markpress CLI to path
export PATH="$HOME/.local/app/markpress/bin:$PATH"

# Add my scripts to PATH
export PATH="$HOME/.local/bin:$PATH"

# (macOS only) add gnubin to PATH to make GNU sed the default sed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# (macOS only) add gnubin to PATH to make GNU coreutils default
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# ls with color
alias ls='ls --color=auto'

# z command
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# vim mode in zsh
bindkey -v
bindkey "^?" backward-delete-char # fix vim weirdness

# Ctrl+R to search through history
bindkey '^R' history-incremental-pattern-search-backward

# Make Ctrl+A and Ctrl+E work while zsh is in vim mode
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# (requires starship installed) init starship
eval "$(starship init zsh)"

# Aliases #
###########

alias reload="source ~/.zshrc"

alias e="$VISUAL"
alias browser="$BROWSER"
alias b="browser"
alias play='mpv --screenshot-directory="~/pokedex/screenshots/psyduck/"'

alias d="pushd ~/.dotfiles > /dev/null && e . && popd > /dev/null"
alias dr="pushd ~/.dotfiles > /dev/null && e README.md && popd > /dev/null"
alias dz="pushd ~/.dotfiles > /dev/null && e zshrc && popd > /dev/null"
alias ds="pushd ~/.dotfiles > /dev/null && e config/sway/config && popd > /dev/null"

alias r="ranger"

alias ir="r ~/dev/inbox"
alias ic="pushd ~/dev/inbox"
alias it="e ~/dev/inbox/TODO.md"
alias is="sync-inbox"

alias c="wl-copy"
alias p="wl-paste"
alias g="gist -p"

alias battery="cat /sys/class/power_supply/BAT0/capacity"
alias mount.putio="mkdir -p ~/downloads/put.io/ && rclone mount putio:/ ~/downloads/put.io/ --daemon && sleep 1 && pushd ~/downloads/put.io/"

# check for files present in inbox
inbox-notifier --dir "$INBOX"

# Final Setup #
###############

# automatically set terminal emulator window titles
#
# from https://wiki.archlinux.org/index.php/zsh#xterm_title
autoload -Uz add-zsh-hook

function xterm_title_precmd () {
  print -Pn -- '\e]2;%n@%m %~\a'
  [[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
  print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
  [[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (alacritty*|gnome*|konsole*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
  add-zsh-hook -Uz precmd xterm_title_precmd
  add-zsh-hook -Uz preexec xterm_title_preexec
fi

# save command history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
