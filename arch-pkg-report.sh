#!/bin/bash

# This script is specific to Arch Linux-based distros. Its purpose is to produce
# a CSV file containing a complete list of packages, their version numbers, and
# their descriptions.

pacList=pac-list.txt
pacDesc=pac-desc.txt
pacReport=pac-report.csv

# Obtain a list of packages and their version numbers
pacman -Q >"${pacList}"

# Extract package descriptions from pacman
echo "Creating ${pacReport}"
awk '{ print $1 }' "${pacList}" | xargs pacman -Qi |
    awk -F': ' '/^Description/ { print $2 }' >"${pacDesc}"

# Remove extraneous commas from the package Descriptions
sed -i 's/,//g' "${pacDesc}"

# Replace the space between the package and version number with a comma
# in the package list
sed -i 's/ /,/g' "${pacList}"

# merge the package list and their descriptions together, creating a CSV
paste -d , "${pacList}" "${pacDesc}" >"${pacReport}"

# add headers to CSV
sed -i '1i Package,Version,Description' "${pacReport}"

# remove helper files
rm "${pacDesc}"
rm "${pacList}"

echo "Done"

# TODO produce structured output of CSV
# awk -F, '{ printf "%-45s, %s\n", $1, $3 }' "${pacReport}"
