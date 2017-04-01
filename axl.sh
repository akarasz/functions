#!/bin/bash

function axl() {
    local host="$1"
    local username="$2"
    local password="$3"
    local xml="$4"

    response=$(curl -X POST --header "content-type: text/xml" --insecure --user $username:$password --data @$xml https://$host:8443/axl/ 2>/dev/null)

    if command -v xmllint &>/dev/null; then
        formatted=$(echo "$response" | xmllint --format -)
        response="$formatted"
    else
        echo 'if you want formatted output, provide the `xmllint` command' >&2
    fi

    if command -v source-highlight &>/dev/null; then
        highlighted=$(echo "$response" | source-highlight -s xml -f esc)
        response="$highlighted"
    else
        echo 'if you want highlighted output, provide the `source-highlight` command' >&2
    fi

    echo "$response"
}

function axl-sql-result-to-csv() {
    local xml_file="$1"

    cat "$xml_file" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" | xmlstarlet sel -B -t -m "//return/row" -n -m "*" -v . -o ,
}
