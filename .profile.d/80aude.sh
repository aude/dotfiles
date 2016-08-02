# -- env --
export EDITOR=vim
export VISUAL=$EDITOR
export PASSWORD_STORE_DIR=~/key/password-store/
export GOPATH=~/dev/go
export ANDROID_HOME=~/src/android-sdk-linux

# gpg-agent
# use gpg-agent's SSH agent emulation
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
	export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
fi

# set $SSH_AGENT to something that will not run,
# so RedHat's xinitrc-common does not launch a new ssh-agent
export SSH_AGENT=' '

# virtualenvwrapper
for VEW in /usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh "$(which virtualenvwrapper_lazy.sh)"; do
	if [[ -f $VEW ]]; then
		export VEW
		export WORKON_HOME=~/dev/py/env
		break
	fi
done

# n
export N_PREFIX=~/src/n

path_dirs=( ~/.local/bin ~/bin $GOPATH/bin $N_PREFIX/bin $ANDROID_HOME/tools )
for dir in ${path_dirs[@]}; do
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
