# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

plugins=(git docker docker-compose yarn kubectl minikube aws fzf zsh-completions)
autoload -U compinit && compinit

export SPACESHIP_KUBECTL_SHOW=true
export SPACESHIP_KUBECTL_VERSION_SHOW=false
export SPACESHIP_GCLOUD_SHOW=false
export SPACESHIP_AWS_SHOW=true

source $ZSH/oh-my-zsh.sh

export LC_ALL=en_US.UTF-8
export DOTFILES=$HOME/dotfiles

export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
export GO111MODULE=auto

export CLOUDSDK_PYTHON=python2

export NVM_DIR="$HOME/.nvm"
[ -f "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
[ -f "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f "$DOTFILES/.nvm-auto.zsh" ] && source "$DOTFILES/.nvm-auto.zsh"
[ -f "$DOTFILES/..kubectl-completion.zsh" ] && source "$DOTFILES/.kubectl-completion.zsh"
[ -f "$DOTFILES/.path" ] && source $DOTFILES/.path
[ -f "$DOTFILES/.aliases" ] && source $DOTFILES/.aliases

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Dev/Tools/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Dev/Tools/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Dev/Tools/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Dev/Tools/google-cloud-sdk/completion.zsh.inc"; fi
