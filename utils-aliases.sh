#!/bin/bash

function alias-reload() {
    local LOCAL_ALIASES=$HOME/.local/bash_aliases

    . $LOCAL_ALIASES
}

function alias-add() { local name="$1"
    local command="${@:2}"

    local LOCAL_ALIASES=$HOME/.local/bash_aliases
    mkdir -p $(dirname $LOCAL_ALIASES)

    local line="alias $name='$command'"

    echo "$line" >> $LOCAL_ALIASES  # persist

    alias-reload
}

alias-reload
