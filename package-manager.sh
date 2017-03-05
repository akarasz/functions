#!/bin/bash

set_yum_aliases() {
    alias pkgi='sudo yum install'
    alias pkgr='sudo yum remove'
    alias pkgu='sudo yum update'
    alias pkgs='yum search'
    alias pkgp='yum provides'
}

set_apt_aliases() {
    alias pkgi='sudo apt-get install'
    alias pkgr='sudo apt-get remove'
    alias pkgu='sudo apt-get update && sudo apt-get upgrade'
    alias pkgs='apt-cache search'
    alias pkgp='apt-file search'
}

command -v apt-get &>/dev/null && set_apt_aliases && return 0
command -v yum &>/dev/null && set_yum_aliases && return 0

return 1
