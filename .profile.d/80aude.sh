# -- env --
export EDITOR='vim'
export VISUAL="$EDITOR"
export PASSWORD_STORE_DIR="$HOME/key/password-store"
export GOPATH="$HOME/dev/go"
export ANDROID_HOME="$HOME/src/android-sdk-linux"
export FLUTTER_HOME="$HOME/src/flutter"
export MPV_SOCKET="$XDG_RUNTIME_DIR/mpv-socket"

# gpg-agent
# use gpg-agent's SSH agent emulation
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"
fi

# set $SSH_AGENT to something that will not run,
# so RedHat's xinitrc-common does not launch a new ssh-agent
export SSH_AGENT=' '

# java
# configure java for use with minimal X window managers
export _JAVA_AWT_WM_NONREPARENTING=1

# libvirt
# configure libvirt to use system session by default
export LIBVIRT_DEFAULT_URI='qemu:///system'

# sway
export XKB_DEFAULT_LAYOUT=us
export XKB_DEFAULT_VARIANT=dvorak

# btlock
export BTLOCK_COMMAND_LOCK='screen-lock'
export BTLOCK_COMMAND_UNLOCK='screen-unlock'

# n
export N_PREFIX="$HOME/src/n"

# maven
# https://zeroturnaround.com/rebellabs/your-maven-build-is-slow-speed-it-up/
export MAVEN_OPTS='-XX:+TieredCompilation -XX:TieredStopAtLevel=1'

path_has() {
    if [[ $PATH = *$1* ]]; then
        return 0
    fi
    return 1
}

path_prepend() {
    if [ -d "$1" ] && ! path_has "$1"; then
        export PATH="$1:$PATH"
    fi
}

path_append() {
    if [ -d "$1" ] && ! path_has "$1"; then
        export PATH="$PATH:$1"
    fi
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"

path_append "$GOPATH/bin"
path_append "$N_PREFIX/bin"
path_append "$ANDROID_HOME"/{tools,platform-tools,emulator}
path_append "$FLUTTER_HOME/bin"

## -- source --
#source_these=()
#for file in "${source_these[@]}"; do
#    if [[ -f $file ]]; then
#        source "$file"
#    fi
#done
#unset source_these
