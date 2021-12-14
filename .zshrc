# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

plugins=(git docker docker-compose yarn kubectl minikube aws fzf zsh-completions kops)
autoload -U compinit && compinit

export SPACESHIP_TIME_SHOW=true
export SPACESHIP_KUBECTL_SHOW=true
export SPACESHIP_KUBECTL_VERSION_SHOW=false
export SPACESHIP_GCLOUD_SHOW=false
export SPACESHIP_AWS_SHOW=true
export SPACESHIP_DOCKER_SHOW=false

export ZSH_DISABLE_COMPFIX=true

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

source $ZSH/oh-my-zsh.sh

export LC_ALL=en_US.UTF-8
export DOTFILES=$HOME/dotfiles

[ -f "$DOTFILES/.path" ] && source $DOTFILES/.path

export GOPATH=$HOME/go
export GOROOT=$(brew --prefix go)/libexec
export GO111MODULE=auto

export CLOUDSDK_PYTHON=python2
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

export BAT_THEME=TwoDark

[ -f "$DOTFILES/.nvm-auto.zsh" ] && source "$DOTFILES/.nvm-auto.zsh"
[ -f "$DOTFILES/..kubectl-completion.zsh" ] && source "$DOTFILES/.kubectl-completion.zsh"
[ -f "$DOTFILES/.aliases" ] && source $DOTFILES/.aliases

if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"

  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

export MACPREFS_BACKUP_DIR="$HOME/dotfiles/macprefs_backup"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/zhivko/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/zhivko/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/zhivko/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/zhivko/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
autoload -U compinit; compinit
