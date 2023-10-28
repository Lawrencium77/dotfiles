# $LOC variable is one of local/remote
base_config=$(cat <<-END
[include]
    path = $DOT_DIR/gitconfig/gitconfig
    path = $DOT_DIR/gitconfig/gitconfig.$LOC
END
)

rm -rf $HOME/.gitconfig  # Remove old config incase it's a symlink
echo "$base_config" > $HOME/.gitconfig 