#!/bin/bash

# README
#
# vpn profiles should go to $HOME/vpn. Scripts named like ${PROFILE_NAME}.sh.
# start() and stop() functions are necessary.

get-environment() {
    local key="$1"

    echo $(tmux show-environment -g $key | sed 's/^.*=//') 
}

set-environment() {
    local key="$1"
    local value="$2"

    tmux set-environment -g "$key" "$value"
}

stop-vpn-when-timeout() {
    local vpn="$1"
    local timeout="$2"

    sleep $(expr $timeout \* 60) 
    
    $vpn stop 
    set-environment $VPN
}

stop-vpn-when-no-ssh-session() {
    local vpn="$1"

    while true; do
        if [ $(ps ax | grep sshd: | grep -v grep | wc -l) -eq 0 ]; then
            $vpn stop
            set-environment $VPN
        fi

        sleep 10
    done
}
 
function vpn() {
    local state="$1"
    local profile="$2"
    local timeout=${3:-480}

    local VPN_PROFILE_DIR=$HOME/vpn

    local VAR_VPN=VPN

    [ -z "$profile" ] && profile=$(get-environment $VAR_VPN)

    local VAR_TIMEOUT=VPN_${profile}_TIMEOUT_PID
    local VAR_NO_SSH=VPN_${profile}_NO_SSH

    local vpn=$VPN_PROFILE_DIR/$profile.sh

    # return if vpn profile not found
    [ ! -f $vpn ] && return 1

    case $state in
        start)
            echo "start vpn $profile..."

            if [ -n "$(get-environment $VAR_VPN)" ]; then
                echo "already connected to a vpn"
                return 2
            fi

            $vpn start
            set-environment $VAR_VPN $profile

            stop-vpn-when-timeout $vpn $timeout &
            set-environment $VAR_TIMEOUT $!

            stop-vpn-when-no-ssh-session $vpn &
            set-environment $VAR_NO_SSH $!
            
            echo "vpn started."
            ;;
        stop)
            echo "stop vpn $profile..."

            if [ -z "$(get-environment $VAR_VPN)" ]; then
                echo "not connected to vpn"
                return 2
            fi

            $vpn stop
            set-environment $VAR_VPN

            # kill auto-stop-vpn
            kill $(get-environment $VAR_TIMEOUT)
            kill $(get-environment $VAR_NO_SSH)

            echo "vpn stopped."
            ;;
    esac
}
