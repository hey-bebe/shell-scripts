#!/bin/bash

# All of this can be accomplished with the command 'pkill.' The
# purpose of this script is to copy the functionality of pkill for
# educational purposes

echo "process name: "
read -r y_input

# TODO: test if user input matches a value or not

for pid in $(ps aux | awk -v search="${y_input}" '$11 ~ search {print $2}'); do
    echo "Killing '$pid'"
    kill "$pid"
done
