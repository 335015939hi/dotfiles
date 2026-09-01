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
# download all submodules
git submodule update --init --recursive

# installs a file as a symlink
# usage: link <file> <dest>; where <file> is relative to repo root and <dest> is relative to $HOME
link() {
  local source="$DIR/$1"
  local target="$HOME/$2"
  local NEWDIR="$(dirname "$target")"
  if ! mkdir -p "$NEWDIR"; then
    echo "mkdir '$NEWDIR' failed ($status)"
    return 1
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
    echo "Install $source to $target failed ($status)"
    return 1
  fi
  echo "Installed $source to $target"
}

# link contents of dir into another dir, basically mkdir -p $dest && cp $source/* $dest except with symlinks
# usage: link_contents_to <source> <dest>; where <source> is relative to repo root and <dest> is relative to $HOME and must be a directory
link_contents_to() {
  local sourcedir="$1"
  local destdir="$2"
  mkdir -p "$HOME/$destdir"
  if [ ! -d "$HOME/$destdir" ]; then
    echo "$destdir is not a directory"
    return 20
  fi
  if [ -z "$(ls "$DIR/$sourcedir/")" ]; then
    return 0
  fi
  for file in "$DIR/$sourcedir"/*; do
    link "$sourcedir/$(basename "$file")" "$destdir/$(basename "$file")" || return 1
  done
}

# installs a command to ~/.local/bin
# usage: linkcmd <file>; where file is relative to repo root
linkcmd() {
  link "$1" ".local/bin/$(basename "$1")"
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

# make cargo install to .local/bin
# not too important if it fails
mkdir -p "$HOME/.cargo"
ls $HOME/.cargo/bin >/dev/null 2>&1 || ln -s ../.local/bin "$HOME"/.cargo/bin

# Zsh stuff
link zshrc .zshrc
link profile .profile
link aliases .aliases
link zsh-autosuggestions .config/zsh/zsh-autosuggestions
link zsh-syntax-highlighting .config/zsh/zsh-syntax-highlighting

# matugen
link matugen .config/matugen

# desktop entries
link_contents_to applications .local/share/applications

# wallpapers
link wallpapers Pictures/wallpapers
if ! [ -d "$DIR/wallpapers/resized" ]; then
  (cd "$DIR/wallpapers" && ./scripts/resize.sh)
fi

checkcmd zsh
checkcmd starship
checkcmd command-not-found
checkcmd tmux
checkcmd e
checkcmd vim
checkcmd nvim
checkcmd matugen
