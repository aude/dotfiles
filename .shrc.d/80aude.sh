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
done; unset to what
alias ls='ls --color'
alias la='ls --all'
alias l='ls --almost-all'
alias ll='la -l'
alias lh='ll --human-readable'
alias grep='grep --color'
alias less='less -r'
alias git='git -c color.ui'
alias tree='tree -C'

alias b=byobu
alias sued=sudoedit

alias vi='ex -v -u NONE'
alias view='vim -R'
alias vimdiff='vim -d'
# vim is set in bin/vim

# The Silver Searcher
unalias ag 2>/dev/null
ag() {
    ag_file=$(/usr/bin/which ag 2>/dev/null) && "$ag_file" "$@" && return
    ack_file=$(/usr/bin/which ack 2>/dev/null) && "$ack_file" "$@" && return
    grep -Ri "$@"
}

# bashrc
if [[ -n $BASH_VERSION ]]; then
	# http://blog.sanctum.geek.nz/better-bash-history/
	shopt -s histappend
	HISTFILESIZE=1000000
	HISTSIZE=1000000
	HISTCONTROL=ignoreboth
	HISTIGNORE='ls:bg:fg:history:..:...:la:l:ll:lh:b'
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
		READLINE_POINT=$((READLINE_POINT + $(wc -m <<< "$selected_path")))
	}
	if command -v selecta >/dev/null 2>&1; then
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
	if command -v selecta >/dev/null 2>&1; then
		# Create the zle widget
		zle -N insert-selecta-path-in-command-line
		# Bind the key to the newly created widget
		bindkey "^F" "insert-selecta-path-in-command-line"
	fi
fi
# (( selecta ))

# (( gpg-agent ))
# set GnuPG TTY. `man 1 gpg-agent`
GPG_TTY=$(tty)
export GPG_TTY

# refresh gpg-agent tty in case user switches into an X session
if command -v gpg-connect-agent >/dev/null 2>&1; then
	gpg-connect-agent updatestartuptty /bye >/dev/null
fi
# (( gpg-agent ))

# -- source --
source_these=( ~/src/z/z.sh $VEW )
for file in "${source_these[@]}"; do
	if [[ -f $file ]]; then
		source "$file"
	fi
done

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
