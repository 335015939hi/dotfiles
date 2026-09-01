if [ -z "$_TONY_PROFILE_SOURCED" ]; then
  export _TONY_PROFILE_SOURCED=1
  umask 027

  export PATH="$HOME/.local/bin:$PATH"

  export EDITOR=nvim

  if [ -S /run/user/"$UID"/openssh_agent ]; then
    export SSH_AUTH_SOCK=/run/user/"$UID"/openssh_agent
  fi

  #export CCACHE_DIR="$HOME/.local/share/ccache"
  #export CCACHE_MAXSIZE="100G"
fi
