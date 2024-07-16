CONFIG_DIR=$(dirname $(realpath ${(%):-%x}))
export DOT_DIR=$CONFIG_DIR/../

# Append custom_bins to PATH variable
p=$DOT_DIR/custom_bins
if [[ "$PATH" != *"$p"* ]]; then
  export PATH="$p:$PATH"
fi

# Append mybins to PATH variable
p="$HOME/.local/mybins"
if [[ "$PATH" != *"$p"* ]]; then
  export PATH="$p:$PATH"
fi

# Set cursor width to narrow in vim and zsh.
# Means that it doesn't change between insert & normal mode in vim.
# Might be worth changing at some point.
_fix_cursor() {
   echo -ne '\e[6 q'
}

precmd_functions+=(_fix_cursor)


ZSH_DISABLE_COMPFIX=true
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH=$HOME/.oh-my-zsh

plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-completions history-substring-search)


source $ZSH/oh-my-zsh.sh
source $CONFIG_DIR/aliases.sh
source $CONFIG_DIR/aliases_meta.sh
source $CONFIG_DIR/p10k.zsh
source $CONFIG_DIR/extras.sh

# Hack for Meta Mac
echo 'export PATH="$HOME/homebrew/bin:$HOME/homebrew/sbin:$PATH"'
