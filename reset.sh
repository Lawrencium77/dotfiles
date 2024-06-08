#!/bin/bash
set -euo pipefail
USAGE=$(cat <<-END
    Usage: ./reset.sh [OPTION]
    Undoes all changes made by deploy.sh. Useful for dev.

    OPTIONS:
        --remote (DEFAULT)      resets remote config
        --local                 resets local config
END
)

LOC="local"
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

# Local and remote config
rm $HOME/.tmux.conf
rm -r $HOME/.config/nvim
rm $HOME/.zshrc
rm $HOME/.gitconfig 
rm $HOME/.config/karabiner/karabiner.json && touch $HOME/.config/karabiner/karabiner.json # Empty file

# Remote-specific config
if [ $LOC == 'remote' ]; then
    rm ~/.ipython/profile_default/ipython_config.py
    rm $HOME/.ipython/profile_default/startup/keybindings.py
fi