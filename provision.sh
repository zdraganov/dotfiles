#!/bin/sh

set -e

echo "Copy needed files to $HOME"
ln -s .gitconfig .gitmessage .vimrc.after .zshrc .path $HOME

eval $SHELL
