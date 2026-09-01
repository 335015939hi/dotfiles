#!/bin/bash

if [ -z "$HOME" ]; then
  echo "HOME is not set"
  exit 2
fi

cd "$(dirname "$0")" || exit 2
DIR="$PWD"

install() {
  mkdir -p "$(dirname "$HOME/$2")"
  ln -s "$DIR/$1" "$HOME/$2"
}

install zshrc .zshrc
install profile .profile
