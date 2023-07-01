#!/usr/bin/zsh

setopt EXTENDED_GLOB
for rcfile in "${HOME}"/.dotfiles/zsh/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
