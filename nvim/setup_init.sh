#!/bin/bash
# Neovim
if [ ! -d $HOME/.config/nvim ]; then
    mkdir -p $HOME/.config/nvim;
fi

ln -s $HOME/git/dotfiles/nvim/init.lua $HOME/.config/nvim
