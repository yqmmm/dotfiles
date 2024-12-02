all: install

UNAME_S := $(shell uname -s)

install: alacritty nvim tmux

kitty:
	[ -d ~/.config/kitty/ ] || ln -s $(PWD)/kitty ~/.config/kitty

alacritty:
	mkdir -p ~/.config/alacritty
	[ -f ~/.config/alacritty/alacritty.toml ] || ln -s $(PWD)/alacritty.toml ~/.config/alacritty/alacritty.toml

nvim:
	mkdir -p ~/.config/
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
	[ -d ~/.fzf ] || (git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all)

karabiner:
	mkdir -p ~/.config/
	[ -f ~/.config/karabiner.edn ] || ln -s $(PWD)/karabiner.edn ~/.config/karabiner.edn

asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1

pythonic:
	mkdir -p ~/.config/pypoetry
	[ -f ~/.config/pypoetry/config.toml ] || ln -s $(PWD)/pypoetry-config.toml ~/.config/pypoetry/config.toml
	[ -f ~/.config/pycodestyle ] || ln -s $(PWD)/pycodestyle ~/.config/pycodestyle

qtile:
	mkdir -p ~/.config/qtile
	ln -s $(PWD)/qtile/config.py    ~/.config/qtile/config.py
	[ -f ~/.config/qtile/autostart.sh ] || ln -s $(PWD)/qtile/autostart.sh ~/.config/qtile/autostart.sh

kmonad:
	sudo mkdir -p /etc/kmonad
	[ -f /etc/kmonad/config.kbd ] || sudo ln -s $(PWD)/config.kbd /etc/kmonad/config.kbd

font:
	mkdir -p ~/.config/fontconfig
	[ -f ~/.config/fontconfig/fonts.conf ] || ln -s $(PWD)/archlinux/fontconfig/fonts.conf ~/.config/fontconfig

xr:
	[ -f ~/.Xresources ] || ln -s $(PWD)/archlinux/gui/.Xresources ~/.Xresources

rofi:
	[ -f ~/.config/rofi/config.rasi ] || ln -s $(PWD)/archlinux/rofi.rasi ~/.config/rofi/config.rasi

zsh:
	[ -d ~/.zprezto ] || git clone --recursive https://github.com/sorin-ionescu/prezto.git "$(HOME)/.zprezto"
	for rcfile in zlogin zlogout zpreztorc zprofile zshev zshrc; do \
		rm -f ~/.$$rcfile; \
		ln -s ~/.dotfiles/zsh/$$rcfile ~/.$$rcfile ; \
	done

git:
	git config --global user.name "Qianmian Yu"
	git config --global user.email "im.qianmian.yu@gmail.com"

.PHONY: all install alacritty nvim tmux fzf karabiner asdf pythonic kitty qtile kmonad font zsh
