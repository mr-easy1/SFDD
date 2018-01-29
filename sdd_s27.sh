#!/bin/bash

################################################################################
# Executes command with a timeout
# Params:
#   $1 timeout in seconds
#   $2 command
# Returns 1 if timed out 0 otherwise
timeout() {

    time=$1

    # start the command in a subshell to avoid problem with pipes
    # (spawn accepts one command)
    command="/bin/sh -c \"$2\""

    expect -c "set echo \"-noecho\";
        set timeout $time; spawn -noecho $command;
        expect timeout { exit 1 } eof { exit 0 }"    

    if [ $? = 1 ] ; then
        echo "Timeout after ${time} seconds"
    fi

}

for n in $( seq 0 99 ); do
    echo ${n}
    timeout 60 "./sdd -c test/s27/s27.scan.cnf -v test/s27/s27_${n}.vtree -M -r0"
done