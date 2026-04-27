#!/bin/bash

# This script recursively searches the home directory for a user
# defined file extension and displays the total number of those files
# and their collective size in MB.

extension=$1

if [ -z "$extension" ]; then
    echo "You did not enter a file extension"
else
    find ~ -type f -name "*.$extension" -print0 \
	| xargs -0 -r du -k \
	| awk '{
	      total+=$1
   	       }

	           END {
		         printf("\nTotal files: %d\nTotal Size: %.1f MB\n", NR, total/1024)
			     }
			       '
fi 
