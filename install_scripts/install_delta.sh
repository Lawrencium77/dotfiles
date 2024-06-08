#!/bin/bash
# Used to install git delta on Linux machine
. $DOT_DIR/install_scripts/util.sh

# Install delta
url=https://github.com/dandavison/delta/releases/download/0.4.4/git-delta_0.4.4_amd64.deb
deb=git-delta_0.4.4_amd64.deb
wget $url
sudo dpkg -i $deb
sudo apt-get install -f
ln -sf $(which delta) $MY_BIN_LOC/delta
rm $deb