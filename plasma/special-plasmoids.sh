#!/bin/bash

plasma_panel_colorizer() {
  if [-d "$HOME/.local/share/plasma/plasmoids/luisbocanegra.panel.colorizer"]; then
    return 0
  fi
  requirecmd cmake
  (cd "$DIR/plasma/plasma-panel-colorizer" && "$DIR/plasma/plasma-panel-colorizer/install-immutable.sh")
}
# TODO: darkly and klassy

plasma-panel-colorizer
