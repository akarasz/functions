#!/bin/bash

alias s='sudo $(history -p !!)'

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles-repo/ --work-tree=$HOME'
alias reload='unalias -a && . ~/.bash_profile'

alias netstatt='netstat -tulpn'

alias ls='ls --color=always'
alias tree='tree -C'
alias mkdir='mkdir -p'

alias dl='curl -O --insecure -L'

# password gen
alias genpass='echo $(< /dev/urandom tr -dc \._A-Z-a-z-0-9 | head -c32)'

function colors-available() {
    for i in {0..255} ; do
        printf "\x1b[38;5;${i}mcolour${i}\n"
    done
}

