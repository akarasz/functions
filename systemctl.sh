#!/bin/bash

alias sctls='sudo systemctl status'
alias sctlr='sudo systemctl restart'

function sctlon() {
    local service="$1"

    sudo systemctl start $service
    sudo systemctl enable $service
}

function sctloff() {
    local service="$1"

    sudo systemctl stop $service
    sudo systemctl disable $service
}

