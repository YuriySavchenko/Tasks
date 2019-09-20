#!/bin/bash

# printing of the title
echo -e '\e[31m------------------------------------------------------------'
echo -e '\e[32m[+] The Decryption'
echo -e '\e[31m------------------------------------------------------------'

# checking if the first an argument for the program has been passed
if [[ -z $1 ]] || [[ -z $2 ]];
then
    # writing to the output file a title about error of passing arguments
    echo -e '\e[31m------------------------------------------------------------'
    echo -e '\e[32m[-] The program has been started without one of the files!'
    echo -e '\e[31m------------------------------------------------------------'
else
    # clearing of the file
    echo -n > $2

    # an array with a latina symbols
    declare -a latina=("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")
    # an array with a morze symbols
    declare -a morze=("•-" "—••" "—•—•" "—••" "•" "••—•" "——•" "••••" "••" "•——-" "—•-" "•—••" "—-" "—•" "——-" "•——•" "——•-" "•—•" "•••" "-" "••-" "•••-" "•—-" "—••-" "—•—-" "——••")

    # set up a separator for separating of the text into words
    IFS=$'\t'

    # reading text from file
    text=$(cat $1)

    # main loop for considering the words
    for i in $text
    do
        # restore a separator
        IFS=$' '

        # loop for considering of symbols in the the words
        for j in $i
        do
            for k in "${!morze[@]}"
            do
                # checking for matching between a symbol in the word and a symbol from the latin array
                if [[ "${morze[$k]}" = "$j" ]];
                then
                    # writing to the output file translated symbol
                    echo -n "${latina[$k]}" >> $2
                    break
                fi
            done
        done

        # setting a separator again for correct separating in next times
        IFS=$'\t'

        # writing to the output file a separator between the words
        echo -n " " >> $2
    done

    # writing to the output file end of the line
    echo >> $2

    # writing to the output file a title about the finishing of execution
    echo -e '\e[31m------------------------------------------------------------'
    echo -e '\e[32m[!] The program has finished execution!'
    echo -e '\e[31m------------------------------------------------------------'
fi
