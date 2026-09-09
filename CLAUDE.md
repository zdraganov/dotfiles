# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal macOS dotfiles for an Apple-Silicon machine. There is no build, no test suite, and no linter — changes are verified by running the provisioning script (or the individual sub-script) and opening a new shell. Everything here targets `darwin` + `/opt/homebrew`.

The repo is expected to live at `$HOME/Dev/zdraganov/dotfiles`. That path is hardcoded in `provision.sh` (`DOTFILES_DIR`) and in `.zshrc` (`$DOTFILES`); cloning elsewhere breaks both.

## Commands

```sh
./provision.sh                      # full idempotent bootstrap; safe to re-run
brew bundle --file Brewfile         # packages/casks/VS Code extensions only
sh macos/defaults.install           # macOS defaults + symbolic hotkeys only
iterm2/apply-profile.sh             # iTerm2 Default profile only (quit iTerm2 first)
exec zsh                            # reload shell after editing zsh files
```

`provision.sh` assumes Homebrew is already installed (that also pulls in the Xcode Command Line Tools). Casks that ship a `.pkg` (`zulu@17`, `netbird-ui`) need sudo and fail silently when run without a real terminal — the script keeps going and reports them at the end.

To refresh the VS Code extension list in `Brewfile`: `code --list-extensions` and rewrite the `vscode "..."` block.

## Architecture

**`provision.sh` is the single entry point** and the source of truth for what gets installed where. It: runs `brew bundle`, installs oh-my-zsh plus three git-cloned custom plugins/themes (powerlevel10k, zsh-completions, forgit), symlinks dotfiles into `$HOME`, downloads the MesloLGS NF font, wires up iTerm2 and VS Code, then applies macOS defaults.

**Two ways a file in this repo reaches the shell — know which one applies before adding a file:**

1. *Symlinked into `$HOME`* — for files another program reads by fixed path: `.zshrc`, `.zprofile`, `.aliases`, `.gitconfig`, `.gitmessage`, `.global_ignore`, `.tmux.conf`, `.p10k.zsh`, and `.ssh_config` → `~/.ssh/config`. Adding one of these means editing the `for f in ...` loop in `provision.sh`.
2. *Sourced straight from the repo* by `.zshrc` via `$DOTFILES`: `.path`, `.zsh-functions`, `.nvm-auto.zsh`, `.aliases`. These need no symlink and take effect immediately on `exec zsh`.

**Shell startup order matters.** `.zprofile` (login shell) runs `brew shellenv` first so `$HOMEBREW_PREFIX` exists. `.zshrc` then sources `.path` *before* oh-my-zsh — several later blocks (`nvm`, `gcloud`, `pyenv`) key off `$HOMEBREW_PREFIX` and off PATH entries set in `.path`. The powerlevel10k instant-prompt block must stay at the very top of `.zshrc`; anything that prints output above it breaks the prompt.

**Git identity is split by directory.** `.gitconfig` carries the personal email; an `includeIf "gitdir:~/Dev/seven-of-di/"` pulls in `.gitconfig-work` (same GitHub account, work-verified address). Work-specific shell config also lives in `.zshrc` under the "work" heading (`WORKSPACE_ROOT`, the `ws` alias).

**SSH keys come from the Bitwarden desktop app's agent socket** (`~/.bitwarden-ssh-agent.sock`). It is set both as `SSH_AUTH_SOCK` in `.zshrc` and as `IdentityAgent` in `.ssh_config`, because GUI apps (VS Code, Fork) don't inherit the env var.

### Platform quirks encoded here

- `iterm2/apply-profile.sh` exists because an iTerm2 *dynamic* profile cannot reliably be the default — iTerm2 reads its prefs before reloading `DynamicProfiles/`. The script exports the plist, merges `iterm2/zdraganov.json`'s profile keys into the Default bookmark via inline Python, and re-imports. It refuses to run while iTerm2 is open, and the changes are lost if iTerm2 is running (it rewrites prefs on quit).
- `macos/defaults.install` writes `AppleSymbolicHotKeys` as an **XML plist fragment**, not the `(96, 50, ...)` array shorthand — the shorthand stores the numbers as strings and macOS silently ignores the hotkey.
- `.aliases` aliases `ls` to `lsd` and `vim` to `nvim`; both are Brewfile entries, so removing a brew there breaks the alias.

## Conventions

Commits follow Conventional Commits with an optional scope, e.g. `feat(macos): next input source with Ctrl+Option+\``. `.gitmessage` is configured as the commit template (50-char subject, 72-char wrapped body explaining why/how/side-effects).

Scripts here are `set -euo pipefail` bash and idempotent by design — guard new steps so a re-run is a no-op (`[ -d ... ] ||`, `ln -sfn`, `|| true` on best-effort commands). Non-obvious workarounds get an inline comment explaining *why*; keep that habit, since most of this file's value is the platform quirks above.
