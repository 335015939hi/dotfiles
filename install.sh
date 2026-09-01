#!/bin/bash

# die if we're homeless
if [ -z "$HOME" ]; then
  echo "HOME is not set"
  exit 2
fi

# find repo root
cd "$(dirname "$0")" || exit 2
DIR="$PWD"

# installs a file as a symlink
# usage: link <file> <dest>; where <file> is relative to repo root and <dest> is relative to $HOME
link() {
  source="$DIR/$1"
  target="$HOME/$2"
  NEWDIR="$(dirname "$target")"
  if ! mkdir -p "$NEWDIR"; then
    status="$?"
    echo "mkdir '$NEWDIR' failed ($status)"
    return "$status"
  fi
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
  if ! ln -s "$source" "$target"; then
    status="$?"
    echo "Install $source to $target failed ($status)"
    return "$status"
  fi
  echo "Installed $source to $target"
}

# installs a command to ~/.local/bin
# usage: linkcmd <file>; where file is relative to repo root
linkcmd() {
  link "$1" "$HOME/.local/bin/$(basename "$1")"
}

# check for the existance of a command
# in future (maybe) prompt to install command based on detected distribution and/or install directly from this repo
# usage: checkcmd <command>
checkcmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Command '$1' not found"
    return 2
  fi
}

# Zsh stuff
link zshrc .zshrc
link profile .profile
link aliases .aliases
link zsh-autosuggestions .config/zsh/zsh-autosuggestions
link zsh-syntax-highlighting .config/zsh/zsh-syntax-highlighting

# matugen
link matugen .config/matugen

#KDE Plasma stuff
link plasma/plasma-matugen-wallpaper.py .local/bin/plasma-matugen-wallpaper.py

checkcmd zsh
checkcmd starship
checkcmd command-not-found
checkcmd tmux
checkcmd e
checkcmd vim
checkcmd nvim
checkcmd matugen
