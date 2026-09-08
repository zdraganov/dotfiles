# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export DOTFILES="$HOME/Dev/zdraganov/dotfiles"
[ -f "$DOTFILES/.path" ] && source "$DOTFILES/.path"

# ---------------------------------------------------------------- oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_DISABLE_COMPFIX=true
fpath+="${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-completions/src"
plugins=(git docker docker-compose yarn kubectl aws fzf z forgit poetry)
source "$ZSH/oh-my-zsh.sh"

# Word navigation with Option (iTerm profile sends Option as Esc+; also works in VS Code / Terminal.app)
bindkey '^[[1;3C' forward-word        # Option+Right (xterm style)
bindkey '^[[1;3D' backward-word       # Option+Left
bindkey '^[f'     forward-word        # Option+Right (Esc-f style)
bindkey '^[b'     backward-word       # Option+Left
bindkey '^[^?'    backward-kill-word  # Option+Backspace
bindkey '^[[3;3~' kill-word           # Option+Fn+Delete

# ---------------------------------------------------------------- environment
export LC_ALL=en_US.UTF-8
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export BAT_THEME=TwoDark
export EDITOR=nvim

# Java (zulu@17 cask) — mobile-rn / Android
export JAVA_HOME="$(/usr/libexec/java_home -v 17 2>/dev/null)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

# pyenv
if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  eval "$(pyenv init - zsh)"
  command -v pyenv-virtualenv-init >/dev/null && eval "$(pyenv virtualenv-init -)"
fi

# gcloud (brew cask)
if [ -d "$HOMEBREW_PREFIX/share/google-cloud-sdk" ]; then
  source "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc"
  source "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc"
fi

# fzf keybindings + completion
command -v fzf >/dev/null && source <(fzf --zsh)

# SSH keys live in Bitwarden; its desktop app exposes them via an agent socket.
export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"

# ---------------------------------------------------------------- work (Seven-of-Di / ai-foundation)
export WORKSPACE_ROOT="$HOME/Dev/seven-of-di/workspaces"
alias ws="$HOME/Dev/seven-of-di/ai-foundation/scripts/workspace.sh"

# ---------------------------------------------------------------- extras
[ -f "$DOTFILES/.zsh-functions" ] && source "$DOTFILES/.zsh-functions"
[ -f "$DOTFILES/.nvm-auto.zsh" ]  && source "$DOTFILES/.nvm-auto.zsh"
[ -f "$DOTFILES/.aliases" ]       && source "$DOTFILES/.aliases"

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
