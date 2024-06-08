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

if [ "$#" -eq 0 ]; then
    echo "Please provide an option. See --help for more info." && exit 1
fi

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
rm $HOME/.zshrc && touch $HOME/.zshrc # Empty file
rm $HOME/.gitconfig 

if [ $LOC == 'local' ]; then
    rm $HOME/.config/karabiner/karabiner.json && touch $HOME/.config/karabiner/karabiner.json # Empty file
fi

if [ $LOC == 'remote' ]; then
    rm ~/.ipython/profile_default/ipython_config.py
    rm $HOME/.ipython/profile_default/startup/keybindings.py
fi