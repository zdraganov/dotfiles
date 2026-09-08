#!/usr/bin/env bash
# Idempotent machine bootstrap. Requires Homebrew already installed (which pulls in the
# Xcode Command Line Tools):  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
set -euo pipefail

DOTFILES_DIR="$HOME/Dev/zdraganov/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

eval "$(/opt/homebrew/bin/brew shellenv)"

echo "==> brew bundle"
brew update
# third-party taps; Homebrew 6 refuses untrusted taps
for t in yoheimuta/protolint netbirdio/tap; do brew trust "$t" >/dev/null 2>&1 || true; done
# Casks that ship a .pkg (zulu@17) need sudo; when run without a terminal they fail
# and are reported at the end. Re-run this script from a real terminal to pick them up.
brew bundle --file "$DOTFILES_DIR/Brewfile" || echo "!! some Brewfile items failed (see above) — the rest of provisioning continues"

echo "==> oh-my-zsh + plugins"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
clone() { [ -d "$2" ] || git clone --depth=1 "$1" "$2"; }
clone https://github.com/romkatv/powerlevel10k.git      "$ZSH_CUSTOM/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-completions.git  "$ZSH_CUSTOM/plugins/zsh-completions"
clone https://github.com/wfxr/forgit.git                "$ZSH_CUSTOM/plugins/forgit"

mkdir -p "$HOME/.nvm" "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

echo "==> link dotfiles into \$HOME"
for f in .zshrc .zprofile .aliases .gitconfig .gitmessage .global_ignore .tmux.conf .p10k.zsh; do
  ln -sfn "$DOTFILES_DIR/$f" "$HOME/$f"
done
ln -sfn "$DOTFILES_DIR/.ssh_config" "$HOME/.ssh/config"

echo "==> MesloLGS NF (the font powerlevel10k is designed for)"
for style in Regular Bold Italic "Bold Italic"; do
  f="$HOME/Library/Fonts/MesloLGS NF $style.ttf"
  [ -f "$f" ] || curl -fsSL -o "$f" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20${style// /%20}.ttf"
done

echo "==> iTerm2 dynamic profile (Hack Nerd Font + One Dark)"
mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
ln -sfn "$DOTFILES_DIR/iterm2/zdraganov.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles/zdraganov.json"
# ...and push the same values into the Default profile (a dynamic profile can't be the default reliably)
"$DOTFILES_DIR/iterm2/apply-profile.sh" || echo "!! iTerm2 profile not applied — quit iTerm2 and run iterm2/apply-profile.sh"

echo "==> VS Code settings + snippets (extensions come from the Brewfile)"
VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
[ -e "$VSCODE_USER/settings.json" ] && [ ! -L "$VSCODE_USER/settings.json" ] && mv "$VSCODE_USER/settings.json" "$VSCODE_USER/settings.json.bak"
ln -sfn "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER/settings.json"
[ -d "$VSCODE_USER/snippets" ] && [ ! -L "$VSCODE_USER/snippets" ] && mv "$VSCODE_USER/snippets" "$VSCODE_USER/snippets.bak"
ln -sfn "$DOTFILES_DIR/vscode/snippets" "$VSCODE_USER/snippets"

echo "==> macOS defaults"
sh "$DOTFILES_DIR/macos/defaults.install"

echo "==> done. Open a new shell (or: exec zsh)."
