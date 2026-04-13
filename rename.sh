#!/bin/bash

# Batch rename file extensions of one type to another.
# This motivated by wanting to convert a bunch of txt files to markdown
# e.g. ./rename.sh md txt

set -e

for file in *."$1"; do
	mv "$file" "${file%."$1"}.$2"
	echo "Changing extension: '$file' to ${file%."$1"}.$2"
done

exit 0
