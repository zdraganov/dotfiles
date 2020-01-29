# Path to your oh-my-zsh installation.
export ZSH="/Users/zhivko/.oh-my-zsh"

ZSH_THEME="spaceship"

plugins=(git)

export SPACESHIP_KUBECTL_SHOW=true
export SPACESHIP_KUBECTL_VERSION_SHOW=false
source $ZSH/oh-my-zsh.sh

export LC_ALL=en_US.UTF-8
export DOTFILES=$HOME/dotfiles

export NVM_DIR="$HOME/.nvm"
[ -f "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
[ -f "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f "$DOTFILES/.nvm-auto.zsh" ] && source "$DOTFILES/.nvm-auto.zsh"
[ -f "$DOTFILES/.path" ] && source $DOTFILES/.path
[ -f "$DOTFILES/.aliases" ] && source $DOTFILES/.aliases

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/zhivko/Dev/Tools/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/zhivko/Dev/Tools/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/zhivko/Dev/Tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/zhivko/Dev/Tools/google-cloud-sdk/completion.zsh.inc'; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
