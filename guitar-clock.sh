#!/bin/sh

cd ~/Dokumenty/Gitarowe || exit 3
test -f practice.clock || exit 2

if [ "$#" -ge 1 ]; then
    if [ "$1" = "-s" ] ; then # shift
        nvim +'0m$' +'x' practice.clock
    elif [ "$1" = "-u" ] ; then #unshift
        nvim +'norm GddggP' +'x' practice.clock
    else
        cat << EOM
usage: $0 [-s|-u]
    -s: shift (next)
    -u: unshift (prev)
    default: open last
EOM
        exit 1
    fi
fi

zathura "$(head -n 1 practice.clock | tr -d '\n')" 2> /dev/null || true &
pgrep gtick > /dev/null || gtick 2> /dev/null || ture &
