#!/bin/bash

# This script recursively searches the home directory for a user
# defined file extension and displays the total number of those files
# and their collective size in MB.

#TODO add max-depth
#TODO add option to ignore certain directories
#TODO add help

directory="$HOME"
extension=""
utility=false

while getopts "e:d:f" opt; do
    case "$opt" in
	e)			# specify an extension
	    extension=$OPTARG
	    ;;
	d)			# specifiy a directory
	    directory=$OPTARG
	    ;;
	f)			# Use fd instead of find
	    utility=true
	    ;;
	*)
	    echo "Usage: $0 -e extension [-d directory] [-f]"
	    exit 1
	    ;;
    esac
done

if [ -z "$extension" ]; then
    echo "You did not enter a file extension"
    echo "Usage: ./fts.sh -e <extension> [-d <dirctory>] [-f]"
    exit 1

elif [ "$utility" = true ]; then  

    fd -u -0 -t f -e "$extension" . "$directory" \
    | xargs -0 -r du -k \
    | awk '{total+=$1}
		END {
		printf("\nTotal files: %d\nTotal Size: %.1f MB\n", NR, total/1024)
		}'

else
    find "$directory" -type f -iname "*.$extension" -print0 \
    | xargs -0 -r du -k \
    | awk '{total+=$1}
	        END {
		printf("\nTotal files: %d\nTotal Size: %.1f MB\n", NR, total/1024)
		}'
fi 
