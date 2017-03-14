#!/bin/bash

ECLIM_HOME=$HOME/.eclim
ECLIPSE_HOME=$HOME/eclipse

ECLIM=$ECLIPSE_HOME/eclim
ECLIMD=$ECLIPSE_HOME/eclimd

LOG=$ECLIM_HOME/init.log
XVFB_PID=$ECLIM_HOME/xvfb.pid

start() {
    Xvfb :1 -screen 0 1024x768x24 &
    echo $! > $XVFB_PID

    DISPLAY=:1 $ECLIMD -b
}

stop() {
    $ECLIM -command shutdown
}

status() {
    $ECLIM -command ping
}

function eclim() {
    local command="$1"

    case $command in
        start)
            start &>$LOG
            ;;
        stop)
            stop &>$LOG
            ;;
        status)
            status
            ;;
        default)
            echo "usage: eclim {start,stop,status}"
            return 1
            ;;
    esac
}
