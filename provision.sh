#!/bin/sh

set -e

DOTFILES_DIR=$HOME/dotfiles

echo "Copy needed files to $HOME"
ln -s $DOTFILES_DIR/.gitconfig $DOTFILES_DIR/.gitmessage $DOTFILES_DIR/.vimrc $DOTFILES_DIR/.vimrc.after $DOTFILES_DIR/.zshrc $DOTFILES_DIR/.path $DOTFILES_DIR/.tmux.conf $HOME

eval $SHELL
