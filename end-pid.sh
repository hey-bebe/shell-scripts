#!/bin/bash

echo "process name: "
read -r y_input

# All of this can be accomplished with the command 'pkill.' But why make things
# easy? At least this was a learning experience.

# TODO: test if user input matches a value or not

for pid in $(ps aux | awk -v search="${y_input}" '$11 ~ search {print $2}'); do
    echo "Killing '$pid'"
    kill "$pid"
done
