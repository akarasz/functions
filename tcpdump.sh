#!/bin/bash

cap() {
    local interface="$1"
    local filename="$2"

    sudo tcpdump -i$interface -s0 -w$filename
}
