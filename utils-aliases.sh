#!/bin/bash

function alias-add() { local name="$1"
    local command="${@:2}"

    local LOCAL_ALIASES=$HOME/.local/bash_aliases

    local line="alias $name='$command'"

    echo "$line" >> $LOCAL_ALIASES  # persist
    . $LOCAL_ALIASES
}
