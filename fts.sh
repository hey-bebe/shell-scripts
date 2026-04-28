#!/bin/bash

# This script recursively searches the home directory for a user
# defined file extension and displays the total number of those files
# and their collective size in MB.

#TODO add max-depth
#TODO add option to ignore certain directories
#TODO add option for fd instead of find
#TODO add help

directory="$HOME"
extension=""

while getopts "e:d:" opt; do
    case "$opt" in
	e)
	    extension=$OPTARG
	    ;;
	d)
	    directory=$OPTARG
	    ;;
	*)
	    echo "Usage: $0 -e extension [-d directory]"
	    exit 1
	    ;;
    esac
done



if [ -z "$extension" ]; then
    echo "You did not enter a file extension"
    echo "Usa: ./fts.sh -e <extension> [-d <dirctory>]"
    exit 1
fi 
    
find "$directory" -type f -iname "*.$extension" -print0 \
    | xargs -0 -r du -k \
    | awk '{ total+=$1 }
	           END {
		         printf("\nTotal files: %d\nTotal Size: %.1f MB\n", NR, total/1024)
			 }'

