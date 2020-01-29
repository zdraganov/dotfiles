#!/bin/sh

set -e

echo "Copy needed files to $HOME"
cp .gitconfig .gitmessage .vimrc.after .zshrc $HOME

eval $SHELL
