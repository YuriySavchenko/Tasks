#!/bin/bash

# variable for saving root directory
root=$1

# creation file for saving
if [ -f tree_file_system.txt ];
then
    rm tree_file_system.txt
fi
touch tree_file_system.txt

# condition for empty variable
if [[ -z $root ]]; 
then
    echo . >> tree_file_system.txt
else
    echo $root >> tree_file_system.txt
fi

# variable for saving level of deep
level=0

# function for traverse
function deep_descent {
    level=$(expr $level + 4)
    local step="--"
    local dir=$1

    # main loop
    for item in $(ls $dir)
    do
        # printing of pointer to item
        printf %"$level"s | tr " " "-" >> tree_file_system.txt
        # printing of item
        echo " "$item >> tree_file_system.txt
        
        # checking path
        if [ -d $dir/$item ];
        then
            # recursive descent
            deep_descent $dir/$item
            level=$(expr $level - 4)
        fi
    done
}

# invoke of function
deep_descent $root

# archiving of the file
zip "archive-"$(echo $(LANG=en_us_88591; date) | tr -s [:space:] '.')'zip' tree_file_system.txt

# removing of file with info
rm tree_file_system.txt
