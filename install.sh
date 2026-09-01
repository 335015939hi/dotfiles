#!/bin/bash

if [ -z "$HOME" ]; then
  echo "HOME is not set"
  exit 2
fi

cd "$(dirname "$0")" || exit 2
DIR="$PWD"

install() {
  NEWDIR="$(dirname "$HOME/$2")"
  mkdir -p "$NEWDIR" || echo "mkdir '$NEWDIR' failed ($?)"
  ln -s -f "$DIR/$1" "$HOME/$2" || echo "install $1 to $2 failed ($?)"
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
