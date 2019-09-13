#!/bin/bash

# main loop which allows find out all processes
for var in $(ls /proc/ | grep '\<[0-9]\{3,6\}\>')
do
    # checking of existence for status file
    if [ -e '/proc/'$var'/status' ];
    then
        pid=$(cat '/proc/'$var'/status' | grep -w Pid | grep -o '\<[0-9]\{1,6\}\>')
        state=$(cat '/proc/'$var'/status' | grep -w State | grep -wo S)
        thread=$(cat '/proc/'$var'/status' | grep -w Threads | grep -o '\<[0-9]\{1,6\}\>')
        link='/proc/'$var'/exe'

        if [ "$(readlink -f $link)" != "" ];
        then
            owner=$(find '/proc/'$var -maxdepth 0 -printf '%u')
            time=$(stat '/proc/'$var | grep Access | tail -n1 | grep -wo '\<[0-9]\{1,4\}\>.*')
            path=$(readlink -f $link)
            info='\e[32m'$pid' \e[34m'$state' \e[36m'$thread' \e[93m'$owner' \e[92m'$time' \e[31m'$path
            echo -e $info
        fi

    fi
done

