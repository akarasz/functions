#!/bin/bash

function axl() {
    local host="$1"
    local username="$2"
    local password="$3"
    local xml="$4"

    curl -X POST --header "content-type: text/xml" --insecure --user $username:$password --data @$xml https://$host:8443/axl/ 2>/dev/null |  \
        xmllint --format - |  \
        source-highlight -s xml -f esc
}

