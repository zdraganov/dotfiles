#!/bin/sh

set -e

DOTFILES_DIR=$HOME/dotfiles

brew update
brew install zsh
brew install fzf
brew install nvm
brew install iterm2
brew install htop
brew install macvim
brew install lsd
brew install bat

brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

brew tap yoheimuta/protolint
brew install protolint

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

curl -L https://bit.ly/janus-bootstrap | bash

git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" 

git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

mkdir -p $HOME/.nvm

echo "Copy needed files to $HOME"
ln -s $DOTFILES_DIR/.gitconfig $DOTFILES_DIR/.gitmessage $DOTFILES_DIR/.vimrc $DOTFILES_DIR/.vimrc.after $DOTFILES_DIR/.zshrc $DOTFILES_DIR/.path $DOTFILES_DIR/.tmux.conf $HOME

source $DOTFILES_DIR/macos/defaults.install
eval $SHELL

