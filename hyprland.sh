# main hypr* configs
link hyprland .config/hypr

# hyprmod, a hyprland configuration GUI
(cd "$DIR/hyprmod" && ./install.sh)

# elephant, a walker dependency
function elephant_install() {
  if checkcmd elephant >/dev/null; then
    return 0
  fi
  requirecmd go
  cd "$DIR/elephant" || return 1
  cd cmd/elephant || return 1
  export GOBIN=$HOME/.local/bin
  go install elephant.go || return 1
}
(elephant_install)

# walker, a launcher
checkcmd walker >/dev/null || (cd walker && cargo install --path .)
