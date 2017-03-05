#!/bin/bash

function template() {
    local template_name="$1"
    local file_name="$2"

    local TEMPLATE_DIR="$HOME/templates"

    local template=$TEMPLATE_DIR/$template_name
    if [ -f $template ]; then
        cat $template > $file_name

        [ $? -eq 0 ] && $EDITOR $file_name
    fi

    echo "no file created"
}
