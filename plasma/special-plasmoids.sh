#!/bin/bash

plasma_panel_colorizer() {
    if [ -d "$HOME/.local/share/plasma/plasmoids/luisbocanegra.panel.colorizer" ]; then
        return 0
    fi
    requirecmd cmake
    (cd "$DIR/plasma/plasma-panel-colorizer" && "$DIR/plasma/plasma-panel-colorizer/install-immutable.sh")
}
# TODO: darkly and klassy

better_blur_dx() {
    if [ -f "$HOME/.local/lib/qt6/plugins/kwin/effects/configs/kwin_better_blur_dx_config.so" ] &&
        [ -f "$HOME/.local/lib/qt6/plugins/kwin/effects/plugins/better_blur_dx.so" ]; then
        return 0
    fi
    (cd plasma/kwin-effects-better-blur-dx &&
        cmake -S . -B build -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
            -DKDE_INSTALL_USE_QT_SYS_PATHS=OFF \
            -DKDE_INSTALL_PLUGINDIR="lib/qt6/plugins" &&
        cd build && make -j $(nproc) install)
}

plasma_panel_colorizer
better_blur_dx

echo 'Please install Darkly and Klassy manually, if you have not done so already'
