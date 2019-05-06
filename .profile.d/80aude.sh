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
# better font rendering
export _JAVA_OPTIONS="$_JAVA_OPTIONS -Dawt.useSystemAAFontSettings=gasp"
# better 2D performance
export _JAVA_OPTIONS="$_JAVA_OPTIONS -Dsun.java2d.opengl=true"

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

# .NET Core
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# PowerShell Core
export POWERSHELL_TELEMETRY_OPTOUT=1

path_has() {
    if [[ $PATH = *$1* ]]; then
        return 0
    fi
    return 1
}

path_add() {
    local position=$1 && shift
    local path
    for path in "$@"; do
        if [ -d "$path" ] && ! path_has "$path"; then
            case "$position" in
                before) export PATH="$path:$PATH";;
                after) export PATH="$PATH:$path";;
                *) echo 'usage: path_add (before|after) <path...>' 1>&2; return 1;;
            esac
        fi
    done
}

path_add 'before' "$HOME/.local/bin"
path_add 'before' "$HOME/bin"

path_add 'after' "$GOPATH/bin"
path_add 'after' "$HOME/.dotnet/tools"
path_add 'after' "$ANDROID_HOME"/{tools{,/bin},platform-tools,emulator}
path_add 'after' "$FLUTTER_HOME/bin"
path_add 'after' "$N_PREFIX/bin"

## -- source --
#source_these=()
#for file in "${source_these[@]}"; do
#    if [[ -f $file ]]; then
#        source "$file"
#    fi
#done
#unset source_these
