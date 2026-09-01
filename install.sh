#!/bin/bash

if [ -z "$HOME" ]; then
  echo "HOME is not set"
  exit 2
fi

cd "$(dirname "$0")" || exit 2
DIR="$PWD"

install() {
  source="$DIR/$1"
  target="$HOME/$2"
  NEWDIR="$(dirname "$HOME/$target")"
  mkdir -p "$NEWDIR" || echo "mkdir '$NEWDIR' failed ($?)"
  # Already the correct symlink
  if [[ -L "$target" && "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
    return 0
  fi
  # Existing file/directory/symlink
  if [[ -e "$target" || -L "$target" ]]; then
    local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
    mv -- "$target" "$backup"
    printf 'Backed up %s -> %s\n' "$target" "$backup"
  fi
  (ln -s "$source" "$target" && echo "Installed $source to $target") || echo "install $source to $target failed ($?)"
}

checkcmd() {
  if ! which "$1" >/dev/null 2>&1; then
    echo "Command '$1' not found"
    return 2
  fi
}

# Zsh stuff
install zshrc .zshrc
install profile .profile
install aliases .aliases
install zsh-autosuggestions .config/zsh/zsh-autosuggestions
install zsh-syntax-highlighting .config/zsh/zsh-syntax-highlighting

# matugen
install matugen .config/matugen
install plasma-matugen-wallpaper.py .local/bin/plasma-matugen-wallpaper.py

checkcmd zsh
checkcmd starship
checkcmd command-not-found
checkcmd tmux
checkcmd e
checkcmd vim
checkcmd nvim
checkcmd matugen
