#!/bin/bash

get_ip_on_if() {
    local if="$1"

    ifconfig $if | grep "inet addr" | cut -d : -f 2 | cut -d ' ' -f 1
}

print_line() {
    local name="$1"
    local ip="$2"

    printf "%-20s %s\n" $name $ip
}

function myip() {
    local primary_if="$1"

    [ -z "$primary_if" ] && primary_if=$(ifconfig | head -n 1 | cut -d ' ' -f 1)

    print_line "public" $(get_ip_on_if $primary_if)
    #print_line "vpn" $(get_ip_on_if ppp0) # TODO
}
