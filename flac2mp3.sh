#!/bin/bash

CPUTHREADS=4
QUALITY="-qscale:a 0"
if [ -z "$SRC_EXT" ]; then
	SRC_EXT="flac"
fi

function usage()
{
    echo "Converts all .$SRC_EXT files in a given directory into .mp3"
    echo "Options:"
    echo "\t-h --help"
    echo "\t-t --threads= (default: $CPUTHREADS)"
    echo "\t-q --quality=[VBR 0-9, or 'best' for 320kbps] (default: 0 - VBR 220-260kbps)"
    echo ""
}

# TODO: actually parse arguments (see https://gist.github.com/jehiah/855086)

# Keep track of the number of concurrent transcodings
C=0

for a in ./*.$SRC_EXT; do
	MP3NAME="${a[@]/%$SRC_EXT/mp3}"
	if [ -e "$MP3NAME" ]; then
		if [ "$(read  -rs -N 1 -p "File \"$MP3NAME\" already exists, overwrite?[yN]" ANSWER && echo $ANSWER)" == "y" ]; then
			echo ""
			rm "$MP3NAME"
		else
			echo " Skipping..."
			continue
		fi
	fi
	(( C++ ))
	echo "Encoding $a ($C of $CPUTHREADS threads busy)..."
	< /dev/null ffmpeg -i "$a" $QUALITY "$MP3NAME" &> /dev/null &
	if (( $C >= $CPUTHREADS )); then
		echo "Waiting for a transcode to complete..."
		wait -n
		(( C--))
	fi
done

# Wait for ongoing conversions to complete
wait
