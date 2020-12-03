.DEFAULT_GOAL := all

.PHONY: git
git:
	stow git

.PHONY: bin
bin:
	mkdir -p ~/.local/bin/
	stow bin -t ~/.local/bin/

.PHONY: bash
bash:
	stow bash

all: git bin bash
