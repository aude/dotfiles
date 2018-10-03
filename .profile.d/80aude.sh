# -- env --
export EDITOR='vim'
export VISUAL="$EDITOR"
export PASSWORD_STORE_DIR="$HOME/key/password-store"
export GOPATH="$HOME/dev/go"
export ANDROID_HOME="$HOME/src/android-sdk-linux"
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

# n
export N_PREFIX="$HOME/src/n"

# maven
# https://zeroturnaround.com/rebellabs/your-maven-build-is-slow-speed-it-up/
export MAVEN_OPTS='-XX:+TieredCompilation -XX:TieredStopAtLevel=1'

path_dirs=( ~/.local/bin ~/bin $GOPATH/bin $N_PREFIX/bin $ANDROID_HOME/tools )
for dir in "${path_dirs[@]}"; do
	if [[ $PATH != *$dir* ]]; then
		export PATH=$dir:$PATH
	fi
done
unset path_dirs dir

## -- source --
#source_these=()
#for file in "${source_these[@]}"; do
#	if [[ -f $file ]]; then
#		source "$file"
#	fi
#done
#unset source_these
