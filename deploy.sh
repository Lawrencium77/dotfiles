#!/bin/bash
set -euo pipefail
USAGE=$(cat <<-END
    Usage: ./deploy.sh [OPTION]
    Creates ~/.zshrc and ~/.tmux.conf with location-specific config

    OPTIONS:
        --remote (DEFAULT)      deploy remote config, all aliases are sourced
        --local                 deploy local config, only local aliases are sourced
END
)

export DOT_DIR=$(dirname $(realpath $0))

LOC="remote"
while (( "$#" )); do
    case "$1" in
        -h|--help)
            echo "$USAGE" && exit 1 ;;
        --remote)
            LOC="remote" && shift ;;
        --local)
            LOC="local" && shift ;;
        --) # end argument parsing
            shift && break ;;
        -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2 && exit 1 ;;
    esac
done


echo "deploying on $LOC machine..."

# Tmux setup
echo "source $DOT_DIR/config/tmux.conf" > $HOME/.tmux.conf

# Vim / Neovim setup
source "$DOT_DIR/nvim/setup_init.sh"

# zshrc setup
echo "source $DOT_DIR/config/zshrc.sh" > $HOME/.zshrc

# Gitconfig setup
source "$DOT_DIR/gitconfig/setup_gitconfig.sh"

# Karabiner elements mapping
if [ $LOC == 'local' ]; then
    mkdir -p $HOME/.config/karabiner
    karabiner_path=$HOME/.config/karabiner/karabiner.json
    dd_karabiner_path=$DOT_DIR/config/karabiner.json

    if [ -e $karabiner_path ] && ! cmp -s $karabiner_path $dd_karabiner_path; then
        read -p "karabiner.json differs from dotfiles. Do you want to overwrite? (y/n) " yn
        case $yn in 
            y )
                cat $karabiner_path > $karabiner_path.backup
                ln -sf $dd_karabiner_path $karabiner_path ;
                ;;
            n ) echo skipping...;
                exit;;
        esac
    else
        ln -sf $dd_karabiner_path $karabiner_path
    fi
fi 

# config/aliases_speechmatics.sh adds remote specific aliases and cmds
[ $LOC = 'remote' ] &&  echo \
    "source $DOT_DIR/config/aliases_speechmatics.sh" >> $HOME/.zshrc

if [ $LOC == 'remote' ]; then
    echo "c.TerminalInteractiveShell.editing_mode = 'vi'" > ~/.ipython/profile_default/ipython_config.py
    cat "$DOT_DIR/config/keybindings.py" > $HOME/.ipython/profile_default/startup/keybindings.py
fi
