#!/bin/bash

# README
#
# vpn profiles should go to $HOME/vpn. Scripts named like ${PROFILE_NAME}.sh.
# start() and stop() functions are necessary.

stop-vpn-when-timeout() {
    local vpn="$1"
    local timeout="$2"

    trap "" HUP
    sleep $(expr $timeout \* 60) 
    
    vpn stop  # this also kills current function running
}

stop-vpn-when-no-ssh-session() {
    local vpn="$1"

    trap "" HUP
    while true; do
        [ ! -d $HOME/vpn/.active ] && return 0  # exit if vpn is not active
        [ $(ps ax | grep sshd: | grep -v grep | wc -l) -eq 0 ] && vpn stop  # this also kills current function running

        sleep 10
    done
}
 
function vpn() {
    local state="$1"
    local profile="$2"
    local timeout=${3:-480}

    local PROFILE_DIR=$HOME/vpn
    local ACTIVE_DIR=$PROFILE_DIR/.active
    
    local CURRENT_PROFILE=$ACTIVE_DIR/profile
    local AUTO_TIMEOUT=$ACTIVE_DIR/func-timeout.pid
    local AUTO_NOSSH=$ACTIVE_DIR/func-nossh.pid

    [ -z "$profile" ] && profile=$(cat $CURRENT_PROFILE)

    local vpn=$PROFILE_DIR/$profile.sh

    # return if vpn profile not found
    [ ! -f $vpn ] && return 1

    case $state in
        start)
            echo "start vpn $profile..."

            if [ -d $ACTIVE_DIR ]; then
                echo "already connected to a vpn"
                return 2
            fi

            mkdir -p $ACTIVE_DIR

            $vpn start
            echo -n "$profile" > $CURRENT_PROFILE

            stop-vpn-when-timeout $vpn $timeout &
            echo -n "$!" > $AUTO_TIMEOUT

            stop-vpn-when-no-ssh-session $vpn &
            echo -n "$!" > $AUTO_NOSSH
            
            echo "vpn started."
            ;;
        stop)
            echo "stop vpn $profile..."

            if [ ! -d $ACTIVE_DIR ]; then
                echo "not connected to vpn"
                return 2
            fi

            $vpn stop
            echo "vpn stopped."

            local timeout_pid=$(cat $AUTO_TIMEOUT)
            local nossh_pid=$(cat $AUTO_NOSSH)

            rm -rf $ACTIVE_DIR

            # kill auto-stop-vpn
            kill -- -$timeout_pid
            kill -- -$nossh_pid
            ;;
    esac
}
