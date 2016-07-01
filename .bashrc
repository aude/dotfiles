# Source global definitions, local conf and our shrc system
source_these=( /etc/bashrc ~/.bashrc.local ~/.shrc )
for file in "${source_these[@]}"; do
	if [[ -f $file ]]; then
		source "$file"
	fi
done
unset source_these file
