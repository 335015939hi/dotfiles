#!/bin/bash

set -euo pipefail

# die if we're homeless
if [ -z "$HOME" ]; then
  echo "HOME is not set"
  exit 2
fi

# find repo root
cd "$(dirname "$0")" || exit 2
DIR="$PWD"
#download all submodules
git submodule update

# installs a file as a symlink
# usage: link <file> <dest>; where <file> is relative to repo root and <dest> is relative to $HOME
link() {
  local source="$DIR/$1"
  local target="$HOME/$2"
  local NEWDIR="$(dirname "$target")"
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

# link contents of dir into another dir, basically mkdir -p $dest && cp $source/* $dest except with symlinks
# usage: link_contents_to <source> <dest>; where <source> is relative to repo root and <dest> is relative to $HOME and must be a directory
link_contents_to() {
  local sourcedir="$1"
  local destdir="$2"
  mkdir -p "$destdir"
  if [ ! -d "$destdir" ]; then
    echo "$destdir is not a directory"
    return 20
  fi
  for file in "$DIR/$sourcedir"/*; do
    link "$sourcedir/$(basename "$file")" "$destdir/$(basename "$file")" || return 1
  done
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

# require the existance of a command, or exit
requirecmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Error: required command '$1' not found"
    exit 22
  fi
}

requirecmd ln
requirecmd mv
requirecmd echo

# Zsh stuff
link zshrc .zshrc
link profile .profile
link aliases .aliases
link zsh-autosuggestions .config/zsh/zsh-autosuggestions
link zsh-syntax-highlighting .config/zsh/zsh-syntax-highlighting

# matugen
link matugen .config/matugen

# KDE Plasma stuff
# Plasma configs
link_contents_to plasma/config .config
# normal plasmoids: just symlink
link_contents_to plasma/plasmoids .local/share/plasma/plasmoids
link_contents_to plasma/desktoptheme .local/share/plasma/desktoptheme
link_contents_to plasma/icons .local/share/icons
link_contents_to plasma/kwin-effects .local/share/kwin/effects
link_contents_to plasma/kwin-scripts .local/share/kwin/scripts
# build&install special plasmoids
source "$DIR/plasma/special-plasmoids.sh"
# my scripts
linkcmd plasma/plasma-matugen-wallpaper.py
link plasma/plasma-profile.sh .config/plasma-workspace/env/plasma-profile.sh

# desktop entries
link_contents_to applications .local/share/applications

checkcmd zsh
checkcmd starship
checkcmd command-not-found
checkcmd tmux
checkcmd e
checkcmd vim
checkcmd nvim
checkcmd matugen
