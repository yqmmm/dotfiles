all: install

UNAME_S := $(shell uname -s)

install: alacritty nvim tmux

alacritty:
	mkdir -p ~/.config/alacritty
	[ -f ~/.config/alacritty/alacritty.yml ] || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml

nvim:
	[ -f ~/.config/nvim/ ] || ln -s $(PWD)/nvim ~/.config/nvim

tmux:
	# Use https://github.com/gpakosz/.tmux
	# [ -d ~/.tmux ] || git clone https://github.com/gpakosz/.tmux.git $(HOME)/.tmux
	# ln -s -f $(HOME)/.tmux/.tmux.conf $(HOME)/.tmux.conf
	# [ -f ~/.tmux.conf.local ] || ln -s $(PWD)/tmux.conf.local ~/.tmux.conf.local
	# Use Tmux Plugin Manager
	mkdir -p ~/.tmux/plugins
	[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmux.conf ~/.tmux.conf

fzf:
	[-d ~/.fzf ] || (git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install)

.PHONY: all install alacritty nvim tmux fzf
