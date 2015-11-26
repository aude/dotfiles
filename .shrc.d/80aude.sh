source_these=( ~/src/z/z.sh )
for file in "${source_these[@]}"; do
    if [[ -f $file ]]; then
        source "$file"
    fi
done
