#!/bin/bash

# function which helps save information about processes
function print_info {
    local pid=$(cat '/proc/'$1'/status' | grep -w Pid | grep -o '\<[0-9]\{1,7\}\>')
    local state=$(cat '/proc/'$1'/status' | grep -w State | grep -wo 'S\|R')
    local thread=$(cat '/proc/'$1'/status' | grep -w Threads | grep -o '\<[0-9]\{1,7\}\>')
    local link='/proc/'$1'/exe'
    local owner=$(find '/proc/'$1 -maxdepth 0 -printf '%u')
    local time=$(stat '/proc/'$1 | grep Access | tail -n1 | grep -wo '\<[0-9]\{1,4\}\>.*')
    local path=$(readlink -f $link)

    local info='\e[32m'$pid' # \e[36m'$2' # \e[34m'$state' # \e[36m'$thread' # \e[93m'$owner' # \e[92m'$time' # \e[31m'$path
    
    # condition for checking of the type for hierarchy
    # P - Parent
    # C - Child
    # if type are Child then program will be printing path for process via Magenta color
    # in another case program will be printing path for process via Red color
    if [ "$2" == "C" ];
    then
        info='\e[32m'$pid' # \e[35m'$2' # \e[34m'$state' # \e[36m'$thread' # \e[93m'$owner' # \e[92m'$time' # \e[35m'$path
    fi

    # writing to the file
    echo -e $info >> output.txt
}

# titles for columns
echo -e '\e[32mPid # \e[35mHierarchy # \e[34mState # \e[36mThreads # \e[93mOwner # \e[92mTime # \e[31mCommand' >> output.txt

# main loop which allows find out all processes
for var in $(ls /proc/ | grep '\<[0-9]\{1,7\}\>')
do
    # checking of existence for status file
    if [ -e '/proc/'$var'/status' ];
    then

        # condition for checking that a status file exists
        if [ "$(pgrep -P $(cat '/proc/'$var'/status' | grep -w Pid | grep -o '\<[0-9]\{1,7\}\>'))" != "" ];
        then

            # condition for checking that path to the file exists
            if [ "$(readlink -f '/proc/'$var'/exe')" != "" ];
            then
                # saving info about parent process
                print_info $var "P"

                # traverse child processes
                for i in $(pgrep -P $(cat '/proc/'$var'/status' | grep -w Pid | grep -o '\<[0-9]\{1,7\}\>'))
                do
                    # saving info about child processes
                    print_info $i "C"
                done
            fi

        fi

    fi
done

# printing info onto display in table style
cat output.txt | column -t -s '#'
# delete file which already are unused
rm -rf output.txt
