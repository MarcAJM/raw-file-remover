#!/bin/zsh

# Turn on case insensitivity when globbing
setopt nocaseglob

# All raw file extensions that need checking:
typeset -A raw_exts
for e in ARW CR2 CR3 NEF NRW RAF ORF RW2 RWL PEF DNG X3F SRW DCR KDC 3FR FFF MEF IIQ MRW; do
	raw_exts[${e:l}]=true
done

for dir in "$@"; do
	cd "$dir" || exit 1;
	
	# Put all jpgs in an array and then store it in a map
	jpgs=( **/*.(jpg|jpeg)(N:t:r) )
	typeset -A jpgmap
	for j in $jpgs; do
  		jpgmap[$j]=true
	done
	
	for f in **/*(N.); do
		
		ext=${${f##*.}:l}
  		if (( ! ${+raw_exts[$ext]} )); then
    		continue
  		fi

		# Extract the file basename	
		name="${f:t:r}"

		# Check if the file matches
		if (( ! ${+jpgmap[$name]} )); then
		
			# Move to trash
			mv "$f" ~/.Trash/
		fi
	done
done