.DEFAULT_GOAL := all

.PHONY: git
git:
	stow git

.PHONY: bin
bin:
	stow bin -t ~/.local/bin/

.PHONY: bash
bash:
	stow bash

.PHONY: sway
sway:
	stow sway -t ~/.config/sway/

.PHONY: hidpi-xwayland
hidpi-xwayland:
	stow hidpi-xwayland --ignore=README.md

.PHONY: emacs
emacs:
	stow emacs -t ~/.emacs.d/

all: git bin bash sway hidpi-xwayland emacs
