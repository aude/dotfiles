# Get the environment variables, runtime scripts, aliases and functions
source_these=( ~/.profile ~/.bashrc )
for file in "${source_these[@]}"; do
	if [[ -f $file ]]; then
		source "$file"
	fi
done
unset source_these file
