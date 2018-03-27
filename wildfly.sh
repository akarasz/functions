#!/bin/bash

function wfl() {
    trap "tmux setw automatic-rename" 0 1 2 5

    tmux rename-window wfl
    tail -n 100 -f /opt/wildfly/standalone/log/server.log
    tmux setw automatic-rename
}
