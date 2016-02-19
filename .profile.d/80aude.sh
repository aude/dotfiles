# -- env --
path_dirs=( ~/.local/bin ~/bin )
for dir in ${path_dirs[@]}; do
    if [[ -z $(grep "$dir" <<< $PATH) ]]; then
        export PATH=$dir:$PATH
    fi
done

export EDITOR=vim
export PASSWORD_STORE_DIR=~/key/password-store/
export GOPATH=~/dev/go

# gpg-agent
if ! pgrep -u "$(whoami)" 'gpg-agent' >/dev/null 2>&1; then
	eval "$(gpg-agent --daemon)"

	# set $SSH_AGENT to something that will not run,
	# so RedHat's xinitrc-common does not launch a new ssh-agent
	export SSH_AGENT=' '
fi

# virtualenvwrapper
#VEW=/usr/share/virtualenvwrapper/virtualenvwrapper.sh
VEW=/usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh
if [[ -f $VEW ]]; then
    export WORKON_HOME=~/dev/py/env
fi

# -- source --
#source_these=()
#for file in "${source_these[@]}"; do
#    if [[ -f $file ]]; then
#        source "$file"
#    fi
#done
