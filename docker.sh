#!/bin/bash

alias dps="docker ps"
alias dpsa="docker ps -a"

alias dlog="docker logs -f"

alias drm="docker rm -f"

dbash() {
    local container="$1"

    docker exec -it $container bash
}
