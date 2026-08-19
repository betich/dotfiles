#!/usr/bin/env bash
# betich/dotfiles installer.
#
#   ./install.sh            everything (brew + configs + language toolchains)
#   ./install.sh shell      configs only — symlinks, no downloads
#   ./install.sh brew       Homebrew packages from the Brewfile
#   ./install.sh langs      python, js/ts, bun, go, platformio
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES
STAMP="$(date +%Y%m%d%H%M%S)"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m warn\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

link() {
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    printf '     %s (already linked)\n' "$dst"; return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak-$STAMP"
    warn "backed up $dst -> $dst.bak-$STAMP"
  fi
  ln -s "$src" "$dst"
  printf '     %s -> %s\n' "$dst" "$src"
}

install_shell() {
  info "Linking configs"
  link shell/zshrc              "$HOME/.zshrc"
  link starship/starship.toml   "$HOME/.config/starship.toml"
  link ghostty/config           "$HOME/.config/ghostty/config"
  link cmux/cmux.json           "$HOME/.config/cmux/cmux.json"
  link git/gitconfig            "$HOME/.gitconfig"
  link git/gitignore_global     "$HOME/.gitignore_global"

  if [ ! -f "$HOME/.gitconfig.local" ]; then
    cp "$DOTFILES/git/gitconfig.local.example" "$HOME/.gitconfig.local"
    warn "created ~/.gitconfig.local — set your name, email and signing key there"
  fi
  [ -f "$HOME/.zshrc.local" ] || : > "$HOME/.zshrc.local"
}

install_brew() {
  if ! have brew; then
    info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
  fi
  info "Installing Brewfile packages"
  brew bundle --file="$DOTFILES/Brewfile"
}

install_langs() { bash "$DOTFILES/scripts/langs.sh"; }

case "${1:-all}" in
  shell) install_shell ;;
  brew)  install_brew ;;
  langs) install_langs ;;
  all)   install_brew; install_shell; install_langs ;;
  *)     echo "usage: $0 [all|shell|brew|langs]" >&2; exit 2 ;;
esac

info "Done. Restart your shell:  exec zsh"
