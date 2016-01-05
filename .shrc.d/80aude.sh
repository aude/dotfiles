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

# quickfix for byobu
if [ "$TERM" = "screen" ]; then
    export TERM=screen-256color
fi

# -- interactive --
# the rest is only relevant in interactive shells
[[ $- != *i* ]] && return

# virtualenvwrapper
#VEW=/usr/share/virtualenvwrapper/virtualenvwrapper.sh
VEW=/usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh
if [[ -f $VEW ]]; then
    export WORKON_HOME=~/dev/py/env
fi

# -- alias --
alias ..='cd ..'
alias ...='cd ../..'
alias ls='ls --color'
alias la='ls --all'
alias l='ls --almost-all'
alias ll='la -l'
alias lh='ll --human-readable'
alias grep='grep --color'
alias less='less -r'
alias git='git -c color.ui'
unalias ag 2>/dev/null
alias ag='ag --color'

alias b=byobu
alias sued=sudoedit

alias vi='ex -v -u NONE'
alias view='vim -R'
alias vimdiff='vim -d'
# vim is set in bin/vim

# -- function --
cl() {
    if [[ $@ ]]; then
        cd "$@"
    else
        cd
    fi
    l
}
dev() {
    cd ~/dev/"$1"
}

# (( selecta ))
# Run Selecta in the current working directory, appending the selected path, if
# any, to the current command, followed by a space.
export SELECTA_IGNORE='\(.*node_modules.*\)\|\(.*\.git.*\)'
# if BASH
if [[ -n $BASH_VERSION ]]; then
    # ~https://gist.github.com/aaronj1335/7090969
    # if we've got the 'selecta' command (https://github.com/garybernhardt/selecta)
    # then bind ctrl-b to fuzzy-find a file and insert it on the command line
    function insert-selecta-path-in-command-line() {
        local selected_path
        # Find the path; abort if the user doesn't select anything.
        selected_path=$(find . -type f -not -regex "$SELECTA_IGNORE" | selecta) || return
        # Append the selection to the current command buffer.
        READLINE_LINE="$READLINE_LINE$selected_path"
        READLINE_POINT=$(($READLINE_POINT + $(wc -m <<< "$selected_path")))
    }
    if which selecta >/dev/null 2>&1; then
        #bind '"\C-f" "$(find . -type f -not -regex \"$SELECTA_IGNORE\" \| selecta)\n"'
        bind -x '"\C-f":"insert-selecta-path-in-command-line"'
    fi
# else if ZSH
elif [[ -n $ZSH_VERSION ]]; then
    # Run Selecta in the current working directory, appending the selected path, if
    # any, to the current command, followed by a space.
    function insert-selecta-path-in-command-line() {
        local selected_path
        # Print a newline or we'll clobber the old prompt.
        echo
        # Find the path; abort if the user doesn't select anything.
        selected_path=$(find . -type f -not -regex "$SELECTA_IGNORE" | selecta) || return
        # Append the selection to the current command buffer.
        eval 'LBUFFER="$LBUFFER$selected_path"'
        # Redraw the prompt since Selecta has drawn several new lines of text.
        zle reset-prompt
        # run the command
        #zle accept-line
    }
    if which selecta >/dev/null 2>&1; then
        # Create the zle widget
        zle -N insert-selecta-path-in-command-line
        # Bind the key to the newly created widget
        bindkey "^F" "insert-selecta-path-in-command-line"
    fi
fi
# (( selecta ))

# -- source --
source_these=( ~/src/z/z.sh $VEW )
for file in "${source_these[@]}"; do
    if [[ -f $file ]]; then
        source "$file"
    fi
done

if [[ -r ~/.dircolors ]]; then
    eval $(dircolors -b ~/.dircolors)
else
    eval $(dircolors -b)
fi

# -- cmd --
# do not show the "Done" message, so run all in subshell
(
    (
        if command -v unlock-keyring >/dev/null 2>&1; then
            unlock-keyring&
        fi
    )&
)
