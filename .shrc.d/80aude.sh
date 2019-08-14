# -- env --
# quickfix for byobu
if [[ $TERM == "screen" && -n $DISPLAY ]]; then
	export TERM=screen-256color
fi

# -- interactive --
# the rest is only relevant in interactive shells
[[ $- != *i* ]] && return

# -- alias --
# type dots to `cd ../../../...`
what='..'; to='cd ..'
while [[ ${#what} -lt 16 ]]; do
    alias "$what"="$to"
    what+='.'; to+='/..'
done; unset what to
alias ls='ls --color'
alias la='ls --all'
alias l='ls --almost-all'
alias ll='la -l'
alias lh='ll --human-readable'
alias lr='l -l -t --reverse --human-readable'
alias grep='grep --color'
alias less='less -r'
alias git='git -c color.ui=auto'
alias rg='rg --no-heading --no-line-number --hidden --search-zip --follow'
unalias ag 2>/dev/null
alias ag='ag --color'
alias tree='tree -C -a'
alias cower='cower --color --sort=votes'

alias b=byobu
alias o=xdg-open
alias sued=sudoedit
alias da='direnv allow'

alias vi='vim -u NONE -N'
alias view='vim -R'
alias vimdiff='vim -d'
# vim is set in bin/vim

alias mpv='mpv --input-ipc-server="$MPV_SOCKET"'

# bashrc
if [[ -n $BASH_VERSION ]]; then
	# http://blog.sanctum.geek.nz/better-bash-history/
	shopt -s histappend
	export HISTFILESIZE=1000000
	export HISTSIZE=1000000
	export HISTCONTROL=ignoreboth
	export HISTIGNORE='ls:bg:fg:history:..:...:la:l:ll:lh:b:da'
	shopt -s cmdhist
	if [[ $PROMPT_COMMAND != *'history -a'* ]]; then
		PROMPT_COMMAND="$PROMPT_COMMAND"$'\n''history -a'
	fi
fi

# zshrc
if [[ -n $ZSH_VERSION ]]; then
	setopt HIST_IGNORE_DUPS
fi

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
# python venv activation
activate() {
    for venv in '.venv' 'venv'; do
        if [[ -f $venv/bin/activate ]]; then
            source "$venv/bin/activate"
            unset venv
            return
        fi
    done

    echo 'did not find any venv' 1>&2
    return 1
}
# (( code search ))
s() {
    # check for actual binaries, aliases and stuff won't work without
    if /usr/bin/which rg >/dev/null 2>&1; then
        rg --smart-case "$@"
    elif /usr/bin/which ag >/dev/null 2>&1; then
        ag "$@"
    elif /usr/bin/which ack >/dev/null 2>&1; then
        ack --smart-case "$@"
    elif /usr/bin/which grep >/dev/null 2>&1; then
        # smart case
        grep -R "$(echo "$1" | grep -q '[[:upper:]]' || echo '-i')" "$@"
    else
        echo "how is this even...? no grep?!" 1>&2
        return 1
    fi
}
# (( code search ))

# (( file search ))
# bind ctrl-f to fuzzy-find a file and append it to the command line
function print_files() {
    # prefer `rg`
    if /usr/bin/which rg >/dev/null 2>&1; then
        rg --files --no-ignore --glob '!.git'
    # fall back to `find`
    else
        # skip .git directories
        find . -name .git -prune -o -type f -print
    fi
}
function choose() {
    # check for actual binaries, aliases and stuff won't work without
    if /usr/bin/which fzy >/dev/null 2>&1; then
        fzy | exists | is_not_empty
    elif /usr/bin/which fzf >/dev/null 2>&1; then
        fzf --cycle
    else
        echo 'install "fzy" or "fzf" to use this functionality' >&2
        return 1
    fi
}
# command to select a file
function select_file() {
    print_files 2>/dev/null | choose
}
# helper functions
function exists() {
    while read -r file; do
        if [ -e "$file" ]; then
            printf '%s\n' "$file"
        fi
    done
}
function is_not_empty() {
    empty='true'
    while read -r line; do
        printf '%s\n' "$line"
        empty='false'
    done
    if "$empty"; then
        return 1
    fi
}

# if BASH
if [[ -n $BASH_VERSION ]]; then

    # ~https://gist.github.com/aaronj1335/7090969
    function append-fuzzyfind-path-to-command-line() {
        local selected_path
        # Find the path; abort if the user doesn't select anything.
        selected_path=$(select_file) || return
        # Quote the path.
        selected_path=$(printf '%q' "$selected_path")
        # Append the selection to the current command buffer.
        READLINE_LINE="$READLINE_LINE$selected_path "
        READLINE_POINT=${#READLINE_LINE}
    }

    # bind the key to the widget
    bind -x '"\C-f":"append-fuzzyfind-path-to-command-line"'

# else if ZSH
elif [[ -n $ZSH_VERSION ]]; then

    function append-fuzzyfind-path-to-command-line() {
        local selected_path
        # Print a newline or we'll clobber the old prompt.
        echo
        # Find the path; abort if the user doesn't select anything.
        selected_path=$(select_file) || return
        # Quote the path.
        selected_path=$(printf '%q' "$selected_path")
        # Append the selection to the current command buffer.
        LBUFFER="$LBUFFER$selected_path"
        # Redraw the prompt since fuzzyfind has drawn several new lines of text.
        zle reset-prompt
        # run the command
        #zle accept-line
    }

    # Create the zle widget
    zle -N append-fuzzyfind-path-to-command-line
    # Bind the key to the newly created widget
    bindkey "^F" "append-fuzzyfind-path-to-command-line"

fi
# (( file search ))

# (( gpg-agent ))
if [[ -d ~/.gnupg ]]; then
    # set GnuPG TTY. `man 1 gpg-agent`
    GPG_TTY=$(tty)
    export GPG_TTY

    # refresh gpg-agent tty in case user switches into an X session
    if command -v gpg-connect-agent >/dev/null 2>&1; then
        gpg-connect-agent updatestartuptty /bye >/dev/null
    fi
fi
# (( gpg-agent ))

# -- source --
source_these=( ~/src/z/z.sh $VEW )
for file in "${source_these[@]}"; do
	if [[ -f $file ]]; then
		source "$file"
	fi
done
unset source_these

if [[ -r ~/.dircolors ]]; then
	eval "$(dircolors -b ~/.dircolors)"
else
	eval "$(dircolors -b)"
fi

# -- cmd --
# do not show the "Done" message, so run all in subshell
#(
#	(
#		if command -v unlock-keyring >/dev/null 2>&1; then
#			unlock-keyring&
#		fi
#	)&
#)
