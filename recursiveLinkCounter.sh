#!/bin/bash

# Recurse through all the files in the given directory and find out how many hard links each has

# Avoid spaces being interpreted as array separators
IFS='
'

#VERBOSE="y"

if [ -z $1 ];then
	DIR=$(pwd)
else
	DIR=$1
fi
echo "Dir: $DIR"
FILES=$(ls -d1Rp $PWD/downloads/**/* | egrep -v '/$')
#FILES=$(ls -1Rpd $DIR | grep -v / | egrep -v '^[[:space:]]*$')

for FILE in $FILES;do
	NUM_LINKS=$(stat --printf="%h" $FILE)
	if [ $NUM_LINKS -lt 2 ];then
		if [ -n "$VERBOSE" ]; then echo "File $FILE has only $NUM_LINKS link(s) pointing to it";
		else echo $FILE;
		fi
	fi
#	echo "Number of links: $NUM_LINKS"
done
