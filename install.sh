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
  ln -s "$DIR/$1" "$HOME/$2" || echo "install $1 to $2 failed ($?)"
}

install zshrc .zshrc
install profile .profile
install aliases .aliases
