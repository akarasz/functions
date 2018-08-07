#!/bin/bash

function colorize {
    local ERROR_LABEL="ERROR"
    local ERROR_COLOR="\e[31m"
    local WARN_LABEL="WARNING"
    local WARN_COLOR="\e[33m"
    local INFO_LABEL="INFO"
    local INFO_COLOR="\e[37m"
    local DEBUG_LABEL="DEBUG"
    local DEBUG_COLOR="\e[90m"
    local TRACE_LABEL="TRACE"
    local TRACE_COLOR="\e[31m"

    local RESET="\e[0m"

    trap "echo -ne \"$RESET\"" ERR EXIT

    while read line; do
        level=$(echo "$line" | sed -n "s/^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\},[0-9]\{3\} \([^ ]\+\) .*$/\1/p")

        case "$level" in
            "$ERROR_LABEL")
                echo -ne "${RESET}${ERROR_COLOR}"
                ;;
            "$WARN_LABEL")
                echo -ne "${RESET}${WARN_COLOR}"
                ;;
            "$INFO_LABEL")
                echo -ne "${RESET}${INFO_COLOR}"
                ;;
            "$DEBUG_LABEL")
                echo -ne "${RESET}${DEBUG_COLOR}"
                ;;
            "$TRACE_LABEL")
                echo -ne "${RESET}${TRACE_COLOR}"
                ;;
        esac

        echo "$line"
    done < "${1:-/dev/stdin}"

    echo -ne "$RESET"
}
