source $HOME/.profile

#disable the blendchanges effect. this effect is responsible for causing stutter and flashes when changing a color scheme
(
  sleep 2
  qdbus6 org.kde.KWin /Effects org.kde.kwin.Effects.unloadEffect blendchanges
) &

#export LD_LIBRARY_PATH="$HOME/.local/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export QML_IMPORT_PATH="$HOME/.local/lib64/qml:$HOME/.local/lib/qml${QML_IMPORT_PATH:+:$QML_IMPORT_PATH}"
export QML2_IMPORT_PATH="$HOME/.local/lib/qt6/qml${QML2_IMPORT_PATH:+:$QML2_IMPORT_PATH}"
