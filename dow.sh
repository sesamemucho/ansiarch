there=$1; shift

#waypipe ssh $there env XDG_RUNTIME_DIR=/run/user/1000 XDG_SESSION_TYPE=wayland PATH=$HOME/.local/bin:$HOME/local/bin:$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/bin "$@"
waypipe --debug ssh $there env XDG_RUNTIME_DIR=/tmp XDG_SESSION_TYPE=wayland PATH=$HOME/.local/bin:$HOME/local/bin:$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/bin "$@"
