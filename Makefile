all: install

UNAME_S := $(shell uname -s)

install: alacritty nvim

alacritty:
	mkdir -p ~/.config/alacritty
	[ -f ~/.config/alacritty/alacritty.yml ] || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml

nvim:
	[ -f ~/.config/nvim/ ] || ln -s $(PWD)/nvim ~/.config/nvim

.PHONY: all install alacritty nvim
