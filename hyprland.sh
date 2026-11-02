# main hypr* configs
link hyprland .config/hypr

# hyprmod, a hyprland configuration GUI
checkcmd hyprmod >/dev/null || (cd "$DIR/hyprmod" && ./install.sh)

# hyprplasma, my KDE plasma compatibility thing
hyprplasma_install() {
  local hyprdir="$HOME/.config/hypr"
  (cd "$DIR/HyprPlasma" && cmake -S . -B build && cmake --build build)
  ln -s "$DIR/HyprPlasma/hyprplasma.lua" "$hyprdir"/hyprplasma.lua
  ln -s "$DIR/HyprPlasma/build/libhyprplasma.so" "$hyprdir"/libhyprplasma.so
}
hyprplasma_install
