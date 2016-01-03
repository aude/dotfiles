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
