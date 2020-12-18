#!/usr/bin/env bash

# Requirement: bash >= 4.0 (because of the usage of $BASHPID)

spawn_with_rules() {(
    # this rule also requires, that the client
    # sets the _NET_WM_PID property
    herbstclient rule once pid=$BASHPID maxage=10 "${RULES[@]}"
    exec "$@"
    ) &
}

# spawn an xterm with uname info, but not where the focus is
RULES=( index='/' focus=off )
spawn_with_rules xterm -e 'uname -a ; read'

# spawn an xterm in pseudotile mode
RULES=( pseudotile=on focus=on )
spawn_with_rules xterm
