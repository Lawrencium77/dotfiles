#!/bin/bash
if [ ! -d $HOME/.config/nvim ]; then
    mkdir -p $HOME/.config/nvim;
fi

if ! [ -e "$HOME/.config/nvim/init.lua" ]; then
    ln -s $HOME/git/dotfiles/nvim/init.lua $HOME/.config/nvim
fi
