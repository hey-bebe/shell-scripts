#!/usr/bin/env bash

# This script recursively searches the home directory by default for a
# user defined file extension and displays the total number of that
# file type and the total size of those files in MB. Use the -d flag
# to specifiy a directory other than the home directory. Use the -f
# flag to use fd, which is substantially faster than find.

#TODO add max-depth
#TODO add option to ignore certain directories
#TODO add help
#TODO add support for smaller file sizes

directory="$HOME"
extension=""
fd=false

while getopts "e:d:f" opt; do
    case "$opt" in
	e)			# specify an extension
	    extension=${OPTARG#.}
	    ;;
	d)			# specifiy a directory
	    directory=$OPTARG
	    ;;
	f)			# Use fd instead of find
	    fd=true
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

elif [ "$fd" = true ]; then  

    fd -u -0 -t f -e "$extension" . "$directory" \
    | xargs -0 -r du -k \
    | awk -v extension="$extension" '
	{
	    total+=$1
	}
	END {
	    printf("Total files (%s): %d\n" \
	    	   "Total Size: %.1f MB\n\n",
		   extension,
		   NR,
		   total/1024)
	}'

else
    find "$directory" -type f -iname "*.$extension" -print0 \
    | xargs -0 -r du -k \
    | awk -v extension="$extension" '
        {
	    total+=$1
	}
	END {
	    printf("Total files (%s): %d\n" \
	    	   "Total Size: %.1f MB\n\n",
		   extension,
		   NR,
		   total/1024)
	}'
fi 
