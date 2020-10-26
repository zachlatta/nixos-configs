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

all: git bin bash sway
