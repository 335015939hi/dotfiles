#!/bin/bash

# helper functions to install plasma stuff

PLASMADIR="$DIR/plasma"
mkdir -p "$PLASMADIR"

# downloads and unpacks a URL to a directory
# usage:download_and_unpack <URL> <dir> <method>
# <method> may be "tar","zip",or "git"
download_and_unpack() {
  local URL="$1"
  local DESTDIR="$2"
  local method="$3"
  case "$method" in
  git)
    mkdir -p "$(dirname "$DESTDIR")" || return
    git clone -q --depth 1 "$URL" "$DESTDIR"
    ;;
  tar)
    mkdir -p "$DESTDIR"
    curl -fsSL "$URL" | tar -xf - -C "$DESTDIR"
    ;;
  zip)
    mkdir -p "$DESTDIR"
    curl -fsSL "$URL" | unzip -d "$DESTDIR" /proc/self/fd/0
    ;;
  *)
    echo "error: bad extract method passed to download_and_unpack"
    return 22
    ;;
  esac
}

# installs a icon pack, if one does not exist
# usage: install_icon <icon_name> <URL>  <method>
# if <icon_name> doesn't exist, downloads <URL> and unpacks it
install_icon() {
  local ICONDIR="$HOME/.local/share/icons"
  local icon_name="$1"
  local URL="$2"
  local method="$3"
  if [ -d "$ICONDIR/$icon_name" ]; then
    return 0
  fi
  echo "Installing icon pack $icon_name"
  download_and_unpack "$URL" "$ICONDIR/$icon_name" "$method"
}

# installs a plasmoid if one doesn't exist
# usage: install_plasmoid <ID> <URL> <method>
install_plasmoid() {
  local PLASMOIDDIR="$HOME/.local/share/plasma/plasmoids"
  local ID="$1"
  local URL="$2"
  local method="$3"
  if [ -d "$PLASMOIDDIR/$ID" ]; then
    return 0
  fi
  download_and_unpack "$URL" "$PLASMOIDDIR/$ID" "$method"
}
