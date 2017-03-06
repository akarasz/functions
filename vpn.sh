#!/bin/bash

# README
#
# vpn profiles should go to $HOME/vpn. Scripts named like ${PROFILE_NAME}.sh.
# start() and stop() functions are necessary.

automatic-stop-vpn() {
    local vpn="$1"
    local timeout="$2"

    sleep $(expr $timeout \* 60) 
    
    $vpn stop 
    tmux set-environment -g VPN ''
}
 
function vpn() {
    local state="$1"
    local profile="$2"
    local timeout=${3:-480}

    local VPN_PROFILE_DIR=$HOME/vpn

    local vpn=$VPN_PROFILE_DIR/$profile.sh

    # exit if vpn profile not found
    [ ! -f $vpn ] && exit 1

    case $state in
        start)
            echo "start vpn $profile..."

            $vpn start
            tmux set-environment -g VPN $profile
            
            automatic-stop-vpn $vpn $timeout &
            tmux set-environment -g VPN_${profile}_PID $!
            
            echo "vpn started."
            ;;
        stop)
            echo "stop vpn $profile..."

            $vpn stop
            tmux set-environment -g VPN ''

            # kill auto-stop-vpn
            kill $(tmux show-environment -g VPN_${profile}_PID | sed 's/^.*=//')

            echo "vpn stopped."
            ;;
    esac
}
